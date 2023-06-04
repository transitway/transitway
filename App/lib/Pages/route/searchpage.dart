import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/Pages/route/homescreen.dart';
import 'package:transitway/components/searchbar.dart';
import 'package:transitway/components/customaddr.dart';
import 'package:transitway/providers/account_provider.dart';
import 'package:transitway/utils/env.dart';
import 'package:transitway/helpers/get_current_position.dart';
import 'package:transitway/helpers/get_place_from_lat_lng.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transitway/helpers/places_class.dart';
import 'package:transitway/Pages/route/routepreview.dart';
import 'package:transitway/providers/route_provider.dart';

class SearchPage extends StatefulWidget {
  final String? preFilledTextFrom;
  final String? preFilledTextTo;
  const SearchPage({
    Key? key,
    this.preFilledTextFrom,
    this.preFilledTextTo,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Place> placePredictions = [];

  String? selectedAddress;
  String? preFilledTextFrom;
  String? toLocationName;
  String? toPlace;

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.preFilledTextFrom ?? '';
    toPlace = widget.preFilledTextTo ?? '';
    getPos(); // Call the getPos func
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = Provider.of<RouteProvider>(context, listen: false);
      route.deleteData();
    });
  }

  Future<void> getPlacePredictions(String input) async {
    if (input.isEmpty) {
      setState(() {
        placePredictions = [];
      });
      return;
    }

    final apiKey = mapKey;
    const apiUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final sessionToken = DateTime.now().millisecondsSinceEpoch.toString();

    final response = await http.get(Uri.parse(
        '$apiUrl?input=$input&components=country:RO&locationbias=circle:8400@44.942965,26.018094&key=$apiKey&sessiontoken=$sessionToken'));

    if (response.statusCode == 200) {
      const maxLengthDescription = 38; // Maximum length for the description
      const maxLengthName = 26;
      final predictions = json.decode(response.body)['predictions'];
      setState(() {
        placePredictions = predictions.map<Place>((prediction) {
          String description = prediction['description'];
          String name = prediction['structured_formatting']['main_text'];
          if (description.length > maxLengthDescription) {
            description =
                '${description.substring(0, maxLengthDescription)}...';
          }
          if (name.length > maxLengthName) {
            name = '${name.substring(0, maxLengthName)}...';
          }
          toLocationName = name;
          return Place(
            description: description,
            placeId: prediction['place_id'],
            name: name,
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch place predictions');
    }
  }

  void onPlaceSelected(String locationName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoutePreview(
          toLocationName: locationName,
        ),
      ),
    );
  }

  void getPos() async {
    Position? position = await getCurrentLocation();

    if (position != null) {
      String? place =
          await getPlaceFromLatLng(position.latitude, position.longitude);

      if (place != null) {
        setState(() {
          preFilledTextFrom = place; // Store the place in the member variable
        });
      } else {
        // Failed to retrieve place information
        throw Exception("Failed to retrieve place information");
      }
    } else {
      // Failed to retrieve current location
      throw Exception('Failed to retrieve current location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(
        builder: (context, route, _) =>
            Consumer<AccountProvider>(builder: (context, auth, _) {
              return (Scaffold(
                body: SafeArea(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, right: 30, left: 30, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                            },
                            child: const Icon(
                              Icons.close,
                            ),
                          ),
                          const Text(
                            'Ruta ta',
                            style: TextStyle(
                                fontSize: 17, fontFamily: 'UberMoveMedium'),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: SearchBarComponent(
                        preFilledTextFrom: preFilledTextFrom ?? '',
                        preFilledTextTo: selectedAddress ?? '',
                        onSearchTextChanged: getPlacePredictions,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAddress = auth.account.homeAddress?.street ??
                              ''; // Set the selected address
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoutePreview(
                                // fromLocation: preFilledTextFrom ?? '',
                                // toLocation:
                                //     auth.account.homeAddress?.street ?? '0',
                                toLocationName:
                                    'Strada Troienelor, Ploiesti, Romania',
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, right: 30, left: 30),
                          child: CustomAddr(
                              title: 'Acasa',
                              address: 'Strada Troienelor, Ploiesti',
                              icon: Icons.home,
                              map: false,
                              color: accentBlue),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoutePreview(
                              // fromLocation: preFilledTextFrom ?? '',
                              // toLocation:
                              //     auth.account.homeAddress?.street ?? '',
                              toLocationName:
                                  'Gheorghe Doja 98, Ploiești, Romania',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 30, left: 30, top: 20.0),
                        child: CustomAddr(
                            title: 'Serviciu',
                            address:
                                'Colegiul National "I. L. Caragiale" Ploiesti',
                            icon: Icons.work,
                            map: false,
                            color: accentBlue),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                      child: Divider(
                        color: darkGrey,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: ListView.builder(
                          itemCount: placePredictions.length,
                          itemBuilder: (context, index) {
                            final prediction = placePredictions[index];
                            return GestureDetector(
                              onTap: () {
                                // route.FromName = preFilledTextFrom ?? '';
                                // route.ToName = prediction.name;
                                route.loadName(preFilledTextFrom ?? '',
                                    prediction.description);
                                setState(() {
                                  selectedAddress = prediction.name;
                                });
                                onPlaceSelected(prediction.name);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: CustomAddr(
                                  title: prediction.name,
                                  address: prediction.description,
                                  icon: Icons.location_on,
                                  map: false,
                                  color: darkGrey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )),
              ));
            }));
  }
}
