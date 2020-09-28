import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/components/text_feild.dart';
import 'package:FoodForGood/services/auth_service.dart';

class GiveAwayScreen extends StatefulWidget {
  @override
  _GiveAwayScreenState createState() => _GiveAwayScreenState();
}

class _GiveAwayScreenState extends State<GiveAwayScreen> {
  @override
  void initState() {
    super.initState();
    this.setUsername();
  }

  setUsername() async {
    this.username = await AuthService().getUsername();
  }

  String username = '',
      title = '',
      description = '',
      phoneNo = '',
      address = 'NONE',
      pictureName = 'NONE';

  Widget currentAddressWidget = Text(
    'NONE',
    style: kTextStyle.copyWith(
      fontSize: 12.0,
      color: kSecondaryColor.withAlpha(150),
    ),
  );
  Position currentPosition;
  int expiryTime = 10;

  Firestore _firestore = Firestore.instance;

  Future<bool> createListing() async {
    bool created = false;
    try {
      await _firestore.collection('Listings').document(title).setData({
        'username': this.username,
        'description': description,
        'expiryTimeInHrs': expiryTime,
        'location':
            GeoPoint(currentPosition.latitude, currentPosition.longitude),
        'phoneNo': phoneNo,
        'pictureName': pictureName,
        'address': address,
      });
      created = true;
    } catch (error) {
      print('ERROR: ' + error.toString());
    }
    return created;
  }

  Future<String> getCurrentLocation() async {
    String defaultReturn = 'DEFAULT';
    try {
      currentPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      double lat, long;
      lat = currentPosition.latitude;
      long = currentPosition.longitude;
      var addresses = await Geocoder.local
          .findAddressesFromCoordinates(Coordinates(lat, long));
      return addresses.first.addressLine;
    } catch (error) {
      print('ERROR: ' + error.toString());
    }
    return defaultReturn;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: kAppBar(
          context: context,
          title: Text('GIVE AWAY', style: kTitleStyle),
          icon: Icon(Icons.arrow_back_ios),
          pressed: () {
            Navigator.pop(context);
          },
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
          children: <Widget>[
            CustomTextFeild(
              label: 'TITLE',
              prefixIcon: Icon(
                Icons.title,
                color: kSecondaryColor,
              ),
              changed: (value) {
                title = value;
              },
              textCap: TextCapitalization.words,
            ),
            SizedBox(height: 15.0),
            CustomTextFeild(
              label: 'DESCRIPTION',
              kbType: TextInputType.multiline,
              lines: 2,
              prefixIcon: Icon(
                Icons.description,
                color: kSecondaryColor,
              ),
              changed: (value) {
                description = value;
              },
              textCap: TextCapitalization.sentences,
            ),
            SizedBox(height: 15.0),
            CustomTextFeild(
              label: 'PHONE NO.',
              prefixIcon: Icon(
                Icons.phone,
                color: kSecondaryColor,
              ),
              changed: (value) {
                phoneNo = value;
              },
              kbType: TextInputType.number,
            ),
            SizedBox(height: 25.0),
            Row(
              children: <Widget>[
                IconButton(
                  color: kPrimaryColor,
                  splashColor: kPrimaryColor.withAlpha(150),
                  icon: Icon(
                    FontAwesomeIcons.mapPin,
                  ),
                  onPressed: () async {
                    setState(() {
                      currentAddressWidget = spinner(context);
                    });
                    String addr = await getCurrentLocation();
                    setState(() {
                      address = addr;
                      currentAddressWidget = addressWidget(
                        context: context,
                        address: address,
                      );
                    });
                  },
                ),
                SizedBox(width: 7.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'ADD LOCATION',
                      style: kTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kSecondaryColor,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    currentAddressWidget,
                  ],
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'EXPIRY TIME (HRS): ',
                  style: kHeadingStyle.copyWith(
                    fontSize: 15.0,
                    color: kSecondaryColor,
                  ),
                ),
                SizedBox(width: 5.0),
                Text(
                  this.expiryTime.toString(),
                  style: kHeadingStyle.copyWith(
                    fontSize: 25.0,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: kPrimaryColor,
                overlayColor: kPrimaryColor.withAlpha(50),
                activeTrackColor: kSecondaryColor,
                inactiveTrackColor: kSecondaryColor.withAlpha(50),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: 30,
                ),
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 15,
                ),
              ),
              child: Slider(
                value: expiryTime.toDouble(),
                min: 1.0,
                max: 24.0,
                onChanged: (double newExpiryTime) {
                  setState(() {
                    expiryTime = newExpiryTime.toInt();
                  });
                },
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  color: kPrimaryColor,
                  splashColor: kPrimaryColor.withAlpha(150),
                  icon: Icon(
                    FontAwesomeIcons.cameraRetro,
                  ),
                  onPressed: () {},
                ),
                SizedBox(width: 7.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'ADD A PICTURE',
                      style: kTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kSecondaryColor,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      width: MediaQuery.of(context).size.width * .55,
                      child: Text(
                        pictureName,
                        style: kTextStyle.copyWith(
                          fontSize: 12.0,
                          color: kSecondaryColor.withAlpha(150),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            RoundedButton(
              title: 'SHARE',
              colour: kPrimaryColor,
              pressed: () async {
                // Create new request in firebase.
                String errorMessage = 'NONE';
                if (title.length == 0) {
                  errorMessage = 'Title field is blank.';
                } else if (description.length == 0) {
                  errorMessage = 'Description field is blank.';
                } else if (phoneNo.length != 10) {
                  errorMessage = 'Invalid phone number.';
                } else if (address == 'NONE') {
                  errorMessage = 'Address not detected.';
                }
                if (errorMessage == 'NONE') {
                  bool created = await createListing();
                  errorMessage = created
                      ? 'Listing created!'
                      : 'Listing not created due to some error.';
                }
                kShowFlushBar(
                  content: errorMessage,
                  context: context,
                  customError: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget spinner(BuildContext context) {
  return Container(
    alignment: Alignment.centerRight,
    height: 35.0,
    width: MediaQuery.of(context).size.width * .4,
    child: SpinKitDoubleBounce(
      size: 20.0,
      color: kPrimaryColor,
    ),
  );
}

Widget addressWidget({BuildContext context, String address = 'NONE'}) {
  return Container(
    width: MediaQuery.of(context).size.width * .55,
    child: Text(
      address,
      style: kTextStyle.copyWith(
        fontSize: 12.0,
        color: kSecondaryColor.withAlpha(150),
      ),
    ),
  );
}
