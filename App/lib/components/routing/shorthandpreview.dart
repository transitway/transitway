import 'package:flutter/material.dart';

class ShortHandPreview extends StatefulWidget {
  final Color color;
  final String text;
  final IconData icon;
  const ShortHandPreview({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
  });

  @override
  State<ShortHandPreview> createState() => _ShortHandPreviewState();
}

class _ShortHandPreviewState extends State<ShortHandPreview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        decoration: BoxDecoration(
            color: widget.color, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: 20,
              ),
              Text(
                widget.text,
                style: const TextStyle(
                    fontFamily: 'UberMoveBold',
                    fontSize: 20,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
