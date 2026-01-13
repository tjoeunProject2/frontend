import 'package:flutter/material.dart';
import '../views/rootShell.dart';
import '../views/homeView.dart';
import '../views/searchView.dart';
import '../views/storageView.dart';
import '../views/mypageView.dart';

class AppRoutes {
  static const root = '/';

  static const home = '/home';
  static const search = '/search';
  static const storage = '/storage';
  static const mypage = '/mypage';

  static final Map<String, WidgetBuilder> routes = {
    root: (_) => const RootShell(),

    home: (_) => const HomeView(),
    search: (_) => const SearchView(),
    storage: (_) => const StorageView(),
    mypage: (_) => const MyPageView(),
  };
}