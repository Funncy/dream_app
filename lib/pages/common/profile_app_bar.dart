import 'package:dream/models/user.dart';
import 'package:dream/viewmodels/auth_view_model_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function()? onProfileTap;
  final AuthViewModelImpl _authViewModelImpl = Get.find<AuthViewModelImpl>();
  ProfileAppBar({
    required this.title,
    required this.onProfileTap,
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
            onTap: onProfileTap,
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
