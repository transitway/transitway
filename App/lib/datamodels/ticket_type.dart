class TicketType {
  final String id;
  final String name;
  final String category;
  final double fare;
  final String city;
  final int noLines;
  final String expiry;

  TicketType({
    required this.id,
    required this.name,
    required this.category,
    required this.fare,
    required this.city,
    required this.noLines,
    required this.expiry,
  });

  factory TicketType.fromJSON(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      fare: json['fare'].toDouble(),
      city: json['city'],
      noLines: json['noLines'],
      expiry: json['expiry'],
    );
  }
}
