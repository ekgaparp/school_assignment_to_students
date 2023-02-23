import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:schoo0l_assignment/HomeScreen.dart';
import 'package:schoo0l_assignment/Menu.dart';
import 'package:schoo0l_assignment/defaulplatform.dart';
import 'package:schoo0l_assignment/login/login_page_mobile.dart';
import 'package:schoo0l_assignment/service/notificationservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Assignment App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const LoginAllScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      body: ZoomDrawer(
        controller: _drawerController,
        style: DrawerStyle.defaultStyle,
        menuScreen: const MenuScreen(),
        mainScreen: HomeScreen(
          zoomController: _drawerController,
        ),
        borderRadius: 24.0,
        showShadow: false,
        angle: 0.0,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        closeCurve: Curves.bounceIn,
      ),
    );
  }
}
