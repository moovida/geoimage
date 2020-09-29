import 'dart:io';

import 'package:geoimage/geoimage.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/geoinfo.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/utils.dart';
import 'package:image/image.dart';

/// A raster class representing a geoimage containing physical data.
class GeoRaster extends AbstractGeoRaster {
  final File _file;
  HdrImage _raster;
  GeoInfo _geoInfo;
  int _rows;
  int _cols;
  TiffInfo _tiffInfo;
  TiffImage _tiffImage;

  GeoRaster(this._file);

  @override
  void read([int imageIndex]) {
    if (imageIndex == null) {
      imageIndex = 0;
    }
    var bytes = _file.readAsBytesSync();
    var tiffDecoder = TiffDecoder();
    _raster = tiffDecoder.decodeHdrImage(bytes, frame: imageIndex);

    _tiffInfo = tiffDecoder.info;
    _tiffImage = _tiffInfo.images[imageIndex];
    _geoInfo = GeoInfo(_tiffImage);
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

  @override
  List<int> getTag(int key) {
    if (_tiffImage != null && _tiffImage.tags != null) {
      var tag = _tiffImage.tags[key];
      if (tag != null) {
        return tag.readValues();
      }
    }
    return null;
  }

  @override
  bool hasTags() {
    return _tiffImage != null && _tiffImage.tags != null ? true : false;
  }
}
