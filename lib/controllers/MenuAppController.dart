import 'package:flutter/material.dart';

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {

    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }

  }

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  List<String> _headerTitle = ["Home", "Lost Data", "Found Data", "Past Data"];
  List<String> get headerTitle => _headerTitle;

  void changePage (int i) {
    _pageIndex = i;
    notifyListeners();
  }

}