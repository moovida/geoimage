import 'dart:io';

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
      var raster = SingleBandRaster(file32bit);
      raster.open();
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
      var raster = SingleBandRaster(file32bit);
      raster.open();
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
      var file64bit = File('./test/files/dtm64.tiff');
      var raster = SingleBandRaster(file64bit);
      raster.open();
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
      var raster = SingleBandRaster(file32int);
      raster.open();
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
      var raster = SingleBandRaster(file16int);
      raster.open();
      raster.loopWithIntValue((col, row, value) {
        var expected = flowData[row][col];
        expect(value, expected);
      });
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
