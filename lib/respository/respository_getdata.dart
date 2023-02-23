import 'package:cloud_firestore/cloud_firestore.dart';

class GetDataFromFirebase {
  Future fetchdataFromFirebase() async {
    try {
      final dataFromFirebase =
          await FirebaseFirestore.instance.collection('assignmentDetail').get();
      print('_dataFromFirebase :$dataFromFirebase');
      return dataFromFirebase;
    } catch (e) {
      throw Exception(e);
    }
  }
}
