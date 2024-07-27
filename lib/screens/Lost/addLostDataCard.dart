import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../constants.dart";
import "../../controllers/MenuAppController.dart";
import "../../widgets.dart";

class AddLostData extends StatefulWidget {
  const AddLostData({super.key});

  @override
  State<AddLostData> createState() => _AddLostDataState();
}

class _AddLostDataState extends State<AddLostData> {
  late String categoryLost = 'None';

  final User? currentUser = FirebaseAuth.instance.currentUser;

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
    FirebaseFirestore.instance.collection("Dadi");
    return lostData.add({
      'title': titleControllerLost.text,
      'description': descriptionControllerLost.text,
      'category': categoryLost,
      'name': currentUser?.displayName,
      'email': currentUser?.email,
      'phone': currentUser?.phoneNumber
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added Successfully'),
        ),
      );
    });
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
                "Add Lost Items",
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
                  if (titleControllerLost.text == "" || descriptionControllerLost.text == "") {
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
