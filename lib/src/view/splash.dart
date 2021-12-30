import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../router.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  String? _token;

  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.instance.requestPermission();
    // _init();
    //call api for loading
    Timer(const Duration(seconds: 3), () {
      // debugPrint('token - ' + _token!);
      RouteStateScope.of(context).go('/signin');
    });
  }

  void _init() async {
    RemoteMessage? msg = await FirebaseMessaging.instance.getInitialMessage();
    if (msg != null) {
      if (Platform.isIOS) {
        _token = await FirebaseMessaging.instance.getAPNSToken();
      } else {
        _token = await FirebaseMessaging.instance.getToken();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CircularProgressIndicator(
                backgroundColor: Colors.white, strokeWidth: 6),
            SizedBox(height: 20),
            Text('Now loading...',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(offset: Offset(4, 4), color: Colors.white10)
                    ],
                    decorationStyle: TextDecorationStyle.solid))
          ],
        ),
      ),
    );
  }
}
