import 'package:app/widgets/text_row_container.dart';
import 'package:flutter/material.dart';

class TextRowSliver extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final String data;
  final Color color;
  final TextAlign textAlign;

  const TextRowSliver({
    Key? key,
    required this.data,
    this.title,
    this.icon,
    this.color = Colors.white,
    this.textAlign = TextAlign.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: TextRowContainer(
        data: data,
        title: title,
        icon: icon,
        textAlign: textAlign,
        color: color,
      ),
    );
  }
}
