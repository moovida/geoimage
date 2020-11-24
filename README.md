A geo-wrapper around the image project (https://pub.dev/packages/image)

This is supposed to provide information about the geographic boundaries of the image, the resolution, the projection.

In case of tiff and esrii ascii grid also physical data are accessible.

Supported formats :

- as geo-imagery
  - geotiff
  - tiff/png/jpg with worldfile and prj file
- as single band geo-raster
  - esri ascii grid
  - geotiff
  - tiff with worldfile and prj file
