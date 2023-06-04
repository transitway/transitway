import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/datamodels/segment.dart';
import 'package:transitway/components/routing/shorthandpreview.dart';
import 'package:transitway/components/routing/walkingshort.dart';
import 'package:transitway/providers/route_provider.dart';
import 'package:transitway/utils/env.dart';

class RouteOption extends StatefulWidget {
  final List<Segment> segments;
  final String arrivalTime;
  final String leaveAt;
  final String fromLoc;
  final int routeIndex;

  const RouteOption({
    Key? key,
    required this.segments,
    required this.arrivalTime,
    required this.leaveAt,
    required this.fromLoc,
    required this.routeIndex,
  }) : super(key: key);

  @override
  State<RouteOption> createState() => _RouteOptionState();
}

class _RouteOptionState extends State<RouteOption> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(builder: (context, route, _) {
      return GestureDetector(
        onTap: () {
          route.changeRouteIndex(widget.routeIndex);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: widget.routeIndex == route.routeIndex
                      ? lightGrey
                      : Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 10,
                    ),
                    child: Text(
                      'Ajungi ${widget.arrivalTime}',
                      style: const TextStyle(
                          fontFamily: 'UberMoveBold', fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      'Pleaca ${widget.leaveAt} de la ${widget.fromLoc}',
                      style: const TextStyle(
                          fontFamily: 'UberMoveMedium', fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      width: double.infinity,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListView.builder(
                          itemCount: widget.segments.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            final item = widget.segments[index];
                            return item.isWalking
                                ? WalkingShort(minutes: item.minutes!)
                                : ShortHandPreview(
                                    color: item.color,
                                    text: item.text,
                                    icon: item.icon,
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                  // const Divider(
                  //   color: darkGrey,
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}


// Row(
//                 children: [
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     '25 min',
//                     style: TextStyle(fontFamily: 'UberMoveBold', fontSize: 20),
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   walkingShort(
//                     minutes: 6,
//                   ),
//                   shortHandPreview(
//                       color: Colors.amber,
//                       text: '44',
//                       icon: Icons.directions_bus),
//                   shortHandPreview(
//                       color: Colors.green, text: '102', icon: Icons.tram),
//                   walkingShort(
//                     minutes: 10,
//                   ),
//                 ],
//               ),