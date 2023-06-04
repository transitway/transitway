import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:transitway/Pages/tickets/ticketspage.dart';
import 'dart:async';

class ExtendedTicket extends StatefulWidget {
  final String line;
  final DateTime expiry;
  final String name;
  final String category;
  final String id;
  final String created;

  const ExtendedTicket({
    Key? key,
    required this.line,
    required this.expiry,
    required this.name,
    required this.category,
    required this.id,
    required this.created,
  }) : super(key: key);

  @override
  State<ExtendedTicket> createState() => _ExtendedTicketState();
}

class _ExtendedTicketState extends State<ExtendedTicket> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    _remainingTime = widget.expiry.difference(now);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _calculateRemainingTime();
      });
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes min $seconds sec';
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = _remainingTime.isNegative;
    final timeLeft = isExpired ? 'Expirat' : _formatDuration(_remainingTime);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TicketsPage()),
                          );
                        },
                        child: const Icon(Icons.arrow_back_ios_new)),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        '${widget.category} ${widget.name}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'UberMoveBold'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 239, 239, 243),
                    borderRadius: BorderRadius.circular(17)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromRGBO(210, 210, 243, 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.date_range_outlined,
                                    color: Color.fromARGB(255, 89, 44, 235),
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.created,
                                    style: const TextStyle(
                                      fontFamily: 'UberMoveMedium',
                                      color: Color.fromARGB(255, 89, 44, 235),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromRGBO(210, 210, 243, 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.timelapse_outlined,
                                    color: Color.fromARGB(255, 89, 44, 235),
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    isExpired ? 'Expirat' : timeLeft,
                                    style: const TextStyle(
                                      fontFamily: 'UberMoveMedium',
                                      color: Color.fromARGB(255, 89, 44, 235),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.category,
                                  style: const TextStyle(
                                      fontFamily: 'UberMoveMedium',
                                      fontSize: 26),
                                ),
                                Text(
                                  widget.name,
                                  style: const TextStyle(
                                      fontFamily: 'UberMoveMedium',
                                      fontSize: 26),
                                ),
                              ],
                            ),
                            Text(
                              widget.line,
                              style: const TextStyle(
                                  fontFamily: 'UberMoveBold', fontSize: 40),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SfBarcodeGenerator(
                          value: widget.id,
                          symbology: QRCode(),
                        ),
                      ),
                      const Text('ID Bilet',
                          style: TextStyle(
                              fontFamily: 'UberMoveBold', fontSize: 20)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          widget.id,
                          style: const TextStyle(
                              fontFamily: 'RobotoMono', fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
