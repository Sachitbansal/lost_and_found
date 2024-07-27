import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/Lost/lostScreen.dart';

class CloudStorageInfo {
  final String? title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;
  final IconData icon;
  final int onTap;


  CloudStorageInfo({
    required this.icon,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
    required this.onTap
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Add Lost Item",
    icon: Icons.search_outlined,
    color: primaryColor,
    onTap:  1,
  ),
  CloudStorageInfo(
    title: "Add Found Item",
    icon: Icons.add_box,
    color: const Color(0xFFFFA113),
    onTap: 2,
  ),
  CloudStorageInfo(
    title: "Past Items",
    icon: Icons.timelapse_outlined,
    color: const Color(0xFFA4CDFF),
    onTap: 3,
  ),
  CloudStorageInfo(
    title: "Apply Filters",
    icon: Icons.filter_alt_outlined,
    color: const Color(0xFF007EE5),
    onTap: 0,
  ),
];
