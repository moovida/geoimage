import 'dart:io';
import 'dart:typed_data';

import 'package:dart_jts/dart_jts.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/impl/geoimage.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/impl/georaster.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/utils.dart';
import 'package:image/image.dart';
import 'package:test/test.dart';

void main() {
  group('Test tiff datatypes', () {
    test('Test metadata', () {
      /*
        Driver: GTiff/GeoTIFF
        Files: dtm32float.tiff
        Size is 10, 8
        Coordinate System is:
        PROJCRS["WGS 84 / UTM zone 32N",
            BASEGEOGCRS["WGS 84",
                DATUM["World Geodetic System 1984",
                    ELLIPSOID["WGS 84",6378137,298.257223563,
                        LENGTHUNIT["metre",1]]],
                PRIMEM["Greenwich",0,
                    ANGLEUNIT["degree",0.0174532925199433]],
                ID["EPSG",4326]],
            CONVERSION["UTM zone 32N",
                METHOD["Transverse Mercator",
                    ID["EPSG",9807]],
                PARAMETER["Latitude of natural origin",0,
                    ANGLEUNIT["degree",0.0174532925199433],
                    ID["EPSG",8801]],
                PARAMETER["Longitude of natural origin",9,
                    ANGLEUNIT["degree",0.0174532925199433],
                    ID["EPSG",8802]],
                PARAMETER["Scale factor at natural origin",0.9996,
                    SCALEUNIT["unity",1],
                    ID["EPSG",8805]],
                PARAMETER["False easting",500000,
                    LENGTHUNIT["metre",1],
                    ID["EPSG",8806]],
                PARAMETER["False northing",0,
                    LENGTHUNIT["metre",1],
                    ID["EPSG",8807]]],
            CS[Cartesian,2],
                AXIS["(E)",east,
                    ORDER[1],
                    LENGTHUNIT["metre",1]],
                AXIS["(N)",north,
                    ORDER[2],
                    LENGTHUNIT["metre",1]],
            USAGE[
                SCOPE["unknown"],
                AREA["World - N hemisphere - 6°E to 12°E - by country"],
                BBOX[0,6,84,12]],
            ID["EPSG",32632]]
        Data axis to CRS axis mapping: 1,2
        Origin = (1640650.000000000000000,5140020.000000000000000)
        Pixel Size = (30.000000000000000,-30.000000000000000)
        Metadata:
          AREA_OR_POINT=Area
          TIFFTAG_RESOLUTIONUNIT=1 (unitless)
          TIFFTAG_XRESOLUTION=1
          TIFFTAG_YRESOLUTION=1
        Image Structure Metadata:
          INTERLEAVE=BAND
        Corner Coordinates:
        Upper Left  ( 1640650.000, 5140020.000) ( 23d35'47.44"E, 45d28'16.75"N)
        Lower Left  ( 1640650.000, 5139780.000) ( 23d35'45.46"E, 45d28' 9.22"N)
        Upper Right ( 1640950.000, 5140020.000) ( 23d36' 0.81"E, 45d28'15.00"N)
        Lower Right ( 1640950.000, 5139780.000) ( 23d35'58.83"E, 45d28' 7.48"N)
        Center      ( 1640800.000, 5139900.000) ( 23d35'53.14"E, 45d28'12.11"N)
        Band 1 Block=10x8 Type=Float32, ColorInterp=Gray

      */
      var file32bit = File('./test/files/dtm32float.tiff');
      var raster = GeoRaster(file32bit);
      raster.read();

      var geoInfo = raster.geoInfo;

      var worldEnvelope = geoInfo!.worldEnvelope;
      var expected =
          Envelope(1640650.000, 1640950.000, 5139780.000, 5140020.000);
      expect(worldEnvelope == expected, true);

      expect(geoInfo.cols, 10);
      expect(geoInfo.rows, 8);
      expect(geoInfo.srid, 32632);
    });
    test('Test 32bit float', () {
      /*
        Driver: GTiff/GeoTIFF
        Files: dtm32float.tiff
        Size is 10, 8
        Coordinate System is:
        PROJCRS["WGS 84 / UTM zone 32N",
            BASEGEOGCRS["WGS 84",
                DATUM["World Geodetic System 1984",
                    ELLIPSOID["WGS 84",6378137,298.257223563,
                        LENGTHUNIT["metre",1]]],
                PRIMEM["Greenwich",0,
                    ANGLEUNIT["degree",0.0174532925199433]],
                ID["EPSG",4326]],
            CONVERSION["UTM zone 32N",
                METHOD["Transverse Mercator",
                    ID["EPSG",9807]],
                PARAMETER["Latitude of natural origin",0,
                    ANGLEUNIT["degree",0.0174532925199433],
                    ID["EPSG",8801]],
                PARAMETER["Longitude of natural origin",9,
                    ANGLEUNIT["degree",0.0174532925199433],
                    ID["EPSG",8802]],
                PARAMETER["Scale factor at natural origin",0.9996,
                    SCALEUNIT["unity",1],
                    ID["EPSG",8805]],
                PARAMETER["False easting",500000,
                    LENGTHUNIT["metre",1],
                    ID["EPSG",8806]],
                PARAMETER["False northing",0,
                    LENGTHUNIT["metre",1],
                    ID["EPSG",8807]]],
            CS[Cartesian,2],
                AXIS["(E)",east,
                    ORDER[1],
                    LENGTHUNIT["metre",1]],
                AXIS["(N)",north,
                    ORDER[2],
                    LENGTHUNIT["metre",1]],
            USAGE[
                SCOPE["unknown"],
                AREA["World - N hemisphere - 6°E to 12°E - by country"],
                BBOX[0,6,84,12]],
            ID["EPSG",32632]]
        Data axis to CRS axis mapping: 1,2
        Origin = (1640650.000000000000000,5140020.000000000000000)
        Pixel Size = (30.000000000000000,-30.000000000000000)
        Metadata:
          AREA_OR_POINT=Area
          TIFFTAG_RESOLUTIONUNIT=1 (unitless)
          TIFFTAG_XRESOLUTION=1
          TIFFTAG_YRESOLUTION=1
        Image Structure Metadata:
          INTERLEAVE=BAND
        Corner Coordinates:
        Upper Left  ( 1640650.000, 5140020.000) ( 23d35'47.44"E, 45d28'16.75"N)
        Lower Left  ( 1640650.000, 5139780.000) ( 23d35'45.46"E, 45d28' 9.22"N)
        Upper Right ( 1640950.000, 5140020.000) ( 23d36' 0.81"E, 45d28'15.00"N)
        Lower Right ( 1640950.000, 5139780.000) ( 23d35'58.83"E, 45d28' 7.48"N)
        Center      ( 1640800.000, 5139900.000) ( 23d35'53.14"E, 45d28'12.11"N)
        Band 1 Block=10x8 Type=Float32, ColorInterp=Gray

      */
      var file32bit = File('./test/files/dtm32float.tiff');
      var raster = GeoRaster(file32bit);
      raster.read();
      raster.loopWithDoubleValue((col, row, value) {
        expect(value, mapData[row][col]);
      });
    });
    test('Test 64bit float', () {
      /*
        Driver: GTiff/GeoTIFF
        Files: dtm64float.tiff
        Size is 10, 8
        Coordinate System is:
        PROJCRS["WGS 84 / UTM zone 32N",
            BASEGEOGCRS["WGS 84",
                DATUM["World Geodetic System 1984",
                    ELLIPSOID["WGS 84",6378137,298.257223563,
                        LENGTHUNIT["metre",1]]],
                PRIMEM["Greenwich",0,
                    ANGLEUNIT["degree",0.0174532925199433]],
                ID["EPSG",4326]],
            CONVERSION["UTM zone 32N",
                METHOD["Transverse Mercator",
                    ID["EPSG",9807]],
                PARAMETER["Latitude of natural origin",0,
                    ANGLEUNIT["degree",0.0174532925199433],
                    ID["EPSG",8801]],
                PARAMETER["Longitude of natural origin",9,
                    ANGLEUNIT["degree",0.0174532925199433],
                    ID["EPSG",8802]],
                PARAMETER["Scale factor at natural origin",0.9996,
                    SCALEUNIT["unity",1],
                    ID["EPSG",8805]],
                PARAMETER["False easting",500000,
                    LENGTHUNIT["metre",1],
                    ID["EPSG",8806]],
                PARAMETER["False northing",0,
                    LENGTHUNIT["metre",1],
                    ID["EPSG",8807]]],
            CS[Cartesian,2],
                AXIS["(E)",east,
                    ORDER[1],
                    LENGTHUNIT["metre",1]],
                AXIS["(N)",north,
                    ORDER[2],
                    LENGTHUNIT["metre",1]],
            USAGE[
                SCOPE["unknown"],
                AREA["World - N hemisphere - 6°E to 12°E - by country"],
                BBOX[0,6,84,12]],
            ID["EPSG",32632]]
        Data axis to CRS axis mapping: 1,2
        Origin = (1640650.000000000000000,5140020.000000000000000)
        Pixel Size = (30.000000000000000,-30.000000000000000)
        Metadata:
          AREA_OR_POINT=Area
          TIFFTAG_RESOLUTIONUNIT=1 (unitless)
          TIFFTAG_XRESOLUTION=1
          TIFFTAG_YRESOLUTION=1
        Image Structure Metadata:
          INTERLEAVE=BAND
        Corner Coordinates:
        Upper Left  ( 1640650.000, 5140020.000) ( 23d35'47.44"E, 45d28'16.75"N)
        Lower Left  ( 1640650.000, 5139780.000) ( 23d35'45.46"E, 45d28' 9.22"N)
        Upper Right ( 1640950.000, 5140020.000) ( 23d36' 0.81"E, 45d28'15.00"N)
        Lower Right ( 1640950.000, 5139780.000) ( 23d35'58.83"E, 45d28' 7.48"N)
        Center      ( 1640800.000, 5139900.000) ( 23d35'53.14"E, 45d28'12.11"N)
        Band 1 Block=10x8 Type=Float64, ColorInterp=Gray
      */
      var file64bit = File('./test/files/dtm64float.tiff');
      var raster = GeoRaster(file64bit);
      raster.read();

      expect(null, raster.geoInfo!.noValue);

      raster.loopWithDoubleValue((col, row, value) {
        expect(value, mapData[row][col]);
      });
    });
    test('Test 32bit int', () {
      /*
        Driver: GTiff/GeoTIFF
        Files: tca32int.tiff
        Size is 10, 8
        Coordinate System is:
        PROJCRS["WGS 84 / UTM zone 32N",
            BASEGEOGCRS["WGS 84",
                DATUM["World Geodetic System 1984",
                    ELLIPSOID["WGS 84",6378137,298.257223563,
                        LENGTHUNIT["metre",1]]],
                PRIMEM["Greenwich",0,
                    ANGLEUNIT["degree",0.0174532925199433]],
                ID["EPSG",4326]],
            CONVERSION["UTM zone 32N",
                METHOD["Transverse Mercator",
                    ID["EPSG",9807]],
                PARAMETER["Latitude of natural origin",0,
                    ANGLEUNIT["degree",0.0174532925199433],
                    ID["EPSG",8801]],
                PARAMETER["Longitude of natural origin",9,
                    ANGLEUNIT["degree",0.0174532925199433],
                    ID["EPSG",8802]],
                PARAMETER["Scale factor at natural origin",0.9996,
                    SCALEUNIT["unity",1],
                    ID["EPSG",8805]],
                PARAMETER["False easting",500000,
                    LENGTHUNIT["metre",1],
                    ID["EPSG",8806]],
                PARAMETER["False northing",0,
                    LENGTHUNIT["metre",1],
                    ID["EPSG",8807]]],
            CS[Cartesian,2],
                AXIS["(E)",east,
                    ORDER[1],
                    LENGTHUNIT["metre",1]],
                AXIS["(N)",north,
                    ORDER[2],
                    LENGTHUNIT["metre",1]],
            USAGE[
                SCOPE["unknown"],
                AREA["World - N hemisphere - 6°E to 12°E - by country"],
                BBOX[0,6,84,12]],
            ID["EPSG",32632]]
        Data axis to CRS axis mapping: 1,2
        Origin = (1640650.000000000000000,5140020.000000000000000)
        Pixel Size = (30.000000000000000,-30.000000000000000)
        Metadata:
          AREA_OR_POINT=Area
          TIFFTAG_RESOLUTIONUNIT=1 (unitless)
          TIFFTAG_XRESOLUTION=1
          TIFFTAG_YRESOLUTION=1
        Image Structure Metadata:
          INTERLEAVE=BAND
        Corner Coordinates:
        Upper Left  ( 1640650.000, 5140020.000) ( 23d35'47.44"E, 45d28'16.75"N)
        Lower Left  ( 1640650.000, 5139780.000) ( 23d35'45.46"E, 45d28' 9.22"N)
        Upper Right ( 1640950.000, 5140020.000) ( 23d36' 0.81"E, 45d28'15.00"N)
        Lower Right ( 1640950.000, 5139780.000) ( 23d35'58.83"E, 45d28' 7.48"N)
        Center      ( 1640800.000, 5139900.000) ( 23d35'53.14"E, 45d28'12.11"N)
        Band 1 Block=10x8 Type=Int32, ColorInterp=Gray
          NoData Value=-2147483648
      */
      var file32int = File('./test/files/tca32int.tiff');
      var raster = GeoRaster(file32int);
      raster.read();

      expect(-2147483648.0, raster.geoInfo!.noValue);

      raster.loopWithIntValue((col, row, value) {
        expect(value, tcaData[row][col]);
      });
    });
    test('Test 16bit int', () {
      /*
        Driver: GTiff/GeoTIFF
        Files: flow16int.tiff
        Size is 10, 8
        Coordinate System is:
        PROJCRS["WGS 84 / UTM zone 32N",
            BASEGEOGCRS["WGS 84",
                DATUM["World Geodetic System 1984",
                    ELLIPSOID["WGS 84",6378137,298.257223563,
                        LENGTHUNIT["metre",1]]],
                PRIMEM["Greenwich",0,
                    ANGLEUNIT["degree",0.0174532925199433]],
                ID["EPSG",4326]],
            CONVERSION["UTM zone 32N",
                METHOD["Transverse Mercator",
                    ID["EPSG",9807]],
                PARAMETER["Latitude of natural origin",0,
                    ANGLEUNIT["degree",0.0174532925199433],
                    ID["EPSG",8801]],
                PARAMETER["Longitude of natural origin",9,
                    ANGLEUNIT["degree",0.0174532925199433],
                    ID["EPSG",8802]],
                PARAMETER["Scale factor at natural origin",0.9996,
                    SCALEUNIT["unity",1],
                    ID["EPSG",8805]],
                PARAMETER["False easting",500000,
                    LENGTHUNIT["metre",1],
                    ID["EPSG",8806]],
                PARAMETER["False northing",0,
                    LENGTHUNIT["metre",1],
                    ID["EPSG",8807]]],
            CS[Cartesian,2],
                AXIS["(E)",east,
                    ORDER[1],
                    LENGTHUNIT["metre",1]],
                AXIS["(N)",north,
                    ORDER[2],
                    LENGTHUNIT["metre",1]],
            USAGE[
                SCOPE["unknown"],
                AREA["World - N hemisphere - 6°E to 12°E - by country"],
                BBOX[0,6,84,12]],
            ID["EPSG",32632]]
        Data axis to CRS axis mapping: 1,2
        Origin = (1640650.000000000000000,5140020.000000000000000)
        Pixel Size = (30.000000000000000,-30.000000000000000)
        Metadata:
          AREA_OR_POINT=Area
          TIFFTAG_RESOLUTIONUNIT=1 (unitless)
          TIFFTAG_XRESOLUTION=1
          TIFFTAG_YRESOLUTION=1
        Image Structure Metadata:
          INTERLEAVE=BAND
        Corner Coordinates:
        Upper Left  ( 1640650.000, 5140020.000) ( 23d35'47.44"E, 45d28'16.75"N)
        Lower Left  ( 1640650.000, 5139780.000) ( 23d35'45.46"E, 45d28' 9.22"N)
        Upper Right ( 1640950.000, 5140020.000) ( 23d36' 0.81"E, 45d28'15.00"N)
        Lower Right ( 1640950.000, 5139780.000) ( 23d35'58.83"E, 45d28' 7.48"N)
        Center      ( 1640800.000, 5139900.000) ( 23d35'53.14"E, 45d28'12.11"N)
        Band 1 Block=10x8 Type=Int16, ColorInterp=Gray
          NoData Value=-32768
      */
      var file16int = File('./test/files/flow16int.tiff');
      var raster = GeoRaster(file16int);
      raster.read();

      expect(-32768.0, raster.geoInfo!.noValue);

      raster.loopWithIntValue((col, row, value) {
        var expected = flowData[row][col];
        expect(value, expected);
      });
    });
  });

  group('Test imageio-ext tiffs', () {
    // test('test tiff with ModelPixelScaleTag', () {
    //   /*
    //     Driver: GTiff/GeoTIFF
    //     Files: test/files/imageioext/test_IFD.tif
    //     Size is 1, 1
    //     Coordinate System is:
    //     GEOGCRS["WGS 84",
    //         DATUM["World Geodetic System 1984",
    //             ELLIPSOID["WGS 84",6378137,298.257223563,
    //                 LENGTHUNIT["metre",1]]],
    //         PRIMEM["Greenwich",0,
    //             ANGLEUNIT["degree",0.0174532925199433]],
    //         CS[ellipsoidal,2],
    //             AXIS["geodetic latitude (Lat)",north,
    //                 ORDER[1],
    //                 ANGLEUNIT["degree",0.0174532925199433]],
    //             AXIS["geodetic longitude (Lon)",east,
    //                 ORDER[2],
    //                 ANGLEUNIT["degree",0.0174532925199433]],
    //         ID["EPSG",4326]]
    //     Data axis to CRS axis mapping: 2,1
    //     Origin = (-180.000000000000000,90.000000000000014)
    //     Pixel Size = (360.000000000072021,-180.000000000036010)
    //     Metadata:
    //       AREA_OR_POINT=Area
    //       TIFFTAG_DATETIME=2012:07:16 09:23:22
    //       TIFFTAG_RESOLUTIONUNIT=2 (pixels/inch)
    //       TIFFTAG_SOFTWARE=Adobe Photoshop CS5 Macintosh
    //       TIFFTAG_XRESOLUTION=72
    //       TIFFTAG_YRESOLUTION=72
    //     Image Structure Metadata:
    //       INTERLEAVE=PIXEL
    //     Corner Coordinates:
    //     Upper Left  (-180.0000000,  90.0000000) (180d 0' 0.00"W, 90d 0' 0.00"N)
    //     Lower Left  (-180.0000000, -90.0000000) (180d 0' 0.00"W, 90d 0' 0.00"S)
    //     Upper Right ( 180.0000000,  90.0000000) (180d 0' 0.00"E, 90d 0' 0.00"N)
    //     Lower Right ( 180.0000000, -90.0000000) (180d 0' 0.00"E, 90d 0' 0.00"S)
    //     Center      (   0.0000000,  -0.0000000) (  0d 0' 0.00"E,  0d 0' 0.00"S)
    //     Band 1 Block=1x1 Type=Byte, ColorInterp=Red
    //     Band 2 Block=1x1 Type=Byte, ColorInterp=Green
    //     Band 3 Block=1x1 Type=Byte, ColorInterp=Blue

    //   */

    //   var file16int = File('./test/files/imageioext/test_IFD.tif');
    //   var raster = GeoImage(file16int);
    //   raster.read();

    //   var geoInfo = raster.geoInfo;

    //   var worldEnvelope = geoInfo!.worldEnvelope;
    //   var expected =
    //       Envelope(-180.0000000, 180.0000000, -90.0000000, 90.0000000);

    //   expect(
    //       NumberUtils.equalsWithTolerance(
    //           worldEnvelope.getMinX(), expected.getMinX(), 0.00000001),
    //       true);
    //   expect(
    //       NumberUtils.equalsWithTolerance(
    //           worldEnvelope.getMaxX(), expected.getMaxX(), 0.00000001),
    //       true);
    //   expect(
    //       NumberUtils.equalsWithTolerance(
    //           worldEnvelope.getMinY(), expected.getMinY(), 0.00000001),
    //       true);
    //   expect(
    //       NumberUtils.equalsWithTolerance(
    //           worldEnvelope.getMaxY(), expected.getMaxY(), 0.00000001),
    //       true);

    //   expect(geoInfo.cols, 1);
    //   expect(geoInfo.rows, 1);
    //   expect(geoInfo.srid, 4326);
    //   expect(
    //       NumberUtils.equalsWithTolerance(
    //           geoInfo.xRes!, 360.000000000072021, 0.00000001),
    //       true);
    //   expect(
    //       NumberUtils.equalsWithTolerance(
    //           geoInfo.yRes!, 180.000000000036010, 0.00000001),
    //       true);
    // });
    test('test tiff with overviews', () {
      /*

      Driver: GTiff/GeoTIFF
      Files: test/files/imageioext/test.tif
      Size is 30, 26
      Coordinate System is:
      PROJCRS["NAD83 / UTM zone 21N",
          BASEGEOGCRS["NAD83",
              DATUM["North American Datum 1983",
                  ELLIPSOID["GRS 1980",6378137,298.257222101,
                      LENGTHUNIT["metre",1]]],
              PRIMEM["Greenwich",0,
                  ANGLEUNIT["degree",0.0174532925199433]],
              ID["EPSG",4269]],
          CONVERSION["UTM zone 21N",
              METHOD["Transverse Mercator",
                  ID["EPSG",9807]],
              PARAMETER["Latitude of natural origin",0,
                  ANGLEUNIT["degree",0.0174532925199433],
                  ID["EPSG",8801]],
              PARAMETER["Longitude of natural origin",-57,
                  ANGLEUNIT["degree",0.0174532925199433],
                  ID["EPSG",8802]],
              PARAMETER["Scale factor at natural origin",0.9996,
                  SCALEUNIT["unity",1],
                  ID["EPSG",8805]],
              PARAMETER["False easting",500000,
                  LENGTHUNIT["metre",1],
                  ID["EPSG",8806]],
              PARAMETER["False northing",0,
                  LENGTHUNIT["metre",1],
                  ID["EPSG",8807]]],
          CS[Cartesian,2],
              AXIS["(E)",east,
                  ORDER[1],
                  LENGTHUNIT["metre",1]],
              AXIS["(N)",north,
                  ORDER[2],
                  LENGTHUNIT["metre",1]],
          USAGE[
              SCOPE["unknown"],
              AREA["Canada - 60°W to 54°W"],
              BBOX[40.57,-60,84,-54]],
          ID["EPSG",26921]]
      Data axis to CRS axis mapping: 1,2
      Origin = (688054.250000000000000,5683177.364485980942845)
      Pixel Size = (7874.000000000000000,-8120.769230769229580)
      Metadata:
        AREA_OR_POINT=Area
        TIFFTAG_RESOLUTIONUNIT=1 (unitless)
        TIFFTAG_XRESOLUTION=1
        TIFFTAG_YRESOLUTION=1
      Image Structure Metadata:
        INTERLEAVE=BAND
      Corner Coordinates:
      Upper Left  (  688054.250, 5683177.364) ( 54d18'15.05"W, 51d16' 7.94"N)
      Lower Left  (  688054.250, 5472037.364) ( 54d24'34.04"W, 49d22'19.17"N)
      Upper Right (  924274.250, 5683177.364) ( 50d55'57.33"W, 51d 8'32.45"N)
      Lower Right (  924274.250, 5472037.364) ( 51d10' 5.49"W, 49d15'13.11"N)
      Center      (  806164.250, 5577607.364) ( 52d42'10.89"W, 50d16'15.86"N)
      Band 1 Block=30x26 Type=Byte, ColorInterp=Gray
        Overviews: 15x13, 8x7, 4x4, 2x2, 1x1

  */

      var tiff = File('./test/files/imageioext/test.tif');
      var raster = GeoImage(tiff);
      raster.read(0);
      var geoInfo = raster.geoInfo!;
      expect(geoInfo.cols, 30);
      expect(geoInfo.rows, 26);
      expect(geoInfo.srid, 26921);

      raster.read(1);
      geoInfo = raster.geoInfo!;
      expect(geoInfo.cols, 15);
      expect(geoInfo.rows, 13);

      raster.read(2);
      geoInfo = raster.geoInfo!;
      expect(geoInfo.cols, 8);
      expect(geoInfo.rows, 7);

      raster.read(3);
      geoInfo = raster.geoInfo!;
      expect(geoInfo.cols, 4);
      expect(geoInfo.rows, 4);

      raster.read(4);
      geoInfo = raster.geoInfo!;
      expect(geoInfo.cols, 2);
      expect(geoInfo.rows, 2);

      raster.read(5);
      geoInfo = raster.geoInfo!;
      expect(geoInfo.cols, 1);
      expect(geoInfo.rows, 1);
    });

    test('test empty tiles tiff', () {
      var tiff = File('./test/files/imageioext/emptyTiles.tif');
      var raster = GeoRaster(tiff);
      raster.read();
      var geoInfo = raster.geoInfo!;
      expect(geoInfo.cols, 1440);
      expect(geoInfo.rows, 720);
      expect(geoInfo.srid, 4326);

      var readNV = raster.getDouble(1439, 0);
      expect(readNV.isNaN && geoInfo.noValue!.isNaN, true);
    });

    // TODO CHECK BACK ON THIS
    // test('test readLZWWithHorizontalDifferencingPredictorOn16Bits', () {
    //   var tiff1 = File('./test/files/imageioext/test.tif');
    //   var raster1 = GeoRaster(tiff1);
    //   raster1.read();
    //   var geoInfo1 = raster1.geoInfo;
    //   // This image has been created from test.tif using the command:
    //   // gdal_translate -OT UInt16 -co COMPRESS=LZW -co PREDICTOR=2 test.tif lzwtest.tif
    //   var tiff2 = File('./test/files/imageioext/lzwtest.tif');
    //   var raster2 = GeoRaster(tiff2);
    //   raster2.read();
    //   var geoInfo2 = raster2.geoInfo;

    //   expect(geoInfo1.cols, geoInfo2.cols);
    //   expect(geoInfo1.rows, geoInfo2.rows);
    //   expect(geoInfo1.srid, geoInfo2.srid);

    //   for (var r = 0; r < geoInfo1.rows; r++) {
    //     for (var c = 0; c < geoInfo1.cols; c++) {
    //       expect(raster1.getDouble(c, r), raster2.getDouble(c, r),
    //           reason: "Different value in rasters at col = $c, row = $r");
    //     }
    //   }
    // });

    // test('test readDeflateWithHorizontalDifferencingPredictorOn16Bits', () {
    //   var tiff1 = File('./test/files/imageioext/test.tif');
    //   var raster1 = GeoRaster(tiff1);
    //   raster1.read();
    //   var geoInfo1 = raster1.geoInfo;
    //   // This image has been created from test.tif using the command:
    //   // gdal_translate -OT UInt16 -co COMPRESS=DEFLATE -co PREDICTOR=2 test.tif deflatetest.tif
    //   var tiff2 = File('./test/files/imageioext/deflatetest.tif');
    //   var raster2 = GeoRaster(tiff2);
    //   raster2.read();
    //   var geoInfo2 = raster2.geoInfo;

    //   expect(geoInfo1.cols, geoInfo2.cols);
    //   expect(geoInfo1.rows, geoInfo2.rows);
    //   expect(geoInfo1.srid, geoInfo2.srid);

    //   for (var r = 0; r < geoInfo1.rows; r++) {
    //     for (var c = 0; c < geoInfo1.cols; c++) {
    //       expect(raster1.getDouble(c, r), raster2.getDouble(c, r),
    //           reason: "Different value in rasters at col = $c, row = $r");
    //     }
    //   }
    // });

    // test('test readDeflateWithFloatingPointPredictor', () {
    //   var tiff1 = File('./test/files/imageioext/test.tif');
    //   var raster1 = GeoRaster(tiff1);
    //   raster1.read();
    //   var geoInfo1 = raster1.geoInfo;
    //   // This image has been created from test.tif using the command:
    //   // gdal_translate -ot Float32 -co COMPRESS=DEFLATE -co PREDICTOR=3 test.tif deflate_predictor_3.tif
    //   var tiff2 = File('./test/files/imageioext/deflate_predictor_3.tif');
    //   var raster2 = GeoRaster(tiff2);
    //   raster2.read();
    //   var geoInfo2 = raster2.geoInfo;

    //   expect(geoInfo1.cols, geoInfo2.cols);
    //   expect(geoInfo1.rows, geoInfo2.rows);
    //   expect(geoInfo1.srid, geoInfo2.srid);

    //   for (var r = 0; r < geoInfo1.rows; r++) {
    //     for (var c = 0; c < geoInfo1.cols; c++) {
    //       expect(raster1.getDouble(c, r), raster2.getDouble(c, r),
    //           reason: "Different value in rasters at col = $c, row = $r");
    //     }
    //   }
    // });
  });

  group('Test worldimages', () {
    test('test jpg', () {
      var jpgFile = File('./test/files/worldimage/earthlights.jpg');
      var rasterJpg = GeoImage(jpgFile);
      rasterJpg.read();
      var geoInfoJpg = rasterJpg.geoInfo!;

      var expected =
          Envelope(-180.0000000, 180.0000000, -90.0000000, 90.0000000);
      expect(geoInfoJpg.worldEnvelope == expected, true);
      expect(geoInfoJpg.cols, 4800);
      expect(geoInfoJpg.rows, 2400);
      expect(geoInfoJpg.srid, -1);
      expect(geoInfoJpg.prjWkt,
          """GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.0174532925199433]]""");
    });

    test('test tiff and jpg', () {
      var jpgFile = File('./test/files/worldimage/earthlights.jpg');
      var rasterJpg = GeoImage(jpgFile);
      rasterJpg.read();
      var geoInfoJpg = rasterJpg.geoInfo!;
      var tiffFile = File('./test/files/worldimage/earthlights.tiff');
      var rasterTiff = GeoImage(tiffFile);
      rasterTiff.read();
      var geoInfoTiff = rasterTiff.geoInfo!;

      expect(geoInfoJpg.worldEnvelope == geoInfoTiff.worldEnvelope, true);
      expect(geoInfoJpg.prjWkt == geoInfoTiff.prjWkt, true);
    });
  });
  group('Test esri ascii grid', () {
    test('test asc io', () {
      var ascFile = File('./test/files/esriasc/dtm_flanginec.asc');
      var rasterAsc = GeoRaster(ascFile);
      rasterAsc.read();
      var geoInfoAsc = rasterAsc.geoInfo!;

      // NCOLS 355
      // NROWS 361
      // XLLCORNER 1637140.0
      // YLLCORNER 5110830.0
      // CELLSIZE 10.0
      // NODATA_VALUE -9999
      var expected = Envelope(
          1637140.0, 1637140.0 + 10.0 * 355, 5110830.0, 5110830.0 + 10.0 * 361);
      expect(geoInfoAsc.worldEnvelope == expected, true);
      expect(geoInfoAsc.cols, 355);
      expect(geoInfoAsc.rows, 361);
      expect(geoInfoAsc.xRes, 10.0);
      expect(geoInfoAsc.yRes, 10.0);
      expect(geoInfoAsc.noValue, -9999.0);
      expect(rasterAsc.getDouble(8, 0), 1217.385986328125);
      expect(geoInfoAsc.srid, -1);
      expect(
          geoInfoAsc.prjWkt!.trim(),
          """PROJCS["Monte Mario / Italy zone 1 - Peninsular Part/Accuracy 3-4m", 
  GEOGCS["Monte Mario", 
    DATUM["Monte Mario", 
      SPHEROID["International 1924", 6378388.0, 297.0, AUTHORITY["EPSG","7022"]], 
      TOWGS84[-104.1, -49.1, -9.9, 0.971, -2.917, 0.714, -11.68], 
      AUTHORITY["EPSG","6265"]], 
    PRIMEM["Greenwich", 0.0, AUTHORITY["EPSG","8901"]], 
    UNIT["degree", 0.017453292519943295], 
    AXIS["Geodetic longitude", EAST], 
    AXIS["Geodetic latitude", NORTH], 
    AUTHORITY["EPSG","4265"]], 
  PROJECTION["Transverse_Mercator"], 
  PARAMETER["central_meridian", 9.0], 
  PARAMETER["latitude_of_origin", 0.0], 
  PARAMETER["scale_factor", 0.9996], 
  PARAMETER["false_easting", 1500000.0], 
  PARAMETER["false_northing", 0.0], 
  UNIT["m", 1.0], 
  AXIS["Easting", EAST], 
  AXIS["Northing", NORTH], 
  AUTHORITY["EPSG","30031000"]]
"""
              .trim());
    });
  });
  // group('Test modules', () {
  //   test('test aspect', () {
  //     var ascFile = File('./test/files/esriasc/dtm_flanginec.asc');
  //     var rasterAsc = GeoRaster(ascFile);
  //     rasterAsc.read();
  //     var aspect = Aspect()
  //       ..doRadiants = false
  //       ..doRound = true
  //       ..inElev = rasterAsc;
  //     aspect.process();
  //     var outAspect = aspect.outAspect;
  //     outAspect.write("/Users/hydrologis/TMP/HORTONTESTS/testaspect.asc");
  //   });
  // });

  group('image tests', () {
    test('color to alpha', () async {
      var imgfile = File('./test/files/img/blackred2x2.png');

      var image = await ImageUtilities.imageFromFile(imgfile.path);
      var newImage = ImageUtilities.colorToAlpha(image!, 0, 0, 0);

      // var newImage = decodeImage(newBytes);
      var newPixels = newImage.getBytes(order: ChannelOrder.rgba);

      //check changed alpha
      expect(newPixels[3], 0);
      expect(newPixels[7], 255);
      expect(newPixels[11], 255);
      expect(newPixels[15], 0);
    });
  });

  group('singleband image tests', () {
    test('dtm test', () async {
      var imgfile = File('./test/files/singleband/dtm_test.tiff');
      var bytes = ImageUtilities.bytesFromImageFile(imgfile.path);

      var image = TiffDecoder().decode(Uint8List.fromList(bytes));
      expect(image!.width, 10);
      expect(image.height, 8);

      for (var row = 0; row < image.height; row++) {
        for (var col = 0; col < image.width; col++) {
          var redValue = image.data!.getPixel(col, row).r.toDouble();
          if (redValue == -10000.0) {
            // the image library doesn't read the novalue properly
            // for now ignore it
            continue;
          }
          expect(redValue, expectedSingleBandData[row][col]);
        }
      }
    });
  });
}

var expectedSingleBandData = [
  [
    800.0,
    900.0,
    1000.0,
    1000.0,
    1200.0,
    1250.0,
    1300.0,
    1350.0,
    1450.0,
    1500.0
  ],
  [
    600.0,
    -9999.0,
    750.0,
    850.0,
    860.0,
    900.0,
    1000.0,
    1200.0,
    1250.0,
    1500.0
  ], //
  [500.0, 550.0, 700.0, 750.0, 800.0, 850.0, 900.0, 1000.0, 1100.0, 1500.0], //
  [400.0, 410.0, 650.0, 700.0, 750.0, 800.0, 850.0, 490.0, 450.0, 1500.0], //
  [450.0, 550.0, 430.0, 500.0, 600.0, 700.0, 800.0, 500.0, 450.0, 1500.0], //
  [500.0, 600.0, 700.0, 750.0, 760.0, 770.0, 850.0, 1000.0, 1150.0, 1500.0], //
  [600.0, 700.0, 750.0, 800.0, 780.0, 790.0, 1000.0, 1100.0, 1250.0, 1500.0], //
  [
    800.0,
    910.0,
    980.0,
    1001.0,
    1150.0,
    1200.0,
    1250.0,
    1300.0,
    1450.0,
    1500.0
  ], //
];

const ND = GeoimageUtils.doubleNovalue;
const NI = GeoimageUtils.intNovalue;

List<List<double>> mapData = [
  //
  [
    800.0,
    900.0,
    1000.0,
    1000.0,
    1200.0,
    1250.0,
    1300.0,
    1350.0,
    1450.0,
    1500.0
  ], //
  [600.0, ND, 750.0, 850.0, 860.0, 900.0, 1000.0, 1200.0, 1250.0, 1500.0], //
  [500.0, 550.0, 700.0, 750.0, 800.0, 850.0, 900.0, 1000.0, 1100.0, 1500.0], //
  [400.0, 410.0, 650.0, 700.0, 750.0, 800.0, 850.0, 490.0, 450.0, 1500.0], //
  [450.0, 550.0, 430.0, 500.0, 600.0, 700.0, 800.0, 500.0, 450.0, 1500.0], //
  [500.0, 600.0, 700.0, 750.0, 760.0, 770.0, 850.0, 1000.0, 1150.0, 1500.0], //
  [600.0, 700.0, 750.0, 800.0, 780.0, 790.0, 1000.0, 1100.0, 1250.0, 1500.0], //
  [
    800.0,
    910.0,
    980.0,
    1001.0,
    1150.0,
    1200.0,
    1250.0,
    1300.0,
    1450.0,
    1500.0
  ] //
];

List<List<int>> tcaData = [
  //
  /*    */ [NI, NI, NI, NI, NI, NI, NI, NI, NI, NI], //
  [NI, NI, 1, 1, 1, 1, 1, 1, 1, NI], //
  [NI, 2, 2, 2, 2, 2, 2, 2, 1, NI], //
  [NI, 46, 3, 3, 3, 3, 1, 5, 2, NI], //
  [NI, 1, 37, 32, 20, 15, 11, 5, 2, NI], //
  [NI, 2, 2, 2, 3, 1, 2, 2, 1, NI], //
  [NI, 1, 1, 1, 1, 2, 1, 1, 1, NI], //
  [NI, NI, NI, NI, NI, NI, NI, NI, NI, NI] //
];

List<List<int>> flowData = [
  //
  [NI, NI, NI, NI, NI, NI, NI, NI, NI, NI], //
  [NI, NI, 6, 6, 6, 6, 6, 6, 6, NI], //
  [NI, 7, 6, 6, 6, 6, 6, 7, 7, NI], //
  [NI, 5, 5, 7, 6, 6, 6, 6, 5, NI], //
  [NI, 3, 4, 5, 5, 5, 5, 5, 5, NI], //
  [NI, 2, 3, 3, 4, 4, 4, 3, 3, NI], //
  [NI, 4, 4, 4, 4, 4, 5, 4, 4, NI], //
  [NI, NI, NI, NI, NI, NI, NI, NI, NI, NI] //
];
