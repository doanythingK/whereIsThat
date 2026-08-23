import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';

class SpaceShellPage extends StatelessWidget {
  const SpaceShellPage({required this.spaceId, required this.child, super.key});

  final String spaceId;
  final Widget child;

  int _selectedIndex(String location) {
    if (location.contains('/floor-plan')) return 1;
    if (location.contains('/shopping')) return 2;
    if (location.contains('/checklist')) return 3;
    if (location.contains('/more') || location.contains('/items')) return 4;
    return 0;
  }

  void _go(BuildContext context, int index) {
    final paths = <String>[
      'home',
      'floor-plan',
      'shopping',
      'checklist',
      'more',
    ];
    context.go('/space/$spaceId/${paths[index]}');
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(location),
        onDestinationSelected: (index) => _go(context, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: context.l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: context.l10n.floorPlan,
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_cart_outlined),
            selectedIcon: const Icon(Icons.shopping_cart),
            label: context.l10n.shopping,
          ),
          NavigationDestination(
            icon: const Icon(Icons.checklist_outlined),
            selectedIcon: const Icon(Icons.checklist),
            label: context.l10n.checklist,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu),
            selectedIcon: const Icon(Icons.menu_open),
            label: context.l10n.more,
          ),
        ],
      ),
    );
  }
}
