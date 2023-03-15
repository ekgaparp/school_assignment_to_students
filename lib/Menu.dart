import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schoo0l_assignment/appoitment/appoitment.dart';
import 'package:schoo0l_assignment/assign_to_student/list_assignment_page.dart';
import 'package:schoo0l_assignment/groups_create/group_page.dart';
import 'package:schoo0l_assignment/lecture/lecture.dart';
import 'package:schoo0l_assignment/login/login_page_mobile.dart';
import 'package:schoo0l_assignment/main.dart';
import 'package:schoo0l_assignment/profile/addprofile.dart';
import 'package:schoo0l_assignment/register_groups/register_to_group.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 15),
          children: <Widget>[
            SizedBox(
              height: 300,
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 140,
                    ),
                    Container(
                      width: 70,
                      height: 70,
                      padding: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: const DecoratedBox(
                        decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage('assets/icons/1.png'),
                            )),
                      ),
                    ),
                    const Text(
                      "Dave Albert",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProfileScreen()));
                      },
                      child: const Text(
                        "View Profile",
                        style: TextStyle(fontSize: 17, color: Colors.white54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text(
                "หน้าหลัก",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
              },
            ),
            ListTile(
              title: const Text("กำหนดนัดหมาย",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const appoitmentScreen()));
              },
            ),
            // ListTile(
            //   title: const Text("Settings",
            //       style: TextStyle(
            //           color: Colors.white, fontWeight: FontWeight.w600)),
            //   onTap: () {},
            // ),
            ListTile(
              title: const Text("สร้างกลุ่ม",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const groupPageScreen()));
              },
            ),
            ListTile(
              title: const Text("สมุดโน๊ต",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const lectureNoteScreen()));
              },
            ),
            ListTile(
              title: const Text("สมัครเข้ากลุ่มและออกจากกลุ่ม",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const registerToGroupScreen()));
              },
            ),
            ListTile(
              title: const Text("รายการการเเจ้งเตือน",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListAssignmentPage()));
              },
            ),
            // ListTile(
            //   title: const Text("Grades",
            //       style: TextStyle(
            //           color: Colors.white, fontWeight: FontWeight.w600)),
            //   onTap: () {},
            // ),
            const SizedBox(
              height: 20.0,
            ),

            ListTile(
              title: const Text("Logout",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {
                print(auth.currentUser);
                auth.signOut().then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginAllScreen();
                  }));
                });
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
