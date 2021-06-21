import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/pages/bottom_navigation/main_screen.dart';
import 'package:dream/pages/login/login_screen.dart';
import 'package:dream/repositories/auth_repository_impl.dart';
import 'package:dream/viewmodels/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootScreen extends StatelessWidget {
  static final routeName = '/';
  @override
  Widget build(BuildContext context) {
    return GetX<AuthViewModel>(
      init: AuthViewModel(
        authRepository: AuthRepositoryImpl(
          firebaseAuth: FirebaseAuth.instance,
          firebaseFirestore: FirebaseFirestore.instance,
          firebaseStorage: FirebaseStorage.instance,
        ),
      ),
      builder: (_) {
        var fireauthStatus = Get.find<AuthViewModel>().fireauthState;

        switch (fireauthStatus) {
          case FireAuthState.signin:
            return MainScreen();
          case FireAuthState.signout:
            return LoginInScreen();
          case FireAuthState.loading:
          default:
            return Scaffold(
              body: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
        }
      },
    );
  }
}
