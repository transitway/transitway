import 'package:flutter/material.dart';
import 'package:transitway/utils/env.dart';

class CustomAddr extends StatefulWidget {
  final String title;
  final String address;
  final IconData icon;
  final bool map;
  final Color color;
  const CustomAddr({
    super.key,
    required this.title,
    required this.address,
    required this.icon,
    required this.map,
    required this.color,
  });

  @override
  State<CustomAddr> createState() => _CustomAddrState();
}

class _CustomAddrState extends State<CustomAddr> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration:
                  BoxDecoration(color: widget.color, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'UberMoveBold'),
                  ),
                  Text(
                    widget.address,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: darkGrey,
                        fontFamily: 'UberMoveBold'),
                  ),
                ],
              ),
            ),
          ],
        ),
        Visibility(
          visible: widget.map == false,
          child: const Icon(
            Icons.arrow_forward_ios,
            color: darkGrey,
            size: 20,
          ),
        ),
      ],
    );
  }
}
