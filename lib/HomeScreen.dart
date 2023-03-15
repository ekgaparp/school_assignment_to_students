import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:schoo0l_assignment/assign_to_student/assign_page.dart';
import 'package:schoo0l_assignment/groups_create/group_page.dart';
import 'package:schoo0l_assignment/groups_create/group_page_screen.dart';
import 'package:schoo0l_assignment/model/group_medel.dart';
import 'package:schoo0l_assignment/respository/respository_getdata.dart';

class HomeScreen extends StatefulWidget {
  final zoomController;
  const HomeScreen({Key? key, this.zoomController}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetDataFromFirebase getDataFromFirebase = GetDataFromFirebase();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  void initState() {
    _getDocumentUser();
    super.initState();
  }

  Future<void> _getDocumentUser() async {
    final dataFromFirebase =
        await FirebaseFirestore.instance.collection('createGroup').doc().get();
    print('object :${dataFromFirebase.data()}');
  }

  List science = [
    'assets/images/Teaching-cuate.png',
    'assets/images/Teaching-bro.png',
    'assets/images/Teaching-amico.png'
  ];

  List math = [
    'assets/images/Teaching-bro.png',
    'assets/images/Teaching-pana.png',
    'assets/images/Teaching-rafiki.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => widget.zoomController.toggle(),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text("Today's Activity",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("createGroup").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((e) {
                return SizedBox(
                  height: 300,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    margin: const EdgeInsets.all(15),
                    elevation: 10,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return GroupPageScreen(
                            nameGroup: e['namegroup'],
                          );
                        }));
                      },
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              child: Image.asset('assets/icons/1.png'),
                            ),
                            title: Text(e['namegroup']),
                          ),
                          Image.asset(
                            'assets/images/Teaching-cuate.png',
                            width: 250,
                            height: 200,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, height: 0.8),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(IconlyBroken.home), label: '_'),
          BottomNavigationBarItem(icon: Icon(IconlyBroken.search), label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                IconlyBroken.search,
                size: 5,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(IconlyBroken.notification), label: ''),
          BottomNavigationBarItem(icon: Icon(IconlyBroken.profile), label: '')
        ],
        onTap: (index) {
          // _incrementTab(index);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple[200],
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const groupPageScreen();
          }));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget overlapped() {
    const overlap = 35.0;
    final items = [
      Container(
          padding: const EdgeInsets.all(2.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Image.asset('assets/icons/1.png'))),
      Container(
          padding: const EdgeInsets.all(2.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
              backgroundColor: Colors.green,
              child: Image.asset('assets/icons/2.png'))),
      Container(
          padding: const EdgeInsets.all(2.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Image.asset('assets/icons/3.png'))),
      Container(
          padding: const EdgeInsets.all(2.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Image.asset('assets/icons/6.png'))),
      Container(
          padding: const EdgeInsets.all(2.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
              backgroundColor: Colors.purple[100],
              child: Text(
                '9',
                style: TextStyle(color: Colors.grey[600], fontSize: 20),
              ))),
    ];

    List<Widget> stackLayers = List<Widget>.generate(items.length, (index) {
      return Padding(
        padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0),
        child: items[index],
      );
    });

    return Stack(children: stackLayers);
  }
}
