import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  Future<void> addUser() async {
    CollectionReference students =
        FirebaseFirestore.instance.collection("Dadi");
    return students.add(
      {
        'month': DateTime.now().month,
        'date': DateTime.now().day,
        'year': DateTime.now().year,
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Lost And Found'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // Large screen layout
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.red,
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                addUser();
                              },
                              child: const Text('Firebase Adding'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Block(
                            color: Colors.green, text: 'Report a found item'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: StreamBuilder<QuerySnapshot>(
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
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              height: 100,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        for (var i = 0;
                                            i < storeDocs.length;
                                            i++) ...[
                                          Table(
                                            border: TableBorder.all(
                                                color: Colors.black,
                                                style: BorderStyle.solid,
                                                width: 2),
                                            children: [
                                              TableRow(children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      storeDocs[i]['month']
                                                          .toString(),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      storeDocs[i]['date']
                                                          .toString(),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      storeDocs[i]['year']
                                                          .toString(),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                            ],
                                          )
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
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Small screen layout
            return Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red,
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          addUser();
                        },
                        child: const Text('Firebase Adding'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child:
                      Block(color: Colors.green, text: 'Report a found item'),
                ),
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: StreamBuilder<QuerySnapshot>(
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
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              height: 100,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        for (var i = 0;
                                            i < storeDocs.length;
                                            i++) ...[
                                          Table(
                                            border: TableBorder.all(
                                                color: Colors.black,
                                                style: BorderStyle.solid,
                                                width: 2),
                                            children: [
                                              TableRow(children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      storeDocs[i]['month']
                                                          .toString(),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      storeDocs[i]['date']
                                                          .toString(),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      storeDocs[i]['year']
                                                          .toString(),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                            ],
                                          )
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
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class Block extends StatelessWidget {
  final Color color;
  final String text;

  Block({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
