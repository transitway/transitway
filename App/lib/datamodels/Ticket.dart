import 'package:transitway/utils/utils.dart';

List<String> convertLines(List<dynamic> dynamicList) {
  return dynamicList.map((item) => item.toString()).toList();
}

class Ticket {
  String? id;
  String? accountID;
  String? name;
  String? category;
  List<String>? lines;
  String? city;
  DateTime? expiresAt;
  DateTime? createdAt;

  Ticket({
    this.id,
    this.accountID,
    this.name,
    this.category,
    this.lines,
    this.city,
    this.expiresAt,
    this.createdAt,
  });

  factory Ticket.fromJSON(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      accountID: json['accountID'],
      name: capitalize(json['name'].toString()),
      category: capitalize(json['category'].toString()),
      lines: convertLines(json['lines']),
      city: json['city'],
      expiresAt: DateTime.parse(json['expiresAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
