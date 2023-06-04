import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/Pages/tickets/tickettypelist.dart';
import 'package:transitway/Pages/topup.dart';
import 'package:transitway/components/ticketobject.dart';
import 'package:transitway/providers/balance_provider.dart';
import 'package:transitway/providers/tickets_provider.dart';
import 'package:transitway/utils/env.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final balance = Provider.of<BalanceProvider>(context, listen: false);
      balance.getBalance();

      final tickets = Provider.of<TicketsProvider>(context, listen: false);
      tickets.getTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BalanceProvider>(builder: (context, balance, _) {
      return Consumer<TicketsProvider>(builder: (context, tickets, _) {
        return Scaffold(
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Soldul tau:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'UberMoveBold'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // balance.value != 0.0
                          //     ? '${balance.value} lei'
                          //     : '-.-- lei',
                          balance.loading ? '-.-- lei' : '${balance.value} lei',
                          style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'UberMoveBold'),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Topup()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: const Color(0xFF5100CC),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.add,
                                size: 26,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TicketTypeList()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: transitwayPurple,
                          borderRadius: BorderRadius.circular(14)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15),
                        child: Text(
                          'Cumpara bilet',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'UberMoveBold'),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: tickets.loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: transitwayPurple,
                          ),
                        )
                      : tickets.list.isEmpty
                          ? const Center(
                              child: Text(
                                'Nu exista bilete',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'UberMoveBold',
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: tickets.list.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = tickets.list[index];
                                return TicketObject(
                                  created: item.createdAt ?? DateTime.now(),
                                  expiry: item.expiresAt ?? DateTime.now(),
                                  line: item.lines ?? [],
                                  name: item.name ?? '',
                                  category: item.category ?? '',
                                  id: item.id ?? '',
                                );
                              },
                            ),
                ),
              ],
            ),
          )),
        );
      });
    });
  }
}
