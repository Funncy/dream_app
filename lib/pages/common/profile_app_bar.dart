import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  late String title;
  final void Function()? onProfileTap;
  String? imageUrl;
  ProfileAppBar({
    required this.title,
    required this.onProfileTap,
    this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> profileImage;
    if (imageUrl == null) {
      profileImage = AssetImage('assets/images/test-img.jpeg');
    } else {
      profileImage = NetworkImage(imageUrl!);
    }

    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: onProfileTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(backgroundImage: profileImage),
          ),
        )
      ],
    );
  }
}
