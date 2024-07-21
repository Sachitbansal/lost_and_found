import 'package:flutter/material.dart';

import '../constants.dart';

class CloudStorageInfo {
  final String? title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;
  final IconData icon;

  CloudStorageInfo({
    required this.icon,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Add Lost Item",
    numOfFiles: 1328,
    icon: Icons.search_outlined,
    totalStorage: "1.9GB",
    color: primaryColor,
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "Add Found Item",
    numOfFiles: 1328,
    icon: Icons.add_box,
    totalStorage: "2.9GB",
    color: Color(0xFFFFA113),
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "Past Items",
    numOfFiles: 1328,
    icon: Icons.timelapse_outlined,
    totalStorage: "1GB",
    color: Color(0xFFA4CDFF),
    percentage: 10,
  ),
  CloudStorageInfo(
    title: "Apply Filters",
    numOfFiles: 5328,
    icon: Icons.filter_alt_outlined,
    totalStorage: "7.3GB",
    color: Color(0xFF007EE5),
    percentage: 78,
  ),
];
