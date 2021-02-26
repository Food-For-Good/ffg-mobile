import 'package:flutter/material.dart';
import 'package:FoodForGood/constants.dart';
import 'listing_card_expanded.dart';

class MyListingCard extends StatelessWidget {
  
  final Text title;
  final Text subtitle;
  final Widget myExpandedListingCard;

  MyListingCard({this.title, this.subtitle, this.myExpandedListingCard});

  Widget build(BuildContext context) {
    return ExpansionTile(
      title: this.title,
      subtitle: this.subtitle,
      backgroundColor: kBackgroundColor,
      children: [
        this.myExpandedListingCard,
      ],
    );
  }
}