import 'dart:io';

import 'package:geoimage/geoimage.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/impl/geoinfo.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/utils.dart';
import 'package:image/image.dart';

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
