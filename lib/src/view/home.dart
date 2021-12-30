import 'package:flutter/material.dart';
import 'package:sample/src/view/profile.dart';

import 'scaffold.dart';
import 'user.dart';
import 'account.dart';
import 'setting.dart';

import '../router.dart';
import '../component/fade_transition_page.dart';

/// Displays the contents of the body of [AppScaffold]
class HomeView extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentRoute = RouteStateScope.of(context).route;
    FadeTransitionPage<void> page;
    switch (currentRoute.pathTemplate) {
      case '/accounts':
        page = FadeTransitionPage<void>(
          key: ValueKey(currentRoute.pathTemplate),
          child: const AccountView(),
        );
        break;
      case '/settings':
        page = FadeTransitionPage<void>(
          key: ValueKey(currentRoute.pathTemplate),
          child: const SettingView(),
        );
        break;
      case '/user/:seq':
        Widget child;
        if (currentRoute.parameters.containsKey("seq")) {
          child = ProfileView(
            seq: int.parse(currentRoute.parameters["seq"]!),
          );
        } else {
          child = const UserView();
        }
        page = FadeTransitionPage<void>(
          key: ValueKey(currentRoute.pathTemplate),
          child: child,
        );
        break;
      case '/users':
      default:
        page = FadeTransitionPage<void>(
          key: ValueKey(currentRoute.pathTemplate),
          child: const UserView(),
        );
        break;
    }
    // A nested Router isn't necessary because the back button behavior doesn't
    // need to be customized.
    return Navigator(
      key: navigatorKey,
      onPopPage: (route, dynamic result) => route.didPop(result),
      pages: [page],
    );
  }
}
