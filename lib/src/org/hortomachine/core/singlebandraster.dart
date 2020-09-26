import 'dart:io';

import 'package:image/image.dart';

class SingleBandRaster {
  final File _file;
  HdrImage _raster;

  SingleBandRaster(this._file);

  void open() {
    var bytes = _file.readAsBytesSync();
    _raster = TiffDecoder().decodeHdrImage(bytes);
    assert(_raster.numChannels == 1);
  }

  int get rows => _raster.height;

  int get cols => _raster.width;

  void loop(Function colRowFunction) {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        colRowFunction(c, r);
      }
    }
  }

  void loopWithFloatValue(Function colRowFunction) {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        colRowFunction(c, r, _raster.red.getFloat(c, r));
      }
    }
  }

  void loopWithIntValue(Function colRowFunction) {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        colRowFunction(c, r, _raster.red.getInt(c, r));
      }
    }
  }

  double getDouble(int col, int row) {
    return _raster.red.getFloat(col, row);
  }

  int getInt(int col, int row) {
    return _raster.red.getInt(col, row);
  }
}
