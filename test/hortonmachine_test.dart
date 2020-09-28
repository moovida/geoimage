import 'dart:io';

import 'package:dart_jts/dart_jts.dart';
import 'package:hortonmachine/hortonmachine.dart';
import 'package:hortonmachine/src/org/hortomachine/core/utils.dart';
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
      var raster = SingleBandGeoRaster(file32bit);
      raster.read();

      var geoInfo = raster.geoInfo;

      var worldEnvelope = geoInfo.worldEnvelope;
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
      var raster = SingleBandGeoRaster(file32bit);
      raster.read();
      raster.loopWithFloatValue((col, row, value) {
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
      var raster = SingleBandGeoRaster(file64bit);
      raster.read();
      raster.loopWithFloatValue((col, row, value) {
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
      var raster = SingleBandGeoRaster(file32int);
      raster.read();
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
      var raster = SingleBandGeoRaster(file16int);
      raster.read();
      raster.loopWithIntValue((col, row, value) {
        var expected = flowData[row][col];
        expect(value, expected);
      });
    });
  });

  group('Test imageio-ext tiffs', () {
    test('test tiff with ModelPixelScaleTag', () {
      /*
        Driver: GTiff/GeoTIFF
        Files: test/files/imageioext/test_IFD.tif
        Size is 1, 1
        Coordinate System is:
        GEOGCRS["WGS 84",
            DATUM["World Geodetic System 1984",
                ELLIPSOID["WGS 84",6378137,298.257223563,
                    LENGTHUNIT["metre",1]]],
            PRIMEM["Greenwich",0,
                ANGLEUNIT["degree",0.0174532925199433]],
            CS[ellipsoidal,2],
                AXIS["geodetic latitude (Lat)",north,
                    ORDER[1],
                    ANGLEUNIT["degree",0.0174532925199433]],
                AXIS["geodetic longitude (Lon)",east,
                    ORDER[2],
                    ANGLEUNIT["degree",0.0174532925199433]],
            ID["EPSG",4326]]
        Data axis to CRS axis mapping: 2,1
        Origin = (-180.000000000000000,90.000000000000014)
        Pixel Size = (360.000000000072021,-180.000000000036010)
        Metadata:
          AREA_OR_POINT=Area
          TIFFTAG_DATETIME=2012:07:16 09:23:22
          TIFFTAG_RESOLUTIONUNIT=2 (pixels/inch)
          TIFFTAG_SOFTWARE=Adobe Photoshop CS5 Macintosh
          TIFFTAG_XRESOLUTION=72
          TIFFTAG_YRESOLUTION=72
        Image Structure Metadata:
          INTERLEAVE=PIXEL
        Corner Coordinates:
        Upper Left  (-180.0000000,  90.0000000) (180d 0' 0.00"W, 90d 0' 0.00"N)
        Lower Left  (-180.0000000, -90.0000000) (180d 0' 0.00"W, 90d 0' 0.00"S)
        Upper Right ( 180.0000000,  90.0000000) (180d 0' 0.00"E, 90d 0' 0.00"N)
        Lower Right ( 180.0000000, -90.0000000) (180d 0' 0.00"E, 90d 0' 0.00"S)
        Center      (   0.0000000,  -0.0000000) (  0d 0' 0.00"E,  0d 0' 0.00"S)
        Band 1 Block=1x1 Type=Byte, ColorInterp=Red
        Band 2 Block=1x1 Type=Byte, ColorInterp=Green
        Band 3 Block=1x1 Type=Byte, ColorInterp=Blue

      */

      var file16int = File('./test/files/imageioext/test_IFD.tif');
      var raster = GeoRaster(file16int);
      raster.read();

      var geoInfo = raster.geoInfo;

      var worldEnvelope = geoInfo.worldEnvelope;
      var expected =
          Envelope(-180.0000000, 180.0000000, -90.0000000, 90.0000000);

      expect(
          NumberUtils.equalsWithTolerance(
              worldEnvelope.getMinX(), expected.getMinX(), 0.00000001),
          true);
      expect(
          NumberUtils.equalsWithTolerance(
              worldEnvelope.getMaxX(), expected.getMaxX(), 0.00000001),
          true);
      expect(
          NumberUtils.equalsWithTolerance(
              worldEnvelope.getMinY(), expected.getMinY(), 0.00000001),
          true);
      expect(
          NumberUtils.equalsWithTolerance(
              worldEnvelope.getMaxY(), expected.getMaxY(), 0.00000001),
          true);

      expect(geoInfo.cols, 1);
      expect(geoInfo.rows, 1);
      expect(geoInfo.srid, 4326);
      expect(
          NumberUtils.equalsWithTolerance(
              geoInfo.xRes, 360.000000000072021, 0.00000001),
          true);
      expect(
          NumberUtils.equalsWithTolerance(
              geoInfo.yRes, 180.000000000036010, 0.00000001),
          true);
    });
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
      var raster = GeoRaster(tiff);
      raster.read(0);
      var geoInfo = raster.geoInfo;
      expect(geoInfo.cols, 30);
      expect(geoInfo.rows, 26);
      print(geoInfo.printTags());
      expect(geoInfo.srid, 26921);

      raster.read(1);
      geoInfo = raster.geoInfo;
      expect(geoInfo.cols, 15);
      expect(geoInfo.rows, 13);

      raster.read(2);
      geoInfo = raster.geoInfo;
      expect(geoInfo.cols, 8);
      expect(geoInfo.rows, 7);

      raster.read(3);
      geoInfo = raster.geoInfo;
      expect(geoInfo.cols, 4);
      expect(geoInfo.rows, 4);

      raster.read(4);
      geoInfo = raster.geoInfo;
      expect(geoInfo.cols, 2);
      expect(geoInfo.rows, 2);

      raster.read(5);
      geoInfo = raster.geoInfo;
      expect(geoInfo.cols, 1);
      expect(geoInfo.rows, 1);
    });

    test('test empty tiles tiff', () {
      var tiff = File('./test/files/imageioext/emptyTiles.tif');
      var raster = GeoRaster(tiff);
      raster.read();
      var geoInfo = raster.geoInfo;
      expect(geoInfo.cols, 1440);
      expect(geoInfo.rows, 720);
      expect(geoInfo.srid, 4326);

      var readNV = raster.getDouble(1439, 0);
      expect(readNV.isNaN && geoInfo.noValue.isNaN, true);
    });
  });
}

const ND = HMConstants.doubleNovalue;
const NI = HMConstants.intNovalue;

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
