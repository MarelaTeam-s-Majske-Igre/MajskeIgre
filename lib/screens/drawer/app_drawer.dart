import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: ThemeColors.primaryBlue,
      child: SafeArea(
        child: Column(children: [
          Image.asset("assets/img/logo_big.png"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: Divider(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: h * 0.02,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: h * 0.04),
            child: Column(
              children: [
                TextButton(
                    onPressed: () => Navigator.of(context).pushNamed("/events"),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: h * 0.01),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            FlutterRemix.calendar_fill,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Koledar dogodkov",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    )),
                TextButton(
                    onPressed: () => launch("http://majske-igre.si"),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: h * 0.01),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            FlutterRemix.home_2_fill,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Spletna stran",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    )),
                TextButton(
                    onPressed: () => Navigator.pushNamed(context, "/about"),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: h * 0.01),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            FlutterRemix.google_play_fill,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "O aplikaciji",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
