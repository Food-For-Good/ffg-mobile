import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  int _selectedIndex = 0;
  PageController _pageController = PageController();

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
                icon: Icon(Icons.done_all_rounded),
                label: 'Completed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.lock_outline_rounded),
                label: 'In Progress',
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
            MyListings(
              firestore: _firestore,
              userEmail: userEmail,
              listState: 'open',
            ),
            MyListings(
              firestore: _firestore,
              userEmail: userEmail,
            ),
            MyListings(
              firestore: _firestore,
              userEmail: userEmail,
            ),
            MyListings(
              firestore: _firestore,
              userEmail: userEmail,
              listState: 'deleted',
            ),
          ],
        ),
      ),
    );
  }
}

class MyListings extends StatelessWidget {
  const MyListings({
    Key key,
    @required Firestore firestore,
    @required this.userEmail,
    this.listState,
    // this.filterCondition,
  })  : _firestore = firestore,
        super(key: key);

  final Firestore _firestore;
  final String userEmail;
  final String listState;
  // final Function filterCondition;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('Listings').snapshots(),
      builder: (context, snapshot) {
        List<MyListingCard> myListingWidgets = [];
        if (snapshot.hasData) {
          final listings = snapshot.data.documents;
          DateTime currentTime = DateTime.now();
          for (var listing in listings) {
            final title =
                (listing.data['title'] == null ? '' : listing.data['title']);
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
                        text: 'Are you sure you want to delete this Listing?',
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
              switch (listState) {
                case 'open':
                  if (expiryTime.isAfter(currentTime)) {
                    myListingWidgets.add(myListingWidget);
                  }
                  break;
                case 'progress':
                  if (expiryTime.isAfter(currentTime)) {
                    myListingWidgets.add(myListingWidget);
                  }
                  break;
                case 'completed':
                  if (expiryTime.isAfter(currentTime)) {
                    myListingWidgets.add(myListingWidget);
                  }
                  break;
                case 'deleted':
                  if (expiryTime.isBefore(currentTime)) {
                    myListingWidgets.add(myListingWidget);
                  }
                  break;
                default:
              }
            }
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: myListingWidgets,
        );
      },
    );
  }
}
