import 'package:geolocator/geolocator.dart';

class GeolocationService {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<bool> isReasonablePostion(
    double startLatitude,
    double startLongitude,
  ) async {
    var distanceInMeters = await Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      20.99820898176506,
      105.79430067116436,
    );

    if (distanceInMeters < 100)
      return true;
    else
      return false;
  }
}
