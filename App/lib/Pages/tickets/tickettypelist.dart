import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/Pages/navbar.dart';
import 'package:transitway/Pages/tickets/buyticket.dart';
import 'package:transitway/components/tickets.dart';
import 'package:transitway/providers/tickets_provider.dart';
import 'package:transitway/utils/env.dart';
import 'package:transitway/utils/utils.dart';

class TicketTypeList extends StatefulWidget {
  const TicketTypeList({super.key});

  @override
  State<TicketTypeList> createState() => _TicketTypeListState();
}

class _TicketTypeListState extends State<TicketTypeList> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tickets = Provider.of<TicketsProvider>(context, listen: false);
      tickets.getTicketTypes('ploiesti');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketsProvider>(builder: (context, tickets, _) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 35,
                  right: 30,
                  left: 30,
                  top: 20,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NavBar(pageIndex: 2)),
                          );
                        },
                        child: const Icon(Icons.arrow_back_ios_new)),
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
              Expanded(
                child: tickets.loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: transitwayPurple,
                        ),
                      )
                    : ListView.builder(
                        itemCount: tickets.typeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = tickets.typeList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BuyTicketPage(
                                          titlu:
                                              '${capitalize(item.category)} ${item.name}',
                                          number: item.noLines,
                                          fare: item.fare,
                                          typeID: item.id,
                                        )),
                              );
                            },
                            child: TicketComponent(
                                name:
                                    '${capitalize(item.category)} ${item.name}',
                                fare: item.fare.toString()),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
