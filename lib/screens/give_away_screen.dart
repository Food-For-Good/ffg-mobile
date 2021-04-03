import 'package:FoodForGood/models/listing_model.dart';
import 'package:FoodForGood/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/components/circular_button.dart';
import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/components/text_feild.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:FoodForGood/services/helper_service.dart';

class GiveAwayScreen extends StatefulWidget {
  final bool editList;
  final Listing editListing;

  GiveAwayScreen({
    this.editList = false,
    this.editListing,
  });

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
  DateTime finalExpiryTime;
  bool expiryTimeSelected = false;
  bool setExpiryTime = false;

  final database = FirestoreDatabase();

  Future<bool> _createListing() async {
    bool created = false;
    try {
      await database.createListing(Listing(
        username: this.username,
        title: this.title,
        description: this.description,
        expiryTime: this.finalExpiryTime,
        phoneNo: this.phoneNo,
        pictureName: this.pictureName,
        address: this.address,
        email: this.email,
        location: GeoPoint(currentPosition.latitude, currentPosition.longitude),
        listingState: listingStateOpen,
        requests: {},
        acceptedRequest: {},
      ));
      created = true;
    } catch (error) {
      print('ERROR: ' + error.toString());
    }
    return created;
  }

  Future<bool> _editListing(Listing editListing) async {
    bool created = false;
    try {
      Listing editedListing = Listing(
        username: this.username,
        title: this.title,
        description: this.description,
        expiryTime: this.finalExpiryTime,
        phoneNo: this.phoneNo,
        pictureName: this.pictureName,
        address: this.address,
        email: this.email,
        listId: editListing.listId,
        location: GeoPoint(currentPosition.latitude, currentPosition.longitude),
        listingState: finalExpiryTime.isBefore(currentTime)
            ? listingStateDeleted
            : listingStateOpen,
        requests: editListing.requests,
        acceptedRequest: editListing.acceptedRequest,
      );
      await database.editListing(editedListing);
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
    this.title = widget.editListing.title;
    this.description = widget.editListing.description;
    this.expiryTime =
        widget.editList ? widget.editListing.expiryTime : currentTime;
    if (widget.editList) {
      this.finalExpiryTime = widget.editListing.expiryTime;
      expiryTimeSelected = true;
    }
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
                  children: <Widget>[
                    IconButton(
                      color: kPrimaryColor,
                      splashColor: kPrimaryColor.withAlpha(150),
                      icon: Icon(Icons.schedule_rounded),
                      onPressed: () {
                        setState(() {
                          setExpiryTime = true;
                          //Remove focus from other nodes, close open keyboard if any.
                          FocusManager.instance.primaryFocus.unfocus();
                        });
                      },
                    ),
                    SizedBox(width: 7.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'EXPIRY TIME',
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
                            expiryTimeSelected
                                ? HelperService.convertDateTimeToHumanReadable(
                                    finalExpiryTime)
                                : (widget.editList
                                    ? HelperService
                                        .convertDateTimeToHumanReadable(
                                            finalExpiryTime)
                                    : 'NONE'),
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
                SizedBox(height: 15.0),
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
                              initialDateTime:
                                  this.expiryTime.isBefore(currentTime)
                                      ? currentTime
                                      : this.expiryTime,
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
                        Column(
                          children: [
                            CircularButton(
                              icon: Icons.check_rounded,
                              fontSize: 25.0,
                              colour: kPrimaryColor,
                              height: 40.0,
                              width: 40.0,
                              pressed: () {
                                setState(() {
                                  expiryTimeSelected = true;
                                  finalExpiryTime = expiryTime;
                                  setExpiryTime = false;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            CircularButton(
                              icon: Icons.clear_rounded,
                              fontSize: 25.0,
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
                      ],
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
                SizedBox(height: 50.0),
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
                    } else if (expiryTimeSelected == false) {
                      errorMessage = 'Expiry time not selected.';
                    }
                    if (errorMessage == 'NONE') {
                      if (widget.editList) {
                        bool created = await _editListing(widget.editListing);
                        errorMessage = created
                            ? 'Listing saved!'
                            : 'Listing not saved due to some error.';
                        Navigator.pop(context);
                      } else {
                        bool created = await _createListing();
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
                SizedBox(height: 20.0)
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
