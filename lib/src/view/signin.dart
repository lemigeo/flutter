import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../component.dart';
import '../model.dart';
import '../store.dart';
import '../auth.dart';
import '../router.dart';

class SignInView extends StatelessWidget {
  const SignInView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _SessionModel>(
        converter: (store) => _SessionModel.create(store),
        builder: (context, _SessionModel model) {
          return SignInViewWidget(model: model);
        });
  }
}

class SignInViewWidget extends StatefulWidget {
  final _SessionModel model;

  const SignInViewWidget({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  _SignInViewWidgetState createState() => _SignInViewWidgetState();
}

class _SignInViewWidgetState extends State<SignInViewWidget> {
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        // clearCache: true,
        userAgent:
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
        useShouldOverrideUrlLoading: true,
        useShouldInterceptAjaxRequest: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  late PullToRefreshController pullToRefreshController;
  Uri uri = Uri.parse(dotenv.get('AUTH_URL'));

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = AuthScope.of(context);
    final routeState = RouteStateScope.of(context);

    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      Expanded(
          child: Stack(children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: uri),
          initialOptions: options,
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          // onLoadStart: (controller, url) {
          // },
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          shouldInterceptAjaxRequest: (controller, ajaxRequest) async {
            return ajaxRequest;
          },
          onAjaxReadyStateChange: (controller, ajaxRequest) async {
            if (ajaxRequest.url.toString().contains("session/info") &&
                ajaxRequest.responseText != null) {
              Map<String, dynamic> resp =
                  jsonDecode(ajaxRequest.responseText.toString());
              if (!resp.containsKey("errorCode")) {
                String cookies = await Cookies.getCookies(uri);
                if (cookies.isNotEmpty) {
                  widget.model.onCreated(User.fromJson(resp), cookies);
                  var signedIn = await authState.signIn(true);
                  if (signedIn) {
                    routeState.go('/users');
                  }
                }
              }
            }

            return AjaxRequestAction.PROCEED;
          },
          onAjaxProgress: (controller, ajaxRequest) async {
            return AjaxRequestAction.PROCEED;
          },
          shouldInterceptFetchRequest: (controller, fetchRequest) async {
            return fetchRequest;
          },
        )
      ])),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "back",
            child: const Icon(Icons.arrow_back),
            backgroundColor: Colors.grey.shade400,
            onPressed: () {
              webViewController?.goBack();
            },
          ),
          FloatingActionButton(
            heroTag: "forward",
            child: const Icon(Icons.arrow_forward),
            backgroundColor: Colors.grey.shade400,
            onPressed: () {
              webViewController?.goForward();
            },
          ),
          FloatingActionButton(
            heroTag: "reload",
            child: const Icon(Icons.refresh),
            backgroundColor: Colors.grey.shade400,
            onPressed: () {
              webViewController?.reload();
            },
          ),
        ],
      ),
    ])));
  }
}

class _SessionModel {
  final Session session;
  final Function(User, String) onCreated;

  _SessionModel({required this.session, required this.onCreated});

  factory _SessionModel.create(Store<AppState> store) {
    _onCreated(User user, String cookies) {
      store.dispatch(SetSession(user, cookies));
    }

    return _SessionModel(session: store.state.session, onCreated: _onCreated);
  }
}
