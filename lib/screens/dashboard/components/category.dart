import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

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
            "Browse by Category",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          StorageInfoCard(
            color: primaryColor,
            icon: Icons.person_2_outlined,
            title: "Personal",
            amountOfFiles: "15",
            numOfFiles: 1328,
          ),
          StorageInfoCard(
            color: Color(0xFF26E5FF),
            icon: Icons.laptop_mac,
            title: "Technical",
            amountOfFiles: "21",
            numOfFiles: 1328,
          ),
          StorageInfoCard(
            color: Color(0xFFFFCF26),
            icon: Icons.book_outlined,
            title: "Academic",
            amountOfFiles: "9",
            numOfFiles: 1328,
          ),
          StorageInfoCard(
            color: Color(0xFFEE2727),
            icon: Icons.question_mark_outlined,
            title: "Un-categorised",
            amountOfFiles: "12",
            numOfFiles: 140,
          ),
        ],
      ),
    );
  }
}
