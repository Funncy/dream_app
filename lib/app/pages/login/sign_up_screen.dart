import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/pages/common_mixin/alert_mixin.dart';
import 'package:dream/app/pages/common_mixin/input_mixin.dart';
import 'package:dream/app/pages/common/loading_widget.dart';
import 'package:dream/app/viewmodels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/constants.dart';

class SignUpScreen extends StatefulWidget {
  static final routeName = '/SignUp';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with AlertMixin, InputMixin {
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _cpwController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  var _groupNames = [
    "시온",
    "더드림",
    "두드림",
    "기타",
  ];
  String _groupName = "기타";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _cpwController.dispose();
    super.dispose();
  }

  void submitLogin(FocusScopeNode currentFocus) async {
    bool isValidate = _formKey.currentState?.validate() ?? false;
    if (isValidate) {
      currentFocus.unfocus();
      await _authViewModel.signUpWithEmail(
          email: _emailController.text,
          password: _pwController.text,
          name: _nameController.text,
          group: _groupName);
      if (_authViewModel.signUpState is Loaded) Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원 가입"),
      ),
      body: Obx(() {
        ViewState signUpState = _authViewModel.signUpState!;
        if (signUpState is Error) alert(signUpState);

        return Stack(
          children: [
            _signUpFormWidget(),
            if (signUpState is Loading) _blackBodyWidget(),
            if (signUpState is Loading) _loadingWidget(),
          ],
        );
      }),
    );
  }

  Padding _signUpFormWidget() {
    return Padding(
      padding: const EdgeInsets.all(Constants.commonGap),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(height: Constants.commonLGap),
            TextFormField(
              controller: _emailController,
              cursorColor: Colors.black54,
              decoration: textInputDecor('이메일'),
              validator: (text) {
                if (text!.isNotEmpty && text.contains('@')) {
                  return null;
                } else {
                  return '정확한 이메일 주소를 입력해주세요.';
                }
              },
            ),
            SizedBox(height: Constants.commonLGap),
            TextFormField(
              controller: _pwController,
              cursorColor: Colors.black54,
              obscureText: true,
              decoration: textInputDecor('비밀번호'),
              validator: (text) {
                if (text!.isNotEmpty && text.length > 4) {
                  return null;
                } else {
                  return '비밀번호를 4자리 이상 입력해주세요.';
                }
              },
            ),
            SizedBox(height: Constants.commonLGap),
            TextFormField(
              controller: _cpwController,
              cursorColor: Colors.black54,
              obscureText: true,
              decoration: textInputDecor('비밀번호 확인'),
              validator: (text) {
                if (text!.isNotEmpty && _pwController.text == text) {
                  return null;
                } else {
                  return '입력값이 비밀번호와 일치하지 않습니다.';
                }
              },
            ),
            Divider(),
            TextFormField(
              controller: _nameController,
              cursorColor: Colors.black54,
              decoration: textInputDecor('이름'),
              validator: (text) {
                if (text!.isNotEmpty) {
                  return null;
                } else {
                  return '이름을 입력해주세요';
                }
              },
            ),
            SizedBox(height: Constants.commonLGap),
            InputDecorator(
              decoration: textInputDecor('지파를 선택해주세요.'),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _groupName,
                  isDense: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _groupName = newValue!;
                    });
                  },
                  items: _groupNames.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: Constants.commonLGap),
            _submitBtn(_formKey),
            Divider(),
            SizedBox(height: Constants.commonLGap),
          ],
        ),
      ),
    );
  }

  TextButton _submitBtn(GlobalKey<FormState> _formKey) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return TextButton(
      onPressed: () => submitLogin(currentFocus),
      style: TextButton.styleFrom(
          primary: Colors.blue,
          backgroundColor: Colors.amber[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          side: BorderSide(color: Colors.amber[300]!)),
      child: Text('회원가입', style: TextStyle(color: Colors.black)),
    );
  }

  LoadingWidget _loadingWidget() => LoadingWidget();

  Widget _blackBodyWidget() => Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.black38,
      );
}
