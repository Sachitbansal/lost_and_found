import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../models/recentLostItemData.dart';

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
        .collection(pageIndex == 3 ? 'PastLost' : 'Dadi')
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
                          if (data.contains(search) && search != '') {
                            return LostItemsList(
                              docId: storeDocs[i],
                              deleteIcon: email == storeDocs[i]['email'] &&
                                  pageIndex != 3,
                            );
                          } else if (search == '') {
                            return LostItemsList(
                              docId: storeDocs[i],
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

  const LostItemsList({
    super.key,
    required this.docId,
    required this.deleteIcon,
  });

  @override
  State<LostItemsList> createState() => _LostItemsListState();
}

class _LostItemsListState extends State<LostItemsList> {
  @override
  Widget build(BuildContext context) {
    final CollectionReference ref =
        FirebaseFirestore.instance.collection('Dadi');

    Future<void> deleteMethod(CollectionReference ref, dynamic docId) async {

      try {
        await ref.doc(docId['id']).delete().then(
              (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
      } catch (e) {
        print("Dikkat $e");
        print(docId);
      }


    }

    return Padding(
      padding: const EdgeInsets.all(defaultPadding / 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          trailing: widget.deleteIcon
              ? GestureDetector(
                  onTap: () => deleteMethod(ref, widget.docId),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white60,
                  ))
              : null,
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
