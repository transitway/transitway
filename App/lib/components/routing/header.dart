import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/providers/route_provider.dart';

class Header extends StatefulWidget {
  final Function onStartNav;
  const Header({super.key, required this.onStartNav});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String timeText = 'Pleaca acum';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final route = Provider.of<RouteProvider>(context, listen: false);
      // route.deleteData();
      // route.loadData(widget.fromLocation, widget.toLocation);
      // route.loadData();
    });
    // Initialize the selected time with the current time
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(builder: (context, route, _) {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catre ${route.toName}',
                  style:
                      const TextStyle(fontFamily: 'UberMoveBold', fontSize: 20),
                ),
                Text(
                  'De la ${route.fromName}',
                  style: const TextStyle(
                      fontFamily: 'UberMoveMedium', fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 20),
                  child: GestureDetector(
                    onTap: () {
                      route.toggleNavMode();
                      widget.onStartNav();
                      //Change header
                      //Change timeline
                      //enternavigation view
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.blue[100]),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(children: [
                          Icon(
                            Icons.navigation,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Start',
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontFamily: 'UberMoveMedium'),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
