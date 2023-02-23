import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schoo0l_assignment/assign_to_student/list_assignment_detail.dart';
import 'package:schoo0l_assignment/respository/respository_getdata.dart';

class ListAssignmentPage extends StatefulWidget {
  const ListAssignmentPage({super.key});

  @override
  State<ListAssignmentPage> createState() => _ListAssignmentPageState();
}

class _ListAssignmentPageState extends State<ListAssignmentPage> {
  final GetDataFromFirebase getDataFromFirebase = GetDataFromFirebase();

  Future _getdata() async {
    await getDataFromFirebase.fetchdataFromFirebase().then((value) {});
  }

  @override
  void initState() {
    _getdata();
    super.initState();
  }

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
          'รายการกำหนดส่ง',
          style: TextStyle(
            fontSize: 23,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('assignmentDetail').snapshots(),
      //   builder: (context, AsyncSnapshot<Object> snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     return ListView(
      //       children: snapshot.data.
      //     );
      //   },
      // )
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
                  return Card(
                    child: ListTile(
                      // leading: const CircleAvatar(),
                      title: Text(document["subjectName"]),
                      // subtitle: Text("การนัดหมาย"),
                      onTap: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const assignmentDetailPage();
                        }))
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          }),
    );
  }
}
