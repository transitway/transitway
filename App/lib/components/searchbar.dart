import 'dart:async';

import 'package:flutter/material.dart';
import 'package:transitway/utils/env.dart';

class SearchBarComponent extends StatefulWidget {
  final Function(String) onSearchTextChanged;
  final Function(String)? focusTo;
  final Function(String)? focusFrom;
  final String? preFilledTextTo;
  final String? preFilledTextFrom;
  const SearchBarComponent({
    Key? key,
    required this.preFilledTextTo,
    required this.preFilledTextFrom,
    required this.onSearchTextChanged,
    this.focusFrom,
    this.focusTo,
  }) : super(key: key);

  @override
  State<SearchBarComponent> createState() => _SearchBarComponentState();
}

class _SearchBarComponentState extends State<SearchBarComponent> {
  final TextEditingController _searchControllerFrom = TextEditingController();
  final TextEditingController _searchControllerTo = TextEditingController();
  final FocusNode _textFocusTo = FocusNode();
  final FocusNode _textFocusFrom = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchControllerFrom.text = widget.preFilledTextFrom ?? '';
    _searchControllerTo.text = widget.preFilledTextTo ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (_searchControllerFrom.text.isEmpty) {
      _searchControllerFrom.text = widget.preFilledTextFrom ?? '';
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            decoration: const BoxDecoration(color: lightGrey),
            height: 80,
          ),
        ),
        Column(
          children: [
            TextField(
              readOnly: true,
              controller: _searchControllerFrom,
              focusNode: _textFocusFrom,
              cursorColor: Colors.black,
              style: const TextStyle(
                fontSize: 17,
                fontFamily: 'UberMoveMedium',
              ),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: transitwayPurple, width: 2),
                  borderRadius: BorderRadius.circular(14),
                ),
                suffixIcon: GestureDetector(
                    onTap: _searchControllerFrom.clear,
                    child: const Icon(
                      Icons.clear,
                      color: Colors.black,
                    )),
                prefixIcon: const Icon(
                  Icons.my_location_rounded,
                  color: transitwayPurple,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                fillColor: const Color(0xFFE8E8E8),
                filled: true,
              ),
            ),
            TextField(
              autofocus: true,
              focusNode: _textFocusTo,
              onChanged: (text) {
                Timer(const Duration(milliseconds: 500), () {
                  widget.onSearchTextChanged(text);
                });
              },
              controller: _searchControllerTo,
              cursorColor: Colors.black,
              style: const TextStyle(
                fontSize: 17,
                fontFamily: 'UberMoveMedium',
              ),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: transitwayPurple, width: 2),
                  borderRadius: BorderRadius.circular(14),
                ),
                suffixIcon: GestureDetector(
                    onTap: _searchControllerTo.clear,
                    child: const Icon(
                      Icons.clear,
                      color: Colors.black,
                    )),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                fillColor: const Color(0xFFE8E8E8),
                filled: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
