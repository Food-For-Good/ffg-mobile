import 'package:flutter/material.dart';

import 'package:FoodForGood/components/dialog_box.dart';
import 'package:FoodForGood/components/my_listing_card_expanded.dart';
import 'package:FoodForGood/components/my_listing_card.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/models/listing_model.dart';
import 'package:FoodForGood/screens/give_away_screen.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:FoodForGood/services/database.dart';

class MyList extends StatefulWidget {
  final String title, description, phoneNo, address;
  MyList({this.title, this.description, this.phoneNo, this.address});

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  final AuthService _auth = AuthService();
  String userEmail = '';

  int _selectedIndex = 0;
  PageController _pageController = PageController();
  DateTime currentTime = DateTime.now();

  getUserEmail() async {
    this.userEmail = await _auth.getEmail();
  }

  final database = FirestoreDatabase();

  Widget _getMyListings(ListingState listingState) {
    return StreamBuilder<List<Listing>>(
      stream: database.listingStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final listings = snapshot.data;
          final children = listings
              .map(
                (listing) {
                  if (listing.email == userEmail) {
                    if (listingState == ListingState.open) {
                      if (listing.expiryTime.isAfter(currentTime)) {
                        return MyListing(
                          database: database,
                          listing: listing,
                        );
                      }
                    } else if (listingState == ListingState.progress) {
                      return MyListing(listing: listing, database: database);
                    } else if (listingState == ListingState.completed) {
                      return MyListing(listing: listing, database: database);
                    } else if (listingState == ListingState.deleted) {
                      if (listing.expiryTime.isBefore(currentTime)) {
                        return MyListing(listing: listing, database: database);
                      }
                    }
                  }
                },
              )
              .whereType<MyListing>()
              .toList();
          return Column(
            children: children,
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Some Error Occured',
              style: kTextStyle,
            ),
          );
        }
        return Center(
          child: Text('No listing available'),
        );
      },
    );
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
        bottomNavigationBar: Container(
          height: 100.0,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: kSecondaryColor,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.lock_open_rounded),
                label: 'Open',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.lock_outline_rounded),
                label: 'In Progress',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.done_all_rounded),
                label: 'Completed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.delete_forever_rounded),
                label: 'Deleted',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: kBackgroundColor,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.animateToPage(index,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear);
              });
            },
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            _getMyListings(ListingState.open),
            _getMyListings(ListingState.open),
            _getMyListings(ListingState.open),
            _getMyListings(ListingState.deleted),
          ],
        ),
      ),
    );
  }
}

class MyListing extends StatelessWidget {
  const MyListing({
    Key key,
    @required this.listing,
    @required this.database,
  }) : super(key: key);

  final FirestoreDatabase database;
  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return MyListingCard(
      title: listing.title,
      subtitle: listing.description,
      myExpandedListingCard: MyListingCardExpanded(
        title: listing.title,
        descrtiption: listing.description,
        address: listing.address,
        expiryTime: listing.expiryTime,
        onEdit: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GiveAwayScreen(
                editList: true,
                editTitle: listing.title,
                editDescription: listing.description,
                listId: listing.listId,
                editExpiryTime: listing.expiryTime,
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
                text: 'Are you sure you want to delete this Listing?',
                onYes: () async {
                  try {
                    database.deleteListing(listId: listing.listId);
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
  }
}
