import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class EmailError extends StatelessWidget {
  const EmailError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: bgColor,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // radius of 10
                color: secondaryColor,
              ),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.currentUser?.delete();
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text(
                    "Please Login with Student ID \nTap To Logout",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
