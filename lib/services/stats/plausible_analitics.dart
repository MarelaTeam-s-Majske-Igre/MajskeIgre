import 'package:plausible_analytics/plausible_analytics.dart';

class PlausibleAnalitics {
  static const String _serverUrl = "https://plausible.sven.marela.team";
  static const String _domain = "majske.marela.team";
  static final Plausible plausible = Plausible(_serverUrl, _domain);

  static void logEvent(
    String page, {
    String? referrer,
  }) {
    if (referrer != null) {
      plausible
          .event(page: page, referrer: referrer);
    } else {
      plausible.event(page: page);
    }
  }
}
