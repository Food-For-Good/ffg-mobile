import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class LocationService {
  static Future<LatLng> getCurrentLatLng() async {
    Position currentPosition = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    return LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  static Future<String> locationToText(LatLng location) async {
    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(location.latitude, location.longitude));
    return addresses.first.addressLine;
  }
}
