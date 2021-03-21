import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> addData(
      {@required String path, @required Map<String, dynamic> data}) async {
    final reference = Firestore.instance.collection(path);
    print('$path: $data');
    final docRef = await reference.add(data);
    await reference
        .document(docRef.documentID)
        .updateData({'docId': docRef.documentID});
  }

  Future<void> deleteData(
      {@required String path, @required String docId}) async {
    final reference = Firestore.instance.collection(path).document(docId);
    await reference.delete();
  }

  Future<void> updateData(
      {@required String path,
      @required String docId,
      @required Map<String, dynamic> data}) async {
    final reference = Firestore.instance.collection(path).document(docId);
    await reference.updateData(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) =>
          snapshot.documents.map((snapshot) => builder(snapshot.data)).toList(),
    );
  }
}
