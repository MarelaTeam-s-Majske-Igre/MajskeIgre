import 'package:plausible_analytics/plausible_analytics.dart';

class PlausibleAnalitics {
  final String serverUrl = "https://plausible.sven.marela.team";
  final String domain = "majske.marela.team";

  static late final Plausible plausible;

  PlausibleAnalitics._internal() {
    plausible = Plausible(serverUrl, domain);
  }

  static void logEvent() {
    final event = plausible.event();
    var x = 0;
  }
}
