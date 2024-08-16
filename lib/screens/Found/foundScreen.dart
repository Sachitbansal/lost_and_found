import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../controllers/MenuAppController.dart';
import '../../controllers/responsive.dart';
import '../../widgets.dart';
import '../Home/components/category.dart';
import '../Home/components/header.dart';
import 'addFoundScreen.dart';
import 'recentFoundItems.dart';

class AddFoundScreen extends StatelessWidget {
  const AddFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      // context.watch<MenuAppController>().topBlocks[
                      //     context.watch<MenuAppController>().pageIndex],
                      const SizedBox(height: defaultPadding),
                      const AddFoundData(),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const RecentFoundItems(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) const StorageDetails(),
                    ],
                  ),
                ),
                // if (!Responsive.isMobile(context))
                //   const SizedBox(width: defaultPadding),
                // // On Mobile means if the screen is less than 850 we don't want to show it
                // if (!Responsive.isMobile(context))
                //   const Expanded(
                //     flex: 2,
                //     child: StorageDetails(),
                //   ),
              ],
            )
          ],
        ),
      ),
    );
  }
}