import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../controllers/MenuAppController.dart';
import '../../widgets.dart';

class RecentFoundItems extends StatefulWidget {
  const RecentFoundItems({
    super.key,
  });

  @override
  State<RecentFoundItems> createState() => _RecentFoundItemsState();
}

class _RecentFoundItemsState extends State<RecentFoundItems> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final int pageIndex = context.watch<MenuAppController>().pageIndex;

    final Stream<QuerySnapshot> foundData =
        FirebaseFirestore.instance.collection('Found').orderBy("timeStamp", descending: true).snapshots();
    final String? email = FirebaseAuth.instance.currentUser?.email;
    final int selectedFoundItem = context.watch<MenuAppController>().selectedFoundItem;

    return context.watch<MenuAppController>().loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent Found Items",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: foundData,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Something Went Wrong.: ${snapshot.error}'),
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

                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .46,
                      child: Column(
                        children: [
                          if (selectedFoundItem < 0)
                            Expanded(
                            child: ListView.builder(
                              itemCount: storeDocs.length,
                              itemBuilder: (BuildContext context, int i) {
                                final String data = storeDocs[i]['title'] +
                                    storeDocs[i]['name'] +
                                    storeDocs[i]['category'] +
                                    storeDocs[i]['description'];
                                final String search =
                                    context.watch<MenuAppController>().search;

                                bool show(bool past, int index) {
                                  if (index != 3) {
                                    if (!past) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  } else {
                                    if (past) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  }
                                }

                                if (data.toLowerCase().contains(search.toLowerCase()) &&
                                    search != '' &&
                                    show(storeDocs[i]['past'], pageIndex)) {
                                  return ItemsBlock(
                                    asset: [storeDocs[i]['imageUrl']],
                                    share: null,
                                    onTap: () => context.read<MenuAppController>().selectFoundItem(i),
                                    docId: storeDocs[i],
                                    bookmarkFunction: null,
                                    bookmarkIcon: false,
                                    isSelected: (bool value) {},
                                    deleteIcon: email == storeDocs[i]['email'],
                                  );
                                } else if (search == '' &&
                                    show(storeDocs[i]['past'], pageIndex)) {
                                  return ItemsBlock(
                                    asset: [storeDocs[i]['imageUrl']],
                                    docId: storeDocs[i],
                                    share: null,
                                    onTap:  () => context.read<MenuAppController>().selectFoundItem(i),
                                    bookmarkFunction: null,
                                    bookmarkIcon: false,
                                    isSelected: (bool value) {},
                                    deleteIcon: email == storeDocs[i]['email'],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          )
                          else GestureDetector(
                          onTap: () => context.read<MenuAppController>().selectFoundItem(-1),
                          child: Column(
                          children: [
                          Text(storeDocs[selectedFoundItem]['title']),
                          Text(storeDocs[selectedFoundItem]['name']),
                          Text(storeDocs[selectedFoundItem]['email']),
                          Text(storeDocs[selectedFoundItem]['category']),
                          Text(storeDocs[selectedFoundItem]['description']),
                          Text(storeDocs[selectedFoundItem]['timeStamp'].toString() ?? 'yo'),
                    ],
                    ),
                    )
                        ],
                      ),
                    );
                  },
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: DataTable(
                //     columnSpacing: defaultPadding,
                //     // minWidth: 600,
                //     columns: [
                //       DataColumn(
                //         label: Text("Title"),
                //       ),
                //       DataColumn(
                //         label: Text("Date"),
                //       ),
                //       DataColumn(
                //         label: Text("Category"),
                //       ),
                //     ],
                //     rows: List.generate(
                //       demoRecentItems.length,
                //           (index) => recentFileDataRow(demoRecentItems[index]),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
  }
}