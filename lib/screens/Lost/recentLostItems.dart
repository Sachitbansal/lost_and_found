import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../controllers/MenuAppController.dart';

class RecentLostItems extends StatefulWidget {
  const RecentLostItems({
    super.key,
  });

  @override
  State<RecentLostItems> createState() => _RecentLostItemsState();
}

class _RecentLostItemsState extends State<RecentLostItems> {
  bool isLoading = false;
  final String? email = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    final int pageIndex = context.watch<MenuAppController>().pageIndex;

    final Stream<QuerySnapshot> lostItemData = FirebaseFirestore.instance
        .collection('Lost')
        .snapshots();

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pageIndex == 3 ? 'Past Lost Items' : 'Recent Lost Items',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: lostItemData,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

              return SizedBox(
                height: MediaQuery.of(context).size.height * .46,
                child: Column(
                  children: [
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
                            }
                            else {
                              if (past) {
                                return true;
                              } else {
                                return false;
                              }
                            }
                          }

                          if (data.contains(search) &&
                              search != '' &&
                              show(storeDocs[i]['past'], pageIndex)) {
                            return LostItemsList(
                              docId: storeDocs[i],
                              collectionName:
                                  pageIndex == 3 ? 'PastLost' : 'Lost',
                              deleteIcon: email == storeDocs[i]['email'] &&
                                  pageIndex != 3,
                            );
                          } else if (search == '' &&
                              show(storeDocs[i]['past'], pageIndex)) {
                            return LostItemsList(
                              docId: storeDocs[i],
                              collectionName:
                                  pageIndex == 3 ? 'PastLost' : 'Lost',
                              deleteIcon: email == storeDocs[i]['email'] &&
                                  pageIndex != 3,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LostItemsList extends StatefulWidget {
  final bool deleteIcon;
  final dynamic docId;
  final String collectionName;

  const LostItemsList(
      {super.key,
      required this.docId,
      required this.deleteIcon,
      required this.collectionName});

  @override
  State<LostItemsList> createState() => _LostItemsListState();
}

class _LostItemsListState extends State<LostItemsList> {
  @override
  Widget build(BuildContext context) {
    Future<void> confirmationDialog(
        {required String confirmDialog,
        void Function()? onPressed,
        required String proceedButton}) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: bgColor,
            title: context.watch<MenuAppController>().loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Text(confirmDialog),
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
                    onPressed: onPressed,
                    child: Text(
                      proceedButton,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    Future<void> deleteMethod(String collectionName, dynamic docId) async {
      try {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(docId['id'])
            .delete()
            .then(
              (doc) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Item Deleted Successfully"),
                  duration: Duration(milliseconds: 2000),
                ),
              ),
              onError: (e) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error $e"),
                  duration: const Duration(milliseconds: 2000),
                ),
              ),
            );
      } catch (e) {
        print("Dikkat $e");
      }
    }

    return Padding(
      padding: const EdgeInsets.all(defaultPadding / 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          trailing: widget.deleteIcon
              ? IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.white60,
                  onPressed: () => confirmationDialog(
                      confirmDialog: "Confirm Delete?",
                      proceedButton: "Delete",
                      onPressed: () {
                        deleteMethod(widget.collectionName, widget.docId)
                            .whenComplete(() {
                          Navigator.of(context).pop();
                        });
                      }),
                )
              : IconButton(
                  icon: const Icon(
                    Icons.mail_outline,
                    color: Colors.white60,
                  ),
                  onPressed: () async {
                    try {
                      final Uri url =
                          Uri.parse("mailto:${widget.docId['email']}");
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Error $e"),
                      ));
                    }
                  },
                ),
          collapsedBackgroundColor: Colors.black26,
          title: Text(widget.docId['title'], maxLines: 2),
          subtitle: Text(
            widget.docId['name'],
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.docId['category'],
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    widget.docId['description'],
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
