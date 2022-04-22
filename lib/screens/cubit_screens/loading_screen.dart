import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  final bool withScaffold;
  final String loadingText;
  const LoadingScreen({
    Key? key,
    this.withScaffold = true,
    this.loadingText = "Nalaganje vsebine",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return withScaffold
        ? Scaffold(
            backgroundColor: ThemeColors.primaryBlue,
            body: _column(),
          )
        : _column();
  }

  Column _column() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(),
        Container(),
        Image.asset("assets/img/logo_big.png"),
        SpinKitSpinningLines(color: Colors.white),
        Text(
          loadingText,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Container(),
        Container(),
      ],
    );
  }
}
