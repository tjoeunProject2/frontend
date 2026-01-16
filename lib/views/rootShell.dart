import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/widgets/navigate.dart';
import '../viewmodels/navigation_vm.dart';
import 'homeView/homeView.dart';
import 'mapView.dart';
import 'searchView/searchView.dart';
import 'storageView.dart';
import 'mypageView/mypageView.dart';

class RootShell extends ConsumerStatefulWidget {
  const RootShell({super.key});

  @override
  ConsumerState<RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<RootShell> {

  final _pages = const [
    HomeView(),
    MapView(),
    SearchView(),
    StorageView(),
    MyPageView(),
  ];

  @override
  Widget build(BuildContext context) {
    final navVm = ref.watch(navigationViewModelProvider);
    
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: navVm.currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          AppNavigation(
            currentIndex: navVm.currentIndex,
            onTap: (i) {
              ref.read(navigationViewModelProvider).setIndex(i);
            },
          ),
          Positioned(
            bottom: 60,
            child: GestureDetector(
              onTap: () {
                ref.read(navigationViewModelProvider).setIndex(2);
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
