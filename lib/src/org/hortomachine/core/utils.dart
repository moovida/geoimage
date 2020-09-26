import 'dart:math' as math;

class HMConstants {
  static const doubleNovalue = -9999.0;

  static const intNovalue = -9999;
}

enum Direction { E, EN, N, NW, W, WS, S, SE }

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
