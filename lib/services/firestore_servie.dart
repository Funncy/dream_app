import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<List<T>> getAllData<T>(
      String collectionName, Function toModelFunction) async {
    var querySnapshot =
        await _firebaseFirestore.collection(collectionName).get();
    return querySnapshot.docs.map<T>(toModelFunction).toList();
  }

  Future<List<T>> getAllDataByDid<T>(
      String collectionName, String did, Function toModelFunction) async {
    var querySnapshot = await _firebaseFirestore
        .collection(collectionName)
        .where('nid', isEqualTo: did)
        .get();

    return querySnapshot.docs.map<T>(toModelFunction).toList();
  }

  Future<List<T>> getAllDataInnerCollection<T>(
      DocumentReference documentReference,
      String collectionName,
      Function toModelFunction) async {
    var querySnapshot =
        await documentReference.collection(collectionName).get();
    return querySnapshot.docs.map<T>(toModelFunction).toList();
  }

  Future<List<String>> getAllImageUrl(String path, String docId) async {
    var imageList = await _firebaseStorage.ref('${path}/${docId}').listAll();
    List<String> imageUrlList = [];
    for (var item in imageList.items)
      imageUrlList.add(await item.getDownloadURL());
    return imageUrlList;
  }
}
