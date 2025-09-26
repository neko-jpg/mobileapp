import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minq/presentation/theme/minq_theme.dart';

class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key, required this.child});

  final Widget child;

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/stats')) {
      return 1;
    }
    if (location.startsWith('/pair')) {
      return 2;
    }
    if (location.startsWith('/quests')) {
      return 3;
    }
    if (location.startsWith('/settings')) {
      return 4;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/stats');
        break;
      case 2:
        context.go('/pair');
        break;
      case 3:
        context.go('/quests');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: tokens.brandPrimary,
        unselectedItemColor: tokens.textMuted,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: 'Pair',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_outlined),
            activeIcon: Icon(Icons.checklist),
            label: 'Quests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
