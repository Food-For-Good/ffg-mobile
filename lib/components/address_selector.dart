import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:FoodForGood/access_tokens.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/services/location_service.dart';

class AddressSelector extends StatefulWidget {
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

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  void initState() {
    super.initState();
    LocationService.getCurrentLatLng().then((currLatLng) {
      this.currentLatLng = currLatLng;
      this._moveCameraToCurrentPosition();
    }).catchError((error) {
      kShowFlushBar(content: error.toString(), context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MapboxMap(
          accessToken: MAPBOX_ACCESS_TOKEN,
          onMapCreated: this._onMapCreated,
          initialCameraPosition: CameraPosition(
            target: this.currentLatLng,
            zoom: 15,
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
              SizedBox(
                height: 8.0,
              ),
              Text(
                'YOUR LOCATION',
                style: kTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                  icon: Icons.location_searching,
                  onPressed: this._moveCameraToCurrentPosition,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: MapButton(
              icon: FontAwesomeIcons.check,
              onPressed: () {
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
