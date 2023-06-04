import 'package:flutter/widgets.dart';

class Segment {
  Color color;
  String text;
  IconData icon;
  final bool isWalking;
  int? minutes;

  Segment({
    required this.color,
    required this.text,
    required this.icon,
    required this.isWalking,
    this.minutes,
  });
}
