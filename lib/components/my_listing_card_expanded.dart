import 'package:flutter/material.dart';
import 'package:FoodForGood/constants.dart';

class MyListingCardExpanded extends StatelessWidget {
  final String title;
  final String descrtiption;
  final String address;
  final Function onDelete;
  final Function onEdit;
  final DateTime expiryTime;

  MyListingCardExpanded(
      {this.title,
      this.descrtiption,
      this.address,
      this.onDelete,
      this.onEdit,
      this.expiryTime});

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
                    'Sharing $title',
                    style: kTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
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
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            Column(
              children: <Widget>[
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
                  width: 80,
                  child: Text(
                    kFormatDateTime(this.expiryTime),
                    softWrap: true,
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: this.onEdit,
              icon: Icon(
                Icons.edit,
                color: kPrimaryColor,
                size: 40.0,
              ),
            ),
            IconButton(
              onPressed: this.onDelete,
              icon: Icon(
                Icons.delete,
                color: kSecondaryColor,
                size: 40.0,
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }
}
