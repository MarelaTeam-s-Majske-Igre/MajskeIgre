import 'package:app/services/global/launch_link.dart';
import 'package:app/services/stats/plausible_analitics.dart';
import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class AboutAppScreen extends StatelessWidget {
  AboutAppScreen({Key? key}) : super(key: key) {
    PlausibleAnalitics.logEvent("about");
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(FlutterRemix.arrow_left_s_line),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: ThemeColors.primaryBlue,
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/img/logo_big.png",
                        height: h * 0.2,
                      ),
                    ),
                  ]),
            ),
            _boxContainer(
              w,
              h,
              title: "Pravno obvestilo",
              body: Text(
                """Vse besedilo, slike in grafike uporabljeni v aplikaciji so last organizatorja prireditve Majskih iger. Razvijalec si ne pridružuje nobenih pravic do uporabe.

Aplikacije je odprtokodna, koda je na voljo na GitHub profilu razvijalca.
        """,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            _boxContainer(
              w,
              h,
              // title: "Razvijalec",
              background: ThemeColors.greenSport,
              stickyLeft: false,
              body: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Jakob Marušič",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                        height: 1,
                        color: Colors.white,
                        width: w * 0.45,
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => LaunchLink.open(
                                    "https://jakob.marela.team",
                                    "Jakobov spletni domek",
                                    "/about",
                                  ),
                              icon: Icon(
                                FlutterRemix.home_2_fill,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () => LaunchLink.open(
                                    "mailto:jakob.marusic@student.uni-lj.si",
                                    "Mail",
                                    "/about",
                                  ),
                              icon: Icon(
                                FlutterRemix.message_2_fill,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () => LaunchLink.open(
                                    "https://github.com/jakmar17",
                                    "GitHub",
                                    "/about",
                                  ),
                              icon: Icon(
                                FlutterRemix.github_fill,
                                color: Colors.white,
                              )),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    width: w * 0.05,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: h * 0.15),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          // color: ThemeColors.sportBackground.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(30)),
                      child: Image.network(
                          "https://avatars.githubusercontent.com/u/34716555?s=400&u=46b5cbdfb3e2900b237d62fecdce1648c18062db&v=4"),
                    ),
                  )
                ],
              ),
            ),
            _boxContainer(
              w,
              h,
              title: "MojŠtudent",
              background: ThemeColors.orangeCulture,
              body: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text(
                      "Mobilna aplikacija za dostop do storitve Mojega študenta, namenjena stanovalcem Študentskega doma Ljubljana",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        color: Colors.white,
                        width: w,
                        height: 1,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => LaunchLink.open(
                            "https://play.google.com/store/apps/details?id=team.marela.mojstudent.moj_student",
                            "GooglePlay",
                            "/about",
                          ),
                          icon: Icon(
                            FlutterRemix.google_play_fill,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => LaunchLink.open(
                            "https://mojstudent.marela.team",
                            "MojStudent",
                            "/about",
                          ),
                          icon: Icon(
                            FlutterRemix.home_2_fill,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  SliverToBoxAdapter _boxContainer(
    double w,
    double h, {
    String? title,
    required Widget body,
    Color? background,
    bool stickyLeft = true,
  }) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(bottom: h * 0.02),
        child: Padding(
          padding: stickyLeft
              ? EdgeInsets.only(right: w * 0.1)
              : EdgeInsets.only(left: w * 0.1),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: h * 0.2,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: background ?? ThemeColors.blueFun,
                borderRadius: stickyLeft
                    ? BorderRadius.horizontal(right: Radius.circular(20))
                    : BorderRadius.horizontal(left: Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.02, vertical: h * 0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    body
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
