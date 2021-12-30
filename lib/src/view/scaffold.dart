import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';

import '../router.dart';
import 'home.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final selectedIndex = _getSelectedIndex(routeState.route.pathTemplate);

    return Scaffold(
      body: AdaptiveNavigationScaffold(
        appBar: AdaptiveAppBar(title: const Text('App')),
        selectedIndex: selectedIndex,
        body: const HomeView(),
        onDestinationSelected: (idx) {
          switch (idx) {
            case 1:
              routeState.go('/accounts');
              break;
            case 2:
              routeState.go('/settings');
              break;
            case 0:
            default:
              routeState.go('/users');
              break;
          }
        },
        destinations: const [
          AdaptiveScaffoldDestination(
            title: 'Users',
            icon: Icons.account_circle,
          ),
          AdaptiveScaffoldDestination(
            title: 'Accounts',
            icon: Icons.account_tree,
          ),
          AdaptiveScaffoldDestination(
            title: 'Settings',
            icon: Icons.settings,
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String pathTemplate) {
    switch (pathTemplate) {
      case '/accounts':
        return 1;
      case '/settings':
        return 2;
      case '/users':
      default:
        return 0;
    }
  }
}
