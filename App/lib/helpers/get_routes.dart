import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transitway/helpers/polyline_decode.dart';
import 'package:transitway/utils/env.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transitway/datamodels/segment.dart';
import 'package:html/parser.dart';

import '../components/routing/step_options.dart';

Polyline walkingPolyline(List<LatLng> points) {
  return Polyline(
    polylineId: const PolylineId('walking'),
    color: Colors.grey,
    patterns: const [PatternItem.dot],
    points: points,
    width: 5,
  );
}

Polyline transitPolyline(Color color, List<LatLng> points) {
  return Polyline(
    polylineId: const PolylineId('transit'),
    color: color,
    points: points,
    width: 5,
  );
}

List<List<Polyline>> parsePolylines(dynamic data) {
  final dynamic routes = data['routes'];

  List<List<Polyline>> result = [];

  for (int routeIndex = 0; routeIndex < routes.length; routeIndex++) {
    final dynamic steps = routes[routeIndex]['legs'][0]['steps'];

    List<Polyline> routePolylines = [];

    for (int stepIndex = 0; stepIndex < steps.length; stepIndex++) {
      final List<LatLng> stepPoints =
          decodeEncodedPolyline(steps[stepIndex]['polyline']['points']);

      String travelMode = steps[stepIndex]['travel_mode'];

      Polyline stepPolyline = const Polyline(polylineId: PolylineId('?'));

      if (travelMode == "WALKING") {
        stepPolyline = walkingPolyline(stepPoints);
      } else {
        String line = steps[stepIndex]['transit_details']['line']['short_name'];
        Color lineColor = lineColors[line] ?? Colors.black;

        stepPolyline = transitPolyline(lineColor, stepPoints);
      }

      routePolylines.add(stepPolyline);
    }

    result.add(routePolylines);
  }

  return result;
}

Map<String, dynamic> parseSegments(dynamic data) {
  final dynamic routes = data['routes'];

  List<List<Segment>> segments = [];
  List<int> noLines = [];
  List<List<String>> lines = [];

  for (int routeIndex = 0; routeIndex < routes.length; routeIndex++) {
    final dynamic steps = routes[routeIndex]['legs'][0]['steps'];

    List<Segment> routeSegments = [];
    List<String> routeLines = [];
    int routeNoLines = 0;

    for (int stepIndex = 0; stepIndex < steps.length; stepIndex++) {
      String travelMode = steps[stepIndex]['travel_mode'];
      int duration =
          int.parse(steps[stepIndex]['duration']['text'].split(' ')[0]);
      String line = '';
      IconData type = Icons.directions_bus;

      Color lineColor = Colors.black;

      if (travelMode == "TRANSIT") {
        dynamic lineData = steps[stepIndex]['transit_details']['line'];
        line = lineData['short_name'];

        lineColor = lineColors[line] ?? Colors.black;

        routeNoLines++;
        routeLines.add(line);

        if (lineData['type'] == 'TRAM') {
          type = Icons.tram;
        } else if (lineData['type'] == 'TROLLEY') {
          type = Icons.directions_transit;
        }
      }

      Segment stepSegment = Segment(
        color: lineColor,
        text: line,
        icon: type,
        isWalking: travelMode == "WALKING",
        minutes: duration,
      );

      routeSegments.add(stepSegment);
    }

    noLines.add(routeNoLines);
    lines.add(routeLines);
    segments.add(routeSegments);
  }

  return {
    "segments": segments,
    "noLines": noLines,
    "lines": lines,
  };
}

List<Map<String, String>> parseMeta(dynamic data) {
  final dynamic routes = data['routes'];

  List<Map<String, String>> result = [];

  for (int routeIndex = 0; routeIndex < routes.length; routeIndex++) {
    final dynamic legs = routes[routeIndex]['legs'][0];
    final dynamic steps = routes[routeIndex]['legs'][0]['steps'];

    String fromLoc = '';
    String leaveAt = '';

    bool isTransit = false;

    for (int stepsIndex = 0; stepsIndex < steps.length; stepsIndex++) {
      if (steps[stepsIndex]['travel_mode'] == "TRANSIT") {
        fromLoc =
            steps[stepsIndex]['transit_details']['departure_stop']['name'];

        if (leaveAt == '') {
          leaveAt =
              steps[stepsIndex]['transit_details']['departure_time']['text'];
        }
        isTransit = true;

        break;
      }
    }

    if (isTransit) {
      result.add(<String, String>{
        // "leaveAt": "la ${legs['departure_time']['text']}",
        'leaveAt': 'la $leaveAt',
        "arrivalTime": "la ${legs['arrival_time']['text']}",
        "fromLoc": fromLoc,
      });
    } else {
      result.add(<String, String>{
        "leaveAt": 'acum',
        "arrivalTime": "in ${legs['duration']['text']}",
        "fromLoc": legs['start_address'],
      });
    }
  }

  return result;
}

List<List<StepOption>> parseSteps(dynamic data) {
  final dynamic routes = data['routes'];

  List<List<StepOption>> stepsList = [];

  for (int routeIndex = 0; routeIndex < routes.length; routeIndex++) {
    final dynamic steps = routes[routeIndex]['legs'][0]['steps'];

    List<StepOption> routeSteps = [];

    for (int stepIndex = 0; stepIndex < steps.length; stepIndex++) {
      String travelMode = steps[stepIndex]['travel_mode'];

      if (travelMode == "WALKING") {
        dynamic walkingSteps = steps[stepIndex]['steps'];
        for (int walkingIndex = 0;
            walkingIndex < walkingSteps.length;
            walkingIndex++) {
          // walkingSteps[walkingIndex]['html_instructions'] ?? "Mergi până la stație"
          String presanitizedInstruction = walkingSteps[walkingIndex]
                  ['html_instructions'] ??
              "Mergi până la stație";
          presanitizedInstruction = presanitizedInstruction.replaceAll(
              '<div style="font-size:0.9em">', '. ');

          String sanitizedInstruction =
              parse(presanitizedInstruction).body!.text;
          sanitizedInstruction =
              sanitizedInstruction.replaceAll("Virează", "Mergi");
          routeSteps.add(StepOption(
            type: false,
            time: walkingSteps[walkingIndex]['duration']['text'],
            distance: walkingSteps[walkingIndex]['distance']['text'],
            street: sanitizedInstruction,
          ));
        }
      } else {
        dynamic transitSteps = steps[stepIndex]['transit_details'];
        routeSteps.add(StepOption(
          timeUntil: transitSteps['departure_time']['text'],
          type: true,
          time: transitSteps['arrival_time']['text'],
          line: transitSteps['line']['short_name'],
          color: lineColors[transitSteps['line']['short_name']],
          fromStation: transitSteps['departure_stop']['name'],
          toStation: transitSteps['arrival_stop']['name'],
          noStops: transitSteps['num_stops'],
        ));
      }
    }
    stepsList.add(routeSteps);
  }

  return stepsList;
}

Future<dynamic> getPublicTransitRoutes(double originLat, double originLng,
    double destinationLat, double destinationLng) async {
  final url =
      'https://maps.googleapis.com/maps/api/directions/json?language=ro&transit_mode=bus|tram&alternatives=true&origin=$originLat,$originLng&destination=$destinationLat,$destinationLng&mode=transit&key=$mapKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return data;
  } else {
    throw Exception('Failed to fetch routes');
  }
}
