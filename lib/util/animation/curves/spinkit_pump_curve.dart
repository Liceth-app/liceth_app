// thanks to: https://github.com/jogboms/flutter_spinkit/blob/master/lib/src/pumping_heart.dart
import 'package:flutter/widgets.dart';
import 'dart:math' as math show pow;

class SpinKitPumpCurve extends Curve {
  const SpinKitPumpCurve();

  static const magicNumber = 4.54545454;

  @override
  double transform(double t) {
    if (t >= 0.0 && t < 0.22) {
      return math.pow(t, 1.0) * magicNumber;
    } else if (t >= 0.22 && t < 0.44) {
      return 1.0 - (math.pow(t - 0.22, 1.0) * magicNumber);
    } else if (t >= 0.44 && t < 0.5) {
      return 0.0;
    } else if (t >= 0.5 && t < 0.72) {
      return math.pow(t - 0.5, 1.0) * (magicNumber / 2);
    } else if (t >= 0.72 && t < 0.94) {
      return 0.5 - (math.pow(t - 0.72, 1.0) * (magicNumber / 2));
    }
    return 0.0;
  }
}
