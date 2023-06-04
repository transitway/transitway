import 'package:flutter/material.dart';
import 'package:transitway/components/routing/header.dart';
import 'package:provider/provider.dart';
import 'package:transitway/utils/env.dart';

import '../../providers/route_provider.dart';
import 'navheader.dart';

class DraggableDrawer extends StatefulWidget {
  final Function onStartNav;
  final Function onEndNav;
  const DraggableDrawer(
      {super.key, required this.onStartNav, required this.onEndNav});

  @override
  State<DraggableDrawer> createState() => _DraggableDrawerState();
}

class _DraggableDrawerState extends State<DraggableDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = Provider.of<RouteProvider>(context, listen: false);
      route.loadRouteOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(builder: (context, route, _) {
      return DraggableScrollableSheet(
          initialChildSize: .30,
          minChildSize: .30,
          maxChildSize: .6,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(17))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Container(
                              height: 4,
                              width: 30,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        if (route.navMode == false)
                          Header(onStartNav: widget.onStartNav),
                        if (route.navMode) NavHeader(onEndNav: widget.onEndNav),
                        const Divider(
                          color: darkGrey,
                        ),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: ListView(
                  //       controller: scrollController,
                  //       children: route.routeOptionsList),
                  // ),

                  route.navMode
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: route.stepsList[route.routeIndex].length,
                            itemBuilder: (context, index) {
                              return route.stepsList[route.routeIndex][index];
                              //available params
                              // bool type;  false for steps, true for bus line
                              // String? street;   street for steps
                              // String? distance;  walking distance for steps
                              // String time;  time of arrival for steps , time of bus arrival for lines
                              // String? fromStation; for lines
                              // String? toStation; for lines
                              // String? timeUntil; time until next bus
                              // Color? color; line color
                              // String? line; line name
                            },
                            controller: scrollController,
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: route.routeOptionsList.length,
                            itemBuilder: (context, index) {
                              return route.routeOptionsList[index];
                            },
                            controller: scrollController,
                          ),
                        )
                ],
              ),
            );
          });
    });
  }
}
