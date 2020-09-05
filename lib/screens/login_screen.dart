import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:FoodForGood/components/provider.dart';
import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/components/text_feild.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
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
                        this._email = value;
                        print(value);
                      },
                    ),
                    SizedBox(height: 20.0),
                    CustomTextFeild(
                      label: 'PASSWORD',
                      kbType: TextInputType.text,
                      isPass: true,
                      prefixIcon: Icon(Icons.lock),
                      changed: (value) {
                        this._password = value;
                        print(value);
                      },
                    ),
                    SizedBox(height: 50.0),
                    RoundedButton(
                      title: 'LOGIN',
                      colour: kPrimaryColor,
                      pressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          AuthService auth = Provider.of(context).auth;
                          await auth.signInWithEmailAndPassword(
                              _email, _password);
                          Navigator.pushReplacementNamed(context, '/');
                        } catch (e) {
                          kShowFlushBar(
                              content: e.toString(), context: context);
                          print('ERROR: ' + e.toString());
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
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
