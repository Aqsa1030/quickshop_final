import 'package:flutter/widgets.dart';

class Responsive {
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isMobile(BuildContext context) {
    return screenWidth(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    return screenWidth(context) >= 600 && screenWidth(context) < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= 1200;
  }

  static double responsiveValue(BuildContext context,
      {double mobile = 1, double tablet = 1.5, double desktop = 2}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static EdgeInsetsGeometry responsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32);
    } else {
      return const EdgeInsets.symmetric(horizontal: 64);
    }
  }

  static int responsiveGridColumns(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  static double responsiveFontSize(BuildContext context,
      {double mobile = 14, double tablet = 16, double desktop = 18}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static double responsiveIconSize(BuildContext context,
      {double mobile = 24, double tablet = 28, double desktop = 32}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }
}