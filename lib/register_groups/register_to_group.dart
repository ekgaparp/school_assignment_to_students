import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class registerToGroupScreen extends StatefulWidget {
  const registerToGroupScreen({super.key});

  @override
  State<registerToGroupScreen> createState() => _registerToGroupScreenState();
}

class _registerToGroupScreenState extends State<registerToGroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'สมัครเข้ากลุ่ม',
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
    );
  }
}
