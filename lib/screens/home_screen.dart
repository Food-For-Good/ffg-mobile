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
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          color: kPrimaryColor,
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25),
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
              SizedBox(height: 30.0),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                  RoundedButton(
                    colour: kPrimaryColor,
                    title: 'REQUEST',
                    height: 150.0,
                    pressed: () {
                      Navigator.pushNamed(context, '/request');
                    },
                  ),
                ]),
              ),
              Container(
                height: 50,
                child: Text('20 donations made till now :)',
                  style: kTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
