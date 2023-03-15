// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schoo0l_assignment/service/overlay.dart';
import 'package:simple_text_form_field/simple_contants.dart';
import 'package:simple_text_form_field/simple_text_form_field.dart';
import 'package:simple_text_form_field/simple_text_form_field_date.dart';

import '../service/newscreen.dart';

class AssignmentPageScreen extends StatefulWidget {
  const AssignmentPageScreen({super.key});

  @override
  State<AssignmentPageScreen> createState() => _AssignmentPageScreenState();
}

class _AssignmentPageScreenState extends State<AssignmentPageScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initSetttings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initSetttings,
    );
  }

  Future onSelectNotification(String payload) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));
  }

  showNotification() async {
    var android = const AndroidNotificationDetails('id', 'channel ',
        priority: Priority.high, importance: Importance.max);

    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
        0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
        payload: 'Welcome to the Local Notification demo ');
  }

  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(const Duration(seconds: 4));
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id',
      'channel name',
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(0, 'เเจ้งเตือนการส่งงาน',
        'เวลา 18.00', scheduledNotificationDateTime, platformChannelSpecifics);
  }

  SimpleTextFormFieldController controllerSubjectName =
      SimpleTextFormFieldController();
  SimpleTextFormFieldController controllerSubjectId =
      SimpleTextFormFieldController();
  SimpleTextFormFieldController controllerDetail =
      SimpleTextFormFieldController();
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
            children: [
              const Text(
                "สร้างกำหนดการส่ง",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
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
              SimpleTextFormField(
                isRequired: true,
                label: 'รายละเอียด',
                controller: controllerDetail,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                width: 120,
                child: ElevatedButton(
                    onPressed: () async {
                      if (controllerDate.isValid &&
                          controllerTime.isValid &&
                          controllerDetail.isValid &&
                          controllerSubjectName.isValid &&
                          controllerSubjectId.isValid) {
                        setState(() {
                          name = controllerSubjectName.value;
                          id = controllerSubjectId.value;
                          detail = controllerDetail.value;
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
                            scheduleNotification();
                          });
                        } catch (e) {
                          throw Exception();
                        }
                        print('controllerTime : ${controllerTime.value}');
                      }
                    },
                    child: const Text('มอบหมาย')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
