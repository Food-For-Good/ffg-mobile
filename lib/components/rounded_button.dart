import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Color splashColour;
  final Color colour;
  final String title;
  final Function pressed;

  CircularButton(
      {this.colour,
      this.title,
      this.pressed,
      this.splashColour = Colors.deepOrange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 45.0, right: 45.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: colour,
                splashColor: splashColour,
                onPressed: pressed,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
