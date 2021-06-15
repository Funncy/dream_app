import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/pages/bottom_navigation/main_screen.dart';
import 'package:dream/pages/login/login_screen.dart';
import 'package:dream/repositories/auth_repository_impl.dart';
import 'package:dream/viewmodels/auth_view_model_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootScreen extends StatelessWidget {
  static final routeName = '/';
  @override
  Widget build(BuildContext context) {
    return GetX<AuthViewModelImpl>(
      init: AuthViewModelImpl(
        authRepository: AuthRepositoryImpl(
          firebaseAuth: FirebaseAuth.instance,
          firebaseFirestore: FirebaseFirestore.instance,
        ),
      ),
      builder: (_) {
        if (Get.find<AuthViewModelImpl>().user?.isActivate == true) {
          return MainScreen();
        }
        return LoginInScreen();
        // return FirstVisitPage();
      },
    );
  }
}
