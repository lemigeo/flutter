import 'package:flutter/material.dart';

import '../router.dart';
import '../view/signin.dart';
import '../view/scaffold.dart';
import '../view/splash.dart';
import '../component/fade_transition_page.dart';

/// Builds the top-level navigator for the app. The pages to display are based
/// on the `routeState` that was parsed by the TemplateRouteParser.
class AppNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const AppNavigator({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final _splashKey = const ValueKey('Splash');
  final _signInKey = const ValueKey('Sign in');
  final _scaffoldKey = const ValueKey<String>('App scaffold');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        debugPrint((route.settings as Page).key.toString());
        // When a page that is stacked on top of the scaffold is popped, display
        // the /books or /authors tab in BookstoreScaffold.
        // if (route.settings is Page &&
        //     (route.settings as Page).key == _bookDetailsKey) {
        //   routeState.go('/books/popular');
        // }

        // if (route.settings is Page &&
        //     (route.settings as Page).key == _authorDetailsKey) {
        //   routeState.go('/authors');
        // }

        return route.didPop(result);
      },
      pages: [
        if (routeState.route.pathTemplate == '/')
          FadeTransitionPage<void>(
            key: _splashKey,
            child: const SplashView(),
          )
        else if (routeState.route.pathTemplate == '/signin')
          // Display the sign in screen.
          FadeTransitionPage<void>(
            key: _signInKey,
            child: const SignInView(),
          )
        else ...[
          // Display the app
          FadeTransitionPage<void>(
            key: _scaffoldKey,
            child: const AppScaffold(),
          ),
        ],
      ],
    );
  }
}
