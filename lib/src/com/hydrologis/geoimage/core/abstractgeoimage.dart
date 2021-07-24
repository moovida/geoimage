import 'package:geoimage/src/com/hydrologis/geoimage/core/geoinfo.dart';
import 'package:image/image.dart';

/// Abstract class for regular grid rasters.
abstract class AbstractGeoImage {
  /// Read the raster accessing the file.
  ///
  /// The optional [imageIndex] defines the image to open.
  void read([int imageIndex]);

  /// Get the geoinformation object for the selected image.
  GeoInfo? get geoInfo;

  /// Get the number of bands.
  int? get bands;

  /// Check if the image has tags (tiff tags).
  bool hasTags();

  /// Get the tag values for a given tag key.
  List<int>? getTag(int key);

  /// Get the image for the currnetly read [imageIndex].
  Image? get image;

  /// Get the image bytes for the currnetly read [imageIndex].
  List<int>? get imageBytes;
}

/// Abstract class for regular grid rasters with physical data.
abstract class AbstractGeoRaster extends AbstractGeoImage {
  /// Get the raster value as double at a given position and (optional) band.
  double getDouble(int col, int row, [int band]);

  /// Set the raster value as double at a given position and (optional) band.
  void setDouble(int col, int row, double value, [int band]);

  /// Get the raster value as int at a given position and (optional) band.
  int getInt(int col, int row, [int band]);

  /// Set the raster value as int at a given position and (optional) band.
  void setInt(int col, int row, int value, [int band]);

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

  /// Write a raster to file.
  void write(String path);
}
