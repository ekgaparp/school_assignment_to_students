import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_text_form_field/simple_text_form_field.dart';

class GroupPageScreen extends StatefulWidget {
  String nameGroup;
  GroupPageScreen({super.key, required this.nameGroup});

  @override
  State<GroupPageScreen> createState() => _GroupPageScreenState();
}

class _GroupPageScreenState extends State<GroupPageScreen> {
  SimpleTextFormFieldController controllerStudentPost =
      SimpleTextFormFieldController();
  @override
  void initState() {
    super.initState();
  }

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
        title: Text(
          widget.nameGroup,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple[200],
        onPressed: () {
          _openAddWork();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _openAddWork() {
    return showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    maxLines: 18,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'สร้างงานของคุณ',
                      hintStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {}, child: const Text('โพสต์')),
                    const SizedBox(width: 20)
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
