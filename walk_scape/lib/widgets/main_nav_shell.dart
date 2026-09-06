import 'package:flutter/material.dart';
import '../pages/nature_spot_finder_page.dart';
import '../pages/active_walk_tracker_page.dart';
import '../pages/mindfulness_journal_page.dart';

/// Shell that hosts the 3 main post-login pages behind a bottom nav bar.
/// (Login/Register is a separate standalone page shown before this.)
class MainNavShell extends StatefulWidget {
  const MainNavShell({super.key});

  @override
  State<MainNavShell> createState() => _MainNavShellState();
}

class _MainNavShellState extends State<MainNavShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    NatureSpotFinderPage(),
    ActiveWalkTrackerPage(),
    MindfulnessJournalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk_outlined),
            activeIcon: Icon(Icons.directions_walk),
            label: 'Walk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Journal',
          ),
        ],
      ),
    );
  }
}
