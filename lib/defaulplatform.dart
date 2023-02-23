import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      //Web
      Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyA1_vGCD1lKbwmQreQEtpDHKKsyTgdI7z8",
              authDomain: "assignment-students.firebaseapp.com",
              projectId: "assignment-students",
              storageBucket: "assignment-students.appspot.com",
              messagingSenderId: "112220500083",
              appId: "1:112220500083:web:2f5aa490e41cd8a79fba06",
              measurementId: "G-FPHBBMPGQS"));
      return const FirebaseOptions(
          apiKey: "AIzaSyA1_vGCD1lKbwmQreQEtpDHKKsyTgdI7z8",
          authDomain: "assignment-students.firebaseapp.com",
          projectId: "assignment-students",
          storageBucket: "assignment-students.appspot.com",
          messagingSenderId: "112220500083",
          appId: "1:112220500083:web:2f5aa490e41cd8a79fba06",
          measurementId: "G-FPHBBMPGQS");
    } else {
      //Android
      return const FirebaseOptions(
        apiKey: "AIzaSyA1_vGCD1lKbwmQreQEtpDHKKsyTgdI7z8",
        projectId: "assignment-students",
        messagingSenderId: "112220500083",
        appId: "1:112220500083:web:2f5aa490e41cd8a79fba06",
      );
    }
  }
}
