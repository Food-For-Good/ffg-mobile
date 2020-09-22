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
      upperBound: 200, //Number of Donations made
    );
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kSecondaryColor,
          centerTitle: true,
          leading: Container(),
          actions: [
            IconButton(
              icon: Icon(
                Icons.close,
                color: kBackgroundColor,
              ),
              onPressed: () async {
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
          title: Text(
            'FFG',
            style: kTextStyle.copyWith(color: kBackgroundColor, fontSize: 20),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: this._showSpinner,
          color: kPrimaryColor,
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50),
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'What would you like to do today?',
                          textAlign: TextAlign.center,
                          style: kTextStyle.copyWith(fontSize: 25.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${controller.value.toInt()} ',
                          style: kTextStyle.copyWith(
                              color: kPrimaryColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'donations made till now :)',
                          style: kTextStyle.copyWith(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20)
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
