import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';

class ChipFilter extends StatelessWidget {
  final bool selected;
  final String title;

  const ChipFilter({
    Key? key,
    this.selected = false,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: width * 0.025),
      decoration: BoxDecoration(
          color: selected ? ThemeColors.purple : Colors.white.withOpacity(0.45),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: ThemeColors.purple.withAlpha(100),
                blurRadius: 5,
                spreadRadius: 5,
              )
          ]),
      child: Center(
          child: Text(
        title,
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
