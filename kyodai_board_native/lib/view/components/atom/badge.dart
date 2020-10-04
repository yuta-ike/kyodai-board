import 'package:flutter/material.dart';
import 'package:kyodai_board/model/enums/club_type.dart';

class Badge extends StatelessWidget{
  const Badge(this.label, { this.color = Colors.cyan, this.textColor = Colors.white, this.borderColor });

  const Badge.official(): this('公認', color: Colors.lightBlue);
  const Badge.interCollege(): this('インカレ', color: Colors.lightGreen);
  Badge.clubType(ClubType clubType): this(clubType?.format, color: Colors.cyan);

  const Badge.beginners(): this('初心者歓迎');
  const Badge.freshman(): this('1回生限定');
  const Badge.needApply(): this('要連絡', color: Colors.white, textColor: Colors.red, borderColor: Colors.red);
  const Badge.online(): this('オンライン');

  final String label;
  final Color color;
  final Color textColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor ?? color),
      ),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Text(
        label,
        style: Theme.of(context).textTheme.caption.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
