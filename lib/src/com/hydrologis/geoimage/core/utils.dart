import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:geoimage/src/com/hydrologis/geoimage/core/abstractgeoimage.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as p;

class GeoimageUtils {
  static const doubleNovalue = -9999.0;

  static const intNovalue = -9999;

  static const ASC_EXT = "asc";
  static const TIFF_EXT = "tiff";
  static const TIF_EXT = "tif";
  static const TIF_WLD_EXT = "tfw";
  static const JPG_EXT = "jpg";
  static const JPG_WLD_EXT = "jgw";
  static const PNG_EXT = "png";
  static const PNG_WLD_EXT = "pgw";

  /// Checks if the supplied [path] refers to a [GeoImage] format, basing on the file extension.
  static bool isGeoImage(String? path) {
    return path != null &&
        (isTiff(path) ||
            path.toLowerCase().endsWith(PNG_EXT) ||
            path.toLowerCase().endsWith(JPG_EXT));
  }

  /// Checks if the supplied [path] refers to a [GeoRaster] format, basing on the file extension.
  static bool isGeoRaster(String? path) {
    return path != null && (isTiff(path) || isAsc(path));
  }

  static bool isTiff(String imagePath) {
    return imagePath.toLowerCase().endsWith(TIF_EXT) ||
        imagePath.toLowerCase().endsWith(TIFF_EXT);
  }

  static bool isAsc(String imagePath) {
    return imagePath.toLowerCase().endsWith(ASC_EXT);
  }

  static String? getWorldFile(String imagePath) {
    String folder = p.dirname(imagePath);
    var name = p.basenameWithoutExtension(imagePath);
    var ext;
    var lastDot = imagePath.lastIndexOf(".");
    if (lastDot > 0) {
      ext = imagePath.substring(lastDot + 1);
    } else {}
    var wldExt;
    if (ext == JPG_EXT) {
      wldExt = JPG_WLD_EXT;
    } else if (ext == PNG_EXT) {
      wldExt = PNG_WLD_EXT;
    } else if (ext == TIF_EXT || ext == TIFF_EXT) {
      wldExt = TIF_WLD_EXT;
    } else {
      return null;
    }

    var wldPath = p.join(folder, name + "." + wldExt);
    var wldFile = File(wldPath);
    if (wldFile.existsSync()) {
      return wldPath;
    }
    return null;
  }

  static String? getPrjFile(String imagePath, {bool alsoIfNotExists = false}) {
    String folder = p.dirname(imagePath);
    var name = p.basenameWithoutExtension(imagePath);
    var prjPath = p.join(folder, name + ".prj");
    var prjFile = File(prjPath);
    if (alsoIfNotExists || prjFile.existsSync()) {
      return prjPath;
    }
    return null;
  }

  static String? getPrjWkt(String imagePath) {
    String? path = getPrjFile(imagePath);
    if (path != null) {
      return File(path).readAsStringSync();
    }
    return null;
  }

  static List<double>? parseWorldFile(String imagePath, int width, int height) {
    var worldFile = getWorldFile(imagePath);
    if (worldFile == null) {
      return null;
    }
    var tfwList = readFileToList(worldFile);
    var xRes = double.parse(tfwList[0]);
    var yRes = -double.parse(tfwList[3]);
    var xExtent = width * xRes;
    var yExtent = height * yRes;

    var west = double.parse(tfwList[4]) - xRes / 2.0;
    var north = double.parse(tfwList[5]) + yRes / 2.0;
    var east = west + xExtent;
    var south = north - yExtent;
    return <double>[west, east, south, north, xRes, yRes];
  }

  static List<String> readFileToList(String filePath) {
    var fileText = File(filePath).readAsStringSync();
    List<String> split = fileText.split('\n');
    return split;
  }
}

enum Direction { E, EN, N, NW, W, WS, S, SE }

class TiffTags {
  static final GEOKEY_DIRECTORY_TAG = 34735;
  static final MODEL_TRANSFORMATION_TAG = 34264;
  static final MODEL_TIEPOINT_TAG = 33922;
  static final MODEL_PIXELSCALE_TAG = 33550;
  static final TAG_GDAL_NODATA = 42113;
}

/// A node of a regular grid. Helps to access neighbour cells.
class GridNode {
  final int _col;
  final int _row;
  final AbstractGeoRaster _raster;
  bool _touchesBound = false;

  GridNode(this._raster, this._col, this._row) {
    if (_col == 0 ||
        _row == 0 ||
        _col == _raster.geoInfo!.cols! - 1 ||
        _row == _raster.geoInfo!.rows! - 1) {
      _touchesBound = true;
    }
  }

  int get col => _col;

  int get row => _row;

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

/// Class to help out with numeric issues, mostly due to floating point usage.
///
/// <p>
/// Since the floating point representation keeps a constant relative precision,
/// comparison is done using relative error.
/// </p>
/// <p>
/// Be aware of the fact that the methods
/// <ul>
/// <li>{@link #dEq(double, double)}</li>
/// <li>{@link #fEq(float, float)}</li>
/// </ul>
/// can be used in the case of "simple" numerical
/// comparison, while in the case of particular values that are generated through
/// iterations the user/developer should consider to supply an epsilon value
/// derived from the knowledge of the domain of the current problem
/// and use the methods
/// <ul>
/// <li>{@link #dEq(double, double, double)}</li>
/// <li>{@link #fEq(float, float, float)}</li>
/// </ul>
/// </p>
///
/// @author Andrea Antonello (www.hydrologis.com)
class NumericsUtilities {
  /// Radiants to degrees conversion factor.
  static const RADTODEG = 360.0 / (2.0 * math.pi);

  /// Returns true if two doubles are considered equal based on a tolerance of {@value #D_TOLERANCE}.
  ///
  /// <p>Note that two {@link Double#NaN} are seen as equal and return true.</p>
  ///
  /// @param a double to compare.
  /// @param b double to compare.
  /// @return true if two doubles are considered equal.
  static bool dEq(double a, double b, double epsilon) {
    if (a.isNaN && b.isNaN) {
      return true;
    }
    var diffAbs = (a - b).abs();
    return a == b
        ? true
        : diffAbs < epsilon
            ? true
            : diffAbs / math.max(a.abs(), b.abs()) < epsilon;
  }

  /// Calculates the hypothenuse as of the Pythagorean theorem.
  ///
  /// @param d1 the length of the first leg.
  /// @param d2 the length of the second leg.
  /// @return the length of the hypothenuse.
  static double pythagoras(double d1, double d2) {
    return math.sqrt(math.pow(d1, 2.0) + math.pow(d2, 2.0));
  }

  /// Check if value is inside a ND interval (bounds included).
  ///
  /// @param value the value to check.
  /// @param ranges the bounds (low1, high1, low2, high2, ...)
  /// @return <code>true</code> if value lies inside the interval.
  static bool isBetween(double value, List<double> ranges) {
    var even = true;
    for (var i = 0; i < ranges.length; i++) {
      if (even) {
        // lower bound
        if (value < ranges[i]) {
          return false;
        }
      } else {
        // higher bound
        if (value > ranges[i]) {
          return false;
        }
      }
      even = !even;
    }
    return true;
  }

  /// Lanczos coefficients
  static final List<double> LANCZOS = [
    0.99999999999999709182,
    57.156235665862923517,
    -59.597960355475491248,
    14.136097974741747174,
    -0.49191381609762019978,
    .33994649984811888699e-4,
    .46523628927048575665e-4,
    -.98374475304879564677e-4,
    .15808870322491248884e-3,
    -.21026444172410488319e-3,
    .21743961811521264320e-3,
    -.16431810653676389022e-3,
    .84418223983852743293e-4,
    -.26190838401581408670e-4,
    .36899182659531622704e-5,
  ];

  /// Avoid repeated computation of log of 2 PI in logGamma
  static final double HALF_LOG_2_PI = 0.5 * math.log(2.0 * math.pi);

  /// Gamma function ported from the apache math package.
  ///
  /// <b>This should be removed if the apache math lib gets in use by HortonMachine.</b>
  ///
  /// <p>Returns the natural logarithm of the gamma function &#915;(x).
  ///
  /// The implementation of this method is based on:
  /// <ul>
  /// <li><a href="http://mathworld.wolfram.com/GammaFunction.html">
  /// Gamma Function</a>, equation (28).</li>
  /// <li><a href="http://mathworld.wolfram.com/LanczosApproximation.html">
  /// Lanczos Approximation</a>, equations (1) through (5).</li>
  /// <li><a href="http://my.fit.edu/~gabdo/gamma.txt">Paul Godfrey, A note on
  /// the computation of the convergent Lanczos complex Gamma approximation
  /// </a></li>
  /// </ul>
  ///
  /// @param x Value.
  /// @return log(&#915;(x))
  static double logGamma(double x) {
    double ret;

    if (x.isNaN || (x <= 0.0)) {
      ret = double.nan;
    } else {
      var g = 607.0 / 128.0;

      var sum = 0.0;
      for (var i = LANCZOS.length - 1; i > 0; --i) {
        sum = sum + (LANCZOS[i] / (x + i));
      }
      sum = sum + LANCZOS[0];

      var tmp = x + g + .5;
      ret =
          ((x + .5) * math.log(tmp)) - tmp + HALF_LOG_2_PI + math.log(sum / x);
    }

    return ret;
  }

  static double gamma(double x) {
    return math.exp(logGamma(x));
  }

  /**
     * Normalizes a value for a given normalization max (assuming the lower is 0).
     * 
     * @param max the max of the sampling values.
     * @param min the min of the sampling values.
     * @param value the current value from the sampling values to be normalized.
     * @param normMax the normalization maximum to use.
     * @return the normalized value.
     */
  static double normalize(
      double max, double min, double value, double normMax) {
    return normMax / (1 + ((max - value) / (value - min)));
  }
}

/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a BSD 3 license that can be
 * found in the LICENSE file.
 */

/// Image utilities
class ImageUtilities {
  static Image? imageFromBytes(Uint8List bytes) {
    Image? image = decodeImage(bytes);
    return image;
  }

//  static void imageBytes2File(File file, List<int> bytes) {
//    Image img = imageFromBytes(bytes);
//
//    writeJpg(img)
//
//  }

  static List<int> bytesFromImageFile(String path) {
    File imgFile = File(path);
    return imgFile.readAsBytesSync();
  }

  static Future<Image?> imageFromFile(String path) async {
    return decodeImageFile(path);
  }

  static List<int> resizeImage(Uint8List bytes,
      {int newWidth = 100, int? longestSizeTo}) {
    Image image = decodeWithCheck(bytes);

    Image thumbnail;
    if (longestSizeTo != null) {
      if (image.width > image.height) {
        thumbnail = copyResize(
          image,
          width: longestSizeTo,
        );
      } else {
        thumbnail = copyResize(
          image,
          height: longestSizeTo,
        );
      }
    } else {
      thumbnail = copyResize(
        image,
        width: newWidth,
      );
    }
    var encoded = encodeJpg(thumbnail);
    return encoded;
  }

  static Image decodeWithCheck(Uint8List bytes) {
    Image? image = decodeImage(bytes);
    // image.set
    if (image == null) {
      throw StateError("No image can be decoded from input data.");
    }
    return image;
  }

  /// Makes pixels of the [image] transparent if color is defined as [r], [g], [b].
  ///
  /// returns an image, yet to be encoded.
  static Image colorToAlpha(Image image, int r, int g, int b) {
    if (image.numChannels == 3) {
      image = image.convert(numChannels: 4);
    }
    var data = image.data!;
    for (var row = 0; row < data.height; row = row + 1) {
      for (var col = 0; col < data.width; col = col + 1) {
        var p = data.getPixel(col, row);
        if (p.r.toInt() == r && p.g.toInt() == g && p.b.toInt() == b) {
          p.setRgba(r, g, b, 0);
        }
      }
    }
    return image;
    // for (var i = 0; i < length; i = i + 4) {
    //   if (pixels[i] == r && pixels[i + 1] == g && pixels[i + 2] == b) {
    //     pixels[i + 3] = 0;
    //   }
    // }
    // set the fact that it now has an alpha channel, else it will not work if prior rgb
    // image.channels = Channels.rgba;
  }

  /// Removes the given color as solid background from the image.
  static void colorToAlphaBlend(
      Image image, int redToHide, int greenToHide, int blueToHide) {
    Uint8List pixels = image.getBytes(order: ChannelOrder.rgba);
    final length = pixels.lengthInBytes;
    for (var i = 0; i < length; i = i + 4) {
      c2a(pixels, i, redToHide, greenToHide, blueToHide);
    }
    // set the fact that it now has an alpha channel, else it will not work if prior rgb
    // image.channels = Channels.rgba;
  }

  static void c2a(Uint8List pixels, int index, int redToHide, int greenToHide,
      int blueToHide) {
    int red = pixels[index];
    int green = pixels[index + 1];
    int blue = pixels[index + 2];
    double alpha = pixels[index + 3].toDouble();

    double a4 = alpha;

    double a1 = 0.0;
    if (red > redToHide) {
      a1 = (red - redToHide) / (255.0 - redToHide);
    } else if (red < redToHide) {
      a1 = (redToHide - red) / (redToHide);
    }
    double a2 = 0.0;
    if (green > greenToHide) {
      a2 = (green - greenToHide) / (255.0 - greenToHide);
    } else if (green < greenToHide) {
      a2 = (greenToHide - green) / (greenToHide);
    }
    double a3 = 0.0;
    if (blue > blueToHide) {
      a3 = (blue - blueToHide) / (255.0 - blueToHide);
    } else if (blue < blueToHide) {
      a3 = (blueToHide - blue) / (blueToHide);
    }

    if (a1 > a2) {
      if (a1 > a3) {
        alpha = a1;
      } else {
        alpha = a3;
      }
    } else {
      if (a2 > a3) {
        alpha = a2;
      } else {
        alpha = a3;
      }
    }

    alpha *= 255.0;

    if (alpha >= 1.0) {
      red = (255.0 * (red - redToHide) / alpha + redToHide).toInt();
      green = (255.0 * (green - greenToHide) / alpha + greenToHide).toInt();
      blue = (255.0 * (blue - blueToHide) / alpha + blueToHide).toInt();

      alpha *= a4 / 255.0;
    }
    pixels[index] = red;
    pixels[index + 1] = green;
    pixels[index + 2] = blue;
    pixels[index + 3] = alpha.toInt();
  }
}
