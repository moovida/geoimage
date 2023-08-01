import 'package:dart_jts/dart_jts.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/utils.dart';
import 'package:image/image.dart';

import 'geotiffentry.dart';

/// Class to extract geographic information from a [TiffImage].
class GeoInfo {
  AffineTransformation? _pixelToWorldTransform;
  AffineTransformation? _worldToPixelTransform;

  /// The projection epsg code. This or [prjWkt] need to be available.
  int _srid = -1;

  /// The projection wkt format. This or [srid] need to be available.
  String? _prjWkt;

  int? _cols;
  int? _rows;
  double? _xResolution;
  double? _yResolution;
  late Envelope _worldEnvelope;
  double? noValue;

  GeoInfo.fromValues(int width, int height, double xScale, double yScale,
      double xMin, double yMax, String? prjWkt) {
    _rows = height;
    _cols = width;
    _prjWkt = prjWkt;

    //  |  xScale      0  dx | => m00, m01, m02
    //  |  0      yScale  dy | => m10, m11, m12
    //  |  0           0   1 |
    var m00 = xScale;
    var m01 = 0.0;
    var m02 = xMin;
    var m10 = 0.0;
    var m11 = yScale;
    var m12 = yMax;
    _pixelToWorldTransform =
        AffineTransformation.fromMatrixValues(m00, m01, m02, m10, m11, m12);
    _worldToPixelTransform = _pixelToWorldTransform!.getInverse();

    _xResolution = m00;
    _yResolution = m11.abs();

    var llCoord = _pixelToWorldTransform!
        .transform(Coordinate(0, 0), Coordinate.empty2D());
    var urCoord = _pixelToWorldTransform!.transform(
        Coordinate(_cols!.toDouble(), _rows!.toDouble()), Coordinate.empty2D());

    _worldEnvelope = Envelope.fromCoordinates(llCoord, urCoord);
  }

  GeoInfo(TiffImage image, [String? prjWkt]) {
    _prjWkt = prjWkt;
    _rows = image.height;
    _cols = image.width;
    // ModelTransformationTag: 34264
    // [30.0, 0.0, 0.0, 1640650.0,
    //  0.0, -30.0, 0.0, 5140020.0,
    //  0.0, 0.0, 0.0, 0.0,
    //  0.0, 0.0, 0.0, 1.0]
    var modelTransformationTag = image.tags[TiffTags.MODEL_TRANSFORMATION_TAG];
    if (modelTransformationTag != null) {
      var transformationMatrix = GeoTiffEntry(modelTransformationTag).read();

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
      _worldToPixelTransform = _pixelToWorldTransform!.getInverse();

      _xResolution = m00;
      _yResolution = m11.abs();

      var llCoord = _pixelToWorldTransform!
          .transform(Coordinate(0, 0), Coordinate.empty2D());
      var urCoord = _pixelToWorldTransform!.transform(
          Coordinate(_cols!.toDouble(), _rows!.toDouble()),
          Coordinate.empty2D());

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
        var modelPixelScale = GeoTiffEntry(modelPixelScaleTag).read();
        var m00 = modelPixelScale[0];
        var m11 = -modelPixelScale[1];

        var modelTiepointTag = image.tags[TiffTags.MODEL_TIEPOINT_TAG];
        if (modelTiepointTag != null) {
          var modelTiepoint = GeoTiffEntry(modelTiepointTag).read();
          var m01 = 0.0;
          var m02 = modelTiepoint[3];
          var m10 = 0.0;
          var m12 = modelTiepoint[4];

          _pixelToWorldTransform = AffineTransformation.fromMatrixValues(
              m00, m01, m02, m10, m11, m12);
          _worldToPixelTransform = _pixelToWorldTransform!.getInverse();

          _xResolution = m00;
          _yResolution = m11.abs();

          var llCoord = _pixelToWorldTransform!
              .transform(Coordinate(0, 0), Coordinate.empty2D());
          var urCoord = _pixelToWorldTransform!.transform(
              Coordinate(_cols!.toDouble(), _rows!.toDouble()),
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
      var projInfovalues = GeoTiffEntry(projInfoTag).readValues();

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
      var gdalNovalueBytes = GeoTiffEntry(gdalNovalueTag).readValues();
      var gdalNovaleString = String.fromCharCodes(gdalNovalueBytes);
      if (gdalNovaleString.startsWith("nan")) {
        noValue = double.nan;
      } else {
        noValue = double.tryParse(gdalNovaleString);
        if (noValue == null) {
          noValue = double.tryParse(
              gdalNovaleString.substring(0, gdalNovaleString.length - 1));
        }
      }
    }
  }

  int get srid => _srid;

  String? get prjWkt => _prjWkt;

  int? get rows => _rows;

  int? get cols => _cols;

  double? get xRes => _xResolution;

  double? get yRes => _yResolution;

  Envelope get worldEnvelope => _worldEnvelope;

  Coordinate? pixelToWorld(Coordinate src, Coordinate dest) {
    return _pixelToWorldTransform?.transform(src, dest);
  }

  Coordinate? worldToPixel(Coordinate src, Coordinate dest) {
    return _worldToPixelTransform?.transform(src, dest);
  }

  Geometry? pixelToWorldGeom(Geometry geom) {
    return _pixelToWorldTransform?.transformGeom(geom);
  }

  Geometry? worldToPixelGeom(Geometry geom) {
    return _worldToPixelTransform?.transformGeom(geom);
  }
}
