import 'package:flutter/material.dart';
import 'package:transitway/utils/env.dart';

class WalkingShort extends StatefulWidget {
  final int minutes;

  const WalkingShort({
    super.key,
    required this.minutes,
  });

  @override
  State<WalkingShort> createState() => _WalkingShortState();
}

class _WalkingShortState extends State<WalkingShort> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: darkGrey)),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.directions_walk,
                color: darkGrey,
                size: 20,
              ),
              Text(
                widget.minutes.toString(),
                style: const TextStyle(
                    fontFamily: 'UberMoveBold', fontSize: 10, color: darkGrey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
