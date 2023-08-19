import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

import '../services/location.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final Location myLocation = Location();
  late Response response;

  Future<void> getLocation() async {
    try {
      await myLocation.getCurrentLocation();
      print('Longitude is ${myLocation.longitude}');
      print('Latitude is ${myLocation.latitude}');
      await getData();
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getData() async {
    final Uri httpsUri = Uri(
      scheme: 'https',
      host: 'api.open-meteo.com',
      path: '/v1/forecast',
      queryParameters: {'latitude': '${myLocation.latitude}', 'longitude': '${myLocation.longitude}', 'current_weather': 'true'},
    );

    print(httpsUri);
    response = await get(httpsUri);

    print(response.statusCode);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    final Position position = await Geolocator.getCurrentPosition();
    print('Current Location: $position');
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            getLocation();
            //getData();
            // _determinePosition(); //Get the current location
          },
          child: Text('Get Location'),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //getLocation();
  }
}
