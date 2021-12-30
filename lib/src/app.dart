import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'auth.dart';
import 'router.dart';
import 'store.dart';
import 'router/navigator.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final store =
      Store<AppState>(appStateReducer, initialState: AppState.initialState());
  final _auth = Auth();
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final RouteState _routeState;
  late final AppRouterDelegate _routerDelegate;
  late final TemplateRouteParser _routeParser;

  @override
  void initState() {
    /// Configure the parser with all of the app's allowed path templates.
    _routeParser = TemplateRouteParser(
      allowedPaths: [
        '/',
        '/signin',
        '/users',
        '/user/:seq',
        '/accounts',
        '/account/:id',
        '/settings'
      ],
      guard: _guard,
      initialRoute: '/',
    );

    _routeState = RouteState(_routeParser);

    _routerDelegate = AppRouterDelegate(
      routeState: _routeState,
      navigatorKey: _navigatorKey,
      builder: (context) => AppNavigator(
        navigatorKey: _navigatorKey,
      ),
    );

    // Listen for when the user logs out and display the signin screen.
    _auth.addListener(_handleAuthStateChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => StoreProvider(
        store: store,
        child: RouteStateScope(
          notifier: _routeState,
          child: AuthScope(
            notifier: _auth,
            child: MaterialApp.router(
              routerDelegate: _routerDelegate,
              routeInformationParser: _routeParser,
              // Revert back to pre-Flutter-2.5 transition behavior:
              // https://github.com/flutter/flutter/issues/82053
              theme: ThemeData(
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                  },
                ),
              ),
            ),
          ),
        ),
      );

  final splashRoute = ParsedRoute('/', '/', {}, {});
  final signInRoute = ParsedRoute('/signin', '/signin', {}, {});
  final usersRoute = ParsedRoute('/users', '/users', {}, {});
  Future<ParsedRoute> _guard(ParsedRoute from) async {
    final signedIn = _auth.signedIn;

    // Go to /signin if the user is not signed in
    if (from == splashRoute) {
      return splashRoute;
    } else if (!signedIn && from != signInRoute) {
      return signInRoute;
    }
    // Go to /users if the user is signed in and tries to go to /signin.
    else if (signedIn && from == signInRoute) {
      return usersRoute;
    }
    return from;
  }

  void _handleAuthStateChanged() {
    if (!_auth.signedIn) {
      _routeState.go('/signin');
    }
  }

  @override
  void dispose() {
    _auth.removeListener(_handleAuthStateChanged);
    _routeState.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }
}
