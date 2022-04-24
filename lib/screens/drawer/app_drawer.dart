import 'package:app/services/global/launch_link.dart';
import 'package:app/services/stats/plausible_analitics.dart';
import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key) {
    PlausibleAnalitics.logEvent("#drawer");
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: ThemeColors.primaryBlue,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _mainMenuPart(w, h, context),
            // Container(
            //   height: h * 0.108,
            //   padding: EdgeInsets.symmetric(vertical: h * 0.015),
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.white.withOpacity(0.25),
            //     borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Image.asset("assets/img/logo-sss.png"),
            //       Image.network(
            //           "https://avatars.githubusercontent.com/u/34716555?s=400&u=46b5cbdfb3e2900b237d62fecdce1648c18062db&v=4"),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Column _mainMenuPart(double w, double h, BuildContext context) {
    return Column(children: [
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
                onPressed: () => LaunchLink.open(
                    "http://majske-igre.si", "Majske igre", "#drawer"),
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
    ]);
  }
}
