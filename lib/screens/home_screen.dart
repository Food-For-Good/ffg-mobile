import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  // Fetching the name after loading this page was causing a delay before the
  // name appeared which is why we fetch it first, then pass it in this widget
  // when we call it.
  final String username;

  HomeScreen({this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text(
          'Home Screen',
          style: kTitleStyle,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: this._showSpinner,
        color: kPrimaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Text(
                      'Hello,',
                      style: kHeadingStyle.copyWith(fontSize: 40.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            // Getting the first name.
                            // (The username could have the last name as well).
                            widget.username.split(' ')[0],
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
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0),
            RoundedButton(
              colour: kPrimaryColor,
              title: 'GIVE AWAY',
              pressed: () {
                Navigator.pushNamed(context, '/giveAway');
              },
            ),
            SizedBox(height: 15.0),
            RoundedButton(
              colour: kPrimaryColor,
              title: 'REQUEST',
              pressed: () {
                Navigator.pushNamed(context, '/request');
              },
            ),
            SizedBox(height: 40.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Shared With ',
                    style: kHeadingStyle.copyWith(
                      fontSize: 25.0,
                      color: kSecondaryColor.withAlpha(150),
                    ),
                  ),
                  Container(
                    width: 60.0,
                    height: 60.0,
                    child: Container(
                      child: Center(
                        child: Text(
                          '0',
                          style: kHeadingStyle.copyWith(
                              fontSize: 40.0, color: kSecondaryColor),
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kSecondaryColor.withAlpha(150),
                          width: 5.0,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Requested From ',
                    style: kHeadingStyle.copyWith(
                      fontSize: 25.0,
                      color: kSecondaryColor.withAlpha(150),
                    ),
                  ),
                  Container(
                    width: 60.0,
                    height: 60.0,
                    child: Container(
                      child: Center(
                        child: Text(
                          '0',
                          style: kHeadingStyle.copyWith(
                              fontSize: 40.0, color: kSecondaryColor),
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kSecondaryColor.withAlpha(150),
                          width: 5.0,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0),
            RoundedButton(
              title: 'LOGOUT',
              colour: kSecondaryColor,
              splashColour: kBackgroundColor.withAlpha(150),
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
            ),
          ],
        ),
      ),
    );
  }
}
