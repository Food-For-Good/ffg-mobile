import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:FoodForGood/components/provider.dart';
import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/screens/give_away_screen.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showSpinner = false;
  String username = '';
  String address = '';
  int sharedWith = 0, requestedFrom = 0;
  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        AuthService auth = Provider.of(context).auth;
        String email = await auth.getEmail();
        var document = _firestore.document('users/$email');
        document.get().then((document) {
          setState(() {
            this.username = document.data['username'];
            this.address = document.data['address'];
            this.sharedWith = document.data['sharedWith'];
            this.requestedFrom = document.data['requestedFrom'];
          });
        });
      } catch (e) {
        print('Error: ' + e.toString());
        Future(() => Navigator.pop(context));
        Future(() => Navigator.pushReplacementNamed(context, '/landing'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // this overrides the 'back' button to do nothing
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          title: Text(
            'Home Screen',
            style: kTitleStyle,
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
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
                              this.username,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GiveAwayScreen(
                        username: username,
                      ),
                    ),
                  );
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
                            this.sharedWith.toString(),
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
                            this.requestedFrom.toString(),
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
                    showSpinner = true;
                  });
                  try {
                    AuthService auth = Provider.of(context).auth;
                    auth.signOut();
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/');
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print('Error: ' + e.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
