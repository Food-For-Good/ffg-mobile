import 'package:cloud_firestore/cloud_firestore.dart';

String listingStateOpen = 'Open';
String listingStateProgress = 'Progress';
String listingStateCompleted = 'Completed';
String listingStateDeleted = 'Deleted';

final String requestStateAccepted = 'requestAccepted';
final String requestStatePending = 'requestPending';
final String requestStateCompleted = 'requestCompleted';

class Listing {
  final String username;
  final String title;
  final String description;
  final DateTime expiryTime;
  final String phoneNo;
  final String pictureName;
  final String address;
  final String email;
  final GeoPoint location;
  final String listId;
  final String listingState;
  final Map<String, dynamic> requests;
  final Map<String, dynamic> acceptedRequest;
  final bool foodReceivedByRequester;
  final bool foodGivenByDonor;

  Listing({
    this.username,
    this.title,
    this.description,
    this.expiryTime,
    this.phoneNo,
    this.pictureName,
    this.address,
    this.email,
    this.location,
    this.listId,
    this.listingState,
    this.requests,
    this.acceptedRequest,
    this.foodReceivedByRequester,
    this.foodGivenByDonor,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'title': this.title,
      'description': this.description,
      'expiryTime': this.expiryTime,
      'location': this.location,
      'phoneNo': this.phoneNo,
      'pictureName': this.pictureName,
      'address': this.address,
      'email': this.email,
      'listingState': listingState,
      'requests': this.requests,
      'acceptedRequest': this.acceptedRequest,
      'foodReceivedByRequester': this.foodReceivedByRequester,
      'foodGivenByDonor': this.foodGivenByDonor,
    };
  }

  factory Listing.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String username = data['username'];
    final String title = data['title'];
    final String description = data['description'];
    final DateTime expiryTime = data['expiryTime'].toDate();
    final String phoneNo = data['phoneNo'];
    final String pictureName = data['pictureName'];
    final String address = data['address'];
    final String email = data['email'];
    final GeoPoint location = data['location'];
    final String listId = data['docId'];
    final String listingState = data['listingState'];
    final Map<String, dynamic> requests = data['requests'];
    final Map<String, dynamic> acceptedRequest = data['acceptedRequest'];
    final bool foodReceivedByRequester = data['foodReceivedByRequester'];
    final bool foodGivenByDonor = data['foodGivenByDonor'];
    return Listing(
        username: username,
        title: title,
        description: description,
        expiryTime: expiryTime,
        location: location,
        phoneNo: phoneNo,
        pictureName: pictureName,
        address: address,
        email: email,
        listId: listId,
        listingState: listingState,
        requests: requests,
        acceptedRequest: acceptedRequest,
        foodReceivedByRequester: foodReceivedByRequester,
        foodGivenByDonor: foodGivenByDonor);
  }
}
