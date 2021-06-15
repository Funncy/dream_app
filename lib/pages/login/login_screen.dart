import 'package:dream/pages/common/alert_mixin.dart';
import 'package:dream/pages/common/input_mixin.dart';
import 'package:dream/pages/login/sign_up_screen.dart';
import 'package:dream/viewmodels/auth_view_model_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({Key? key}) : super(key: key);

  @override
  _LoginInScreenState createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen>
    with AlertMixin, InputMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void submitLogin(FocusScopeNode currentFocus) async {
    bool isValidate = _formKey.currentState?.validate() ?? false;
    if (isValidate) {
      currentFocus.unfocus();
      var result = await Get.find<AuthViewModelImpl>().signInWithEmail(
          email: _emailController.text, password: _pwController.text);
      if (!result.isCompleted) {
        print("login error");
        // showAlert(errorModel: result.errorModel);
      }
    }
  }

  void pageToSignUp() {
    Get.toNamed(SignUpScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
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
                decoration: textInputDecor('Email'),
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
                decoration: textInputDecor('Password'),
              ),
              SizedBox(height: Constants.commonLGap),
              _submitBtn(context, _formKey),
              SizedBox(height: Constants.commonLGap),
              Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: pageToSignUp,
                      child: Text(
                        "회원가입",
                        style: TextStyle(color: Colors.blue),
                      ))),
              Divider(),
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
      child: Text('로그인', style: TextStyle(color: Colors.black)),
    );
  }
}
