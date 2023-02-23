// ignore_for_file: avoid_unnecessary_containers
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:schoo0l_assignment/login/form_register.dart';
import 'package:schoo0l_assignment/service/overlay.dart';

class LoginScreenWep extends StatefulWidget {
  const LoginScreenWep({super.key});

  @override
  State<LoginScreenWep> createState() => _LoginScreenWepState();
}

class _LoginScreenWepState extends State<LoginScreenWep> {
  final _formKey = GlobalKey<FormState>();
  final emailregister = TextEditingController();
  final passwordRegister = TextEditingController();

  bool _isObscure = true;
  Future<void> signInWithEmailAndPassword() async {
    bool isFormValid = _formKey.currentState!.validate();
    if (!isFormValid) return;
    var loadingOverlay = LoadingOverlay.of(context);
    try {
      loadingOverlay.show();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailregister.toString(),
          password: passwordRegister.toString());
      // _sharedPreferencescollectEmail(_profile.email);
      // final _userCurrent = FirebaseAuth.instance.currentUser;
      // print('_userCurrent :$_userCurrent');
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      // loadingOverlay.hide();
    }
    _formKey.currentState!.save();
  }

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 400;
  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isDesktop(context))
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 400,
                  // width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Card(
                    margin: const EdgeInsets.all(20.0),
                    color: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 40.0, right: 70.0, left: 70.0, bottom: 40.0),
                      child: Form(
                        key: _formKey,
                        child: Column(children: [
                          _buildTextWelcome(),
                          const SizedBox(height: 50),
                          _buildTextFieldEmail(),
                          const SizedBox(height: 25),
                          _buildTextFieldPassword(),
                          const SizedBox(height: 50),
                          _buildEmailAndPasswordLoginButton(),
                          const SizedBox(height: 20),
                          _buildRegisterButton(),
                          const SizedBox(height: 20),
                          // _buildTextOr(),
                          const SizedBox(height: 30),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextWelcome() {
    return const Text(
      "ยินดีต้อนรับ",
      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTextFieldEmail() {
    return TextFormField(
      controller: emailregister,
      decoration: InputDecoration(
        hintText: "อีเมล",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(width: 0),
        ),
      ),
      validator: MultiValidator([
        RequiredValidator(errorText: "Please Enter E-mail"),
        EmailValidator(errorText: "Invalid Email format")
      ]),
      keyboardType: TextInputType.emailAddress,
      // onChanged: (String email) {
      //   _profile.email = email;
      // },
    );
  }

  Widget _buildTextFieldPassword() {
    return TextFormField(
      controller: passwordRegister,
      decoration: InputDecoration(
          hintText: "รหัสผ่าน",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(width: 0),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          )),
      validator: RequiredValidator(errorText: "Please Enter Password"),
      obscureText: _isObscure,
      // onChanged: (String password) {
      //   _profile.password = password;
      // },
    );
  }

  Widget _buildEmailAndPasswordLoginButton() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 0, 251),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0))),
          onPressed: () async {
            await signInWithEmailAndPassword();
          },
          child: const Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 25))),
    );
  }

  Widget _buildRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'หากยังไม่มีบัญชีกดที่นี้',
          style: TextStyle(fontSize: 12),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FromRegisterAllUser()));
          },
          child: const Text(
            "  สร้างบัญชีใหม่",
            style: TextStyle(
                color: Color.fromARGB(255, 255, 0, 251),
                fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
