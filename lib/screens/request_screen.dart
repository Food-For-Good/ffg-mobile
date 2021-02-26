import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:FoodForGood/access_tokens.dart';
import 'package:FoodForGood/components/listing_card.dart';
import 'package:FoodForGood/components/listing_card_expanded.dart';
import 'package:FoodForGood/constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart' as dartLatLng;
import 'package:FoodForGood/services/location_service.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final Firestore _firestore = Firestore.instance;
  LatLng locationMapBox;
  MapboxMapController controller;
  LatLng currentLatLng = LatLng(0.0, 0.0);
  List<Marker> markers = [];
  Widget _myAnimatedWidget;

  List<Marker> addMarker(double lat, double lon) {
    Marker newMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: dartLatLng.LatLng(lat, lon),
      builder: (ctx) => Container(
        child: Icon(
          FontAwesomeIcons.mapMarkerAlt,
          color: kPrimaryColor,
        ),
      ),
    );
    markers.add(newMarker);
    return markers;
  }

  dartLatLng.LatLng convertLatLng(latlong) {
    dartLatLng.LatLng dartLatlong;
    dartLatlong.latitude = latlong.latitude;
    dartLatlong.longitude = latlong.longitude;
    return dartLatlong;
  }

  Future<LatLng> getCurrentPos() async {
    locationMapBox = await LocationService.getCurrentLatLng();
    return locationMapBox;
  }

  List<Marker> currentMarker() {
    Marker currentMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: convertLatLng(locationMapBox),
      builder: (ctx) => Container(
        child: Icon(
          FontAwesomeIcons.mapMarkerAlt,
          color: kSecondaryColor,
        ),
      ),
    );
    markers.add(currentMarker);
    return markers;
  }

  Widget allListings() {
    return ListView(
      children: <Widget>[
        StreamBuilder(
          stream: _firestore.collection('Listings').snapshots(),
          builder: (context, snapshot) {
            List<ListingCard> listingWidgets = [];
            if (snapshot.hasData) {
              final listings = snapshot.data.documents;
              for (var listing in listings) {
                final title = listing.data['title'];
                final username = listing.data['username'];
                final description = listing.data['description'];
                final address = listing.data['address'];
                GeoPoint location = listing.data['location'];
                addMarker(location.latitude, location.longitude);

                final listingWidget = ListingCard(
                  username: username,
                  title: title,
                  onPressed: () {
                    setState(() {
                      _myAnimatedWidget = ListingCardExpanded(
                        username: username,
                        title: title,
                        descrtiption: description,
                        address: address,
                        onCross: () {
                          setState(() {
                            _myAnimatedWidget = allListings();
                          });
                        },
                      );
                    });
                  },
                );
                listingWidgets.add(listingWidget);
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listingWidgets,
            );
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _myAnimatedWidget = allListings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: kAppBar(
          context: context,
          title: Text('REQUESTS', style: kTitleStyle),
          icon: Icon(Icons.arrow_back_ios),
          pressed: () {
            Navigator.pop(context);
          },
        ),
        body: Stack(
          children: <Widget>[
            FlutterMap(
              options: MapOptions(
                center: dartLatLng.LatLng(23.022505, 72.571365),
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/presi-patel/ckl9ahy1h0r3c17n0lffaoki7/tiles/256/{z}/{x}/{y}@2x?access_token=$MAPBOX_ACCESS_TOKEN",
                  additionalOptions: {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': 'mapbox.streets',
                  },
                ),
                MarkerLayerOptions(
                  markers: markers,
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  border: Border.all(width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: MediaQuery.of(context).size.height * .35,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: _myAnimatedWidget,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
