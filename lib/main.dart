import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/screens/give_away_screen.dart';
import 'package:FoodForGood/screens/home_screen.dart';
import 'package:FoodForGood/screens/landing_screen.dart';
import 'package:FoodForGood/screens/login_screen.dart';
import 'package:FoodForGood/screens/my_list_screen.dart';
import 'package:FoodForGood/screens/register_screen.dart';
import 'package:FoodForGood/screens/request_screen.dart';
import 'package:FoodForGood/services/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Disables vertical orientation.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: GestureDetector(
        onTap: () {
          //Dispose keyboard when clicked on
          //non-responsive portion of screen any where in the application.
          FocusManager.instance.primaryFocus.unfocus();
        },
        child: MaterialApp(
          title: 'Food For Good',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            accentColor: kSecondaryColor,
            scaffoldBackgroundColor: kBackgroundColor,
            fontFamily: 'Proxima Nova',
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => LandingScreen(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/home': (context) => HomeScreen(),
            '/giveAway': (context) => GiveAwayScreen(),
            '/request': (context) => RequestScreen(),
            '/myList': (context) => MyList(),
          },
        ),
      ),
    );
  }
}
