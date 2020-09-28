import 'package:flutter/foundation.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:FoodForGood/services/location_service.dart';

class AddressModel extends ChangeNotifier {
  LatLng location;
  String text;

  AddressModel([location, text]) {
    this.location = location ?? LatLng(0.0, 0.0);
    this.text = text ?? '';
  }

  void _syncTextToLocation() async {
    try {
      this.text = await LocationService.locationToText(this.location);
    } catch (error) {
      this.text = '';
    }
    notifyListeners();
  }

  void updateLocation(LatLng newLocation) {
    this.location = newLocation;
    this._syncTextToLocation();
    notifyListeners();
  }

  void updateText(String newText) {
    this.text = newText;
    notifyListeners();
  }
}
