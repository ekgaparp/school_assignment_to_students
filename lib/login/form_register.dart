// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:schoo0l_assignment/login/login_page_mobile.dart';
import 'package:schoo0l_assignment/login/login_page_web.dart';
import 'package:schoo0l_assignment/service/overlay.dart';

class FromRegisterAllUser extends StatefulWidget {
  const FromRegisterAllUser({super.key});

  @override
  _FromRegisterAllUserState createState() => _FromRegisterAllUserState();
}

class _FromRegisterAllUserState extends State<FromRegisterAllUser> {
  final _formKey = GlobalKey<FormState>();
  final Future<FirebaseApp> _firebase = Firebase.initializeApp();

  bool _isObscure = true;
  bool _isObscure2 = true;

  var confirmPass;
  final TextEditingController emailregister = TextEditingController();
  final TextEditingController passwordRegister = TextEditingController();
  final TextEditingController passwordConRegiter = TextEditingController();
  final TextEditingController roleUserRegister = TextEditingController();
  // Profile _profile = Profile();

  Future<void> showAlert() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(children: const [
                Text(
                  'สำเร็จเเล้ว!!',
                  style: TextStyle(fontSize: 16),
                )
              ]),
              content: const Text(
                "ยินดีด้วยคุณได้สมัครสมาชิกมาเป็นครอบครัวเดียวกันกับเรา กรุณาเข้าสู่ระบบเพื่อเริ่มใช้งาน",
                style: TextStyle(fontSize: 14),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("ตกลง"),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const LoginAllScreen();
                    }));
                  },
                ),
              ]);
        });
  }

  Future createUserWithEmailAndPassword() async {
    bool validate = _formKey.currentState!.validate();
    if (validate) {
      _formKey.currentState!.save();
      final loadingOverlay = LoadingOverlay.of(context);
      try {
        loadingOverlay.show();
        // final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailregister.text, password: passwordRegister.text);
        // await userCredential.user!.sendEmailVerification();
        final firebaseUser = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(firebaseUser!.uid)
            .set({
          "UID": firebaseUser.uid.toString(),
          "email": emailregister.text,
          "password": passwordRegister.text,
          "comfirmpassword": passwordConRegiter.text,
          "status": 'not complete'
        });
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case "invalid-email":
            message = "Your email address appears to be incorrect.";
            break;
          case "wrong-password":
            message = "Your password is wrong.";
            break;
          case "user-not-found":
            message = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            message = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            message = "Too many requests";
            break;
          case "operation-not-allowed":
            message = "Signing in with Email and Password is not enabled.";
            break;
          case "email-already-in-use":
            message = "Email already in use";
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            message = "NetworkError Please check your internet";
            break;
          default:
            message = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: message);
        return;
      }
      loadingOverlay.hide();
      await showAlert();
    }
  }

  List itemList = ["ควาย", "หญ๋า", "คนเลี้ยง"];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Colors.black,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 70,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                            child: Text(
                          "สร้างบัญชีผู้ใช้งาน",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w400),
                        )),
                        const SizedBox(height: 8),
                        const SizedBox(
                            child: Text(
                          "ลงทะเบียนเพื่อมาเป็นครอบครัวเดียวกันกับเรา",
                          style: TextStyle(
                              fontWeight: FontWeight.w200, fontSize: 15),
                        )),
                        const SizedBox(height: 20),
                        _buildTextfieldEmail(),
                        const SizedBox(height: 15),
                        _buildTextfiedPassword(),
                        const SizedBox(height: 15),
                        _buildTextfieldConfrimPassWord(),
                        const SizedBox(height: 15),
                        // _buildRoleOfUser(),
                        // const SizedBox(height: 40),
                        _buildCreeateButton()
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget _buildTextfieldEmail() {
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
      // onSaved: (email) {
      //   _profile.email = email.toString();
      // },
    );
  }

  Widget _buildTextfiedPassword() {
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
      obscureText: _isObscure,
      validator: (value) {
        confirmPass = value;
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        if (value!.isEmpty) {
          return "Please Enter New Password";
        } else if (value.length < 9) {
          return "Password must be atleast 9 characters long";
        } else {
          return null;
        }
      },
      onChanged: (value) {
        print('object : $value');
      },
      // onSaved: (password) {
      //   _profile.password = password!;
      // },
    );
  }

  Widget _buildTextfieldConfrimPassWord() {
    return TextFormField(
      controller: passwordConRegiter,
      decoration: InputDecoration(
          hintText: "ยืนยันรหัสผ่าน",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(width: 0),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure2 ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isObscure2 = !_isObscure2;
              });
            },
          )),
      obscureText: _isObscure2,
      validator: (value) {
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        if (value!.isEmpty) {
          return "Please Re-Enter Password";
        } else if (value.length < 9) {
          return "Password must be atleast 9 characters long";
        } else if (value != confirmPass) {
          return "Password must be same as above";
        } else {
          return null;
        }
      },
      // onSaved: (comfirmpassword) {
      //   _profile.comfirmpassword = comfirmpassword!;
      // },
    );
  }

  Widget _buildRoleOfUser() {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        hintText: '   สถานะของคุณ',
        fillColor: Colors.grey.shade200,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          // borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.all(10),
      dropdownDecoration: BoxDecoration(
        border: const Border(),
        borderRadius: BorderRadius.circular(0),
      ),
      items: itemList
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        setState(() {});
      },
      // onSaved: (role) {
      //   _profile.roleUser = role.toString();
      // },
    );
  }

  Widget _buildCreeateButton() {
    return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 0, 251),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0))),
            onPressed: () async {
              await createUserWithEmailAndPassword();
              //
              print('model : ${emailregister.text} ${passwordRegister.text}');
            },
            child: const Text("สร้างบัญชี", style: TextStyle(fontSize: 20))));
  }
}
