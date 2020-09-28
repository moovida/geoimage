import 'dart:io';

import 'package:dart_jts/dart_jts.dart';
import 'package:hortonmachine/src/org/hortomachine/core/utils.dart';
import 'package:image/image.dart';

/// Abstract class for regular grid rasters.
abstract class Raster {
  /// Open the raster accessing the file.
  void open();

  /// Get the geoinformation object.
  GeoInfo get geoInfo;

  /// Get the number of bands.
  int get bands;

  /// Get the raster value as double at a given position and (optional) band.
  double getDouble(int col, int row, [int band]);

  /// Get the raster value as int at a given position and (optional) band.
  int getInt(int col, int row, [int band]);

  /// Loop over a raster using a function of type:
  /// (col, row, floatvalue) {
  ///   ...processing goes in here
  /// }
  ///
  void loopWithFloatValue(Function colRowValueFunction);

  /// Loop over a raster using a function of type:
  /// (col, row, intvalue) {
  ///   ...processing goes in here
  /// }
  ///
  void loopWithIntValue(Function colRowValueFunction);

  /// Loop over a raster using a function of type:
  /// (gridNode) {
  ///   ...processing goes in here
  /// }
  ///
  void loopWithGridNode(Function gridNodeFunction);
}

class GridNode {
  final int _col;
  final int _row;
  final SingleBandRaster _raster;
  bool _touchesBound = false;

  GridNode(this._raster, this._col, this._row) {
    if (_col == 0 ||
        _row == 0 ||
        _col == _raster._cols - 1 ||
        _row == _raster._rows - 1) {
      _touchesBound = true;
    }
  }

  bool get touchesBound => _touchesBound;

  double getDouble() {
    return _raster.getDouble(_col, _row);
  }

  double getDoubleAt(Direction direction) {
    var value;
    switch (direction) {
      case Direction.NW:
        value = _raster.getDouble(_col - 1, _row - 1);
        break;
      case Direction.N:
        value = _raster.getDouble(_col, _row - 1);
        break;
      case Direction.EN:
        value = _raster.getDouble(_col + 1, _row - 1);
        break;
      case Direction.E:
        value = _raster.getDouble(_col + 1, _row);
        break;
      case Direction.SE:
        value = _raster.getDouble(_col + 1, _row + 1);
        break;
      case Direction.S:
        value = _raster.getDouble(_col, _row + 1);
        break;
      case Direction.WS:
        value = _raster.getDouble(_col - 1, _row + 1);
        break;
      case Direction.W:
        value = _raster.getDouble(_col - 1, _row);
        break;
    }
    return value;
  }
}

/// Class to extract geographic information from a [TiffImage].
class GeoInfo {
  AffineTransformation _pixelToWorldTransform;
  AffineTransformation _worldToPixelTransform;
  int _srid = -1;
  int _cols;
  int _rows;
  double _xResolution;
  double _yResolution;
  Envelope _worldEnvelope;

  GeoInfo(TiffImage image) {
    _rows = image.height;
    _cols = image.width;
    // ModelTransformationTag: 34264
    // [30.0, 0.0, 0.0, 1640650.0,
    //  0.0, -30.0, 0.0, 5140020.0,
    //  0.0, 0.0, 0.0, 0.0,
    //  0.0, 0.0, 0.0, 1.0]
    var modelTransformationTag = image.tags[34264];
    if (modelTransformationTag != null) {
      var transformationMatrix = modelTransformationTag.read();

      //  |  xScale      0  dx | => m00, m01, m02
      //  |  0      yScale  dy | => m10, m11, m12
      //  |  0           0   1 |
      var m00 = transformationMatrix[0];
      var m01 = 0.0;
      var m02 = transformationMatrix[3];
      var m10 = 0.0;
      var m11 = transformationMatrix[5];
      var m12 = transformationMatrix[7];
      _pixelToWorldTransform =
          AffineTransformation.fromMatrixValues(m00, m01, m02, m10, m11, m12);
      _worldToPixelTransform = _pixelToWorldTransform.getInverse();

      _xResolution = m00;
      _yResolution = m11.abs();

      var llCoord = _pixelToWorldTransform.transform(
          Coordinate(0, 0), Coordinate.empty2D());
      var urCoord = _pixelToWorldTransform.transform(
          Coordinate(_cols.toDouble(), _rows.toDouble()), Coordinate.empty2D());

      _worldEnvelope = Envelope.fromCoordinates(llCoord, urCoord);
    } else {
      // ModelTiepointTag: 33922 -> needs to be there if 34264 is not
      // TODO
      // needs ModelPixelScaleTag: 33550 ->  = (ScaleX, ScaleY, ScaleZ)

      //  ModelTiepointTag (2,3):
      //    0.5              0.5              0
      //    -3683154.58      4212096.53       0
      // ModelPixelScaleTag (1,3):
      //    10000            10000            0
    }

    // GeoKeyDirectoryTag: 34735 -> also 'ProjectionInfoTag' and 'CoordSystemInfoTag'
    // [1, 1, 2, 3, 1024,
    //  0, 1, 1, 1025,
    //  0, 1, 1, 3072,
    //  0, 1, 32632]
    var projInfoTag = image.tags[34735];
    if (projInfoTag != null) {
      var projInfovalues = projInfoTag.read();
      _srid = projInfovalues[15];
    }
  }

  int get srid => _srid;

  int get rows => _rows;

  int get cols => _cols;

  double get xRes => _xResolution;

  double get yRes => _yResolution;

  Envelope get worldEnvelope => _worldEnvelope;

  Coordinate pixelToWorld(Coordinate src, Coordinate dest) {
    return _pixelToWorldTransform.transform(src, dest);
  }

  Coordinate worldToPixel(Coordinate src, Coordinate dest) {
    return _worldToPixelTransform.transform(src, dest);
  }

  Geometry pixelToWorldGeom(Geometry geom) {
    return _pixelToWorldTransform.transformGeom(geom);
  }

  Geometry worldToPixelGeom(Geometry geom) {
    return _worldToPixelTransform.transformGeom(geom);
  }
}

/// A raster class representing a single band raster.
class SingleBandRaster extends Raster {
  final File _file;
  HdrImage _raster;
  GeoInfo _geoInfo;
  int _rows;
  int _cols;

  SingleBandRaster(this._file);

  @override
  void open() {
    var bytes = _file.readAsBytesSync();
    var tiffDecoder = TiffDecoder();
    _raster = tiffDecoder.decodeHdrImage(bytes);
    assert(_raster.numChannels == 1);

    var tiffInfo = tiffDecoder.info;
    var image = tiffInfo.images[0];
    _geoInfo = GeoInfo(image);
    _rows = _geoInfo.rows;
    _cols = _geoInfo.cols;
    // image.tags.forEach((key, value) {
    //   print(key);
    //   print(value.read());
    //   print("=====================");
    // });
  }

  @override
  GeoInfo get geoInfo => _geoInfo;

  @override
  int get bands => 1;

  @override
  void loopWithFloatValue(Function colRowValueFunction) {
    for (var r = 0; r < _rows; r++) {
      for (var c = 0; c < _cols; c++) {
        colRowValueFunction(c, r, getDouble(c, r));
      }
    }
  }

  @override
  void loopWithIntValue(Function colRowValueFunction) {
    for (var r = 0; r < _rows; r++) {
      for (var c = 0; c < _cols; c++) {
        colRowValueFunction(c, r, getInt(c, r));
      }
    }
  }

  @override
  void loopWithGridNode(Function gridNodeFunction) {
    for (var r = 0; r < _rows; r++) {
      for (var c = 0; c < _cols; c++) {
        gridNodeFunction(GridNode(this, c, r));
      }
    }
  }

  @override
  double getDouble(int col, int row, [int band]) {
    return _raster.red.getFloat(col, row);
  }

  @override
  int getInt(int col, int row, [int band]) {
    return _raster.red.getInt(col, row);
  }
}
