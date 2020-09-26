import 'dart:io';

import 'package:hortonmachine/src/org/hortomachine/core/utils.dart';
import 'package:image/image.dart';

/// Abstract class for regular grid rasters.
abstract class Raster {
  /// Open the raster accessing the file.
  void open();

  /// Get the rows of the raster grid.
  int get rows;

  /// Get the cols of the raster grid.
  int get cols;

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
        _col == _raster.cols - 1 ||
        _row == _raster.rows - 1) {
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

/// A raster class representing a single band raster.
class SingleBandRaster extends Raster {
  final File _file;
  HdrImage _raster;

  SingleBandRaster(this._file);

  @override
  void open() {
    var bytes = _file.readAsBytesSync();
    _raster = TiffDecoder().decodeHdrImage(bytes);
    assert(_raster.numChannels == 1);
  }

  @override
  int get rows => _raster.height;

  @override
  int get cols => _raster.width;

  @override
  int get bands => 1;

  @override
  void loopWithFloatValue(Function colRowValueFunction) {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        colRowValueFunction(c, r, getDouble(c, r));
      }
    }
  }

  @override
  void loopWithIntValue(Function colRowValueFunction) {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        colRowValueFunction(c, r, getInt(c, r));
      }
    }
  }

  @override
  void loopWithGridNode(Function gridNodeFunction) {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
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
