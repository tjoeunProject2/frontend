import 'package:flutter/material.dart';
import '../views/user/loginView.dart';
import '../views/user/registerView.dart';
import '../views/rootShell.dart';
import '../views/homeView/homeView.dart';
import '../views/searchView/searchView.dart';
import '../views/storageView.dart';
import '../views/mypageView/mypageView.dart';
import "../views/startView.dart";
import '../views/mapView.dart';

class AppRoutes {

  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String homeView = '/home';
  static const String search = '/search';
  static const String storage = '/storage';
  static const String mypage = '/mypage';
  static const String start = './start';
  static const String rootshell = './rootshell';
  static const String map = '/map';

  static final Map<String, WidgetBuilder> routes = {
    root: (_) => const StartView(),
    login: (_) => const LoginView(),
    register: (_) => const RegisterView(),
    homeView: (_) => const HomeView(),
    search: (_) => const SearchView(),
    storage: (_) => const StorageView(),
    mypage: (_) => const MyPageView(),
    rootshell: (_) => const RootShell(),
    map: (_) => const MapView(),
  };
}