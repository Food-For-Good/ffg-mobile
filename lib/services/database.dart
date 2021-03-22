import 'package:FoodForGood/models/listing_model.dart';
import 'package:FoodForGood/services/api_path.dart';
import 'package:FoodForGood/services/firestore_service.dart';

class FirestoreDatabase {
  final _service = FirestoreService.instance;

  Stream<List<Listing>> listingStream() => _service.collectionStream(
        path: APIPath.listing(),
        builder: (data) => Listing.fromMap(data),
      );

  Future<void> deleteListing({Listing listing}) async =>
      await _service.deleteData(
        path: APIPath.listing(),
        docId: listing.listId,
      );

  Future<void> createListing(Listing listing) async => await _service.addData(
        path: APIPath.listing(),
        data: listing.toMap(),
      );

  Future<void> editListing(Listing listing) async =>
      await _service.updateData(
        path: APIPath.listing(),
        docId: listing.listId,
        data: listing.toMap(),
      );

  Future<void> editListingState(String listingState, Listing listing) async =>
      await _service.updateData(
        path: APIPath.listing(),
        docId: listing.listId,
        data: {'listingState': listingState},
      );
  Future<void> createListingRequest(
          Listing listing, Map<String, dynamic> updatedRequestsList) async =>
      await _service.updateData(
        path: APIPath.listing(),
        docId: listing.listId,
        data: {
          'requests': updatedRequestsList,
          'listingState': listingStateProgress
        },
      );
}
