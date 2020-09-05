import 'package:flutter/material.dart';
import 'package:FoodForGood/constants.dart';

class ListingCard extends StatelessWidget {
  final String username;
  final String title;
  final Function onPressed;

  ListingCard({this.username, this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: kPrimaryColor.withAlpha(150),
        splashColor: kPrimaryColor,
        onTap: onPressed,
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .65,
              margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    username,
                    style: kTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    'Sharing $title',
                    style: kTextStyle,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: kPrimaryColor,
                ),
              ),
              width: 35,
              height: 35,
              child: Text(
                '6.7',
                style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
