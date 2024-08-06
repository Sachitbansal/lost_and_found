import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';

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

    final Stream<QuerySnapshot> foundData = FirebaseFirestore.instance
        .collection(pageIndex == 3 ? 'PastFound' : 'Found')
        .snapshots();
    final String? email = FirebaseAuth.instance.currentUser?.email;

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
            "Recent Found Items",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: foundData,
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
                            return ItemsBlock(
                              asset: const [
                                "https://cdn.pixabay.com/photo/2023/03/06/04/26/calculator-7832583_640.png"
                              ],
                              share: null,
                              onTap: null,
                              docId: storeDocs[i],
                              bookmarkFunction: null,
                              bookmarkIcon: false,
                              isSelected: (bool value) {},
                              deleteIcon: email == storeDocs[i]['email'],
                            );
                          } else if (search == '') {
                            return ItemsBlock(
                              asset: const [
                                "https://cdn.pixabay.com/photo/2023/03/06/04/26/calculator-7832583_640.png"
                              ],
                              docId: storeDocs[i],
                              share: null,
                              onTap: null,
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
                    ),
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

class ItemsBlock extends StatefulWidget {
  const ItemsBlock({
    super.key,
    required this.asset,
    required this.share,
    required this.onTap,
    required this.bookmarkFunction,
    required this.bookmarkIcon,
    required this.deleteIcon,
    required this.isSelected,
    required this.docId,
    this.usage,
  });

  final List asset;
  final dynamic docId;
  final String? usage;
  final bool bookmarkIcon, deleteIcon;
  final void Function()? share, onTap, bookmarkFunction;
  final ValueChanged<bool> isSelected;

  @override
  State<ItemsBlock> createState() => _ItemsBlockState();
}

class _ItemsBlockState extends State<ItemsBlock> {
  bool isSelected = false;

  final CollectionReference ref =
  FirebaseFirestore.instance.collection('Found');

  Future<void> deleteMethod(CollectionReference ref, dynamic docId) async {
    try {
      await ref.doc(docId['id']).delete().then(
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
      print(docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding / 2),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(widget.asset[0]),
                      fit: BoxFit.fitWidth,),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.docId['title'],
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                            style: GoogleFonts.play(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.docId['name'],
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.play(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    if (widget.deleteIcon)
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.white60,
                            ),
                            onPressed: () => deleteMethod(ref, widget.docId),
                          )
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
