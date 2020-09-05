import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:FoodForGood/constants.dart';

class ListingCardExpanded extends StatelessWidget {
  final String username;
  final String title;
  final String descrtiption;
  final String address;
  final Function onCross;

  ListingCardExpanded(
      {this.username,
      this.title,
      this.descrtiption,
      this.address,
      this.onCross});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .56,
              margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
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
                  SizedBox(height: 5.0),
                  Text(
                    'Sharing $title',
                    style: kTextStyle,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    descrtiption,
                    style: kTextStyle.copyWith(
                      fontSize: 14.0,
                      color: kSecondaryColor.withAlpha(950),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    address,
                    style: kTextStyle.copyWith(
                      fontSize: 14.0,
                      color: kSecondaryColor.withAlpha(950),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5.0, right: 5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3,
                      color: kPrimaryColor,
                    ),
                  ),
                  width: 55,
                  height: 55,
                  child: Text(
                    '6.7',
                    style: kTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  width: 60,
                  child: Text(
                    'EXPIRY TIME',
                    style: kTextStyle.copyWith(
                      color: kSecondaryColor.withAlpha(950),
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 55,
                  child: Text(
                    '11.30AM 15.11.19',
                    style: kTextStyle.copyWith(
                        fontSize: 14.5, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.check,
                color: kPrimaryColor,
                size: 40.0,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.phoneAlt,
                color: kSecondaryColor.withAlpha(950),
                size: 35.0,
              ),
            ),
            IconButton(
              onPressed: onCross,
              icon: Icon(
                FontAwesomeIcons.times,
                color: kSecondaryColor,
                size: 40.0,
              ),
            )
          ],
        ),
      ],
    );
  }
}
