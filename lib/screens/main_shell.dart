import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'dashboard_screen.dart';
import 'sales_screen.dart';
import 'inventory_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    DashboardScreen(),
    SalesScreen(),
    InventoryScreen(),
    ReportsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.home),
            activeIcon: HeroIcon(HeroIcons.home, style: HeroIconStyle.solid),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.creditCard),
            activeIcon: HeroIcon(HeroIcons.creditCard, style: HeroIconStyle.solid),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.bookOpen),
            activeIcon: HeroIcon(HeroIcons.bookOpen, style: HeroIconStyle.solid),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.presentationChartBar),
            activeIcon: HeroIcon(HeroIcons.presentationChartBar, style: HeroIconStyle.solid),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.user),
            activeIcon: HeroIcon(HeroIcons.user, style: HeroIconStyle.solid),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
