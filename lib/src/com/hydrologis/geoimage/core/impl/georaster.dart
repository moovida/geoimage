import 'dart:io';

import 'package:geoimage/geoimage.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/geoinfo.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/utils.dart';
import 'package:image/image.dart';

import '../utils.dart';

/// A raster class representing a geoimage containing physical data.
class GeoRaster extends AbstractGeoRaster {
  final File _file;
  HdrImage _raster;
  GeoInfo _geoInfo;
  int _rows;
  int _cols;
  TiffInfo _tiffInfo;
  TiffImage _tiffImage;
  List<List<double>> dataList;

  GeoRaster(this._file);

  @override
  void read([int imageIndex]) {
    if (imageIndex == null) {
      imageIndex = 0;
    }

    // right now geotiff ad esri ascii grids are supported
    if (GeoimageUtils.isTiff(_file.path)) {
      var bytes = _file.readAsBytesSync();
      var tiffDecoder = TiffDecoder();
      _raster = tiffDecoder.decodeHdrImage(bytes, frame: imageIndex);
      _tiffInfo = tiffDecoder.info;
      _tiffImage = _tiffInfo.images[imageIndex];

      // even in this case there might be worldfile info. In case use them.
      var wesnxyValues = GeoimageUtils.parseWorldFile(
          _file.path, _raster.width, _raster.height);
      var prjWkt = GeoimageUtils.getPrjWkt(_file.path);
      if (wesnxyValues != null) {
        // has worldfile
        _geoInfo = GeoInfo.fromValues(
            _raster.width,
            _raster.height,
            wesnxyValues[4],
            -wesnxyValues[5],
            wesnxyValues[0],
            wesnxyValues[3],
            prjWkt);
      } else {
        _geoInfo = GeoInfo(_tiffImage);
      }
      _rows = _geoInfo.rows;
      _cols = _geoInfo.cols;
    } else if (GeoimageUtils.isAsc(_file.path)) {
      var prjWkt = GeoimageUtils.getPrjWkt(_file.path);
      var fileLines = GeoimageUtils.readFileToList(_file.path);

      // ncols         4
      // nrows         6
      // xllcorner     0.0
      // yllcorner     0.0
      // cellsize      50.0
      // NODATA_value  -9999

      int cols;
      int rows;
      double west;
      double south;
      double novalue;
      double res;
      dataList = [];
      bool dataStarted = false;
      for (var i = 0; i < fileLines.length; i++) {
        var line = fileLines[i].trim();
        if (line.isEmpty) {
          continue;
        }
        if (!dataStarted &&
            double.tryParse(line.substring(0, 1)) == null &&
            line.substring(0, 1) != "-") {
          // starts with letter -> header
          line = line.toLowerCase();
          var split = line.split(RegExp(r'\s+'));
          if (split.length == 2) {
            if (split[0] == "ncols") {
              cols = int.parse(split[1]);
            } else if (split[0] == "nrows") {
              rows = int.parse(split[1]);
            } else if (split[0] == "xllcorner") {
              west = double.parse(split[1]);
            } else if (split[0] == "yllcorner") {
              south = double.parse(split[1]);
            } else if (split[0] == "cellsize") {
              res = double.parse(split[1]);
            } else if (split[0] == "nodata_value") {
              novalue = double.parse(split[1]);
            }
          }
        } else {
          dataStarted = true;
          List<double> rowData = [];
          var split = line.split(RegExp(r'\s+'));
          if (split.length != cols) {
            throw ArgumentError(
                "The values in the row are of different number than the one defined in the header: ${split.length} vs $cols");
          }
          split.forEach((element) {
            rowData.add(double.parse(element));
          });
          dataList.add(rowData);
        }
      }
      if (dataList.length != rows) {
        throw ArgumentError(
            "The row number if different from the one defined in the header: ${dataList.length} vs $rows");
      }
      _geoInfo = GeoInfo.fromValues(
          cols, rows, res, -res, west, south + rows * res, prjWkt);
      _rows = _geoInfo.rows;
      _cols = _geoInfo.cols;
      _geoInfo.noValue = novalue;
    }
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
    if (dataList != null) {
      return dataList[row][col];
    } else {
      if (band == null || band == 0) {
        return _raster.red.getFloat(col, row);
      } else if (band == 1) {
        return _raster.green.getFloat(col, row);
      } else if (band == 2) {
        return _raster.blue.getFloat(col, row);
      }
      return null;
    }
  }

  @override
  int getInt(int col, int row, [int band]) {
    if (dataList != null) {
      return dataList[row][col].toInt();
    } else {
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
