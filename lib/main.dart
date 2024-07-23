import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_and_found/screens/SignUp/signup_screen.dart';
import 'package:lost_and_found/screens/main/main_screen.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'controllers/MenuAppController.dart';

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
    return ChangeNotifierProvider(
      create: (context) => MenuAppController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lost and Found',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        home: const MyHomePage(title: 'Lost And Found'),
      ),
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
          return const MainScreen();
        } else {
          return const SignUpScreen();
        }
      },
    );
  }

}


