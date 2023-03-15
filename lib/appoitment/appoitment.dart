import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schoo0l_assignment/Service/overlay.dart';
import 'package:simple_text_form_field/simple_contants.dart';
import 'package:simple_text_form_field/simple_text_form_field.dart';
import 'package:simple_text_form_field/simple_text_form_field_date.dart';

class appoitmentScreen extends StatefulWidget {
  const appoitmentScreen({super.key});

  @override
  State<appoitmentScreen> createState() => _appoitmentScreenState();
}

class _appoitmentScreenState extends State<appoitmentScreen> {
  SimpleTextFormFieldController controllerSubjectName =
      SimpleTextFormFieldController();
  SimpleTextFormFieldController controllerSubjectId =
      SimpleTextFormFieldController();
  // SimpleTextFormFieldController controllerDetail =
  //     SimpleTextFormFieldController();
  SimpleTextFormFieldDateController controllerDate =
      SimpleTextFormFieldDateController();
  SimpleTextFormFieldDateController controllerTime =
      SimpleTextFormFieldDateController();

  String? name = "";
  String? id = "";
  String? detail = "";
  String? time = "";
  String? date = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'กำหนดการนัดหมาย',
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SimpleTextFormField(
                isRequired: true,
                label: 'ชื่อวิชา',
                controller: controllerSubjectName,
              ),
              SimpleTextFormField(
                isRequired: true,
                label: 'รหัสวิชา',
                controller: controllerSubjectId,
              ),
              const SizedBox(height: 5),
              SimpleTextFormFieldDate(
                isRequired: true,
                label: 'วันที่กำหนดส่ง',
                controller: controllerDate,
                type: InputDatetimeType.date,
              ),
              const SizedBox(height: 5),
              SimpleTextFormFieldDate(
                isRequired: true,
                label: 'เวลาที่กำหนดส่ง',
                controller: controllerTime,
                type: InputDatetimeType.time,
              ),
              const SizedBox(height: 5),
              const Text('กำหนดกลุ่มการเเจ้งเตือน'),
              // SimpleTextFormField(
              //   isRequired: true,
              //   label: 'รายละเอียด',
              //   controller: controllerDetail,
              // ),
              const SizedBox(height: 300),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (controllerDate.isValid &&
                              controllerTime.isValid &&
                              // controllerDetail.isValid
                              // &&
                              controllerSubjectName.isValid &&
                              controllerSubjectId.isValid) {
                            setState(() {
                              name = controllerSubjectName.value;
                              id = controllerSubjectId.value;
                              // detail = controllerDetail.value;
                              date = SimpleConstants.dateToString(
                                  controllerDate.value,
                                  format: "dd/MM/yyyy");
                              time = controllerTime.value.format(context);
                            });
                            final loadingOverlay = LoadingOverlay.of(context);
                            try {
                              loadingOverlay.show();
                              FirebaseFirestore.instance
                                  .collection('assignmentDetail')
                                  .doc()
                                  .set({
                                "subjectName": name,
                                "subjectId": id,
                                "date_deadline": date,
                                "time_deadline": time,
                                "detail": detail
                              }).whenComplete(() {
                                loadingOverlay.hide();
                                Navigator.pop(context);
                                // scheduleNotification();
                              });
                            } catch (e) {
                              throw Exception();
                            }
                            print('controllerTime : ${controllerTime.value}');
                          }
                        },
                        child: const Text('มอบหมาย')),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
