// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:schoo0l_assignment/HomeScreen.dart';
import 'package:simple_text_form_field/simple_text_form_field.dart';

import '../Service/overlay.dart';

class AddProfileScreen extends StatefulWidget {
  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final formKey = GlobalKey<FormState>();

  SimpleTextFormFieldController fname = SimpleTextFormFieldController();
  SimpleTextFormFieldController lname = SimpleTextFormFieldController();
  SimpleTextFormFieldController idstudent = SimpleTextFormFieldController();
  SimpleTextFormFieldController yearstudent = SimpleTextFormFieldController();
  SimpleTextFormFieldController genderstudent = SimpleTextFormFieldController();
  SimpleTextFormFieldController callstudent = SimpleTextFormFieldController();
  SimpleTextFormFieldController schoolstudent = SimpleTextFormFieldController();

  //เตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  String? name = "";
  String? lastName = "";
  String? studentID = "";
  String? gender = "";
  String? call = "";
  String? school = "";
  String? year = "";

  Future<void> _saveAndValidate() async {
    if (fname.isValid &&
        lname.isValid &&
        idstudent.isValid &&
        yearstudent.isValid &&
        genderstudent.isValid &&
        callstudent.isValid &&
        schoolstudent.isValid) {
      setState(() {
        name = fname.value;
        lastName = lname.value;
        studentID = idstudent.value;
        year = yearstudent.value;
        gender = genderstudent.value;
        call = callstudent.value;
        school = schoolstudent.value;
      });
      var loadingOverlay = LoadingOverlay.of(context);
      var firebaseUser = FirebaseAuth.instance.currentUser;
      loadingOverlay.show();
      await FirebaseFirestore.instance.collection("students").doc().set({
        "UserID": firebaseUser!.uid,
        'studentid': studentID,
        "fname": name,
        "lname": lastName,
        "school": school,
        "year": year,
        "call": call,
        "gender": gender
      });
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(firebaseUser.uid)
          .update({'status': 'complete'});
      formKey.currentState!.reset();
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) {
        return const HomeScreen();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
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
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await _saveAndValidate();
                    },
                    // var json = jsonEncode(_controller.document.toDelta().toJson());
                    // print(json);
                    // do something
                  )
                ],
                automaticallyImplyLeading: true,
                centerTitle: true,
                title: const Text("เพิ่มข้อมูลส่วนตัว",
                    style: TextStyle(fontSize: 25)),
                elevation: .0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(15),
                  ),
                ),
                toolbarHeight: 80,
              ),
              body: Container(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimpleTextFormField(
                        isRequired: true,
                        label: 'ชื่อ',
                        controller: fname,
                      ),
                      const SizedBox(height: 7),
                      SimpleTextFormField(
                        isRequired: true,
                        label: 'นามสกุล',
                        controller: lname,
                      ),
                      const SizedBox(height: 7),
                      SimpleTextFormField(
                        isRequired: true,
                        label: 'รหัสนักศึกษา',
                        controller: idstudent,
                      ),
                      const SizedBox(height: 7),
                      const Text("สำนักวิชา", style: TextStyle(fontSize: 20)),
                      DropdownSearch<String>(
                        popupProps:
                            const PopupProps.menu(showSelectedItems: true),
                        items: const [
                          "สำนักวิชาการจัดการ",
                          "สำนักวิชาเทคโนโลยีการเกษตร",
                          "สำนักวิชาพยาบาลศาสตร์",
                          "สำนักวิชาพยาบาลศาสตร์",
                          "สำนักวิชาเภสัชศาสตร์",
                          "สำนักวิชาวิทยศาสตร์",
                          "สำนักวิชาวิศวกรรมศาสตร์และทรัพยากร",
                          "สำนักวิชาวิศวกรรมศาสตร์และทรัพยากร",
                          "สำนักวิชาสถาปัตยกรรมศาสตร์และการออกแบบ",
                          "สำนักวิชาสหเวชศาสตร์และสาธารณสุขศาสตร์",
                          "สำนักวิชาสารสนเทศศาสตร์",
                          "วิทยาลัยทันตแพทยศาสตร์นานาชาติ",
                          "วิทยาลัยสัตวแพทยศาสตร์อัครราชกุมารี"
                        ],
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                        )),
                        validator: MultiValidator(
                            [RequiredValidator(errorText: "กรุณาใส่ข้อมูล")]),
                        onSaved: (school) {
                          schoolstudent.value = school!;
                        },
                        onChanged: null,
                        selectedItem: null,
                      ),
                      const SizedBox(height: 7),
                      const Text("ชั้นปี", style: TextStyle(fontSize: 20)),
                      DropdownSearch<String>(
                        popupProps: const PopupProps.dialog(
                          showSelectedItems: true,
                          constraints: BoxConstraints(
                              minWidth: 400, maxWidth: 400, maxHeight: 280),
                        ),
                        items: const ['1', '2', '3', '4', '5'],
                        validator:
                            RequiredValidator(errorText: "กรุณาใส่ข้อมูล"),
                        onSaved: (year) {
                          yearstudent.value = year!;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                        )),
                        onChanged: print,
                        //show selected item
                        selectedItem: "",
                      ),
                      const Text("เพศ", style: TextStyle(fontSize: 20)),
                      DropdownSearch<String>(
                        popupProps: const PopupProps.dialog(
                            showSelectedItems: true,
                            constraints: BoxConstraints(
                                minWidth: 400, maxWidth: 400, maxHeight: 180)),
                        items: const ["ชาย", "หญิง", "อื่นๆ"],
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                        )),
                        validator: MultiValidator(
                            [RequiredValidator(errorText: "กรุณาใส่ข้อมูล")]),
                        onSaved: (gender) {
                          genderstudent.value = gender!;
                        },
                        onChanged: print,
                        selectedItem: "",
                      ),
                      const SizedBox(height: 7),
                      SimpleTextFormField(
                        isRequired: true,
                        label: 'เบอร์ติดต่อ',
                        controller: callstudent,
                      ),
                      const SizedBox(height: 7),
                    ],
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
}
