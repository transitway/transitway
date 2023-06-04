import 'package:flutter/material.dart';
import 'package:transitway/components/lineshorthand.dart';

class LineListItem extends StatefulWidget {
  final LineType lineType;
  final String line;
  final Color color;
  final String fromTo;

  const LineListItem({
    Key? key,
    required this.lineType,
    required this.color,
    required this.line,
    required this.fromTo,
  }) : super(key: key);

  @override
  State<LineListItem> createState() => _LineListItemState();
}

class _LineListItemState extends State<LineListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Row(
        children: [
          LinesShortHand(
              color: widget.color, line: widget.line, type: widget.lineType),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              widget.fromTo,
              style:
                  const TextStyle(fontFamily: 'UberMoveMedium', fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
