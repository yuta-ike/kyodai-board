import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget{
  const TextWithIcon(this.text, {
    @required this.leadingIcon,
    this.style,
  });

  final String text;
  final IconData leadingIcon;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: style,
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                leadingIcon,
                size: style.fontSize,
                color: style.color,
              ),
            ),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}