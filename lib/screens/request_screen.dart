import 'package:FoodForGood/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart' as dartLatLng;
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:FoodForGood/access_tokens.dart';
import 'package:FoodForGood/components/listing_card.dart';
import 'package:FoodForGood/components/listing_card_expanded.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:FoodForGood/services/location_service.dart';
import 'package:FoodForGood/models/listing_model.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  String myUsername = '';
  String myEmail = '';
  LatLng locationMapBox;
  MapboxMapController controller;
  LatLng currentLatLng = LatLng(0.0, 0.0);
  List<Marker> markers = [];
  Widget _myAnimatedWidget;
  DateTime currentTime = DateTime.now();

  String requestId = '';

  setUsername() async {
    this.myUsername = await AuthService().getUsername();
  }

  getUserEmail() async {
    this.myEmail = await AuthService().getEmail();
  }

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

  Widget _getAllListings() {
    final database = FirestoreDatabase();
    return StreamBuilder<List<Listing>>(
      stream: database.listingStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final listings = snapshot.data;
          final children = listings
              .map(
                (listing) {
                  if (listing.expiryTime.isAfter(currentTime) &&
                      listing.listingState == listingStateOpen) {
                    return ListingCard(
                      username: listing.username,
                      title: listing.title,
                      onPressed: () {
                        setState(() {
                          _myAnimatedWidget = ListingCardExpanded(
                            username: listing.username,
                            title: listing.title,
                            descrtiption: listing.description,
                            address: listing.address,
                            expiryTime: listing.expiryTime,
                            tickMarkColor: kPrimaryColor,
                            onPressedTickMark: () async {
                              Map<String, dynamic> requests = listing.requests;
                              if (requests.containsKey(myEmail)) {
                                print('Request is already created');
                              } else {
                                requests[myEmail] = currentTime.toString();
                                await database.createListingRequest(
                                    listing, requests);
                              }
                              print('Listing request is successfully created');
                            },
                            onCross: () {
                              setState(() {
                                _myAnimatedWidget = _getAllListings();
                              });
                            },
                          );
                        });
                      },
                    );
                  }
                },
              )
              .whereType<ListingCard>()
              .toList();
          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Some Error Occured',
              style: kTextStyle,
            ),
          );
        }
        return Center(
          child: Text('No listing available'),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    this.setUsername();
    this.getUserEmail();
    _myAnimatedWidget = _getAllListings();
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
