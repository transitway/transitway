import 'package:flutter/material.dart';
import 'package:transitway/utils/env.dart';

class StepWalking extends StatefulWidget {
  final String street;
  final String distance;
  final String time;
  const StepWalking(
      {Key? key,
      required this.street,
      required this.distance,
      required this.time})
      : super(key: key);

  @override
  State<StepWalking> createState() => _StepWalkingState();
}

class _StepWalkingState extends State<StepWalking> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          child: Row(
            children: [
              const Icon(
                Icons.directions_walk,
                size: 30,
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.street,
                      style: const TextStyle(
                          fontFamily: 'UberMoveBold', fontSize: 20),
                    ),
                    Text(
                      '${widget.distance} • ${widget.time}',
                      style: const TextStyle(
                          fontFamily: 'UberMoveMedium',
                          fontSize: 15,
                          color: darkGrey),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 85.0),
          child: Divider(
            color: darkGrey,
          ),
        )
      ],
    );
  }
}
