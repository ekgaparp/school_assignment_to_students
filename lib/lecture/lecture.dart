import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:schoo0l_assignment/HomeScreen.dart';

import '../service/overlay.dart';

class lectureNoteScreen extends StatefulWidget {
  const lectureNoteScreen({super.key});

  @override
  State<lectureNoteScreen> createState() => _lectureNoteScreenState();
}

class _lectureNoteScreenState extends State<lectureNoteScreen> {
  final QuillController _controller = QuillController.basic();
  String? about;
  Future _addDataToFirebase() async {
    var json = jsonEncode(_controller.document.toDelta().toJson());
    await FirebaseFirestore.instance.collection('collectionPath').doc().set({
      "noteLecture": json,
    });
  }

  void _dispatchsetCompanyAbout() {
    final loadingOverlay = LoadingOverlay.of(context);
    var json = jsonEncode(_controller.document.toDelta().toJson());
    // if (json == '[{"insert":"\n"}]' || json.isEmpty) {
    //   Navigator.pop(context);
    // }
    if (json.length > 17) {
      loadingOverlay.show();
      _addDataToFirebase();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.done,
                color: Colors.black,
              ),
              onPressed: () {
                _dispatchsetCompanyAbout();
                // var json = jsonEncode(_controller.document.toDelta().toJson());
                // print(json);
                // do something
              },
            )
          ],
          centerTitle: true,
          title: const Text(
            'Lecture Note',
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
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                QuillToolbar.basic(
                  multiRowsDisplay: false,
                  showAlignmentButtons: true,
                  showDividers: false,
                  showSmallButton: false,
                  showInlineCode: false,
                  showBackgroundColorButton: false,
                  // showAlignmentButtons: false,
                  showJustifyAlignment: false,
                  showListBullets: false,
                  showCodeBlock: false,
                  showQuote: false,
                  showIndent: false,
                  showLink: false,
                  showListCheck: false,
                  showUndo: false,
                  showRedo: false,
                  showDirection: false,
                  showSearchButton: false,
                  controller: _controller,
                  toolbarIconSize: 25,
                  iconTheme: const QuillIconTheme(
                    borderRadius: 14,
                    iconSelectedFillColor: Colors.orange,
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: QuillEditor.basic(
                        controller: _controller, readOnly: false)),
              ],
            ),
          ),
        ));
  }
}
