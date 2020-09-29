import 'dart:convert';
import 'dart:io';

import 'package:dart_jts/dart_jts.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/utils.dart';
import 'package:image/image.dart';

class TiffTags {
  static final GEOKEY_DIRECTORY_TAG = 34735;
  static final MODEL_TRANSFORMATION_TAG = 34264;
  static final MODEL_TIEPOINT_TAG = 33922;
  static final MODEL_PIXELSCALE_TAG = 33550;
  static final TAG_GDAL_NODATA = 42113;
}

/// Abstract class for regular grid rasters.
abstract class AbstractGeoImage {
  /// Read the raster accessing the file.
  ///
  /// The optional [imageIndex] defines the image to open.
  void read([int imageIndex]);

  /// Get the geoinformation object for the selected image.
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

/// A node of a regular grid. Helps to access neighbour cells.
class GridNode {
  final int _col;
  final int _row;
  final AbstractGeoImage _raster;
  bool _touchesBound = false;

  GridNode(this._raster, this._col, this._row) {
    if (_col == 0 ||
        _row == 0 ||
        _col == _raster.geoInfo.cols - 1 ||
        _row == _raster.geoInfo.rows - 1) {
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
  final TiffImage image;
  double noValue;

  GeoInfo(this.image) {
    _rows = image.height;
    _cols = image.width;
    // ModelTransformationTag: 34264
    // [30.0, 0.0, 0.0, 1640650.0,
    //  0.0, -30.0, 0.0, 5140020.0,
    //  0.0, 0.0, 0.0, 0.0,
    //  0.0, 0.0, 0.0, 1.0]
    var modelTransformationTag = image.tags[TiffTags.MODEL_TRANSFORMATION_TAG];
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
      // needs ModelPixelScaleTag: 33550 ->  = (ScaleX, ScaleY, ScaleZ)

      //  ModelTiepointTag (2,3):
      //    0.5              0.5              0
      //    -3683154.58      4212096.53       0
      // ModelPixelScaleTag (1,3):
      //    10000            10000            0
      var modelPixelScaleTag = image.tags[TiffTags.MODEL_PIXELSCALE_TAG];
      if (modelPixelScaleTag != null) {
        var modelPixelScale = modelPixelScaleTag.read();
        var m00 = modelPixelScale[0];
        var m11 = -modelPixelScale[1];

        var modelTiepointTag = image.tags[TiffTags.MODEL_TIEPOINT_TAG];
        if (modelTiepointTag != null) {
          var modelTiepoint = modelTiepointTag.read();
          var m01 = 0.0;
          var m02 = modelTiepoint[3];
          var m10 = 0.0;
          var m12 = modelTiepoint[4];

          _pixelToWorldTransform = AffineTransformation.fromMatrixValues(
              m00, m01, m02, m10, m11, m12);
          _worldToPixelTransform = _pixelToWorldTransform.getInverse();

          _xResolution = m00;
          _yResolution = m11.abs();

          var llCoord = _pixelToWorldTransform.transform(
              Coordinate(0, 0), Coordinate.empty2D());
          var urCoord = _pixelToWorldTransform.transform(
              Coordinate(_cols.toDouble(), _rows.toDouble()),
              Coordinate.empty2D());

          _worldEnvelope = Envelope.fromCoordinates(llCoord, urCoord);
        }
      }
    }

    // GeoKeyDirectoryTag: 34735 -> also 'ProjectionInfoTag' and 'CoordSystemInfoTag'
    // [1, 1, 2, 3,
    //  1024, 0, 1, 1,
    //  1025, 0, 1, 1,
    //  3072, 0, 1, 32632]

    // [1, 1, 0, 7,
    // 1024, 0, 1, 2,
    // 1025, 0, 1, 2,
    // 2048, 0, 1, 4326,
    // 2049, 34737, 7, 0,
    // 2054, 0, 1, 9102,
    // 2057, 34736, 1, 2,
    // 2059, 34736, 1, 1]
    var projInfoTag = image.tags[TiffTags.GEOKEY_DIRECTORY_TAG];
    if (projInfoTag != null) {
      var projInfovalues = projInfoTag.readValues();

      // look for an epsg code
      //
      // GeographicTypeGeoKey         = 2048
      // ProjectedCSTypeGeoKey          = 3072
      //
      // TODO this part needs more love and knowledge
      for (var i = 4; i < projInfovalues.length; i += 4) {
        var value = projInfovalues[i];
        if (value == 2048 || value == 3072) {
          _srid = projInfovalues[i + 3];
          break;
        }
      }
    }

    var gdalNovalueTag = image.tags[TiffTags.TAG_GDAL_NODATA];
    if (gdalNovalueTag != null) {
      var gdalNovalueBytes = gdalNovalueTag.readValues();
      String gdalNovaleString =
          utf8.decode(gdalNovalueBytes, allowMalformed: false).trim();
      if (gdalNovaleString.startsWith("nan")) {
        noValue = double.nan;
      } else {
        noValue = double.parse(gdalNovaleString);
      }
    }
  }

  bool hasTag(int key) {
    return image.tags[key] != null;
  }

  List<dynamic> getTag(int key) {
    return image.tags[key].read();
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

  String printTags() {
    String tagsStr = "TAGS:\n";
    image.tags.forEach((key, value) {
      tagsStr += "\t$key = ${value.read()}\n";
    });
    return tagsStr;
  }
}

/// A raster class representing a single band raster.
class SingleBandGeoImage extends AbstractGeoImage {
  final File _file;
  HdrImage _raster;
  GeoInfo _geoInfo;
  int _rows;
  int _cols;
  TiffInfo _tiffInfo;

  SingleBandGeoImage(this._file);

  @override
  void read([int imageIndex]) {
    if (imageIndex == null) {
      imageIndex = 0;
    }
    var bytes = _file.readAsBytesSync();
    var tiffDecoder = TiffDecoder();
    _raster = tiffDecoder.decodeHdrImage(bytes, frame: imageIndex);
    assert(_raster.numberOfChannels == 1);

    _tiffInfo = tiffDecoder.info;
    var image = _tiffInfo.images[imageIndex];
    _geoInfo = GeoInfo(image);
    _rows = _geoInfo.rows;
    _cols = _geoInfo.cols;
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

/// A raster class representing a generic georaster.
class GeoImage extends AbstractGeoImage {
  final File _file;
  HdrImage _raster;
  GeoInfo _geoInfo;
  int _rows;
  int _cols;
  TiffInfo _tiffInfo;

  GeoImage(this._file);

  @override
  void read([int imageIndex]) {
    if (imageIndex == null) {
      imageIndex = 0;
    }
    var bytes = _file.readAsBytesSync();
    var tiffDecoder = TiffDecoder();
    _raster = tiffDecoder.decodeHdrImage(bytes, frame: imageIndex);

    _tiffInfo = tiffDecoder.info;
    var image = _tiffInfo.images[imageIndex];
    _geoInfo = GeoInfo(image);
    _rows = _geoInfo.rows;
    _cols = _geoInfo.cols;
  }

  @override
  GeoInfo get geoInfo => _geoInfo;

  @override
  int get bands => _raster.numberOfChannels;

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
    if (band == null || band == 0) {
      return _raster.red.getFloat(col, row);
    } else if (band == 1) {
      return _raster.green.getFloat(col, row);
    } else if (band == 2) {
      return _raster.blue.getFloat(col, row);
    }
    return null;
  }

  @override
  int getInt(int col, int row, [int band]) {
    if (band == null || band == 0) {
      return _raster.red.getInt(col, row);
    } else if (band == 1) {
      return _raster.green.getInt(col, row);
    } else if (band == 2) {
      return _raster.blue.getInt(col, row);
    }
    return null;
  }
}
