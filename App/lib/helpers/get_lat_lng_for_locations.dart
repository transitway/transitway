import 'package:transitway/helpers/get_lat_lng_from_place.dart';

Future<Map<String, Map<String, double>>> getLatLngForLocations(
  String fromLocation,
  String toLocation,
) async {
  try {
    final fromLatLng = await getLatLngfromPlace(fromLocation);
    final toLatLng = await getLatLngfromPlace(toLocation);

    return {
      'from': fromLatLng,
      'to': toLatLng,
    };
  } catch (e) {
    throw Exception('Error getting latLng for locations: $e');
  }
}
