import 'package:dream/pages/common/alert_mixin.dart';
import 'package:dream/pages/common/input_mixin.dart';
import 'package:dream/viewmodels/auth_view_model_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class SignUpScreen extends StatefulWidget {
  static final routeName = '/SignUp';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with AlertMixin, InputMixin {
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
      var result = await Get.find<AuthViewModelImpl>().signUpWithEmail(
          email: _emailController.text,
          password: _pwController.text,
          name: _nameController.text,
          group: _groupName);
      print(result);
      print(Get.find<AuthViewModelImpl>().user);
      print("Test");
      // if (result.isComplete) {
      //   Get.toNamed(TermsAndConditionsPage.routeName);
      // } else {
      //   showAlert(errorModel: result.errorModel);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원 가입"),
      ),
      body: Padding(
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
                obscureText: true,
                decoration: textInputDecor('이름'),
                validator: (text) {
                  if (text!.isNotEmpty && _pwController.text == text) {
                    return null;
                  } else {
                    return '입력값이 비밀번호와 일치하지 않습니다.';
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
              _submitBtn(context, _formKey),
              Divider(),
              SizedBox(height: Constants.commonLGap),
            ],
          ),
        ),
      ),
    );
  }

  TextButton _submitBtn(BuildContext context, GlobalKey<FormState> _formKey) {
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
}
