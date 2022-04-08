import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  final Function? refresh;

  const ErrorScreen({
    Key? key,
    this.errorMessage = "Napaka pri nalaganju vsebine",
    this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeColors.primaryBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(),
          Container(),
          Column(
            children: [
              Text(
                errorMessage,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              if (refresh != null)
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: ThemeColors.purple),
                    onPressed: () => refresh!(),
                    child: Text("Ponovno naloži"))
            ],
          ),
          Container(),
          Container(),
          Image.asset(
            "assets/img/logo_big.png",
            height: h * 0.1,
          ),
        ],
      ),
    );
  }
}
