import 'package:flutter/material.dart';
import 'package:transitway/utils/env.dart';

class FAQComponent extends StatefulWidget {
  final String title;
  final String content;

  const FAQComponent({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<FAQComponent> createState() => _FAQComponentState();
}

class _FAQComponentState extends State<FAQComponent> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'UberMoveBold',
                      fontSize: 18),
                ),
              ),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
            ],
          ),
        ),
        if (isExpanded)
          Column(
            children: [
              const Divider(
                color: darkGrey,
              ),
              Text(
                widget.content,
                style:
                    const TextStyle(fontFamily: 'UberMoveMedium', fontSize: 15),
              ),
            ],
          ),
      ],
    );
  }
}
