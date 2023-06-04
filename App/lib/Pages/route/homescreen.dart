import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:transitway/Pages/route/searchpage.dart';
import 'package:transitway/components/customaddr.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:transitway/helpers/get_place_from_lat_lng.dart';
import 'package:transitway/providers/account_provider.dart';
import 'package:transitway/providers/route_provider.dart';
import 'package:transitway/utils/env.dart';
import 'package:transitway/Pages/route/routepreview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double sheetPageHeight = 250;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late GoogleMapController mapController;

  var geoLocator = Geolocator();
  late Position currentPosition;
  String? placePos;

  @override
  void initState() {
    super.initState();
    loadMapStyle();
  }

  late String customMapStyle;

  Future<void> loadMapStyle() async {
    customMapStyle = await rootBundle.loadString('assets/mapstyling.json');
  }

  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    currentPosition = position;

    String? place =
        await getPlaceFromLatLng(position.latitude, position.longitude);
    placePos = place;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = CameraPosition(target: pos, zoom: 17);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(44.942573, 26.019305),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(builder: (context, auth, _) {
      return Consumer<RouteProvider>(builder: (context, route, _) {
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                padding: EdgeInsets.only(bottom: sheetPageHeight),
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  mapController = controller;

                  setupPositionLocator();
                },
              ),
              Positioned(
                bottom: 260,
                right: 20,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  elevation: 3,
                  onPressed: () {
                    setupPositionLocator();
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                              color: lightGrey,
                              borderRadius: BorderRadius.circular(19)),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Row(children: [
                              Icon(
                                Icons.search,
                                size: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Unde mergem?',
                                  style: TextStyle(
                                      fontFamily: 'UberMoveBold',
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: darkGrey),
                                ),
                              )
                            ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchPage()),
                            );
                          },
                          child: GestureDetector(
                            onTap: () {
                              route.loadName(placePos ?? '',
                                  auth.account.homeAddress?.street ?? '');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RoutePreview(
                                    toLocationName:
                                        'Strada Troienelor, Ploiesti, Romania',
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: CustomAddr(
                                  title: 'Acasa',
                                  address: 'Strada Troienelor, Ploiesti',
                                  icon: Icons.home,
                                  map: true,
                                  color: accentBlue),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            route.loadName(placePos ?? '',
                                auth.account.workAddress?.street ?? '');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoutePreview(
                                  toLocationName:
                                      'Gheorghe Doja 98, Ploiești, Romania',
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: CustomAddr(
                                title: 'Serviciu',
                                address:
                                    'Colegiul National "I. L. Caragiale" Ploiesti',
                                icon: Icons.work,
                                map: true,
                                color: accentBlue),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
