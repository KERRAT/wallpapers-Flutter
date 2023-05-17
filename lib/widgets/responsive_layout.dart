import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:sizer/sizer.dart';

class LayoutHelpers {
  static double getAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height * 0.8;
    return screenWidth / screenHeight;
  }

  static double getWidthFactor(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 380) {
      return 0.8;
    } else if (screenWidth <= 540) {
      return 1;
    } else {
      return 1;
    }
  }

  static double scaleSideButtonToDisplaySize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 540) {
      return 6.5.h;
    } else {
      return 6.h;
    }
  }

  static double scaleShareButtonToDisplaySize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 540) {
      return 8.5.h;
    } else {
      return 8.h;
    }
  }

  static double scaleReturnButtonToDisplaySize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 540) {
      return 5.5.h;
    } else {
      return 4.5.h;
    }
  }

  static double getBottomMargin(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isScaledToSmall =
        MediaQueryData.fromWindow(ui.window).devicePixelRatio < 2.4;

    if (isScaledToSmall) {
      if (screenWidth <= 380) {
        return MediaQueryData.fromWindow(ui.window).size.height * 0.09;
      } else if (screenWidth <= 540) {
        return MediaQueryData.fromWindow(ui.window).size.height * 0.15;
      } else {
        return MediaQueryData.fromWindow(ui.window).size.height * 0.1;
      }
    } else {
      if (screenWidth <= 380) {
        return MediaQueryData.fromWindow(ui.window).size.height * 0.1;
      } else if (screenWidth <= 540) {
        return MediaQueryData.fromWindow(ui.window).size.height * 0.15;
      } else {
        return MediaQueryData.fromWindow(ui.window).size.height * 0.1;
      }
    }
  }

  static double getSideMargin(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 380) {
      return 45;
    } else if (screenWidth <= 540) {
      return 15;
    } else {
      return 60;
    }
  }

  static bool isTablet(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 540) {
      return false;
    } else {
      return true;
    }
  }
}
