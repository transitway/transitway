import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SearchableDropdown extends StatefulWidget {
  final String titlu;
  final Function(String?) onChanged;
  const SearchableDropdown({
    Key? key,
    required this.titlu,
    required this.onChanged, // Add this line
  }) : super(key: key);

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

List<String> busLines = ["35B", "40", "44", "102", "101", "1D", "2", "30"];
String selectedLines = '';

class _SearchableDropdownState extends State<SearchableDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            widget.titlu,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'UberMoveBold'),
          ),
        ),
        DropdownSearch(
          items: busLines,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              labelText: "Alege un traseu",
            ),
          ),
          onChanged: (value) {
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}
