import 'package:flutter/material.dart';
import 'package:transitway/components/linelistitem.dart';
import 'package:transitway/components/lineshorthand.dart';
import 'package:transitway/utils/env.dart';

class LinesPage extends StatefulWidget {
  const LinesPage({super.key});

  @override
  State<LinesPage> createState() => _LinesPageState();
}

class LineItem {
  String fromTo = '';
  String line = '';
  Color color = Colors.black;
  LineType type = LineType.bus;

  LineItem(this.fromTo, this.line, this.color, this.type);
}

class _LinesPageState extends State<LinesPage> {
  List<LineItem> items = [
    LineItem(
        'Malu Rosu - Gara de Sud', '44', Colors.amber, LineType.trolleybus),
    LineItem('Spitalul Judetean - Gara de Sud', '101', Colors.grey,
        LineType.lightRail),
    LineItem(
        'Prahova Value Centre - Gara de Vest', '2', Colors.blue, LineType.bus),
  ];

  List<LineItem> filteredItems = [];

  @override
  void initState() {
    super.initState();
    items.sort((a, b) {
      // Custom comparator to sort numerically
      final lineA = int.tryParse(a.line);
      final lineB = int.tryParse(b.line);
      if (lineA != null && lineB != null) {
        return lineA.compareTo(lineB);
      } else {
        return a.line.compareTo(b.line);
      }
    });
    filteredItems = List.from(items);
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems =
            List.from(items); // Copy items list to preserve original order
      });
    } else {
      setState(() {
        filteredItems = items
            .where(
                (item) => item.line.toLowerCase().contains(query.toLowerCase()))
            .toList();
        filteredItems.sort((a, b) =>
            a.line.compareTo(b.line)); // Sort alphabetically by line name
      });
    }
  }

  TextEditingController textController =
      TextEditingController(text: 'Cauta linii');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: TextField(
                onTap: () {
                  if (textController.text == 'Cauta linii') {
                    textController.clear();
                  }
                },
                controller: textController,
                onChanged: (value) => filterItems(value),
                cursorColor: Colors.black,
                style:
                    const TextStyle(fontSize: 17, fontFamily: 'UberMoveMedium'),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: transitwayPurple, width: 2),
                    borderRadius: BorderRadius.circular(14),
                  ),
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
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length * 2,
                itemBuilder: (BuildContext context, int index) {
                  final itemIndex =
                      index ~/ 2; // Adjusted index to match filteredItems
                  final item = filteredItems[itemIndex];

                  if (index.isOdd) {
                    return const Divider(); // Divider widget for odd-indexed items
                  } else if (index == filteredItems.length * 2 - 1) {
                    // Last index, don't display the divider
                    return LineListItem(
                      lineType: item.type,
                      color: item.color,
                      line: item.line,
                      fromTo: item.fromTo,
                    );
                  } else {
                    return Column(
                      children: [
                        LineListItem(
                          lineType: item.type,
                          color: item.color,
                          line: item.line,
                          fromTo: item.fromTo,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
