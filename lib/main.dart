import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:FoodForGood/components/provider.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/screens/give_away_screen.dart';
import 'package:FoodForGood/screens/home_screen.dart';
import 'package:FoodForGood/screens/landing_screen.dart';
import 'package:FoodForGood/screens/login_screen.dart';
import 'package:FoodForGood/screens/register_screen.dart';
import 'package:FoodForGood/screens/request_screen.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // disables vertical orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Provider(
      auth: AuthService(),
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
          '/': (context) => HomeController(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
          '/landing': (context) => LandingScreen(),
          '/giveAway': (context) => GiveAwayScreen(),
          '/request': (context) => RequestScreen(),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  // will check the auth stream and if user is already logged in
  // returns the HomeScreen else the LandingScreen
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            print(signedIn);
            return signedIn ? HomeScreen() : LandingScreen();
          }
          // loading...
          return ModalProgressHUD(
            inAsyncCall: true,
            child: Container(),
            color: kSecondaryColor,
          );
        });
  }
}
