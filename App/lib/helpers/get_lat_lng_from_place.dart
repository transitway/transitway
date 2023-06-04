import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:transitway/utils/env.dart';

Future<Map<String, double>> getLatLngfromPlace(String place) async {
  final apiKey = mapKey; // Replace with your Google Maps API key
  const apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json';

  final response =
      await http.get(Uri.parse('$apiUrl?address=$place&key=$apiKey'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final results = data['results'] as List<dynamic>;

    if (results.isNotEmpty) {
      final location = results[0]['geometry']['location'];
      final lat = location['lat'] as double;
      final lng = location['lng'] as double;

      return {'latitude': lat, 'longitude': lng};
    }
  }

  // Failed to convert place to latlng
  return {'latitude': 0.0, 'longitude': 0.0};
}
