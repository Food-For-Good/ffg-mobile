import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:FoodForGood/components/dialog_box.dart';
import 'package:FoodForGood/components/my_listing_card_expanded.dart';
import 'package:FoodForGood/components/my_listing_card.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/screens/give_away_screen.dart';
import 'package:FoodForGood/services/auth_service.dart';

class MyList extends StatefulWidget {
  final String title, description, phoneNo, address;
  MyList({this.title, this.description, this.phoneNo, this.address});

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  final Firestore _firestore = Firestore.instance;
  final AuthService _auth = AuthService();
  String userEmail = '';
  bool _showSpinner = false;

  getUserEmail() async {
    setState(() {
      this._showSpinner = true;
    });
    this.userEmail = await _auth.getEmail();
    setState(() {
      this._showSpinner = false;
    });
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
        backgroundColor: kBackgroundColor,
        appBar: kAppBar(
          context: context,
          title: Text('MyList', style: kTitleStyle),
          icon: Icon(Icons.arrow_back_ios),
          pressed: () {
            Navigator.pop(context);
          },
        ),
        body: ModalProgressHUD(
          inAsyncCall: this._showSpinner,
          child: StreamBuilder(
            stream: _firestore.collection('Listings').snapshots(),
            builder: (context, snapshot) {
              List<MyListingCard> listingWidgets = [];
              if (snapshot.hasData) {
                final listings = snapshot.data.documents;
                for (var listing in listings) {
                  final title = (listing.data['title'] == null
                      ? ''
                      : listing.data['title']);
                  final description = listing.data['description'];
                  final address = listing.data['address'];
                  final email = listing.data['email'];
                  final listId = listing.data['docId'];
                  final expiryTime = listing.data['expiryTime'].toDate();
                  final myListingWidget = MyListingCard(
                    title: title,
                    subtitle: description,
                    myExpandedListingCard: MyListingCardExpanded(
                      title: title,
                      descrtiption: description,
                      address: address,
                      expiryTime: expiryTime,
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GiveAwayScreen(
                              editList: true,
                              editTitle: title,
                              editDescription: description,
                              listId: listId,
                              editExpiryTime: expiryTime,
                            ),
                          ),
                        );
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogBox(
                              title: 'Delete',
                              text:
                                  'Are you sure you want to delete this Listing?',
                              onYes: () async {
                                try {
                                  await _firestore
                                      .collection('Listings')
                                      .document(listing.data['docId'])
                                      .delete();
                                  Navigator.pop(context);
                                } catch (error) {
                                  print('ERROR: ' + error.toString());
                                }
                              },
                            );
                          },
                        );
                      },
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
      ),
    );
  }
}
