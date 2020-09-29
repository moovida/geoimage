import 'dart:io';

import 'package:geoimage/geoimage.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/impl/geoinfo.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/utils.dart';
import 'package:image/image.dart';

/// A raster class representing a generic geoimage.
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
