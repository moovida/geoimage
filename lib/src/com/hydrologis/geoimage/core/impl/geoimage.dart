import 'dart:io';

import 'package:geoimage/geoimage.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/geoinfo.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/utils.dart';
import 'package:image/image.dart';

/// A raster class representing a generic geoimage.
class GeoImage extends AbstractGeoImage {
  final File _file;
  Image _image;
  GeoInfo _geoInfo;
  TiffImage _tiffImage;

  GeoImage(this._file);

  @override
  void read([int imageIndex]) {
    if (imageIndex == null) {
      imageIndex = 0;
    }
    var bytes = _file.readAsBytesSync();
    TiffDecoder tiffDecoder;
    if (GeoimageUtils.isTiff(_file.path)) {
      tiffDecoder = TiffDecoder();
      _image = tiffDecoder.decodeImage(bytes);
    } else {
      _image = decodeImage(bytes);
    }
    var wesnxyValues =
        GeoimageUtils.parseWorldFile(_file.path, _image.width, _image.height);
    if (wesnxyValues != null) {
      // has worldfile
      _geoInfo = GeoInfo.fromValues(_image.width, _image.height,
          wesnxyValues[4], -wesnxyValues[5], wesnxyValues[0], wesnxyValues[3]);
    } else if (tiffDecoder != null) {
      // without worldfile only tiffs can contain geoinfo
      var tiffInfo = tiffDecoder.info;
      _tiffImage = tiffInfo.images[imageIndex];
      _geoInfo = GeoInfo(_tiffImage);
    } else {
      throw ArgumentError("The supplied image is not a supported geoimage.");
    }
  }

  @override
  GeoInfo get geoInfo => _geoInfo;

  @override
  int get bands => _image.numberOfChannels;

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
