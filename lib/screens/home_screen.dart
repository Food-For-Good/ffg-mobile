import 'package:FoodForGood/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:FoodForGood/components/circular_button.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:FoodForGood/services/helper_service.dart';

class HomeScreen extends StatefulWidget {
  // Fetching the name after loading this page was causing a delay before the
  // name appeared which is why we fetch it first, then pass it in this widget
  // when we call it.
  final String username;

  HomeScreen({this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _showSpinner = false;

  AnimationController controller;

  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
      upperBound: 200, // Number of Donations made.
    );
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: kAppBar(
          context: context,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('FoodFor', style: kTitleStyle),
              Text(
                'Good',
                style: kTitleStyle.copyWith(color: kPrimaryColor),
              )
            ],
          ),
          icon: Icon(Icons.menu_rounded),
          pressed: () {
            _scaffoldKey.currentState
                .openDrawer(); // Open drawer with the icon.
          },
        ),
        drawer: Drawer(
          child: Container(
            color: kBackgroundColor,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                  ),
                  child: Container(
                    child: Image.asset('assets/logo/logo_symbol.png'),
                  ),
                ),
                ListTile(
                  title: Text(
                    'About US',
                    style: kTextStyle.copyWith(fontSize: 20.0),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Sign Out',
                    style: kTextStyle.copyWith(fontSize: 20.0),
                  ),
                  onTap: () {
                    showDialog(
                      // Alert dialog for Sign-Out.
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Container(
                            color: kBackgroundColor,
                            height: 250.0,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Sign Out',
                                        style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30.0)),
                                    Text('!',
                                        style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30.0,
                                            color: kPrimaryColor)),
                                  ],
                                ),
                                Text(
                                  'Are you sure you want to leave?',
                                  style: kTextStyle,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      RoundedButton(
                                        title: 'No',
                                        colour: kPrimaryColor,
                                        width: 120.0,
                                        pressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      SizedBox(width: 10.0),
                                      RoundedButton(
                                        title: 'Yes',
                                        colour: kSecondaryColor,
                                        splashColour: Colors.white10,
                                        width: 120.0,
                                        pressed: () async {
                                          setState(() {
                                            this._showSpinner = true;
                                          });
                                          AuthService().signOut();
                                          Navigator.pushNamedAndRemoveUntil(
                                              context, '/', (route) => false);
                                          setState(() {
                                            this._showSpinner = false;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: this._showSpinner,
          color: kPrimaryColor,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 50.0),
                child: Container(
                  width: 500.0,
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Text(
                        'Hello,',
                        style: kHeadingStyle.copyWith(fontSize: 40.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 60.0,
                          child: FittedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                  HelperService.getFirstName(widget.username),
                                  style: TextStyle(
                                    fontSize: 60.0,
                                    fontWeight: FontWeight.bold,
                                    color: kSecondaryColor,
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  '!',
                                  style: TextStyle(
                                    fontSize: 65.0,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 100.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'What would you like to do today?',
                          textAlign: TextAlign.center,
                          style: kTextStyle.copyWith(fontSize: 25.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularButton(
                            colour: kPrimaryColor,
                            title: 'GIVE AWAY',
                            pressed: () {
                              Navigator.pushNamed(context, '/giveAway');
                            },
                          ),
                          CircularButton(
                            colour: kPrimaryColor,
                            title: 'REQUEST',
                            pressed: () {
                              Navigator.pushNamed(context, '/request');
                            },
                          ),
                        ]),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${controller.value.toInt()} ',
                          style: kTextStyle.copyWith(
                              color: kPrimaryColor,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'donations made till now :)',
                          style: kTextStyle.copyWith(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
