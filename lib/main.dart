import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/homeScreen.dart';
import 'loginscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBl3SbauHcgslIwDuch-b_QtYRoVcC7oOs",
          authDomain: "lost-and-found-3d66f.firebaseapp.com",
          projectId: "lost-and-found-3d66f",
          storageBucket: "lost-and-found-3d66f.appspot.com",
          messagingSenderId: "837914510150",
          appId: "1:837914510150:web:3bee7a3b72f527c2ca9b47",
          measurementId: "G-QE5S56XYFP"),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription<User?> user;

  @override
  void initState() {
    user = FirebaseAuth.instance.authStateChanges().listen((user) {});
    super.initState();
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            FirebaseAuth.instance.currentUser!.emailVerified) {
          return const HomeScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  // Widget build(BuildContext context) {
  //   return const HomeScreen();
  // }
}


