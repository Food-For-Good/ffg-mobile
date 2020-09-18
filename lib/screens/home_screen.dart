import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:FoodForGood/components/circular_button.dart';
import 'package:FoodForGood/constants.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Title(
          color: Colors.white,
          child: Text('FFG'),
        ),
        leading: Container(),
      ),
      body: ModalProgressHUD(
        inAsyncCall: this._showSpinner,
        color: kPrimaryColor,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25),
              child: Container(
                width: 500,
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Text(
                      'Hello,',
                      style: kHeadingStyle.copyWith(fontSize: 40.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 60,
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
            SizedBox(height: 30.0),
            Expanded(
              child: Row(
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
            ),
            Container(
              height: 60,
              child: Text(
                '20 donations made till now :)',
                style: kTextStyle.copyWith(fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
