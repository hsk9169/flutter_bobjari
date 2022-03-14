import 'package:flutter/material.dart';

class SignInBobScreen extends StatefulWidget {
  const SignInBobScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInBobScreen();
}

class _SignInBobScreen extends State<SignInBobScreen> {
  final formKey = GlobalKey<FormState>();

  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();

  String _email = '';
  String _password = '';
  bool emailCheck = false, passwordCheck = false;

  @override
  void initState() {
    super.initState();
    emailInputController.addListener(_checkEmailFilled);
    passwordInputController.addListener(_checkPasswordFilled);
  }

  @override
  void dispose() {
    emailInputController.dispose();
    passwordInputController.dispose();
    super.dispose();
  }

  void _checkEmailFilled() {
    emailInputController.text == '' ? emailCheck = false : true;
  }

  void _checkPasswordFilled() {
    passwordInputController.text == '' ? passwordCheck = false : true;
  }

  void validateAndSave() {
    final form = formKey.currentState;
    if (form != null) {
      if (form.validate()) {
        form.save();
        print('Form is valid Email: $_email, password: $_password');
      } else {
        print('Form is invalid Email: $_email, password: $_password');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle bobButtonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 18.0),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('밥자리 로그인',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (_value) =>
                    _value == '' ? 'Email can\'t be empty' : null,
                controller: emailInputController,
                onSaved: (_value) =>
                    _value != '' ? _email = _value! : _email = '',
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (_value) =>
                    _value == '' ? 'Password can\'t be empty' : null,
                controller: passwordInputController,
                onSaved: (_value) =>
                    _value != '' ? _password = _value! : _password = '',
              ),
              ElevatedButton(
                style: bobButtonStyle,
                child: const Text('밥자리 계정으로 시작하기'),
                onPressed:
                    !emailCheck && !passwordCheck ? null : validateAndSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
