import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootPage extends StatelessWidget {
  static final routeName = '/';
  @override
  Widget build(BuildContext context) {
    return GetX(
      init: AuthController(
          authRepository: AuthRepositoryImpl(
              firebaseAuth: FirebaseAuth.instance,
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseFunctions:
                  FirebaseFunctions.instanceFor(region: 'asia-northeast3'))),
      builder: (_) {
        if (Get.find<AuthController>().user?.isActivate == true) {
          // return FitnessVideoListPage();
        }
        // return FirstVisitPage();
      },
    );
  }
}
