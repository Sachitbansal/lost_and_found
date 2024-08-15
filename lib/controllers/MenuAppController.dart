import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/screens/Home/components/topBlocks.dart';
import 'package:lost_and_found/screens/Lost/lostScreen.dart';
import '../screens/Found/foundScreen.dart';
import '../screens/Home/homeScreen.dart';
import '../screens/Lost/topBlocksLost.dart';
import '../screens/Past/pastScreen.dart';

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  int _pageIndex = 0;
  String _search = '';
  bool _loading = false;

  final List<String> _headerTitle = [
    "Home",
    "Lost Data",
    "Found Data",
    "Past Data"
  ];
  final List<Widget> _topBlocks = [
    const TopBlocksHome(),
    const TopBlocksLost(),
    const TopBlocksHome(),
    const TopBlocksHome(),
  ];

  final List<Widget> _mainScreenWidgets = [
    const HomeScreen(),
    const AddLostScreen(),
    const AddFoundScreen(),
    const PastScreen(),
  ];

  final List<String> _categoryList = [
    'Technical',
    'Personal',
    'Academic',
    'Other'
  ];

  late String _selectedCategory = 'None';
  late int _selectedLostItem = -1;

  int get pageIndex => _pageIndex;
  int get selectedLostItem => _selectedLostItem;

  List<Widget> get topBlocks => _topBlocks;

  List<String> get headerTitle => _headerTitle;

  List<String> get categoryList => _categoryList;

  String get selectedCategory => _selectedCategory;
  String get search => _search;
  bool get loading => _loading;

  List<Widget> get mainScreenWidgets => _mainScreenWidgets;


  void changePage(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  void changeCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void changeSearch (String search) {
    _search = search;

    notifyListeners();
  }

  void changeLoading (bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void selectLostItem (int index) {
    _selectedLostItem = index;
    notifyListeners();
  }

}
