import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Block extends StatelessWidget {
  final Color color;
  final String text;

  const Block({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.titleController,
    required this.labelText,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.icon,
    this.maxLines,
  }) : super(key: key);

  final TextEditingController? titleController;
  final String labelText;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Widget? icon;
  final int? maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      onChanged: onChanged,
      keyboardType: keyboardType,
      cursorColor: Colors.blue[300],
      decoration: InputDecoration(
        suffixIcon: icon,
        isCollapsed: true,
        fillColor: Colors.blue[200]?.withOpacity(0.05),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0.8,
            color: Colors.blue[300]!,
          ),
        ),
        labelText: labelText,
      ),
      controller: titleController,
      validator: validator,
    );
  }
}

class FilterTitle extends StatelessWidget {
  const FilterTitle({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText(
      {Key? key,
        required this.onTap,
        this.size,
        required this.title,
        required this.bgColor,
        required this.fontColor})
      : super(key: key);
  final void Function() onTap;
  final double? size;
  final String title;
  final Color? bgColor, fontColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5),
        width: size,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue[200]!),
          color: bgColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.play(
              color: fontColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBlockWidget extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final String name;
  final String task;

  CustomBlockWidget({
    required this.title,
    required this.name,
    required this.task,
    required this.description,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue[900]!, width: 2),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "${name} ${task} a ${title}",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          Text(
            category,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),

        ],
      ),
    );
  }
}

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {

  final titleControllerLost = TextEditingController();
  final titleControllerFound = TextEditingController();
  final descriptionControllerLost = TextEditingController();
  final descriptionControllerFound = TextEditingController();

  late String categoryLost = 'None';
  late String categoryFound = 'None';

  @override
  void dispose() {
    titleControllerLost.dispose();
    titleControllerFound.dispose();
    descriptionControllerLost.dispose();
    descriptionControllerFound.dispose();
    super.dispose();
  }

  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addUser() async {
    CollectionReference students =
    FirebaseFirestore.instance.collection("Dadi");
    return students.add(
      {
        'title': titleControllerLost.text,
        'description': descriptionControllerLost.text,
        'category': categoryLost,
        'name': auth.currentUser?.displayName,
      },
    ).then(
          (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added Successfully'),
          ),
        );
      },
    );
  }

  Future<void> addFound() async {
    CollectionReference students =
    FirebaseFirestore.instance.collection("Found");
    return students.add(
      {
        'title': titleControllerFound.text,
        'description': descriptionControllerFound.text,
        'category': categoryLost,
        'name': auth.currentUser?.displayName,
      },
    ).then(
          (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added Successfully'),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report'
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const FilterTitle(
                        title: 'What did you loose?',
                      ),
                      CustomTextField(
                        titleController: titleControllerLost,
                        labelText: 'Title',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter a Title';
                          }
                          return null;
                        },
                      ),
                      const FilterTitle(
                        title: 'Description',
                      ),
                      CustomTextField(
                        maxLines: 4,
                        titleController: descriptionControllerLost,
                        labelText: 'Describe the lost item',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter a Title';
                          }
                          return null;
                        },
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ButtonWithText(
                                  onTap: () {
                                    setState(() {
                                      categoryLost = 'Personal';
                                    });
                                  },
                                  size: 80,
                                  title: "Personal",
                                  fontColor:
                                  categoryLost == 'Personal'
                                      ? Colors.white
                                      : Colors.blue[300],
                                  bgColor:
                                  categoryLost == 'Personal'
                                      ? Colors.blue[400]
                                      : Colors.green[100],
                                ),
                                ButtonWithText(
                                  onTap: () {
                                    setState(() {
                                      categoryLost = 'Academic';
                                    });
                                  },
                                  size: 80,
                                  title: "Academic",
                                  fontColor:
                                  categoryLost == 'Academic'
                                      ? Colors.white
                                      : Colors.blue[300],
                                  bgColor:
                                  categoryLost == 'Academic'
                                      ? Colors.blue[400]
                                      : Colors.green[100],
                                ),
                                ButtonWithText(
                                  onTap: () {
                                    setState(() {
                                      categoryLost = 'Technical';
                                    });
                                  },
                                  size: 80,
                                  title: "Technical",
                                  fontColor:
                                  categoryLost == 'Technical'
                                      ? Colors.white
                                      : Colors.blue[300],
                                  bgColor:
                                  categoryLost == 'Technical'
                                      ? Colors.blue[400]
                                      : Colors.green[100],
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.blue[
                                  700]!, // red as border color
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  addUser();
                                },
                                child: Icon(Icons.add),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.pink[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const FilterTitle(
                        title: 'What did you find?',
                      ),
                      CustomTextField(
                        titleController: titleControllerFound,
                        labelText: 'Title',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter a Title';
                          }
                          return null;
                        },
                      ),
                      const FilterTitle(
                        title: 'Description',
                      ),
                      CustomTextField(
                        maxLines: 4,
                        titleController: descriptionControllerFound,
                        labelText:
                        'Describe the found item and where did you find it',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter a Title';
                          }
                          return null;
                        },
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ButtonWithText(
                                  onTap: () {
                                    setState(() {
                                      categoryFound = 'Personal';
                                    });
                                  },
                                  size: 80,
                                  title: "Personal",
                                  fontColor:
                                  categoryFound == 'Personal'
                                      ? Colors.white
                                      : Colors.blue[300],
                                  bgColor:
                                  categoryFound == 'Personal'
                                      ? Colors.blue[400]
                                      : Colors.green[100],
                                ),
                                ButtonWithText(
                                  onTap: () {
                                    setState(() {
                                      categoryFound = 'Academic';
                                    });
                                  },
                                  size: 80,
                                  title: "Academic",
                                  fontColor:
                                  categoryFound == 'Academic'
                                      ? Colors.white
                                      : Colors.blue[300],
                                  bgColor:
                                  categoryFound == 'Academic'
                                      ? Colors.blue[400]
                                      : Colors.green[100],
                                ),
                                ButtonWithText(
                                  onTap: () {
                                    setState(() {
                                      categoryFound = 'Technical';
                                    });
                                  },
                                  size: 80,
                                  title: "Technical",
                                  fontColor:
                                  categoryFound == 'Technical'
                                      ? Colors.white
                                      : Colors.blue[300],
                                  bgColor:
                                  categoryFound == 'Technical'
                                      ? Colors.blue[400]
                                      : Colors.green[100],
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.blue[
                                  700]!, // red as border color
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  addFound();
                                },
                                child: Icon(Icons.add),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
