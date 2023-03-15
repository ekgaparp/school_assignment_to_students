// ignore_for_file: camel_case_types
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:schoo0l_assignment/Service/overlay.dart';
import 'package:simple_text_form_field/simple_text_form_field.dart';

import '../main.dart';

class groupPageScreen extends StatefulWidget {
  const groupPageScreen({super.key});

  @override
  State<groupPageScreen> createState() => _groupPageScreenState();
}

class _groupPageScreenState extends State<groupPageScreen> {
  @override
  void initState() {
    _getDataFromJson();
    super.initState();
  }

  SimpleTextFormFieldController controllerSubjectGroupName =
      SimpleTextFormFieldController();
  SimpleTextFormFieldController controllerSubjectName =
      SimpleTextFormFieldController();
  SimpleTextFormFieldController controllerCreateGroup =
      SimpleTextFormFieldController();

  List listNameStudent = [];
  List selectedName = [];

  Future<void> _getDataFromJson() async {
    final String jsonListStudent =
        await rootBundle.loadString("assets/data_user/data_user.json");
    final Map nameStudent = jsonDecode(jsonListStudent);
    List list = nameStudent['listStudent'];
    setState(() {
      listNameStudent = list;
    });
  }

  Future<void> _gotohome() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const MyHomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'สร้างกลุ่ม',
          style: TextStyle(color: Colors.black),
        ),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SimpleTextFormField(
                isRequired: true,
                label: 'ชื่อกลุ่ม',
                controller: controllerSubjectGroupName,
              ),
              SimpleTextFormField(
                isRequired: true,
                label: 'ชื่อ',
                controller: controllerSubjectName,
              ),
              const SizedBox(height: 10),
              Row(
                children: const <Widget>[
                  Text('รับทั้งหมด'),
                  SizedBox(width: 20),
                  Text('30'),
                ],
              ),
              const SizedBox(height: 10),
              SimpleTextFormField(
                editable: false,
                // isRequired: true,
                placeHolder: '222',
                label: 'ผู้สร้างกลุุ่ม',
                controller: controllerCreateGroup,
              ),
              const SizedBox(height: 10),
              MultiSelectDialogField(
                listType: MultiSelectListType.LIST,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.3),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                buttonText: const Text('เลือกรายชื่อนักศึกษา'),
                searchable: true,
                title: const Text('รายชื่อนักศึกษา'),
                items: listNameStudent
                    .map((item) => MultiSelectItem(item, item['name']))
                    .toList(),
                onConfirm: (result) {
                  selectedName.clear();
                  selectedName.add(result);
                  print("selectedName : ${selectedName.toList()}");
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (controllerSubjectGroupName.isValid &&
                              controllerSubjectGroupName.isValid &&
                              controllerCreateGroup.isValid) {
                            setState(() {});
                            final loadingOverlay = LoadingOverlay.of(context);
                            try {
                              loadingOverlay.show();
                              final getDocID = FirebaseFirestore.instance
                                  .collection("createGroup")
                                  .doc();

                              await getDocID.set({
                                "namegroup": controllerSubjectGroupName.value,
                                "name": controllerSubjectName.value,
                                "userCreate": controllerCreateGroup.value,
                                "listStudentInGroup": selectedName.toString(),
                                "docID": getDocID.id
                              });
                              await _gotohome();
                            } catch (e) {
                              if (kDebugMode) {
                                print('object :$e');
                              }
                            }
                          }
                        },
                        child: const Text('สร้างกลุ่ม')),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
