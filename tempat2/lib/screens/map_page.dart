import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; //google map
import 'package:flutter_polyline_points/flutter_polyline_points.dart'; //line in map
import 'package:location/location.dart'; //location

class MapPage extends StatefulWidget {
  //////////////////////////////////////////////////////////////////////////////
  final double destinationLatitude;
  final double destinationLongitude;

  const MapPage({
    Key? key,
    required this.destinationLatitude,
    required this.destinationLongitude,
  }) : super(key: key);
/////////////////////////////////////////////////////////////////////////
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();
  StreamSubscription<LocationData>? _locationSubscription;

  //screen follow the user location
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  Set<Marker> markers = {};

  //cordinat - pisition west & south kena letak "-"
  static LatLng _pInitial = LatLng(5.2077, 103.2049); //marang
  static LatLng _pDestination = LatLng(5.4072, 103.0883); //UMT
  LatLng? _currentP = null;

  Map<PolylineId, Polyline> polylines = {};

  // Update the polyline whenever the user's location changes
  void updatePolyline() {
    getPolylinePoints().then((coordinates) {
      setState(() {
        // Clear existing polylines
        polylines.clear();

        // Generate and add a new polyline
        generatePolyLineFromPoints(coordinates);
      });
    });
  }

  bool _isMounted = false;
  @override
  void initState() {
    super.initState();
    _isMounted = true;
    //get value for destination
    _pDestination =
        LatLng(widget.destinationLatitude, widget.destinationLongitude);
    //getLocationUpdate() -> get user location(ask permision to access user location)
    getLocationUpdate().then(
      (_) => {
        getPolylinePoints().then((coordinates) => {
              generatePolyLineFromPoints(coordinates),
            }),
      },
    );
  }

  @override
  void dispose() {
    // Cancel the location subscription when the widget is disposed
    _locationSubscription?.cancel();
    _isMounted = false;
    super.dispose();
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pop(); // This will navigate back to the previous page
          },
        ),
      ),
      //tunjuk map
      // if _currentP== null display "In Process..." of not display GoogleMap()
      body: _currentP == null
          ? const Center(
              child: Text("In Process..."),
            )
          : GoogleMap(
              //screen follow the user location
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              //awal2 position
              initialCameraPosition: CameraPosition(
                target: _pInitial, // ambik kat atas
                zoom: 18,
              ),
              //letak mark kat map
              markers: {
                Marker(
                  //user location
                  markerId: MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                  position: _currentP!,
                ),
                Marker(
                  markerId: MarkerId("_sourceLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pInitial,
                ),
                Marker(
                  markerId: MarkerId("_destinationLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pDestination,
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////
  //screen follow the user location
  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 18,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////
  //get user location(ask permision to access user location)
  Future<void> getLocationUpdate() async {
    bool _serviceEnable; //allow to get location or not
    PermissionStatus _permissionGranted;

    _serviceEnable = await _locationController.serviceEnabled();
    if (_serviceEnable) {
      _serviceEnable =
          await _locationController.requestService(); //request permission??
    } else {
      return;
    }

    //check permission allow or denied
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      //display request permission to user
      _permissionGranted = await _locationController.requestPermission();
      //if user not granted the permission
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    //if user granted the permission
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (_isMounted &&
          currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          //_currentP is location of user
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);

          // Update _pInitial with the current location
          _pInitial = _currentP!;

          // Update marker positions in the set
          markers = {
            Marker(
              markerId: MarkerId("_currentLocation"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: _currentP!,
            ),
            Marker(
              markerId: MarkerId("_sourceLocation"),
              icon: BitmapDescriptor.defaultMarker,
              position: _pInitial,
            ),
            Marker(
              markerId: MarkerId("_destinationLocation"),
              icon: BitmapDescriptor.defaultMarker,
              position: _pDestination,
            ),
          };

          //screen follow the user location
          _cameraToPosition(_currentP!);

          // Update the markers set
          updatePolyline(); // Call this method to update the polyline
        });
      }
    });
  }

/////////////////////////////////////////////////////////////////////////////////////////

  ///untuk letak line kat map
  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBIq3gydD8o5NftHRwtiCzKO05-5g1mmxs", //from consts.dart
      PointLatLng(_pInitial.latitude, _pInitial.longitude),
      PointLatLng(_pDestination.latitude, _pDestination.longitude),
      travelMode: TravelMode.driving, // travel mode
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  //line kat map
  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: const Color.fromARGB(255, 0, 64, 116),
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
