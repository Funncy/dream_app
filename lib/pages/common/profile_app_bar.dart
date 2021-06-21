import 'package:dream/app/data/models/user.dart';
import 'package:dream/pages/profile/profile_screen.dart';
import 'package:dream/viewmodels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AuthViewModel _authViewModelImpl = Get.find<AuthViewModel>();
  ProfileAppBar({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  ImageProvider getImageProvider(String? imageUrl) {
    ImageProvider result;
    if (imageUrl == null) {
      result = AssetImage('assets/images/test-img.jpeg');
    } else {
      result = NetworkImage(imageUrl);
    }
    return result;
  }

  void goToProfileScreen() {
    Get.toNamed(ProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      UserModel? user = _authViewModelImpl.user;
      if (user == null) {
        //TODO: ERROR
      }
      return AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: goToProfileScreen,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                  backgroundImage: getImageProvider(user!.profileImageUrl)),
            ),
          )
        ],
      );
    });
  }
}
