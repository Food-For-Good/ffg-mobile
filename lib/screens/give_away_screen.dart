import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';

import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/components/circular_button.dart';
import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/components/text_feild.dart';
import 'package:FoodForGood/services/auth_service.dart';

class GiveAwayScreen extends StatefulWidget {
  final bool editList;
  final String editTitle, editDescription, listId;

  GiveAwayScreen(
      {this.editList = false,
      this.editTitle,
      this.editDescription,
      this.listId});

  @override
  _GiveAwayScreenState createState() => _GiveAwayScreenState();
}

class _GiveAwayScreenState extends State<GiveAwayScreen> {
  setUsername() async {
    this.username = await AuthService().getUsername();
  }

  getUserEmail() async {
    this.email = await AuthService().getEmail();
  }

  String username = '',
      title = '',
      description = '',
      phoneNo = '1234567890',
      address = 'NONE',
      pictureName = 'NONE',
      email = '';

  Widget currentAddressWidget = Text(
    'NONE',
    style: kTextStyle.copyWith(
      fontSize: 12.0,
      color: kSecondaryColor.withAlpha(150),
    ),
  );
  Position currentPosition;
  DateTime currentTime = DateTime.now();
  DateTime expiryTime;
  bool first = true;
  bool setExpiryTime = false;

  Firestore _firestore = Firestore.instance;

  Future<bool> createListing() async {
    bool created = false;
    try {
      final docRef = await _firestore.collection('Listings').add({
        'username': this.username,
        'title': this.title,
        'description': this.description,
        'expiryTimeInHrs': this.expiryTime,
        'location':
            GeoPoint(currentPosition.latitude, currentPosition.longitude),
        'phoneNo': this.phoneNo,
        'pictureName': this.pictureName,
        'address': this.address,
        'email': this.email,
      });
      await _firestore
          .collection('Listings')
          .document(docRef.documentID)
          .updateData({
        'docId': docRef.documentID, // Adding auto-generated document Id.
      });
      created = true;
    } catch (error) {
      print('ERROR: ' + error.toString());
    }
    return created;
  }

  Future<bool> editListing(String listId) async {
    bool created = false;
    try {
      await _firestore.collection('Listings').document(listId).updateData(
        {
          'title': this.title,
          'description': this.description,
        },
      );
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
  void initState() {
    super.initState();
    this.setUsername();
    this.getUserEmail();
    this.title = widget.editTitle;
    this.description = widget.editDescription;
    this.expiryTime = currentTime;
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
        body: Container(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              // This will stop overscroll glow effect.
              overscroll.disallowGlow();
              return;
            },
            child: ListView(
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
                    this.title = value;
                  },
                  textCap: TextCapitalization.words,
                  editingController: TextEditingController(text: this.title),
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
                    this.description = value;
                  },
                  textCap: TextCapitalization.sentences,
                  editingController:
                      TextEditingController(text: this.description),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'EXPIRY TIME: ',
                      style: kHeadingStyle.copyWith(
                        fontSize: 15.0,
                        color: kSecondaryColor,
                      ),
                    ),
                    SizedBox(width: 15.0),
                    IconButton(
                      icon: Icon(
                        Icons.schedule_rounded,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        first = false;
                        setState(() {
                          setExpiryTime = true;
                        });
                      },
                      iconSize: 30.0,
                    )
                  ],
                ),
                SizedBox(height: 15.0),
                if (!first)
                  Text(
                    kFormatDateTime(this.expiryTime),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                if (setExpiryTime)
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 200.0,
                          width: 250.0,
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                                textTheme: CupertinoTextThemeData(
                                    dateTimePickerTextStyle: kTextStyle)),
                            child: CupertinoDatePicker(
                              initialDateTime: this.expiryTime,
                              minimumDate:
                                  currentTime.subtract(Duration(seconds: 30)),
                              maximumYear: currentTime.year + 1,
                              onDateTimeChanged: (dateTime) {
                                setState(() {
                                  this.expiryTime = dateTime;
                                });
                              },
                            ),
                          ),
                        ),
                        CircularButton(
                          title: 'Done',
                          fontSize: 10.0,
                          colour: kPrimaryColor,
                          height: 40.0,
                          width: 40.0,
                          pressed: () {
                            setState(() {
                              setExpiryTime = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                if (!first) SizedBox(height: 15.0),
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
                  title: widget.editList ? 'SAVE' : 'SHARE',
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
                      if (widget.editList) {
                        bool created = await editListing(widget.listId);
                        errorMessage = created
                            ? 'Listing saved!'
                            : 'Listing not saved due to some error.';
                        Navigator.pop(context);
                      } else {
                        bool created = await createListing();
                        errorMessage = created
                            ? 'Listing created!'
                            : 'Listing not created due to some error.';
                        Navigator.pushReplacementNamed(context, '/request');
                      }
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
