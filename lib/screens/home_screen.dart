import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:FoodForGood/components/provider.dart';
import 'package:FoodForGood/components/circular_button.dart';
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
          title: Title(color:Colors.white, child: Text('FFG')),
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
                child: Container(
                  width: 500,
                  // color: Colors.teal,
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
                          // color: Colors.redAccent,
                          child: FittedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                  // this.username,
                                  'Abcdefghijk',
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
                  style: kTextStyle.copyWith(
                    fontSize: 22
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
