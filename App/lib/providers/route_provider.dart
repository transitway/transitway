import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transitway/helpers/get_lat_lng_for_locations.dart';
import 'package:transitway/helpers/get_routes.dart';
import 'package:transitway/datamodels/ticket.dart';
import 'package:transitway/url.dart';

import 'package:transitway/state/state.dart' as state;
import 'package:http/http.dart' as http;

import '../components/routing/route_option.dart';
import '../components/routing/step_options.dart';
import '../datamodels/segment.dart';

class RouteProvider with ChangeNotifier {
  int routeIndex = 0;

  double fromLatitude = 0.0;
  double fromLongitude = 0.0;
  double toLatitude = 0.0;
  double toLongitude = 0.0;

  bool isLoading = true;

  dynamic data = {};

  bool navMode = false;

  String fromName = '';
  String toName = '';

  LatLngBounds bounds = LatLngBounds(
    southwest: const LatLng(0.0, 0.0),
    northeast: const LatLng(0.0, 0.0),
  );

  bool ticketoverlay = false;

  toggleTicketOverlay() {
    ticketoverlay = !ticketoverlay;

    notifyListeners();
  }

  toggleNavMode() {
    navMode = !navMode;

    notifyListeners();
  }

  List<Polyline> polylines = [
    const Polyline(polylineId: PolylineId("polyline0")),
    const Polyline(polylineId: PolylineId("polyline1")),
    const Polyline(polylineId: PolylineId("polyline2")),
    const Polyline(polylineId: PolylineId("polyline3")),
    const Polyline(polylineId: PolylineId("polyline4")),
    const Polyline(polylineId: PolylineId("polyline5")),
    const Polyline(polylineId: PolylineId("polyline6")),
    const Polyline(polylineId: PolylineId("polyline7")),
    const Polyline(polylineId: PolylineId("polyline8")),
    const Polyline(polylineId: PolylineId("polyline9")),
  ];

  Set<Polyline> polylinesSet = <Polyline>{
    const Polyline(polylineId: PolylineId("polyline0")),
    const Polyline(polylineId: PolylineId("polyline1")),
    const Polyline(polylineId: PolylineId("polyline2")),
    const Polyline(polylineId: PolylineId("polyline3")),
    const Polyline(polylineId: PolylineId("polyline4")),
    const Polyline(polylineId: PolylineId("polyline5")),
    const Polyline(polylineId: PolylineId("polyline6")),
    const Polyline(polylineId: PolylineId("polyline7")),
    const Polyline(polylineId: PolylineId("polyline8")),
    const Polyline(polylineId: PolylineId("polyline9")),
  };

  List<List<Polyline>> polylinesList = [];
  List<List<Segment>> segmentsList = [];
  List<int> noLines = [];
  List<List<String>> lines = [];
  List<Map<String, String>> metaList = [];

  List<List<StepOption>> stepsList = [];

  List<RouteOption> routeOptionsList = [];

  Ticket boughtTicket = Ticket();

  deleteData() async {
    routeIndex = 0;

    fromLatitude = 0.0;
    fromLongitude = 0.0;
    toLatitude = 0.0;
    toLongitude = 0.0;

    isLoading = true;

    bounds = LatLngBounds(
      southwest: const LatLng(0.0, 0.0),
      northeast: const LatLng(0.0, 0.0),
    );

    data = {};

    polylines = [
      const Polyline(polylineId: PolylineId("polyline0")),
      const Polyline(polylineId: PolylineId("polyline1")),
      const Polyline(polylineId: PolylineId("polyline2")),
      const Polyline(polylineId: PolylineId("polyline3")),
      const Polyline(polylineId: PolylineId("polyline4")),
      const Polyline(polylineId: PolylineId("polyline5")),
      const Polyline(polylineId: PolylineId("polyline6")),
      const Polyline(polylineId: PolylineId("polyline7")),
      const Polyline(polylineId: PolylineId("polyline8")),
      const Polyline(polylineId: PolylineId("polyline9")),
    ];

    polylinesSet = <Polyline>{
      const Polyline(polylineId: PolylineId("polyline0")),
      const Polyline(polylineId: PolylineId("polyline1")),
      const Polyline(polylineId: PolylineId("polyline2")),
      const Polyline(polylineId: PolylineId("polyline3")),
      const Polyline(polylineId: PolylineId("polyline4")),
      const Polyline(polylineId: PolylineId("polyline5")),
      const Polyline(polylineId: PolylineId("polyline6")),
      const Polyline(polylineId: PolylineId("polyline7")),
      const Polyline(polylineId: PolylineId("polyline8")),
      const Polyline(polylineId: PolylineId("polyline9")),
    };

    polylinesList = [];
    segmentsList = [];
    metaList = [];

    routeOptionsList = [];
  }

  loadPolylines() {
    for (int i = 0; i < polylines.length; i++) {
      if (i < polylinesList[routeIndex].length) {
        polylines[i] = Polyline(polylineId: polylines[i].polylineId);
        polylines[i] = Polyline(
          polylineId: polylines[i].polylineId,
          color: polylinesList[routeIndex][i].color,
          patterns: polylinesList[routeIndex][i].patterns,
          points: polylinesList[routeIndex][i].points,
          width: polylinesList[routeIndex][i].width,
        );
      } else {
        polylines[i] = Polyline(polylineId: polylines[i].polylineId);
      }
    }
  }

  changeRouteIndex(int index) async {
    routeIndex = index;

    loadPolylines();
    polylinesSet = Set<Polyline>.of(polylines);

    notifyListeners();
  }

  loadName(String localFromName, String localToName) {
    fromName = localFromName;
    toName = localToName;
    if (fromName.length > 35) {
      fromName = '${fromName.substring(0, 35)}...';
    }
    if (toName.length > 20) {
      toName = '${toName.substring(0, 20)}...';
    }

    notifyListeners();
  }

  loadData() async {
    Map<String, Map<String, double>> latLngMap =
        await getLatLngForLocations(fromName, toName);

    fromLatitude = latLngMap['from']?['latitude'] ?? 0.0;
    fromLongitude = latLngMap['from']?['longitude'] ?? 0.0;
    toLatitude = latLngMap['to']?['latitude'] ?? 0.0;
    toLongitude = latLngMap['to']?['longitude'] ?? 0.0;

    // fromLatitude = 44.940880;
    // fromLongitude = 26.022520;
    // toLatitude = 44.944694;
    // toLongitude = 25.996167;

    isLoading = false;

    bounds = LatLngBounds(
      southwest: LatLng(
        fromLatitude < toLatitude ? fromLatitude : toLatitude,
        fromLongitude < toLongitude ? fromLongitude : toLongitude,
      ),
      northeast: LatLng(
        fromLatitude > toLatitude ? fromLatitude : toLatitude,
        fromLongitude > toLongitude ? fromLongitude : toLongitude,
      ),
    );

    // getting the directions
    data = await getPublicTransitRoutes(
        fromLatitude, fromLongitude, toLatitude, toLongitude);

    // getting polylines, segments and metaList
    polylinesList = parsePolylines(data);

    final parseSegmentsResult = parseSegments(data);
    segmentsList = parseSegmentsResult['segments'];
    noLines = parseSegmentsResult['noLines'];
    lines = parseSegmentsResult['lines'];
    metaList = parseMeta(data);

    // gettings steps
    stepsList = parseSteps(data);

    loadPolylines();
    polylinesSet = Set<Polyline>.of(polylines);

    notifyListeners();
  }

  loadRouteOptions() async {
    for (int i = 0; i < segmentsList.length; i++) {
      routeOptionsList.add(RouteOption(
        segments: segmentsList[i],
        arrivalTime: metaList[i]['arrivalTime'] ?? "",
        leaveAt: metaList[i]['leaveAt'] ?? "",
        fromLoc: metaList[i]['fromLoc'] ?? "",
        routeIndex: i,
      ));
    }

    notifyListeners();
  }

  buyTicket(List<String> lines, String typeID, BuildContext context) async {
    final response = await http.post(Uri.parse("${AppURL.buyTicket}$typeID"),
        headers: authHeader(state.token),
        body: jsonEncode(<String, dynamic>{
          'lines': lines,
        }));

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      boughtTicket = Ticket.fromJSON(json['ticket']);

      print(boughtTicket);

      notifyListeners();
      Navigator.pop(context);
    }
  }
}
