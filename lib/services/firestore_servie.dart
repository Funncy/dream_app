import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> getData(
      {@required collectionName, @required String did}) async {
    var result =
        await _firebaseFirestore.collection(collectionName).doc(did).get();
    return result.data();
  }

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
        .orderBy('updatedAt')
        .get();

    return querySnapshot.docs.map<T>(toModelFunction).toList();
  }

  Future<List<T>> getAllDataInnerCollectionByReference<T>(
      {@required DocumentReference documentReference,
      @required String collectionName,
      @required Function toModelFunction}) async {
    QuerySnapshot querySnapshot = await documentReference
        .collection(collectionName)
        .orderBy('updatedAt')
        .get();
    return querySnapshot.docs.map<T>(toModelFunction).toList();
  }

  Future<List<T>> getAllDataInnerCollectionById<T>(
      {@required String did,
      @required String parentCollectionName,
      @required String childCollectionName,
      @required Function toModelFunction}) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection(parentCollectionName)
        .doc(did)
        .collection(childCollectionName)
        .orderBy('updatedAt')
        .get();
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

  Future<void> writeDataInInnerCollection(
      {@required String parentCollectionName,
      @required String did,
      @required String childCollectionName,
      @required Map<String, Object> json}) async {
    await _firebaseFirestore
        .collection(parentCollectionName)
        .doc(did)
        .collection(childCollectionName)
        .add(json);
  }

  Future<void> updateInCollection(
      {@required String collectionName,
      @required String did,
      @required Map<String, Object> updateJson}) async {
    await _firebaseFirestore
        .collection(collectionName)
        .doc(did)
        .update(updateJson);
  }
}
