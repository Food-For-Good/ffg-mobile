import 'package:FoodForGood/constants.dart';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Color splashColour;
  final Color colour;
  final String title;
  final Function pressed;
  final double height;
  final double width;
  final double fontSize;
  final IconData icon;

  CircularButton(
      {this.splashColour = Colors.deepOrange,
      this.colour,
      this.title,
      this.pressed,
      this.height = 150.0,
      this.width = 150.0,
      this.fontSize = 28.0,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: this.colour, // button color
        child: InkWell(
          splashColor: this.splashColour,
          onTap: this.pressed,
          child: Container(
            alignment: Alignment.center,
            height: this.height,
            width: this.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon == null
                  ? Text(
                      title,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: this.fontSize,
                      ),
                    )
                  : Icon(
                      this.icon,
                      color: kBackgroundColor,
                      size: this.fontSize,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
