import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/app/repositories/auth_repository_impl.dart';
import 'package:dream/app/viewmodels/auth_view_model.dart';
import 'package:dream/app/viewmodels/profile_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/instance_manager.dart';

class ProfileBindins extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileViewModel>(ProfileViewModel(
        authRepository: AuthRepositoryImpl(
            firebaseAuth: FirebaseAuth.instance,
            firebaseFirestore: FirebaseFirestore.instance,
            firebaseStorage: FirebaseStorage.instance),
        authViewModel: Get.find<AuthViewModel>()));
  }
}
