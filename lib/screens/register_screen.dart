import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/components/text_feild.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/screens/home_screen.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:FoodForGood/services/helper_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool _showSpinner = false;
  String _name, _email, _password, _confirmPassword, _address;
  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: ModalProgressHUD(
          color: kPrimaryColor,
          inAsyncCall: this._showSpinner,
          child: Material(
            child: Container(
              color: kBackgroundColor,
              child: Center(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll
                        .disallowGlow(); // This will stop overscroll glow effect.
                    return;
                  },
                  child: ListView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                    shrinkWrap: true,
                    children: <Widget>[
                      Center(
                        child: Stack(
                          children: <Widget>[
                            Text(
                              'Start',
                              style: kHeadingStyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: <Widget>[
                                  Text(
                                    'Sharing',
                                    style: kHeadingStyle,
                                  ),
                                  SizedBox(width: 5.0),
                                  Text('!',
                                      style: kHeadingStyle.copyWith(
                                          color: kPrimaryColor)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      CustomTextFeild(
                        label: 'NAME',
                        prefixIcon: Icon(Icons.person),
                        textCap: TextCapitalization.words,
                        changed: (value) {
                          this._name = value.trim();
                        },
                      ),
                      SizedBox(height: 10.0),
                      CustomTextFeild(
                        label: 'EMAIL',
                        prefixIcon: Icon(Icons.email),
                        kbType: TextInputType.emailAddress,
                        changed: (value) {
                          this._email = value.trim();
                        },
                      ),
                      SizedBox(height: 10.0),
                      CustomTextFeild(
                        label: 'ADDRESS',
                        prefixIcon: Icon(Icons.location_on),
                        textCap: TextCapitalization.sentences,
                        changed: (value) {
                          this._address = value.trim();
                        },
                      ),
                      SizedBox(height: 10.0),
                      CustomTextFeild(
                        label: 'PASSWORD',
                        prefixIcon: Icon(Icons.lock),
                        isPass: true,
                        changed: (value) {
                          this._password = value.trim();
                        },
                      ),
                      SizedBox(height: 10.0),
                      CustomTextFeild(
                        label: 'CONFIRM PASSWORD',
                        prefixIcon: Icon(Icons.lock),
                        isPass: true,
                        changed: (value) {
                          this._confirmPassword = value.trim();
                        },
                      ),
                      SizedBox(height: 40.0),
                      RoundedButton(
                        title: 'SIGNUP',
                        colour: kPrimaryColor,
                        pressed: () async {
                          setState(() {
                            this._showSpinner = true;
                          });
                          try {
                            HelperService.validateData(
                                this._name,
                                this._email,
                                this._address,
                                this._password,
                                this._confirmPassword);

                            // Creating new user.
                            await AuthService().createUserWithEmailAndPassword(
                                this._email, this._password, this._name);

                            // Saving user info to firestore.
                            await this
                                ._firestore
                                .collection('users')
                                .document(this._email)
                                .setData({
                              'username': this._name,
                              'address': this._address,
                              'sharedWith': 0,
                              'requestedFrom': 0
                            });

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen(username: this._name),
                              ),
                            );
                          } catch (error) {
                            kShowFlushBar(
                                content: error.toString(), context: context);
                          }
                          setState(() {
                            this._showSpinner = false;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Already a member?',
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Text(
                              'Log In!',
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
