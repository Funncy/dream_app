import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/repositories/pary_repository_impl.dart';
import 'package:dream/viewmodels/pray_view_model.dart';
import 'package:get/get.dart';

class PrayBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<PrayViewModel>(PrayViewModel(
        prayRepository: PrayRepositoryImpl(
      firebaseFirestore: FirebaseFirestore.instance,
    )));
  }
}
