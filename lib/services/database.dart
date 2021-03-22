import 'package:FoodForGood/models/listing_model.dart';
import 'package:FoodForGood/services/api_path.dart';
import 'package:FoodForGood/services/firestore_service.dart';

class FirestoreDatabase {
  final _service = FirestoreService.instance;

  Stream<List<Listing>> listingStream() => _service.collectionStream(
        path: APIPath.listing(),
        builder: (data) => Listing.fromMap(data),
      );

  Future<void> deleteListing({String listId}) async =>
      await _service.deleteData(
        path: APIPath.listing(),
        docId: listId,
      );

  Future<void> createListing(Listing listing) async => await _service.addData(
        path: APIPath.listing(),
        data: listing.toMap(),
      );

  Future<void> editListing(Listing listing, String listId) async =>
      await _service.updateData(
        path: APIPath.listing(),
        docId: listId,
        data: listing.toMap(),
      );
      
  Future<void> editListingState(String listingState, String listId) async =>
      await _service.updateData(
        path: APIPath.listing(),
        docId: listId,
        data: {'listingState': listingState},
      );
}
