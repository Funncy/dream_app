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

  Future<List<String>> getAllImageUrl(String path, String docId) async {
    var images = await _firebaseStorage.ref('${path}/${docId}').listAll();
    List<String> imageUrl = [];
    for (var item in images.items) imageUrl.add(await item.getDownloadURL());
    return imageUrl;
  }
}
