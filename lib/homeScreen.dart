import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final Stream<QuerySnapshot> workoutData =
        FirebaseFirestore.instance.collection("Dadi").snapshots();
    final Stream<QuerySnapshot> foundData =
        FirebaseFirestore.instance.collection("Found").snapshots();

    String? imageURL = auth.currentUser?.photoURL;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: 0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageURL!),
                backgroundColor: Colors.black,
              ),
            ),
            const Text('Lost And Found'),
            GestureDetector(
              onDoubleTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const SecondRoute()),
                // );
              },
              onTap: () {
                auth.signOut();
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageURL),
                backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // Large screen layout
            return Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .35,
                  child: Column(
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
                ),
                Expanded(
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: workoutData,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Something Went Wrong.'),
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final List storeDocs = [];
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map a = document.data() as Map<String, dynamic>;
                            storeDocs.add(a);
                            a['id'] = document.id;
                            a['collection'] = document.reference;
                          }).toList();

                          if (isLoading) {
                            return const Center(
                              child: Text('Loading'),
                            );
                          } else {
                            return Container(
                              color: Colors.blue[400],
                              height: MediaQuery.of(context).size.height * .46,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        for (var i = 0;
                                            i < storeDocs.length;
                                            i++) ...[
                                          CustomBlockWidget(
                                            task: 'lost',
                                            title: storeDocs[i]['title'],
                                            name: storeDocs[i]['name'],
                                            description: storeDocs[i]
                                                ['description'],
                                            category: storeDocs[i]['category'],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: foundData,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Something Went Wrong.'),
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final List storeDocs = [];
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map a = document.data() as Map<String, dynamic>;
                            storeDocs.add(a);
                            a['id'] = document.id;
                            a['collection'] = document.reference;
                          }).toList();

                          if (isLoading) {
                            return const Center(
                              child: Text('Loading'),
                            );
                          } else {
                            return Container(
                              color: Colors.pink[300],
                              height: MediaQuery.of(context).size.height * .46,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        for (var i = 0;
                                            i < storeDocs.length;
                                            i++) ...[
                                          CustomBlockWidget(
                                            task: 'found',
                                            title: storeDocs[i]['title'],
                                            name: storeDocs[i]['name'],
                                            description: storeDocs[i]
                                                ['description'],
                                            category: storeDocs[i]['category'],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Small screen layout
            return SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: workoutData,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Something Went Wrong.'),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final List storeDocs = [];
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map a = document.data() as Map<String, dynamic>;
                        storeDocs.add(a);
                        a['id'] = document.id;
                        a['collection'] = document.reference;
                      }).toList();

                      if (isLoading) {
                        return const Center(
                          child: Text('Loading'),
                        );
                      } else {
                        return Container(
                          color: Colors.blue[400],
                          height: MediaQuery.of(context).size.height * .46,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    for (var i = 0;
                                        i < storeDocs.length;
                                        i++) ...[
                                      CustomBlockWidget(
                                        task: 'lost',
                                        title: storeDocs[i]['title'],
                                        name: storeDocs[i]['name'],
                                        description: storeDocs[i]
                                            ['description'],
                                        category: storeDocs[i]['category'],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Add()),
                          );
                        },
                        child: const Text('Report Lost or Found Item'),
                      ),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: foundData,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Something Went Wrong.'),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final List storeDocs = [];
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map a = document.data() as Map<String, dynamic>;
                        storeDocs.add(a);
                        a['id'] = document.id;
                        a['collection'] = document.reference;
                      }).toList();

                      if (isLoading) {
                        return const Center(
                          child: Text('Loading'),
                        );
                      } else {
                        return Container(
                          color: Colors.pink[300],
                          height: MediaQuery.of(context).size.height * .46,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    for (var i = 0;
                                        i < storeDocs.length;
                                        i++) ...[
                                      CustomBlockWidget(
                                        task: 'found',
                                        title: storeDocs[i]['title'],
                                        name: storeDocs[i]['name'],
                                        description: storeDocs[i]
                                            ['description'],
                                        category: storeDocs[i]['category'],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
