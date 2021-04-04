import 'package:FoodForGood/components/icon_button.dart';
import 'package:FoodForGood/components/request_card.dart';
import 'package:flutter/material.dart';

import 'package:FoodForGood/components/my_listing_card.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/models/listing_model.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:FoodForGood/services/database.dart';

class MyRequestScreen extends StatefulWidget {
  final String title, description, phoneNo, address;
  MyRequestScreen({this.title, this.description, this.phoneNo, this.address});

  @override
  _MyRequestScreenState createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  final AuthService _auth = AuthService();
  String userEmail = '';

  int _selectedIndex = 0;
  PageController _pageController = PageController();
  DateTime currentTime = DateTime.now();

  getUserEmail() async {
    this.userEmail = await _auth.getEmail();
  }

  final database = FirestoreDatabase();

  final String requestStateAccepted = 'requestAccepted';
  final String requestStatePending = 'requestPending';
  final String requestStateTaken = 'requestTaken';

  Widget _getMyRequestLists(String requestState) {
    return StreamBuilder<List<Listing>>(
      stream: database.listingStream(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final listings = snapshot.data;
          print(listings);
          final children = listings
              .map(
                (listing) {
                  if (listing.requests.containsKey(userEmail)) {
                    //User's request is accepted by the donor.
                    if (listing.acceptedRequest.containsKey(userEmail) &&
                        requestState == requestStateAccepted) {
                      print('sending listing' + listing.toString());
                      return MyListingCard(
                        title: listing.title,
                        subtitle: listing.description,
                        listing: listing,
                        requestCards: [
                          RequestCard(
                            title: 'Food taken successfully',
                            requestIsAccepted: true,
                            onAccept: () {
                              kShowFlushBar(
                                  content:
                                      'Congratulations! Food exchanged successfully',
                                  context: context,
                                  customError: true);
                            },
                          )
                        ],
                      );
                      //No request is accepted by the donor.
                    } else if (listing.acceptedRequest.isEmpty &&
                        requestState == requestStatePending) {
                      return MyListingCard(
                          title: listing.title,
                          subtitle: listing.description,
                          listing: listing,
                          customIconButtons: [
                            CustomIconButton(
                              icon: Icons.clear,
                              onPressed: () async {
                                if (!listing.acceptedRequest
                                    .containsKey(userEmail)) {
                                  await database.deleteListingRequest(
                                    listing: listing,
                                    requesterEmail: userEmail,
                                  );
                                  kShowFlushBar(
                                      content:
                                          'Your request is succesfully deleted.',
                                      customError: true,
                                      context: context);
                                }
                              },
                            )
                          ]);
                      //Someone else is given the listing.
                    } else if (!listing.acceptedRequest
                            .containsKey(userEmail) &&
                        listing.acceptedRequest.isNotEmpty &&
                        requestState == requestStateTaken) {
                      return MyListingCard(
                        title: listing.title,
                        subtitle: listing.description,
                        listing: listing,
                      );
                    }
                  }
                },
              )
              .whereType<MyListingCard>()
              .toList();
          return ListView(
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
          title: Text('My Requests', style: kTitleStyle),
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
                label: 'Accepted',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.lock_outline_rounded),
                label: 'In Progress',
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
          onPageChanged: (index) async {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            _getMyRequestLists(requestStateAccepted),
            _getMyRequestLists(requestStatePending),
          ],
        ),
      ),
    );
  }
}

class MyRequest extends StatelessWidget {
  const MyRequest({
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
      listing: listing,
      customIconButtons: [CustomIconButton(icon: Icons.clear, size: 40.0)],
    );
  }
}
