import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/components/text_feild.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/screens/home_screen.dart';
import 'package:FoodForGood/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showSpinner = false;
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: this._showSpinner,
        color: kPrimaryColor,
        child: Material(
          child: Container(
            color: kBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Center(
                      child: Stack(
                        children: <Widget>[
                          Text(
                            'Welcome',
                            style: kHeadingStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                  'Back',
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
                                    fontSize: 60.0,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.0),
                    CustomTextFeild(
                      label: 'EMAIL',
                      kbType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.email),
                      changed: (value) {
                        this._email = value.trim();
                      },
                    ),
                    SizedBox(height: 20.0),
                    CustomTextFeild(
                      label: 'PASSWORD',
                      kbType: TextInputType.text,
                      isPass: true,
                      prefixIcon: Icon(Icons.lock),
                      changed: (value) {
                        this._password = value.trim();
                      },
                    ),
                    SizedBox(height: 50.0),
                    RoundedButton(
                      title: 'LOGIN',
                      colour: kPrimaryColor,
                      pressed: () async {
                        setState(() {
                          this._showSpinner = true;
                        });
                        try {
                          if (this._email == null) {
                            throw 'ERROR_EMAIL_FIELD_EMPTY';
                          } else if (this._password == null) {
                            throw 'ERROR_PASSWORD_FIELD_EMPTY';
                          }
                          AuthService auth = AuthService();
                          await auth.signInWithEmailAndPassword(
                              this._email, this._password);
                          String username = await auth.getUsername();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(username: username),
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
                          'New here?',
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(width: 5.0),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                          child: Text(
                            'Join us!',
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
    );
  }
}
