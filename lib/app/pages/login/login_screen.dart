import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/pages/common/alert_mixin.dart';
import 'package:dream/app/pages/common/input_mixin.dart';
import 'package:dream/app/pages/common/loading_widget.dart';
import 'package:dream/app/pages/login/sign_up_screen.dart';
import 'package:dream/app/viewmodels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/constants.dart';

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({Key? key}) : super(key: key);

  @override
  _LoginInScreenState createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen>
    with AlertMixin, InputMixin {
  AuthViewModel _authViewModel = Get.find<AuthViewModel>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  @override
  void initState() {
    _authViewModel.authStateStream.listen((state) {
      if (state is Error) alertWithFailure(state.failure);
    });
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
      await _authViewModel.signInWithEmail(
          email: _emailController.text, password: _pwController.text);
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
      body: Obx(() {
        ViewState authState = _authViewModel.authState!;
        return Stack(
          children: [
            _loginForm(),
            if (authState is Loading) _blackBodyWidget(),
            if (authState is Loading) _loadingWidget(),
          ],
        );
      }),
    );
  }

  Widget _loginForm() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
            _submitBtn(_formKey),
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
      child: Text('로그인', style: TextStyle(color: Colors.black)),
    );
  }

  LoadingWidget _loadingWidget() => LoadingWidget();

  Widget _blackBodyWidget() => Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.black38,
      );
}
