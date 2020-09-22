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

  static Future<String> getCurrentAddress() async {
    LatLng currentPosition = await LocationService.getCurrentLatLng();
    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(currentPosition.latitude, currentPosition.longitude));
    return addresses.first.addressLine;
  }
}
