import 'package:FoodForGood/constants.dart';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Color splashColour;
  final Color colour;
  final String title;
  final Function pressed;
  final height;
  final width;

  CircularButton({
    this.colour,
    this.title,
    this.pressed,
    this.splashColour = Colors.deepOrange,
    this.height = 150.0,
    this.width = 150.0
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: kPrimaryColor, // button color
        child: InkWell(
          splashColor: splashColour,
          onTap: pressed,
          child: Container(
            alignment: Alignment.center,
            height: height,
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
