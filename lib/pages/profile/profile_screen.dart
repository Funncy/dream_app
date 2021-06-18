import 'dart:io';

import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:dream/models/user.dart';
import 'package:dream/pages/common/alert_mixin.dart';
import 'package:dream/viewmodels/auth_view_model_impl.dart';
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
  AuthViewModelImpl _authViewModel = Get.find<AuthViewModelImpl>();
  UserModel? user;
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
      var result = await _authViewModel.setProfileImage(imageFile: _image);
      if (!result.isCompleted) {
        alertWithErrorModel(result.errorModel);
        return;
      }
    } else {
      print('No image selected.');
    }
  }

  void signOut() async {
    ViewModelResult result = await _authViewModel.signOut();
    if (result.isCompleted)
      Get.back();
    else {
      //TODO: 경고창 띄워야함 . 로그아웃 실패
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("프로필"),
        ),
        body: Obx(() {
          UserModel? user = _authViewModel.user;
          if (user == null) {}
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
                      child: _profileImage(user!.profileImageUrl)),
                  SizedBox(
                    width: size.width,
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
        }));
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
}
