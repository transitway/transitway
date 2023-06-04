import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/providers/route_provider.dart';
import 'package:transitway/utils/env.dart';

class PreviewTicket extends StatefulWidget {
  final int noOfLines;
  final List<String> lines;
  const PreviewTicket(
      {super.key, required this.noOfLines, required this.lines});

  @override
  State<PreviewTicket> createState() => _PreviewTicketState();
}

class _PreviewTicketState extends State<PreviewTicket> {
  double price = 0.0;
  String ticketType = '';
  String typeID = '';

  @override
  void initState() {
    super.initState();
    if (widget.noOfLines == 1) {
      ticketType = 'Bilet 1 calatorie';
      price = 2.5;
      typeID = 'bilet1c';
    } else if (widget.noOfLines == 2) {
      ticketType = 'Bilet 2 calatorii';
      price = 5.0;
      typeID = 'bilet2c';
    } else {
      ticketType = 'Abonament o zi';
      price = 6.0;
      typeID = 'biletzi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(builder: (context, route, _) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: const Icon(Icons.arrow_back_ios_new),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Cumpara bilet',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'UberMoveBold'),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  ticketType,
                  style:
                      const TextStyle(fontFamily: 'UberMoveBold', fontSize: 30),
                ),
                if (widget.noOfLines > 1)
                  Text(
                    'Traseul tau are ${(widget.noOfLines - 1) > 1 ? "${widget.noOfLines} conexiuni" : "1 conexiune"}',
                    style: const TextStyle(
                        fontFamily: 'UberMoveMedium',
                        fontSize: 15,
                        color: darkGrey),
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pretul total',
                        style: TextStyle(
                            fontSize: 20, fontFamily: 'UberMoveMedium'),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            price.toString(),
                            style: const TextStyle(
                                fontSize: 40, fontFamily: 'UberMoveBold'),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'RON',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'UberMoveBold'),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await route.buyTicket(widget.lines, typeID, context);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0XFF2E01C8),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: route.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Center(
                              child: Text(
                                'Plateste',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
