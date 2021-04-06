import 'package:FoodForGood/components/dialog_box.dart';
import 'package:FoodForGood/components/icon_button.dart';
import 'package:FoodForGood/components/request_card.dart';
import 'package:flutter/material.dart';

import 'package:FoodForGood/components/my_listing_card.dart';
import 'package:FoodForGood/constants.dart';
import 'package:FoodForGood/models/listing_model.dart';
import 'package:FoodForGood/services/auth_service.dart';
import 'package:FoodForGood/services/database.dart';

class MyRequestScreen extends StatefulWidget {
  final int selectedIndexFromRequestPage;
  MyRequestScreen({this.selectedIndexFromRequestPage});

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
                        (!listing.foodReceivedByRequester ||
                            !listing.foodGivenByDonor) &&
                        requestState == requestStateAccepted) {
                      print('sending listing' + listing.toString());
                      return MyListingCard(
                        title: listing.username,
                        subtitle: listing.title,
                        listing: listing,
                        requestState: requestStateAccepted,
                        requestCards: [
                          RequestCard(
                            title: 'Food taken successfully?',
                            // requestIsAccepted: true,
                            requestState: requestStateAccepted,
                            onAccept: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogBox(
                                    title: 'Food Taken',
                                    text:
                                        'Is the food successfully received from the donor?',
                                    onYes: () async {
                                      try {
                                        await database.editFoodHandoverState(
                                            listing: listing,
                                            confirmationByUser: true,
                                            user: 'Receiver');
                                      } catch (e) {
                                        print(e.toString());
                                      }
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            },
                          )
                        ],
                      );
                      //No request is accepted by the donor.
                    } else if (listing.acceptedRequest.isEmpty &&
                        requestState == requestStatePending &&
                        listing.listingState == listingStateOpen) {
                      return MyListingCard(
                          title: listing.username,
                          subtitle: listing.title,
                          listing: listing,
                          requestState: requestStatePending,
                          customIconButtons: [
                            CustomIconButton(
                              icon: Icons.clear,
                              size: 40.0,
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
                      //Food is recieved.
                    } else if (listing.acceptedRequest.containsKey(userEmail) &&
                        listing.foodGivenByDonor &&
                        listing.foodReceivedByRequester &&
                        requestState == requestStateCompleted) {
                      return MyListingCard(
                        title: listing.username,
                        subtitle: 'Sharing ' + listing.title,
                        listing: listing,
                        requestState: requestStateCompleted,
                      );
                    }
                  }
                },
              )
              .whereType<MyListingCard>()
              .toList();
          if (children.isEmpty) {
            return Center(
                child: Text(
              'Currently, No request is present here!',
              style: kTextStyle,
            ));
          }
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
    if (widget.selectedIndexFromRequestPage != null) {
      _selectedIndex = widget.selectedIndexFromRequestPage;
      _pageController =
          PageController(initialPage: widget.selectedIndexFromRequestPage);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                label: 'Requested',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.done_all_rounded),
                label: 'Completed',
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
            _getMyRequestLists(requestStateCompleted),
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
