import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/repositories/pary_repository_impl.dart';
import 'package:dream/viewmodels/pray_list_view_model.dart';
import 'package:dream/viewmodels/pray_send_view_model.dart';
import 'package:get/get.dart';

class PrayBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<PrayListViewModel>(PrayListViewModel(
        prayRepository: PrayRepositoryImpl(
      firebaseFirestore: FirebaseFirestore.instance,
    )));
    Get.put<PraySendViewModel>(PraySendViewModel(
        prayRepository: PrayRepositoryImpl(
      firebaseFirestore: FirebaseFirestore.instance,
    )));
  }
}
