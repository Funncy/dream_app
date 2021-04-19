import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<List<T>> getAllData<T>(
      {@required String collectionName,
      @required Function toModelFunction}) async {
    var querySnapshot =
        await _firebaseFirestore.collection(collectionName).get();
    return querySnapshot.docs.map<T>(toModelFunction).toList();
  }

  Future<List<T>> getAllDataByDid<T>(
      {@required String collectionName,
      @required String columnName,
      @required String did,
      @required Function toModelFunction}) async {
    var querySnapshot = await _firebaseFirestore
        .collection(collectionName)
        .where(columnName, isEqualTo: did)
        .get();

    return querySnapshot.docs.map<T>(toModelFunction).toList();
  }

  Future<List<T>> getAllDataInnerCollection<T>(
      {@required DocumentReference documentReference,
      @required String collectionName,
      @required Function toModelFunction}) async {
    var querySnapshot =
        await documentReference.collection(collectionName).get();
    return querySnapshot.docs.map<T>(toModelFunction).toList();
  }

  Future<List<String>> getAllImageUrl(
      {@required String path, @required String docId}) async {
    var imageList = await _firebaseStorage.ref('${path}/${docId}').listAll();
    List<String> imageUrlList = [];
    for (var item in imageList.items)
      imageUrlList.add(await item.getDownloadURL());
    return imageUrlList;
  }

  Future<void> writeDataInCollection(
      {@required String collectionName,
      @required Map<String, Object> json}) async {
    await _firebaseFirestore.collection(collectionName).add(json);
  }
}
