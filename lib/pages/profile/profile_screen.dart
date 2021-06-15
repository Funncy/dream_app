import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:dream/models/user.dart';
import 'package:dream/viewmodels/auth_view_model_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  static final routeName = '/Profile';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var authViewModel = Get.find<AuthViewModelImpl>();
  UserModel? user;

  @override
  void initState() {
    //TODO: user가 없는 경우 처리 해줘야함.
    user = authViewModel.user;
    super.initState();
  }

  void modifyProfileImage() {}

  void signOut() async {
    ViewModelResult result = await authViewModel.signOut();
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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(onTap: () {}, child: _profileImage()),
              SizedBox(
                width: size.width,
                height: 10,
              ),
              Text("이름 : ${user!.name}"),
              SizedBox(
                height: 10,
              ),
              Text("그룹 : ${user!.group}"),
              SizedBox(
                height: 10,
              ),
              Text(
                  "가입일 : ${user!.createdAt?.year}-${user!.createdAt?.month}-${user!.createdAt?.day}"),
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
      ),
    );
  }

  Stack _profileImage() {
    return Stack(children: [
      Container(
          width: 100,
          height: 100,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/test-img.jpeg'),
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
}
