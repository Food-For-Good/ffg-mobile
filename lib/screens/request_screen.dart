import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:FoodForGood/components/listing_card.dart';
import 'package:FoodForGood/components/listing_card_expanded.dart';
import 'package:FoodForGood/constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final Firestore _firestore = Firestore.instance;
  Position currentPosition;
  List<Marker> markers = [];
  Widget _myAnimatedWidget;

  void addMarker(double lat, double lon) {
    Marker newMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(lat, lon),
      builder: (ctx) => Container(
        child: Icon(
          FontAwesomeIcons.mapMarkerAlt,
          color: kPrimaryColor,
        ),
      ),
    );
    markers.add(newMarker);
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
                final title = listing.documentID;
                final username = listing.data['username'];
                final description = listing.data['description'];
                final address = listing.data['address'];
                // GeoPoint location = listing.data['location'];
                // addMarker(location.latitude, location.longitude);
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: kAppBar(context, 'REQUESTS'),
      body: Stack(
        children: <Widget>[
          FlutterMap(
            options: MapOptions(
              center: LatLng(23.022505, 72.571365),
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://api.tiles.mapbox.com/v4/"
                    "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoiaWFtcHJheXVzaCIsImEiOiJjazNhZmdvYzUwYmx3M2NuMzE5dTY4bWtlIn0.Qr3fZ_oKWfRkWu6IqSH72Q',
                  'id': 'mapbox.streets',
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    point: LatLng(23.050505, 72.571365),
                    builder: (ctx) => Container(
                      child: Icon(
                        FontAwesomeIcons.mapMarkerAlt,
                        color: kSecondaryColor,
                        size: 40.0,
                      ),
                    ),
                  ),
                ],
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
    );
  }
}
