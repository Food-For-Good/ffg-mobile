import 'package:FoodForGood/constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Function pressed;
  final Color colour;
  final Color splashColour;
  final double height;
  final double width;

  RoundedButton(
      {@required this.title,
      @required this.pressed,
      this.colour,
      this.splashColour = Colors.deepOrange,
      this.height = 50.0,
      this.width = 150.0});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      height: this.height,
      minWidth: this.width,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: this.colour,
      splashColor: this.splashColour,
      onPressed: this.pressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: Text(this.title,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: kTextStyle.copyWith(
                fontWeight: FontWeight.bold, color: kBackgroundColor)),
      ),
    );
  }
}
