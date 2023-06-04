import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:transitway/components/routing/draggabledrawer.dart';
import 'package:transitway/Pages/route/searchpage.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'
    as maps_lat_lng;
import 'package:transitway/providers/route_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class RoutePreview extends StatefulWidget {
  final String toLocationName;

  const RoutePreview({
    required this.toLocationName,
    Key? key,
  }) : super(key: key);

  @override
  State<RoutePreview> createState() => _RoutePreviewState();
}

enum MapViewMode {
  overView,
  navigation,
}

class _RoutePreviewState extends State<RoutePreview> {
  late GoogleMapController _mapController;
  MapViewMode currentViewMode = MapViewMode.overView;
  CameraPosition? overviewCameraPosition;
  late StreamSubscription<Position> _positionStreamSubscription;
  bool isMapBeingDragged = false;
  bool overview = true;
  String locationShow = '';
  late String title = widget.toLocationName;
  bool isOverviewMode = true;
  Set<Polyline> polylineSet = <Polyline>{};

  @override
  void initState() {
    super.initState();
    RouteProvider route = RouteProvider();
    //added location stream

    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      if (currentViewMode == MapViewMode.navigation) {
        updateNavView(position);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      route = Provider.of<RouteProvider>(context, listen: false);
      await route.deleteData();
      await route.loadData();
    });

    Future.delayed(const Duration(seconds: 3), () {
      // setting the camera
      setCamera(route.bounds);
      overview = true;
      isMapBeingDragged = true;
    });

    loadMapStyle();
  }

  late String customMapStyle;

  Future<void> loadMapStyle() async {
    customMapStyle = await rootBundle.loadString('assets/mapstyling.json');
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  void setCamera(LatLngBounds bounds) {
    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          bounds, 80.0), // 50.0 is the padding to add around the bounds
    );
    currentViewMode = MapViewMode.overView;
  }

  //this is the overview view
  void overviewView() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    final LatLng pos = LatLng(position.latitude, position.longitude);
    overviewCameraPosition =
        CameraPosition(target: pos, zoom: 14, tilt: 0, bearing: 0);
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(overviewCameraPosition!));
    currentViewMode = MapViewMode.overView;
  }

  void navView() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    final LatLng pos = LatLng(position.latitude, position.longitude);
    final CameraPosition cameraPosition = CameraPosition(
        target: pos, zoom: 20, tilt: 60, bearing: position.heading);
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    currentViewMode = MapViewMode.navigation;
  }

  void updateNavView(Position position) {
    final LatLng pos = LatLng(position.latitude, position.longitude);
    final CameraPosition cameraPosition = CameraPosition(
        target: pos, zoom: 20, tilt: 60, bearing: position.heading);
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(
        builder: (context, route, _) => (Scaffold(
              body: Stack(
                children: [
                  if (!route.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: GoogleMap(
                        compassEnabled: false,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        onMapCreated: (controller) {
                          _mapController = controller;
                          _mapController.setMapStyle(customMapStyle);
                        },
                        onTap: (argument) {
                          setState(() {
                            isMapBeingDragged = true;
                          });
                        },
                        polylines: route.polylinesSet,
                        initialCameraPosition: CameraPosition(
                          target: maps_lat_lng.LatLng(
                              route.toLatitude, route.toLongitude),
                          zoom: 14.0,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('toLocation'),
                            position: maps_lat_lng.LatLng(
                                route.toLatitude, route.toLongitude),
                            infoWindow: const InfoWindow(title: 'To Location'),
                          ),
                        },
                      ),
                    ),
                  if (route.isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  SafeArea(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!route.navMode)
                            AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SearchPage(),
                                      ),
                                    );
                                  },
                                  elevation: 2,
                                  backgroundColor: Colors.white,
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 56),
                          Align(
                            alignment: Alignment.topRight,
                            child: FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  isOverviewMode = !isOverviewMode;
                                });
                                if (overview == false &&
                                    isMapBeingDragged == true) {
                                  navView();
                                  isMapBeingDragged = false;
                                } else if (overview == false &&
                                    isMapBeingDragged == false) {
                                  setCamera(route.bounds);
                                  overview = true;
                                  isMapBeingDragged = true;
                                } else if (overview == true) {
                                  navView();
                                  overview = false;
                                  isMapBeingDragged = false;
                                }
                              },
                              elevation: 2,
                              backgroundColor: Colors.white,
                              child: Icon(
                                isOverviewMode
                                    ? Icons.my_location
                                    : Icons.swap_calls,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!route.isLoading)
                    DraggableDrawer(onStartNav: () {
                      navView();
                      overview = false;
                      isMapBeingDragged = false;
                      isOverviewMode = false;
                    }, onEndNav: () {
                      setCamera(route.bounds);
                      overview = true;
                      isMapBeingDragged = true;
                      isOverviewMode = true;
                    }),
                ],
              ),
            )));
  }
}
