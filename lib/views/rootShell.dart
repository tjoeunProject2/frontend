import 'package:flutter/material.dart';
import '../common/widgets/navigate.dart';
import 'homeView/homeView.dart';
import 'mapView.dart';
import 'searchView/searchView.dart';
import 'storageView.dart';
import 'mypageView/mypageView.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  final _pages = const [
    HomeView(),
    MapView(),
    SearchView(),
    StorageView(),
    MyPageView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          AppNavigation(
            currentIndex: _index,
            onTap: (i) {
              setState(() {
                _index = i;
              });
            },
          ),
          Positioned(
            bottom: 60,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _index = 2;
                });
              },
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C4DFF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C4DFF).withValues(alpha: 0.6),
                      blurRadius: 20,
                      offset: const Offset(0, 14),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
