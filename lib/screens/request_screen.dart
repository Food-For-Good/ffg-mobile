import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart' as dartLatLng;
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:FoodForGood/access_tokens.dart';
import 'package:FoodForGood/components/listing_card.dart';
import 'package:FoodForGood/components/listing_card_expanded.dart';
import 'package:FoodForGood/components/map_button.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/screens/my_request_screen.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:FoodForGood/services/database.dart';
import 'package:FoodForGood/models/listing_model.dart';

import 'chat_screen.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  String myUsername = '';
  String myEmail = '';
  MapboxMapController controller;
  List<Marker> markers = [];
  Widget _myAnimatedWidget;
  DateTime currentTime = DateTime.now();
  Marker currentLocationMarker = Marker();
  // dartLatLng.LatLng currentLatLngView;
  dartLatLng.LatLng currentLatitudeLongitude = dartLatLng.LatLng(23.0, 23.0);
  bool _showSpinner = false;
  MapController mapController = MapController();

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

  Future<dartLatLng.LatLng> getCurrentLatLong() async {
    setState(() {
      _showSpinner = true;
    });
    Position currentLatLong;
    try {
      currentLatLong = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      currentLatitudeLongitude.latitude = currentLatLong.latitude;
      currentLatitudeLongitude.longitude = currentLatLong.longitude;
      setState(() {
        _showSpinner = false;
      });
    } catch (error) {
      print('ERROR: ' + error.toString());
    }
    return currentLatitudeLongitude;
  }

  // Future<LatLng> getCurrentPos() async {
  //   locationMapBox = await LocationService.getCurrentLatLng();
  //   return locationMapBox;
  // }
  // getCurrentViewPoint() async {
  //   currentLatLngView = await this.getCurrentLatLong();
  //   print('currentLatLangView is :- ' + currentLatLngView.toString());
  // }

  void currentMarker() async {
    currentLocationMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: await getCurrentLatLong(),
      builder: (ctx) => Container(
        child: Icon(
          FontAwesomeIcons.mapMarkerAlt,
          color: kSecondaryColor,
        ),
      ),
    );
    markers.add(currentLocationMarker);
  }

  dartLatLng.LatLng getLatLngFromGeoPoint(GeoPoint location) {
    dartLatLng.LatLng dartLocation = dartLatLng.LatLng(0.0, 0.0);
    dartLocation.latitude = location.latitude;
    dartLocation.longitude = location.longitude;
    return dartLocation;
  }

  // _getDistanceBetweenTwoLocations(dartLatLng.LatLng location1, dartLatLng.LatLng location2) {
  //   double x1 = location1.latitude;
  //   double x2 = location2.latitude;
  //   double y1 = location1.longitude;
  //   double y2 = location2.longitude;
  //   double distance = (x2 - x2);
  // }

  Widget _getAllListings(BuildContext ctx) {
    final database = FirestoreDatabase();
    return StreamBuilder<List<Listing>>(
      stream: database.listingStream(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final listings = snapshot.data;
          final children = listings
              .map(
                (listing) {
                  if (listing.expiryTime.isAfter(currentTime) &&
                      listing.listingState == listingStateOpen) {
                    addMarker(
                        listing.location.latitude, listing.location.longitude);
                    return ListingCard(
                      username: listing.username,
                      title: listing.title,
                      onPressed: () {
                        setState(() {
                          //Move to the location of the listing when it is pressed.
                          mapController.move(
                              getLatLngFromGeoPoint(listing.location), 13.0);
                          _myAnimatedWidget = ListingCardExpanded(
                            username: listing.username,
                            title: listing.title,
                            descrtiption: listing.description,
                            address: listing.address,
                            expiryTime: listing.expiryTime,
                            tickMarkColor: kPrimaryColor,
                            onPressedTickMark: () async {
                              if (listing.email != myEmail) {
                                Map<String, dynamic> requests =
                                    listing.requests;
                                if (requests.containsKey(myEmail)) {
                                  print('Request is already created');
                                  kShowFlushBar(
                                      context: ctx,
                                      content:
                                          'Request is already created for this listing!',
                                      customError: true);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyRequestScreen(
                                          selectedIndexFromRequestPage: (listing
                                                  .acceptedRequest
                                                  .containsKey(myEmail))
                                              ? 0
                                              : 1,
                                        ),
                                      ));
                                } else {
                                  requests[myEmail] = myUsername;
                                  await database.createListingRequest(
                                      listing, requests);
                                  kShowFlushBar(
                                      context: ctx,
                                      content: 'Request generated successfully',
                                      customError: true);
                                  print(
                                      'Listing request is successfully created');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyRequestScreen(
                                          selectedIndexFromRequestPage: 1,
                                        ),
                                      ));
                                }
                              } else {
                                kShowFlushBar(
                                    content:
                                        'You can not accept your own listing!',
                                    customError: true);
                              }
                            },
                            onPressedChat: () {
                              if (listing.email != myEmail) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      myEmail: myEmail,
                                      otherPersonEmail: listing.email,
                                    ),
                                  ),
                                );
                              } else {
                                kShowFlushBar(
                                    content: 'You can not chat with yourself!',
                                    customError: true);
                              }
                            },
                            onCross: () {
                              setState(() {
                                _myAnimatedWidget = _getAllListings(ctx);
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
    currentMarker();
    print(markers);
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
        body: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          child: Stack(
            children: <Widget>[
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: dartLatLng.LatLng(23.022505, 72.571365),
                  zoom: 10.0,
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
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MapButton(
                    icon: Icons.my_location,
                    onPressed: () {
                      mapController.move(currentLatitudeLongitude, 13.0);
                    },
                  ),
                ),
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
                    child: _myAnimatedWidget ?? _getAllListings(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
