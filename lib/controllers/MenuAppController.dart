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

  int get pageIndex => _pageIndex;

  List<Widget> get topBlocks => _topBlocks;

  List<String> get headerTitle => _headerTitle;

  List<String> get categoryList => _categoryList;

  String get selectedCategory => _selectedCategory;

  List<Widget> get mainScreenWidgets => _mainScreenWidgets;


  void changePage(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  void changeCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

}
