import 'package:flutter/material.dart';
import 'package:FoodForGood/constants.dart';

class MyListingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget myExpandedListingCard;

  MyListingCard({this.title, this.subtitle, this.myExpandedListingCard});

  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(this.title, style: kTextStyle.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(this.subtitle, style: kTextStyle.copyWith(fontSize: 13.0)),
      backgroundColor: kBackgroundColor,
      children: [
        this.myExpandedListingCard,
      ],
    );
  }
}
