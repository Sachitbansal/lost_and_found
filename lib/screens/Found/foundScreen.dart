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
  dynamic selectedImageByte = 'None';
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

  selectFile() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {

      try {
        selectedFile = fileResult.files.first.name;
        selectedImageByte = fileResult.files.first.bytes;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(selectedFile),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
          ),
        );
      }


    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No Image Selected"),
        ),
      );
    }
  }

  Future<String> uploadFile() async {
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
      return await reference.getDownloadURL();
    } catch (error) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
        ),
      );

      return 'Error';
    }
  }

  Future<void> addLost(String category) async {
    context.read<MenuAppController>().changeLoading(true);

    final String imageUrl = await uploadFile();

    if (imageUrl != 'Error') {
      CollectionReference lostData =
      FirebaseFirestore.instance.collection("Found");
      return lostData.add({
        'title': titleControllerLost.text,
        'description': descriptionControllerLost.text,
        'category': categoryLost,
        'name': currentUser?.displayName,
        'email': currentUser?.email,
        'phone': currentUser?.phoneNumber,
        'imageUrl': imageUrl,
      }).then(
            (value) {
              context.read<MenuAppController>().changeLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added Successfully'),
            ),
          );
        },
      );
    } else {
      context.read<MenuAppController>().changeLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error Occurred in Uploading Image"),
        ),
      );
    }


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
                  } else if (selectedImageByte == 'None') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select Image of Found item'),
                      ),
                    );
                  }else {
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
          context.watch<MenuAppController>().loading ? const Center(child: CircularProgressIndicator(),) : CustomTextField(
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
              selectFile();
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
