import 'package:app/widgets/row_container.dart';
import 'package:flutter/material.dart';

class TextRowContainer extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final String data;
  final Color color;
  final TextAlign textAlign;

  const TextRowContainer({
    Key? key,
    required this.data,
    this.title,
    this.icon,
    this.color = Colors.white,
    this.textAlign = TextAlign.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return RowContainer(
      color: color,
      icon: icon,
      title: title,
      child: Padding(
        padding: EdgeInsets.only(left: w * 0.02, top: h * 0.005),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                data,
                textAlign: textAlign,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }
}
