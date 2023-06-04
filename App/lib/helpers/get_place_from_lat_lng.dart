import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transitway/utils/env.dart';

Future<String?> getPlaceFromLatLng(double latitude, double longitude) async {
  final url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$mapKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    if (result['status'] == 'OK') {
      final place = result['results'][0]['formatted_address'];
      return place;
    }
  }

  return null;
}
