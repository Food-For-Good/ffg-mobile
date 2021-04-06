import 'package:flutter/material.dart';

import '../constants.dart';

class MapButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  const MapButton({@required this.icon, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        splashColor: Colors.deepOrange,
        child: Icon(
          this.icon,
          color: kBackgroundColor,
          size: 30.0,
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}
