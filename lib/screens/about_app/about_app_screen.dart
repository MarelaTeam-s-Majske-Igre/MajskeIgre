import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

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
                """Vse besedilo, slike in grafike uporabljeni v aplikaciji so last organizatorja prireditve Majskih iger. Razvijalec MarelaTeam si ne pridružuje nobenih pravic do uporabe.

Aplikacije je odprtokodna, koda je na voljo na GitHub profilu razvijalca.
        """,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            _boxContainer(
              w,
              h,
              title: "Razvijalec",
              background: ThemeColors.greenSport,
              stickyLeft: false,
              body: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Marela Team",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "Team",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  )
                ],
              ),
            ),
            _boxContainer(
              w,
              h,
              title: "MajŠtudent",
              background: ThemeColors.orangeCulture,
              body: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Marela Team",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "Team",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  SliverToBoxAdapter _boxContainer(
    double w,
    double h, {
    required String title,
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
                      title,
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
