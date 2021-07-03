import 'dart:io';

import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/user.dart';
import 'package:dream/app/pages/common_mixin/alert_mixin.dart';
import 'package:dream/app/pages/common/loading_widget.dart';
import 'package:dream/app/viewmodels/auth_view_model.dart';
import 'package:dream/app/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  static final routeName = '/Profile';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AlertMixin {
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  late UserModel? user = _authViewModel.user;
  ProfileViewModel _profileViewModel = Get.find<ProfileViewModel>();
  late ImageProvider profileImage;
  late File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  ImageProvider getImageProvider(String? imageUrl) {
    ImageProvider result;
    if (imageUrl == null) {
      result = AssetImage('assets/images/test-img.jpeg');
    } else {
      result = NetworkImage(imageUrl);
    }
    return result;
  }

  _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    await setProfileImage(pickedFile);
  }

  _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    await setProfileImage(pickedFile);
  }

  setProfileImage(PickedFile? file) async {
    if (file != null) {
      _image = File(file.path);
      //TODO: user null 처리 필요
      _profileViewModel.setProfileImage(imageFile: _image, userId: user!.id);
    }
  }

  void signOut() async {
    await _authViewModel.signOut();
    if (_authViewModel.signOutState is Loaded) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("프로필"),
        ),
        body: Obx(() {
          ViewState profileState = _profileViewModel.profileState!;
          //로그아웃 에러용 state
          ViewState signOutState = _authViewModel.signOutState!;
          if (profileState is Error) alert(profileState);
          if (signOutState is Error) alert(signOutState);

          return Stack(
            children: [
              _profileBodyWidget(user!),
              if (profileState is Loading) _blackBodyWidget(),
              if (profileState is Loading) _loadingWidget(),
            ],
          );
        }));
  }

  Container _profileBodyWidget(UserModel user) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  _showPickerBottomSheetWidget(context);
                },
                child: _profileImage(user.profileImageUrl)),
            SizedBox(
              width: double.maxFinite,
              height: 10,
            ),
            Text("이름 : ${user.name}"),
            SizedBox(
              height: 10,
            ),
            Text("그룹 : ${user.group}"),
            SizedBox(
              height: 10,
            ),
            Text(
                "가입일 : ${user.createdAt?.year}-${user.createdAt?.month}-${user.createdAt?.day}"),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {},
              child: Text(
                "내 정보 수정하기",
                style: TextStyle(fontSize: 20),
              ),
            ),
            MaterialButton(
              onPressed: signOut,
              child: Text(
                "로그 아웃",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack _profileImage(String? imageUrl) {
    return Stack(children: [
      Container(
          width: 100,
          height: 100,
          child: CircleAvatar(
            backgroundImage: getImageProvider(imageUrl),
          )),
      Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: Colors.white),
          child: Center(
              child: Icon(
            Icons.edit,
            color: Colors.black,
          )),
        ),
      )
    ]);
  }

  void _showPickerBottomSheetWidget(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  LoadingWidget _loadingWidget() => LoadingWidget();

  Widget _blackBodyWidget() => Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.black38,
      );
}
