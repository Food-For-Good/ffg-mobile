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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: ModalProgressHUD(
          inAsyncCall: this._showSpinner,
          color: kPrimaryColor,
          child: Material(
            child: Container(
              alignment: Alignment.center,
              color: kBackgroundColor,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll
                      .disallowGlow(); // This will stop overscroll glow effect.
                  return;
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
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
                                  style: kHeadingStyle,
                                ),
                                SizedBox(width: 5.0),
                                Text('!',
                                    style: kHeadingStyle.copyWith(
                                        color: kPrimaryColor))
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
                    SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return AnimatedPadding(
                                padding: MediaQuery.of(context).viewInsets,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.decelerate,
                                child: ForgotPasswordModal(showSuccess: () {
                                  kShowFlushBar(
                                    content:
                                        'Please check your email for further instructions.',
                                    context: context,
                                    customError: true,
                                  );
                                }),
                              );
                            },
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    RoundedButton(
                      title: 'LOGIN',
                      colour: kPrimaryColor,
                      pressed: () async {
                        //Remove focus from other nodes, close open keyboard if any.
                        FocusManager.instance.primaryFocus.unfocus();
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
                          String currentUserUid =
                              await auth.signInWithEmailAndPassword(
                                  this._email, this._password);
                          String username = await auth.getUsername();
                          if (currentUserUid != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen(username: username),
                              ),
                            );
                          } else {
                            kShowFlushBar(
                                content: 'Please verify your email.',
                                context: context,
                                customError: true);
                          }
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
                    SizedBox(height: 10.0)
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

class ForgotPasswordModal extends StatefulWidget {
  final Function showSuccess;

  const ForgotPasswordModal({@required this.showSuccess});

  @override
  _ForgotPasswordModalState createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  bool _showSpinner = false;
  String _email;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      height: 300.0,
      child: ModalProgressHUD(
        inAsyncCall: this._showSpinner,
        color: kPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Forgot Password',
                    style: kHeadingStyle.copyWith(
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    '?',
                    style: kHeadingStyle.copyWith(
                      fontSize: 30.0,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              CustomTextFeild(
                label: 'EMAIL',
                changed: (value) {
                  this._email = value.trim();
                },
              ),
              RoundedButton(
                title: 'RESET PASSWORD',
                colour: kPrimaryColor,
                pressed: () async {
                  //Remove focus from other nodes, close open keyboard if any.
                  FocusManager.instance.primaryFocus.unfocus();
                  setState(() {
                    this._showSpinner = true;
                  });

                  if (this._email == null || this._email.length == 0) {
                    kShowFlushBar(
                        content: 'ERROR_EMAIL_FIELD_EMPTY', context: context);
                  } else {
                    try {
                      await AuthService().resetPassword(this._email);
                      Navigator.pop(context);
                      widget.showSuccess();
                    } catch (error) {
                      kShowFlushBar(
                          content: error.toString(), context: context);
                    }
                  }

                  setState(() {
                    this._showSpinner = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
