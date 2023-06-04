import 'package:flutter/material.dart';
import 'package:transitway/components/routing/shorthandsteps.dart';
import 'package:transitway/utils/env.dart';

class StepComponent extends StatefulWidget {
  final String fromStation;
  final String toStation;
  final String timeUntil;
  final String timeOfArrival;
  final String line;
  final Color color;
  final int noStops;

  const StepComponent({
    Key? key,
    required this.fromStation,
    required this.toStation,
    required this.timeOfArrival,
    required this.timeUntil,
    required this.color,
    required this.line,
    required this.noStops,
  }) : super(key: key);

  @override
  State<StepComponent> createState() => _StepComponentState();
}

class _StepComponentState extends State<StepComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShortHandSteps(
                      color: widget.color,
                      text: widget.line,
                      icon: Icons.directions_bus),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fromStation,
                        style: const TextStyle(
                            fontFamily: 'UberMoveBold', fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          'Mergi ${widget.noStops > 1 ? '${widget.noStops} stații' : 'o stație'}',
                          style: TextStyle(
                              fontFamily: 'UberMoveMedium',
                              fontSize: 15,
                              color: darkGrey),
                        ),
                      ),
                      Text(
                        widget.toStation,
                        style: const TextStyle(
                            fontFamily: 'UberMoveMedium',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.timeUntil,
                        style: const TextStyle(
                            fontFamily: 'UberMoveMedium', fontSize: 15),
                      ),
                      SizedBox(
                        height: 27,
                      ),
                      Text(
                        widget.timeOfArrival,
                        style: const TextStyle(
                            fontFamily: 'UberMoveMedium', fontSize: 15),
                      )
                    ],
                  ),
                ],
              ),
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
