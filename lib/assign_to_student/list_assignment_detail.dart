import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class assignmentDetailPage extends StatefulWidget {
  const assignmentDetailPage({super.key});

  @override
  State<assignmentDetailPage> createState() => _assignmentDetailPageState();
}

class _assignmentDetailPageState extends State<assignmentDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: const Text(
          '',
          style: TextStyle(
            fontSize: 23,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("assignmentDetail")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: snapshot.data!.docs.map((document) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document['subjectName']),
                      Text(document['subjectId']),
                      Text(document['date_deadline']),
                      Text(document['time_deadline']),
                      Text(document['detail']),
                    ],
                  );
                  // Card(
                  //   child: ListTile(
                  //     // leading: const CircleAvatar(),
                  //     title: Text(document["subjectName"]),
                  //   ),
                  // );
                }).toList(),
              ),
            );
          }),
    );
  }
}
