import 'package:flutter/material.dart';
import 'package:FoodForGood/services/auth_service.dart';

class Provider extends InheritedWidget {
  // Basically when the onAuthStateChanged is true which means the auth service changed, provider will
  // change all the widgets below it.
  final AuthService auth;
  Provider({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Provider) as Provider);
}
