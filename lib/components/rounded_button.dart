import 'package:FoodForGood/constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Function pressed;
  final Color colour;
  final Color splashColour;
  final double height;
  final double width;
  final Color borderColour;
  final Color textColour;

  RoundedButton({
    @required this.title,
    @required this.pressed,
    this.colour,
    this.splashColour = Colors.deepOrange,
    this.height = 50.0,
    this.width,
    this.borderColour,
    this.textColour = kBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      height: this.height,
      //If width is not provided, then minWidth is 75% of screen size.
      minWidth: this.width ?? MediaQuery.of(context).size.width * 0.75,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: kSecondaryColor,
            width: 2.0,
            style:
                (borderColour == null) ? BorderStyle.none : BorderStyle.solid),
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
                fontWeight: FontWeight.bold, color: this.textColour)),
      ),
    );
  }
}
