import 'dart:io';
import 'dart:typed_data';

import 'package:geoimage/geoimage.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/geoinfo.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/utils.dart';
import 'package:image/image.dart';
import '../geotiffentry.dart';

/// A raster class representing a generic geoimage.
class GeoImage extends AbstractGeoImage {
  final File _file;
  Image? _image;
  GeoInfo? _geoInfo;
  TiffImage? _tiffImage;
  late Uint8List _imageBytes;

  GeoImage(this._file);

  @override
  void read([int? imageIndex]) {
    if (imageIndex == null) {
      imageIndex = 0;
    }
    _imageBytes = _file.readAsBytesSync();
    TiffDecoder? tiffDecoder;
    if (GeoimageUtils.isTiff(_file.path)) {
      tiffDecoder = TiffDecoder();
      //_image = tiffDecoder.decodeImage(_imageBytes);
      _image = tiffDecoder.decode(_imageBytes);
    } else {
      _image = decodeImage(_imageBytes);

    }
    if (_image == null) {
      throw StateError("Unable to decode image.");
    }
    var wesnxyValues =
        GeoimageUtils.parseWorldFile(_file.path, _image!.width, _image!.height);

    var prjWkt = GeoimageUtils.getPrjWkt(_file.path);
    if (wesnxyValues != null) {
      // has worldfile
      _geoInfo = GeoInfo.fromValues(
          _image!.width,
          _image!.height,
          wesnxyValues[4],
          -wesnxyValues[5],
          wesnxyValues[0],
          wesnxyValues[3],
          prjWkt);
    } else if (tiffDecoder != null) {
      // without worldfile only tiffs can contain geoinfo
      var tiffInfo = tiffDecoder.info;
      if (tiffInfo != null) {
        _tiffImage = tiffInfo.images[imageIndex];
        if (_tiffImage != null) {
          _geoInfo = GeoInfo(_tiffImage!, prjWkt);
        }
      }
    } else {
      throw ArgumentError("The supplied image is not a supported geoimage.");
    }
  }

  @override
  Image? get image => _image;

  @override
  List<int>? get imageBytes => _imageBytes;

  @override
  GeoInfo? get geoInfo => _geoInfo;

  @override
  int? get bands => _image?.data?.numChannels;
  //int? get bands => _image?.numberOfChannels;

  @override
  List<int>? getTag(int key) {
    if (_tiffImage != null) {
      var tag = _tiffImage!.tags[key];
      if (tag != null) {
        return GeoTiffEntry(tag).readValues();
      }
    }
    return null;
  }

  @override
  bool hasTags() {
    return _tiffImage != null ? true : false;
  }
}
