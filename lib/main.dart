import 'package:finearts/Organizer/organizer_register.dart';
import 'package:finearts/admin/admin_home.dart';
import 'package:finearts/admin/student_list.dart';
import 'package:finearts/firebase_options.dart';
import 'package:finearts/admin/events_list.dart';
import 'package:finearts/organizer/events_home.dart';
import 'package:finearts/organizer/organizer_login.dart';
import 'package:finearts/splash_screen.dart';
import 'package:finearts/student/student_home_nav.dart';
import 'package:finearts/student/student_login.dart';
import 'package:finearts/student/student_registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false/** removing debug banner */,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      // connect to page
      home: SplashScreen(),
    );
  }
}

