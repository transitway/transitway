import 'package:flutter/material.dart';
import 'package:transitway/components/routing/step.dart';
import 'package:transitway/components/routing/stepwalking.dart';

class StepOption extends StatefulWidget {
  final bool type; // false for steps, true for bus line
  final String? street;
  final String? distance;
  final String time;
  final String? fromStation;
  final String? toStation;
  final String? timeUntil;
  final Color? color;
  final String? line;
  final int? noStops;

  const StepOption({
    Key? key,
    required this.type,
    this.color,
    this.distance,
    this.fromStation,
    this.line,
    this.street,
    required this.time,
    this.timeUntil,
    this.toStation,
    this.noStops,
  }) : super(key: key);

  @override
  State<StepOption> createState() => _StepOptionState();
}

class _StepOptionState extends State<StepOption> {
  @override
  Widget build(BuildContext context) {
    if (!widget.type) {
      return StepWalking(
          street: widget.street ?? '?street',
          distance: widget.distance ?? '-km',
          time: widget.time);
    } else {
      return StepComponent(
          fromStation: widget.fromStation ?? '?fromstation',
          toStation: widget.toStation ?? '?tostation',
          timeOfArrival: widget.time,
          timeUntil: widget.timeUntil ?? '-min',
          color: widget.color ?? Colors.black,
          line: widget.line ?? '--',
          noStops: widget.noStops ?? 1);
    }
  }
}
