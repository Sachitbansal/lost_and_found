import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';
import '../../../widgets.dart';

class RecentFoundItems extends StatefulWidget {
  const RecentFoundItems({
    super.key,
  });

  @override
  State<RecentFoundItems> createState() => _RecentFoundItemsState();
}

class _RecentFoundItemsState extends State<RecentFoundItems> {
  bool isLoading = false;

  final Stream<QuerySnapshot> foundData =
  FirebaseFirestore.instance.collection("Found").snapshots();


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
          Text(
            "Recent Lost Items",
            style: Theme.of(context).textTheme.titleMedium,
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
                return SizedBox(
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
                              ItemsBlock(
                                asset: const [
                                  "https://cdn.pixabay.com/photo/2023/03/06/04/26/calculator-7832583_640.png"
                                ],
                                name: storeDocs[i]['title'],
                                location: storeDocs[i]['name'],
                                bedCount: '5',
                                share: null,
                                bathCount: '4',
                                onTap: null,
                                bookmarkFunction: null,
                                bookmarkIcon: false,
                                isSelected: (bool value) {},
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
    required this.name,
    required this.location,
    required this.bedCount,
    required this.share,
    required this.bathCount,
    required this.onTap,
    required this.bookmarkFunction,
    required this.bookmarkIcon,
    required this.isSelected,
    this.usage,
  });

  final List asset;
  final String location, bedCount, name, bathCount;
  final String? usage;
  final bool bookmarkIcon;
  final void Function()? share, onTap, bookmarkFunction;
  final ValueChanged<bool> isSelected;

  @override
  State<ItemsBlock> createState() => _ItemsBlockState();
}

class _ItemsBlockState extends State<ItemsBlock> {
  bool isSelected = false;

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
                      fit: BoxFit.fitWidth),
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
                            widget.name,
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
                            widget.location,
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
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.king_bed,
                                    color: Colors.blue[700],
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.bedCount,
                                    style: GoogleFonts.play(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightBlueAccent,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.bathtub,
                                    color: Colors.blue[700],
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.bathCount,
                                    style: GoogleFonts.play(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightBlueAccent,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (widget.usage != 'public')
                    IconButton(
                      icon: Icon(
                        widget.bookmarkIcon
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: Colors.lightBlueAccent,
                      ),
                      onPressed: widget.bookmarkFunction,
                    ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: widget.share,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
