import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/Pages/tickets/tickettypelist.dart';
import 'package:transitway/components/searchdropdown.dart';
import 'package:transitway/providers/tickets_provider.dart';

class BuyTicketPage extends StatefulWidget {
  final String titlu;
  final int number;
  final double fare;
  final String typeID;

  const BuyTicketPage({
    Key? key,
    required this.titlu,
    required this.number,
    required this.fare,
    required this.typeID,
  }) : super(key: key);

  @override
  State<BuyTicketPage> createState() => _TicketSelectedOneState();
}

class _TicketSelectedOneState extends State<BuyTicketPage> {
  List<Widget> dropdowns = [];
  List<String> selectedBusLines = []; // Move the initialization here

  @override
  void initState() {
    super.initState();
    selectedBusLines = List<String>.filled(
        widget.number, ""); // Initialize selectedBusLines with empty strings
    for (int i = 0; i < widget.number; i++) {
      dropdowns.add(SearchableDropdown(
        titlu: 'Traseul ${i + 1}',
        onChanged: (String? selectedLine) {
          setState(() {
            selectedBusLines[i] = selectedLine ?? '';
          });
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketsProvider>(builder: (context, tickets, _) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TicketTypeList()),
                          );
                        },
                        child: const Icon(Icons.arrow_back_ios_new),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          widget.titlu,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'UberMoveBold'),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: dropdowns,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(tickets.errorMessage,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'UberMoveBold',
                                  color: Colors.red)),
                        ],
                      ),
                    ],
                  ),
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
                            widget.fare.toString(),
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
                    await tickets.buyTicket(
                        selectedBusLines, widget.typeID, context);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0XFF2E01C8),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: tickets.loading
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
