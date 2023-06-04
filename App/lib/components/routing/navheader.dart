import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/Pages/route/previewticket.dart';
import 'package:transitway/Pages/tickets/extendedticket.dart';
import 'package:transitway/providers/route_provider.dart';
import 'package:transitway/utils/formatDate.dart';

class NavHeader extends StatefulWidget {
  final Function onEndNav;
  const NavHeader({super.key, required this.onEndNav});

  @override
  State<NavHeader> createState() => _NavHeaderState();
}

class _NavHeaderState extends State<NavHeader> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(builder: (context, route, _) {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catre ${route.toName}',
              style: const TextStyle(fontFamily: 'UberMoveBold', fontSize: 20),
            ),
            Text(
              'De la ${route.fromName}',
              style:
                  const TextStyle(fontFamily: 'UberMoveMedium', fontSize: 15),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          route.toggleNavMode();
                          widget.onEndNav();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.blue[100]),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(children: [
                              Icon(
                                Icons.swap_calls,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Schimba ruta',
                                style: TextStyle(
                                    color: Colors.blue[700],
                                    fontFamily: 'UberMoveMedium'),
                              ),
                            ]),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    if (route.boughtTicket.accountID == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreviewTicket(
                                  noOfLines: route.noLines[route.routeIndex],
                                  lines: route.lines[route.routeIndex])));
                    } else {
                      String line = '';
                      if (route.boughtTicket.lines!.isEmpty) {
                        line = '';
                      } else if (route.boughtTicket.lines!.length == 1) {
                        line = route.boughtTicket.lines![0];
                      } else {
                        line =
                            '${route.boughtTicket.lines![0]}|${route.boughtTicket.lines![1]}';
                      }
                      print(line);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExtendedTicket(
                                    line: line,
                                    category: route.boughtTicket.category!,
                                    id: route.boughtTicket.id!,
                                    name: route.boughtTicket.name!,
                                    created: formatDate(
                                        route.boughtTicket.createdAt!),
                                    expiry: route.boughtTicket.expiresAt!,
                                  )));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.blue[100]),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(children: [
                              Icon(
                                Icons.receipt_long,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                route.boughtTicket.id == null
                                    ? 'Cumpara bilet'
                                    : 'Vezi bilet',
                                style: TextStyle(
                                    color: Colors.blue[700],
                                    fontFamily: 'UberMoveMedium'),
                              ),
                            ]),
                          ),
                        )
                      ],
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
