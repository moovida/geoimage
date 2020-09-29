import 'dart:math';

import 'package:geoimage/src/com/hydrologis/geoimage/core/utils.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/abstractgeoimage.dart';
import 'package:geoimage/src/com/hydrologis/geoimage/core/impl/georaster.dart';

class Aspect {
  /// The input elevation raster.
  AbstractGeoRaster inElev;

  /// Switch to define whether create the output map in degrees (default) or radiants.
  bool doRadiants = false;

  /// Switch to define whether the output map values should be rounded (might make sense in the case of degree maps).
  bool doRound = false;

  /// The map of aspect.
  AbstractGeoRaster outAspect;

  static final nv = GeoimageUtils.doubleNovalue;

  void process() {
    var radtodeg = NumericsUtilities.RADTODEG;
    if (doRadiants) {
      radtodeg = 1.0;
    }

    var geoInfo = inElev.geoInfo;
    double xRes = geoInfo.xRes;
    double yRes = geoInfo.yRes;

    outAspect = GeoRaster.ascToWrite(geoInfo.cols, geoInfo.rows, geoInfo.xRes,
        geoInfo.worldEnvelope.getMinX(), geoInfo.worldEnvelope.getMinY(),
        defaultValue: nv, novalue: nv, prjWkt: geoInfo.prjWkt);

    inElev.loopWithGridNode((GridNode node) {
      if (node.touchesBound) {
        //aspectIter.setSample(col, row, 0, HMConstants.shortNovalue);
        outAspect.setInt(node.col, node.row, GeoimageUtils.intNovalue);
      } else {
        double aspect = calculateAspect(node, radtodeg, doRound, xRes, yRes);
        if (doRound) {
          //  aspectIter.setSample(col, row, 0, (short) aspect);
          outAspect.setInt(node.col, node.row, aspect.round());
        } else {
          outAspect.setDouble(node.col, node.row, aspect);
        }
      }
    });
  }

  /**
     * Calculates the aspect in a given {@link GridNode}.
     * 
     * @param node the current grid node.
     * @param radtodeg radiants to degrees conversion factor. Use {@link NumericsUtilities#RADTODEG} if you 
     *                 want degrees, use 1 if you want radiants. 
     * @param doRound if <code>true</code>, values are round to integer.
     * @return the value of aspect.
     */
  static double calculateAspect(
      GridNode node, double radtodeg, bool doRound, double xRes, double yRes) {
    double aspect = nv;
    // the value of the x and y derivative
    double aData = 0.0;
    double bData = 0.0;
    double centralValue = node.getDouble();
    double nValue = node.getDoubleAt(Direction.N);
    double sValue = node.getDoubleAt(Direction.S);
    double wValue = node.getDoubleAt(Direction.W);
    double eValue = node.getDoubleAt(Direction.E);

    if (!isNovalue(centralValue)) {
      bool sIsNovalue = isNovalue(sValue);
      bool nIsNovalue = isNovalue(nValue);
      bool wIsNovalue = isNovalue(wValue);
      bool eIsNovalue = isNovalue(eValue);

      if (!sIsNovalue && !nIsNovalue) {
        aData = atan((nValue - sValue) / (2 * yRes));
      } else if (nIsNovalue && !sIsNovalue) {
        aData = atan((centralValue - sValue) / (yRes));
      } else if (!nIsNovalue && sIsNovalue) {
        aData = atan((nValue - centralValue) / (yRes));
      } else if (nIsNovalue && sIsNovalue) {
        aData = nv;
      } else {
        throw StateError("");
      }
      if (!wIsNovalue && !eIsNovalue) {
        bData = atan((wValue - eValue) / (2 * xRes));
      } else if (wIsNovalue && !eIsNovalue) {
        bData = atan((centralValue - eValue) / (xRes));
      } else if (!wIsNovalue && eIsNovalue) {
        bData = atan((wValue - centralValue) / (xRes));
      } else if (wIsNovalue && eIsNovalue) {
        bData = nv;
      } else {
        // can't happen
        throw StateError("");
      }

      double delta = 0.0;
      // calculate the aspect value
      if (aData < 0 && bData > 0) {
        delta = acos(sin(aData.abs()) *
            cos(bData.abs()) /
            (sqrt(1 - pow(cos(aData), 2) * pow(cos(bData), 2))));
        aspect = delta * radtodeg;
      } else if (aData > 0 && bData > 0) {
        delta = acos(sin(aData.abs()) *
            cos(bData.abs()) /
            (sqrt(1 - pow(cos(aData), 2) * pow(cos(bData), 2))));
        aspect = (pi - delta) * radtodeg;
      } else if (aData > 0 && bData < 0) {
        delta = acos(sin(aData.abs()) *
            cos(bData.abs()) /
            (sqrt(1 - pow(cos(aData), 2) * pow(cos(bData), 2))));
        aspect = (pi + delta) * radtodeg;
      } else if (aData < 0 && bData < 0) {
        delta = acos(sin(aData.abs()) *
            cos(bData.abs()) /
            (sqrt(1 - pow(cos(aData), 2) * pow(cos(bData), 2))));
        aspect = (2 * pi - delta) * radtodeg;
      } else if (aData == 0 && bData > 0) {
        aspect = (pi / 2.0) * radtodeg;
      } else if (aData == 0 && bData < 0) {
        aspect = (pi * 3.0 / 2.0) * radtodeg;
      } else if (aData > 0 && bData == 0) {
        aspect = pi * radtodeg;
      } else if (aData < 0 && bData == 0) {
        aspect = 2.0 * pi * radtodeg;
      } else if (aData == 0 && bData == 0) {
        aspect = 0.0;
      } else if (isNovalue(aData) || isNovalue(bData)) {
        aspect = nv;
      } else {
        // can't happen
        throw StateError("");
      }
      if (doRound) {
        aspect = aspect.round().toDouble();
      }
    }
    return aspect;
  }

  static bool isNovalue(double value) {
    return GeoimageUtils.doubleNovalue == value;
  }
}
