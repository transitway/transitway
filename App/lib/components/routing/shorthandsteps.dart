import 'package:flutter/material.dart';

class ShortHandSteps extends StatefulWidget {
  final Color color;
  final String text;
  final IconData icon;
  const ShortHandSteps({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
  });

  @override
  State<ShortHandSteps> createState() => _ShortHandStepsState();
}

class _ShortHandStepsState extends State<ShortHandSteps> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.color, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: Colors.white,
              size: 15,
            ),
            Text(
              widget.text,
              style: const TextStyle(
                  fontFamily: 'UberMoveBold',
                  fontSize: 15,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
