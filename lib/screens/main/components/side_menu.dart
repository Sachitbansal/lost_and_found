import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.jpg"),
          ),
          DrawerListTile(
            title: "Home",
            icon: Icons.home_outlined,
            press: () {
              context.read<MenuAppController>().changePage(0);
            },
          ),
          DrawerListTile(
            title: "Lost",
            icon: Icons.search_outlined,
            press: () {
              context.read<MenuAppController>().changePage(1);
            },
          ),
          DrawerListTile(
            title: "Found",
            icon: Icons.add_box,
            press: () {
              context.read<MenuAppController>().changePage(2);
            },
          ),
          DrawerListTile(
            title: "Past",
            icon: Icons.timelapse_outlined,
            press: () {
              context.read<MenuAppController>().changePage(3);
            },
          ),
          DrawerListTile(
            title: "Logout",
            icon: Icons.logout_outlined,
            press: () {

              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: bgColor,
                    title: context.watch<MenuAppController>().loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text('Confirm Logout'),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.currentUser?.delete();
                              FirebaseAuth.instance.signOut().whenComplete(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.press,
    required this.icon,
  });

  final String title;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
      ),
      title: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
