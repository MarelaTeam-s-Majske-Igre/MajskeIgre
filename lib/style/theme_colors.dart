import 'package:flutter/material.dart';

class ThemeColors {
  static final Map<int, Color> _colorCodesPrussianBlue = {
    50: Color.fromRGBO(18, 43, 65, .1),
    100: Color.fromRGBO(18, 43, 65, .2),
    200: Color.fromRGBO(18, 43, 65, .3),
    300: Color.fromRGBO(18, 43, 65, .4),
    400: Color.fromRGBO(18, 43, 65, .5),
    500: Color.fromRGBO(18, 43, 65, .6),
    600: Color.fromRGBO(18, 43, 65, .7),
    700: Color.fromRGBO(18, 43, 65, .8),
    800: Color.fromRGBO(18, 43, 65, .9),
    900: Color.fromRGBO(18, 43, 65, 1),
  };

  static final Map<int, Color> _colorCodesCarolinaBlue = {
    50: Color.fromRGBO(96, 164, 218, .1),
    100: Color.fromRGBO(96, 164, 218, .2),
    200: Color.fromRGBO(96, 164, 218, .3),
    300: Color.fromRGBO(96, 164, 218, .4),
    400: Color.fromRGBO(96, 164, 218, .5),
    500: Color.fromRGBO(96, 164, 218, .6),
    600: Color.fromRGBO(96, 164, 218, .7),
    700: Color.fromRGBO(96, 164, 218, .8),
    800: Color.fromRGBO(96, 164, 218, .9),
    900: Color.fromRGBO(96, 164, 218, 1),
  };

  static final Map<int, Color> _colorCodesYellowGreen = {
    50: Color.fromRGBO(164, 205, 57, .1),
    100: Color.fromRGBO(164, 205, 57, .2),
    200: Color.fromRGBO(164, 205, 57, .3),
    300: Color.fromRGBO(164, 205, 57, .4),
    400: Color.fromRGBO(164, 205, 57, .5),
    500: Color.fromRGBO(164, 205, 57, .6),
    600: Color.fromRGBO(164, 205, 57, .7),
    700: Color.fromRGBO(164, 205, 57, .8),
    800: Color.fromRGBO(164, 205, 57, .9),
    900: Color.fromRGBO(164, 205, 57, 1),
  };

  static final Map<int, Color> _colorCodesAmber = {
    50: Color.fromRGBO(254, 126, 3, .1),
    100: Color.fromRGBO(254, 126, 3, .2),
    200: Color.fromRGBO(254, 126, 3, .3),
    300: Color.fromRGBO(254, 126, 3, .4),
    400: Color.fromRGBO(254, 126, 3, .5),
    500: Color.fromRGBO(254, 126, 3, .6),
    600: Color.fromRGBO(254, 126, 3, .7),
    700: Color.fromRGBO(254, 126, 3, .8),
    800: Color.fromRGBO(254, 126, 3, .9),
    900: Color.fromRGBO(254, 126, 3, 1),
  };

  static final Map<int, Color> _colorCodesJazzberryJam = {
    50: Color.fromRGBO(161, 2, 76, .1),
    100: Color.fromRGBO(161, 2, 76, .2),
    200: Color.fromRGBO(161, 2, 76, .3),
    300: Color.fromRGBO(161, 2, 76, .4),
    400: Color.fromRGBO(161, 2, 76, .5),
    500: Color.fromRGBO(161, 2, 76, .6),
    600: Color.fromRGBO(161, 2, 76, .7),
    700: Color.fromRGBO(161, 2, 76, .8),
    800: Color.fromRGBO(161, 2, 76, .9),
    900: Color.fromRGBO(161, 2, 76, 1),
  };

  // static final Map<int, Color> _colorCodesBlue = {
  //   50: Color.fromRGBO(37, 95, 133, .1),
  //   100: Color.fromRGBO(37, 95, 133, .2),
  //   200: Color.fromRGBO(37, 95, 133, .3),
  //   300: Color.fromRGBO(37, 95, 133, .4),
  //   400: Color.fromRGBO(37, 95, 133, .5),
  //   500: Color.fromRGBO(37, 95, 133, .6),
  //   600: Color.fromRGBO(37, 95, 133, .7),
  //   700: Color.fromRGBO(37, 95, 133, .8),
  //   800: Color.fromRGBO(37, 95, 133, .9),
  //   900: Color.fromRGBO(37, 95, 133, 1),
  // };

  // static final Map<int, Color> _colorCodesRed = {
  //   50: Color.fromRGBO(193, 41, 46, .1),
  //   100: Color.fromRGBO(193, 41, 46, .2),
  //   200: Color.fromRGBO(193, 41, 46, .3),
  //   300: Color.fromRGBO(193, 41, 46, .4),
  //   400: Color.fromRGBO(193, 41, 46, .5),
  //   500: Color.fromRGBO(193, 41, 46, .6),
  //   600: Color.fromRGBO(193, 41, 46, .7),
  //   700: Color.fromRGBO(193, 41, 46, .8),
  //   800: Color.fromRGBO(193, 41, 46, .9),
  //   900: Color.fromRGBO(193, 41, 46, 1),
  // };

  static MaterialColor primaryBlue =
      MaterialColor(0xff122b41, _colorCodesPrussianBlue);
  static MaterialColor blueFun =
      MaterialColor(0xff60a4da, _colorCodesCarolinaBlue);
  static MaterialColor greenSport =
      MaterialColor(0xffa4cd39, _colorCodesYellowGreen);
  static MaterialColor orangeCulture =
      MaterialColor(0xfffe7103, _colorCodesAmber);
  static MaterialColor purple =
      MaterialColor(0xffa1024c, _colorCodesJazzberryJam);

  static Color sportBackground =
      Color.alphaBlend(Colors.black.withOpacity(0.25), ThemeColors.greenSport);

  static Color cultureBackground = Color.alphaBlend(
      Colors.black.withOpacity(0.25), ThemeColors.orangeCulture);

  static Color funBackground =
      Color.alphaBlend(Colors.black.withOpacity(0.25), ThemeColors.blueFun);
}
