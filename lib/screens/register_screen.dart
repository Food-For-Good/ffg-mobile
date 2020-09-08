import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:FoodForGood/components/provider.dart';
import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/components/text_feild.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool showSpinner = false;
  String _name, _email, _password, _address;
  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        color: kPrimaryColor,
        inAsyncCall: showSpinner,
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
                    SizedBox(height: 20.0),
                    CustomTextFeild(
                      label: 'NAME',
                      prefixIcon: Icon(Icons.person),
                      textCap: TextCapitalization.words,
                      changed: (value) {
                        this._name = value;
                        print(value);
                      },
                    ),
                    SizedBox(height: 10.0),
                    CustomTextFeild(
                      label: 'EMAIL',
                      prefixIcon: Icon(Icons.email),
                      kbType: TextInputType.emailAddress,
                      changed: (value) {
                        this._email = value;
                        print(value);
                      },
                    ),
                    SizedBox(height: 10.0),
                    CustomTextFeild(
                      label: 'ADDRESS',
                      prefixIcon: Icon(Icons.location_on),
                      textCap: TextCapitalization.sentences,
                      changed: (value) {
                        this._address = value;
                        print(value);
                      },
                    ),
                    SizedBox(height: 10.0),
                    CustomTextFeild(
                      label: 'PASSWORD',
                      prefixIcon: Icon(Icons.lock),
                      isPass: true,
                      changed: (value) {
                        this._password = value;
                        print(value);
                      },
                    ),
                    SizedBox(height: 50.0),
                    CircularButton(
                      title: 'SIGNUP',
                      colour: kPrimaryColor,
                      pressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          // checking empty fields
                          if (_name == null) {
                            throw 'ERROR_NAME_FIELD_EMPTY';
                          } else if (_address == null) {
                            throw 'ERROR_ADDRESS_FIELD_EMPTY';
                          }

                          // creating the user
                          AuthService auth = Provider.of(context).auth;
                          await auth.createUserWithEmailAndPassword(
                              _email, _password, _name);

                          // saving info to firestore
                          await _firestore
                              .collection('users')
                              .document(_email)
                              .setData({
                            'username': _name,
                            'address': _address,
                            'sharedWith': 0,
                            'requestedFrom': 0
                          });

                          Navigator.pop(context);
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
