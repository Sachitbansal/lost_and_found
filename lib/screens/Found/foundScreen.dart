import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../controllers/MenuAppController.dart';
import '../../controllers/responsive.dart';
import '../../widgets.dart';
import '../Home/components/category.dart';
import '../Home/components/header.dart';
import '../Home/components/recentFoundItems.dart';

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
                      context.watch<MenuAppController>().topBlocks[
                          context.watch<MenuAppController>().pageIndex],
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
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddFoundData extends StatefulWidget {
  const AddFoundData({super.key});

  @override
  State<AddFoundData> createState() => _AddFoundDataState();
}

class _AddFoundDataState extends State<AddFoundData> {
  late String categoryLost = 'None';
  late var selectedImageByte;
  UploadTask? uploadTask;

  final User? currentUser = FirebaseAuth.instance.currentUser;
  final pickedImages = <Image>[];
  late String selectedFile;
  bool isLoading = false;

  final titleControllerLost = TextEditingController();
  final descriptionControllerLost = TextEditingController();

  @override
  void dispose() {
    titleControllerLost.dispose();
    descriptionControllerLost.dispose();
    super.dispose();
  }

  Future<void> addLost(String category) async {
    CollectionReference lostData =
        FirebaseFirestore.instance.collection("Found");
    return lostData.add({
      'title': titleControllerLost.text,
      'description': descriptionControllerLost.text,
      'category': categoryLost,
      'name': currentUser?.displayName,
      'email': currentUser?.email,
      'phone': currentUser?.phoneNumber
    }).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added Successfully'),
          ),
        );
      },
    );
  }

  selectFile(bool imageFrom) async {
    // try {
    //   bool isGranted = await Permission.mediaLibrary.status.isGranted;
    //
    //   if (!isGranted) {
    //     isGranted = await Permission.mediaLibrary.request().isGranted;
    //     print("Permission nahi hai");
    //   } else {
    //     FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
    //
    //     if (fileResult != null) {
    //       selectedFile = fileResult.files.first.name;
    //       selectedImageByte = fileResult.files.first.bytes;
    //       uploadFile();
    //     }
    //     print(selectedFile);
    //   }
    // } catch (error) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text("Dikkat $error"),
    //       // duration: Duration(milliseconds: 300),
    //     ),
    //   );
    // }

    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    final auth = FirebaseAuth.instance.currentUser?.email;
    print(auth);

    if (fileResult != null) {
      selectedFile = fileResult.files.first.name;
      selectedImageByte = fileResult.files.first.bytes;
      // uploadFile();
    }
    print(selectedFile);
  }

  Future<void> uploadFile() async {
    try {
      final imgId = DateTime.now().millisecondsSinceEpoch.toString();

      Reference reference =
          FirebaseStorage.instance.ref().child("images").child("post_$imgId");
      final metaData = SettableMetadata(contentType: 'image/jpeg');

      uploadTask = reference.putData(selectedImageByte, metaData);

      await uploadTask?.whenComplete(
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Uploaded"),
              // duration: Duration(milliseconds: 300),
            ),
          );
        },
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          duration: Duration(milliseconds: 300),
        ),
      );
    }

    // return await reference.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Add Found Items",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                style: ButtonStyle(
                  iconColor: WidgetStateProperty.all(Colors.white70),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: primaryColor),
                    ),
                  ),
                ),
                onPressed: () async {
                  if (titleControllerLost.text == "" ||
                      descriptionControllerLost.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all fields'),
                      ),
                    );
                  } else {
                    try {
                      await addLost(categoryLost);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$error"),
                          duration: const Duration(milliseconds: 3000),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.add),
              )
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          CustomTextField(
            labelText: "Title",
            titleController: titleControllerLost,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          CustomTextField(
            labelText: "Description",
            maxLines: 5,
            titleController: descriptionControllerLost,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          ButtonWithText(
            bgColor: primaryColor,
            fontColor: Colors.white70,
            title: 'Add Images',
            onTap: () async {
              // await context.read<MenuAppController>().pickImage();
              // print(context.watch<MenuAppController>().pickedImaged);
              selectFile(true);
              // Image.memory(selectedImageByte);
            },
          ),
          Wrap(
            children: [
              for (var category
                  in context.watch<MenuAppController>().categoryList)
                ButtonWithText(
                  size: 90,
                  onTap: () {
                    categoryLost = category;
                    context.read<MenuAppController>().changeCategory(category);
                  },
                  title: category,
                  bgColor:
                      context.watch<MenuAppController>().selectedCategory ==
                              category
                          ? Colors.blue[400]
                          : secondaryColor,
                  fontColor:
                      context.watch<MenuAppController>().selectedCategory ==
                              category
                          ? Colors.white
                          : Colors.white70,
                ),
            ],
          )
        ],
      ),
    );
  }
}
