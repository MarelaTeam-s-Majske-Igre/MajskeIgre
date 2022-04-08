import 'package:app/data/event_type/event_type.dart';
import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';

class EventTypeService {
  static String getEventTypeAssetImage(EventType type) {
    switch (type) {
      case EventType.SPORT:
        return "assets/img/sportko.png";
      case EventType.CULTURE:
        return "assets/img/kultko.png";
      case EventType.FUN:
        return "assets/img/zabavko.png";
    }
  }

  static Color getEventTypeColor(EventType type) {
    switch (type) {
      case EventType.SPORT:
        return ThemeColors.greenSport;
      case EventType.CULTURE:
        return ThemeColors.orangeCulture;
      case EventType.FUN:
        return ThemeColors.blueFun;
    }
  }

  static Color getEventTypeBackgroundColor(EventType type) {
    switch (type) {
      case EventType.SPORT:
        return ThemeColors.sportBackground;
      case EventType.CULTURE:
        return ThemeColors.cultureBackground;
      case EventType.FUN:
        return ThemeColors.funBackground;
    }
  }
}
