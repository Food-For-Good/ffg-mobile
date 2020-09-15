import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/screens/home_screen.dart';
import 'package:FoodForGood/services/auth_service.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  AuthService _auth = AuthService();
  bool _showSpinner = false;

  _checkStatusAndRedirect() async {
    // Checking if the user is logged in or not.
    // Redirecting to the home screen if the user is logged in.
    // NOTE: A future is used instead of a stream since we only need to check
    // once and not continuously.
    setState(() {
      this._showSpinner = true;
    });
    String username = await AuthService().getUsername();
    FirebaseUser currentUser = await this._auth.getUser;
    setState(() {
      this._showSpinner = false;
    });
    if (currentUser != null) {
      // Pushing a replacement since we don't want the back button in the
      // home screen leading back to the landing page.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            username: username,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    this._checkStatusAndRedirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: this._showSpinner,
        color: kPrimaryColor,
        child: Stack(
          children: <Widget>[
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background_lighter.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 350.0),
                Center(
                  child: RoundedButton(
                    colour: kPrimaryColor,
                    title: 'LOGIN',
                    pressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New here?',
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 22.0,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Join Us!',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
