import 'package:app/services/stats/plausible_analitics.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchLink {
  static open(String link, String name, String referrer) {
    launch(link);
    PlausibleAnalitics.logEvent(name, referrer: referrer);
  }
}
