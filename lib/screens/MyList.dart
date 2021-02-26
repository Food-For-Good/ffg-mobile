import 'package:FoodForGood/constants.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:FoodForGood/components/listing_card_expanded.dart';
import 'package:FoodForGood/components/my_listing_card.dart';

class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  final Firestore _firestore = Firestore.instance;
  final AuthService _auth = AuthService();
  String userEmail = '';

  getUserEmail() async {
    this.userEmail = await _auth.getEmail();
  }

  @override
  void initState() {
    super.initState();
    this.getUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: kAppBar(
          context: context,
          title: Text('MyList', style: kTitleStyle),
          icon: Icon(Icons.arrow_back_ios),
          pressed: () {
            Navigator.pop(context);
          },
        ),
        body: StreamBuilder(
          stream: _firestore.collection('Listings').snapshots(),
          builder: (context, snapshot) {
            List<MyListingCard> listingWidgets = [];
            if (snapshot.hasData) {
              final listings = snapshot.data.documents;
              for (var listing in listings) {
                final title = listing.data['title'];
                final username = listing.data['username'];
                final description = listing.data['description'];
                final address = listing.data['address'];
                final email = listing.data['email'];
                final myListingWidget = MyListingCard(
                  title: Text(title),
                  subtitle: Text(description),
                  myExpandedListingCard: ListingCardExpanded(
                    username: username,
                    title: title,
                    descrtiption: description,
                    address: address,
                  ),
                );
                if (email == userEmail) {
                  listingWidgets.add(myListingWidget);
                }
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listingWidgets,
            );
          },
        ),
      ),
    );
  }
}
