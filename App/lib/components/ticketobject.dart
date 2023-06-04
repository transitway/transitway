import 'dart:async';
import 'package:flutter/material.dart';
import 'package:transitway/Pages/tickets/extendedticket.dart';
import 'package:transitway/utils/formatDate.dart';

class TicketObject extends StatefulWidget {
  final List<String> line;
  final DateTime expiry;
  final String name;
  final String category;
  final String id;
  final DateTime created;

  const TicketObject({
    Key? key,
    required this.line,
    required this.expiry,
    required this.name,
    required this.category,
    required this.id,
    required this.created,
  }) : super(key: key);

  @override
  State<TicketObject> createState() => _TicketObjectState();
}

class _TicketObjectState extends State<TicketObject> {
  late Timer _timer;
  late Duration _remainingTime;
  String completeName = '';

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
    if (widget.line.length == 1) {
      completeName = widget.line[0];
    } else if (widget.line.length > 1) {
      completeName = "${widget.line[0]} | ${widget.line[1]}";
    } else {
      completeName = '';
    }
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
    final minutes = duration.inMinutes.remainder(60);
    final hours = duration.inHours.remainder(24);
    final days = duration.inDays;

    String formattedTime = '';

    if (days > 0) {
      formattedTime += '$days d ';
    }

    if (hours > 0) {
      formattedTime += '$hours h ';
    }

    formattedTime += '$minutes min';

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = _remainingTime.isNegative;
    final timeLeft = isExpired ? 'Expirat' : _formatDuration(_remainingTime);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExtendedTicket(
                    line: completeName,
                    expiry: widget.expiry,
                    name: widget.name,
                    category: widget.category,
                    id: widget.id,
                    created: formatDate(widget.created),
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Container(
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
                              formatDate(widget.created),
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
                                fontFamily: 'UberMoveMedium', fontSize: 26),
                          ),
                          Text(
                            widget.name,
                            style: const TextStyle(
                                fontFamily: 'UberMoveMedium', fontSize: 26),
                          ),
                        ],
                      ),
                      Text(
                        completeName,
                        style: const TextStyle(
                            fontFamily: 'UberMoveBold', fontSize: 45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
