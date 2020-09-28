import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:FoodForGood/access_tokens.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/models/address_model.dart';
import 'package:FoodForGood/services/location_service.dart';

class AddressSelector extends StatefulWidget {
  final AddressModel addressModel;

  const AddressSelector({@required this.addressModel});

  @override
  _AddressSelectorState createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector> {
  LatLng currentLatLng = LatLng(0.0, 0.0);
  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    this.mapController = controller;
  }

  void _moveCameraToCurrentPosition() {
    mapController.animateCamera(
      CameraUpdate.newLatLng(this.currentLatLng),
    );
  }

  void _moveCameraToOriginalLocation() async {
    try {
      this.currentLatLng = await LocationService.getCurrentLatLng();
      this._moveCameraToCurrentPosition();
    } catch (error) {
      kShowFlushBar(content: error.toString(), context: context);
    }
  }

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  void initState() {
    super.initState();
    this.currentLatLng = widget.addressModel.location;
    if (this.currentLatLng == LatLng(0.0, 0.0)) {
      this._moveCameraToOriginalLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MapboxMap(
          accessToken: MAPBOX_ACCESS_TOKEN,
          onMapCreated: this._onMapCreated,
          trackCameraPosition: true,
          initialCameraPosition: CameraPosition(
            target: this.currentLatLng,
            zoom: 14,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Icon(
                      Icons.circle,
                      size: 23.0,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Icon(
                    FontAwesomeIcons.mapPin,
                    size: 50.0,
                    color: kSecondaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MapButton(
                icon: Icons.zoom_in,
                onPressed: this._zoomIn,
              ),
              MapButton(
                icon: Icons.zoom_out,
                onPressed: this._zoomOut,
              ),
              MapButton(
                icon: Icons.my_location,
                onPressed: this._moveCameraToOriginalLocation,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.topRight,
            child: MapButton(
              icon: FontAwesomeIcons.check,
              onPressed: () {
                widget.addressModel.updateLocation(
                  this.mapController.cameraPosition.target,
                );
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class MapButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  const MapButton({@required this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        splashColor: Colors.deepOrange,
        child: Icon(
          this.icon,
          color: kBackgroundColor,
          size: 30.0,
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}
