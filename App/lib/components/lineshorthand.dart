import 'package:flutter/material.dart';

enum LineType {
  bus,
  lightRail,
  trolleybus,
}

class CustomIconComponent extends StatelessWidget {
  final LineType lineType;
  final Color color;

  const CustomIconComponent({super.key, required this.lineType, required this.color});

  IconData getIconForType() {
    switch (lineType) {
      case LineType.bus:
        return Icons.directions_bus;
      case LineType.trolleybus:
        return Icons.directions_transit;
      case LineType.lightRail:
        return Icons.tram;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      getIconForType(),
      size: 20,
      color: color,
    );
  }
}

class LinesShortHand extends StatefulWidget {
  final Color color;
  final String line;
  final LineType type;

  const LinesShortHand({
    Key? key,
    required this.color,
    required this.line,
    required this.type,
  }) : super(key: key);

  @override
  State<LinesShortHand> createState() => _LinesShortHandState();
}

class _LinesShortHandState extends State<LinesShortHand> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 2),
        child: Row(
          children: [
            CustomIconComponent(
              lineType: widget.type,
              color: widget.color,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                widget.line,
                style: const TextStyle(
                  fontFamily: 'UberMoveBold',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
