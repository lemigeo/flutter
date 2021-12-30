import 'package:flutter/material.dart';

import '../model.dart';
import '../router.dart';
import '../component.dart';

class TabView extends StatefulWidget {
  const TabView({
    Key? key,
  }) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_handleTabIndexChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('App'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Users',
                icon: Icon(Icons.account_circle),
              ),
              Tab(
                text: 'Accounts',
                icon: Icon(Icons.account_tree),
              ),
              Tab(
                text: 'Settings',
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            UserList(
              users: List<User>.empty(),
              onTap: _handleUserTapped,
            ),
            AccountList(
              accounts: List<Account>.empty(),
              onTap: _handleAccountTapped,
            ),
          ],
        ),
      );

  RouteState get _routeState => RouteStateScope.of(context);

  void _handleUserTapped(User user) {
    _routeState.go('/user/${user.seq}');
  }

  void _handleAccountTapped(Account account) {
    _routeState.go('/account/${account.id}');
  }

  void _handleTabIndexChanged() {
    switch (_tabController.index) {
      case 1:
        _routeState.go('/accounts');
        break;
      case 2:
        _routeState.go('/settings');
        break;
      case 0:
      default:
        _routeState.go('/users');
        break;
    }
  }
}
