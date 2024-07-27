import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {

    final int pageIndex = context.watch<MenuAppController>().pageIndex;

    final Stream<QuerySnapshot> lostItemData =
    FirebaseFirestore.instance.collection(pageIndex == 3 ? 'PastLost' : 'Dadi').snapshots();

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
                              LostItemsList(
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
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(RecentFile fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              fileInfo.icon!,
              height: 25,
              width: 25,
            ),
            SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                fileInfo.title!,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          fileInfo.date!,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          fileInfo.size!,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
class LostItemsList extends StatelessWidget {

  final String title;
  final String description;
  final String category;
  final String name;
  final String task;

  const LostItemsList({super.key,
    required this.title,
    required this.name,
    required this.task,
    required this.description,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.all(defaultPadding/2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          // backgroundColor: Colors.black54,
          collapsedBackgroundColor: Colors.black26,
          title: Text(title, maxLines: 2),
          subtitle: Text(
            name,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category, style: TextStyle( color: Colors.white70)),
                  Text(description, style: TextStyle( color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

