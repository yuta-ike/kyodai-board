import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget{
  const TextWithIcon(this.text, {
    @required this.leadingIcon,
    this.style,
    this.spacing = 2,
    this.iconColor,
  });

  final String text;
  final IconData leadingIcon;
  final TextStyle style;
  final double spacing;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: style,
        children: [
          WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(right: spacing),
              child: Icon(
                leadingIcon,
                size: style.fontSize,
                color: iconColor ?? style.color,
              ),
            ),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}