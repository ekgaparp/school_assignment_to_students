// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:schoo0l_assignment/HomeScreen.dart';
import 'package:schoo0l_assignment/login/form_register.dart';
import 'package:schoo0l_assignment/main.dart';
import 'package:schoo0l_assignment/model/profile_all_user.dart';
import 'package:schoo0l_assignment/profile/addprofile.dart';

import 'package:schoo0l_assignment/service/overlay.dart';

class LoginAllScreen extends StatefulWidget {
  const LoginAllScreen({super.key});

  @override
  State<LoginAllScreen> createState() => _LoginAllScreenState();
}

class _LoginAllScreenState extends State<LoginAllScreen> {
  final _formKey = GlobalKey<FormState>();
  final Profile _profile = Profile("", "", "", "", "", "", "", "", "", "");
  bool _isObscure = true;

  Future<void> signInWithEmailAndPassword() async {
    bool isFormValid = _formKey.currentState!.validate();
    if (!isFormValid) return;
    var loadingOverlay = LoadingOverlay.of(context);
    try {
      loadingOverlay.show();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _profile.email, password: _profile.password);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      loadingOverlay.hide();
      return;
    }
    _formKey.currentState!.save();
    await _gotohome();
  }

  Future<void> _gotohome() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const MyHomePage();
    }));
  }

  Future<void> _getroleUser() async {
    try {
      final userCurrent = FirebaseAuth.instance.currentUser;

      final FirebaseFirestore database = FirebaseFirestore.instance;
      DocumentSnapshot<Map<String, dynamic>> documentReference =
          await database.collection('Users').doc(userCurrent!.uid).get();
      // final roleBase = documentReference.get('role');
      // print('roleBase :$roleBase');
      final statusUser = documentReference.get('status');
      print('statusUser :$statusUser');
      // if (roleBase == 'นักศึกษา') {
      if (statusUser == 'not complete') {
        print(1);
        Navigator.push(context, MaterialPageRoute(builder: ((context) {
          // return AddProfileScreen();
          return const HomeScreen();
        })));
      } else {
        print(2);
        Navigator.push(context, MaterialPageRoute(builder: ((context) {
          return const HomeScreen();
        })));
      }
      // }
      // if (roleBase == 'ผู้ให้คำปรึกษา') {
      //   if (statusUser == 'not complete') {
      //     print(3);
      //     Navigator.push(context, MaterialPageRoute(builder: ((context) {
      //       return AddProfileScreencon();
      //     })));
      //   } else {
      //     print(4);
      //     Navigator.push(context, MaterialPageRoute(builder: ((context) {
      //       return HomeConsultScreen();
      //     })));
      //   }
      // }
      // if (roleBase == 'ผู้ดูเเลระบบ') {
      //   print(5);
      //   Navigator.push(context, MaterialPageRoute(builder: ((context) {
      //     return HomeScreenofAdmin();
      //   })));
      // }
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 60,
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextWelcome(),
              const SizedBox(height: 10),
              _buildLoginDescriptionText(),
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
              // _buildGoogleAndFacebookButton(),
            ],
          ),
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

  Widget _buildLoginDescriptionText() {
    return const Text(
      "ใส่อีเมลเเละรหัสผ่านของคุณ!!",
      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
    );
  }

  Widget _buildTextFieldEmail() {
    return TextFormField(
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
      onChanged: (String email) {
        _profile.email = email;
      },
    );
  }

  Widget _buildTextFieldPassword() {
    return TextFormField(
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
      onChanged: (String password) {
        _profile.password = password;
      },
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
            await _getroleUser();
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

  // void _sharedPreferencescollectEmail(String email) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('email', email);
  // }
}
