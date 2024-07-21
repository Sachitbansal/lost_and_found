import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../models/recentLostItemData.dart';

class RecentLostItems extends StatefulWidget {
  const RecentLostItems({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentLostItems> createState() => _RecentLostItemsState();
}

class _RecentLostItemsState extends State<RecentLostItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Lost Items",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding/2,
              // minWidth: 600,
              columns: const [
                DataColumn(
                  label: Text("Title"),
                ),
                DataColumn(
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text("Category"),
                ),
              ],
              rows: List.generate(
                demoRecentItems.length,
                (index) => recentFileDataRow(demoRecentItems[index]),
              ),
            ),
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
            SizedBox(width: 5,),
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
