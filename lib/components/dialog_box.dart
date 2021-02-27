import 'package:flutter/material.dart';

import 'package:FoodForGood/components/rounded_button.dart';
import 'package:FoodForGood/constants.dart';

class DialogBox extends StatelessWidget {
  final String title;
  final String text;
  final Function onYes;

  DialogBox({
    this.title,
    this.text,
    this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        color: kBackgroundColor,
        height: 250.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(this.title,
                    style: kTextStyle.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 30.0)),
                Text('!',
                    style: kTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: kPrimaryColor)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                this.text,
                style: kTextStyle,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RoundedButton(
                    title: 'No',
                    colour: kPrimaryColor,
                    width: 120.0,
                    pressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 10.0),
                  RoundedButton(
                    title: 'Yes',
                    colour: kBackgroundColor,
                    splashColour: Colors.black12,
                    width: 120.0,
                    borderColour: kSecondaryColor,
                    textColour: kSecondaryColor,
                    pressed: this.onYes,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
