import 'dart:async';
import 'package:beu_flutter/screens/customer/customer_dashboard_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
import 'package:beu_flutter/screens/welcome_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  SharedPreferences prefs;
  String userid, usertype, token;

  @override
  initState() {
    super.initState();
    _getSharedPrefs();

    Timer(const Duration(seconds: 4), onNavigate);
  }

  Future<Null> _getSharedPrefs() async {
    _firebaseMessaging.requestNotificationPermissions();
    token = await _firebaseMessaging.getToken();
    print("token: $token");
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
      usertype = prefs.getString("usertype");
      if (token != null && token != "") {
        prefs.setString("fcm_token", token);
      }
    });
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('I have a cloud messaging message yay');
    //     print('onMessage: $message');
    //   },
    //   onBackgroundMessage: (Map<String, dynamic> message) async {
    //     print('onBackgroundMessage: $message');
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('onLaunch: $message');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print('onResume: $message');
    //   },
    // );
    print("$userid : $usertype");
  }

  Widget _bodyWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Image.asset(
        "assets/images/beu_logo.png",
        color: Colors.white,
        height: 200,
        width: 200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  void onNavigate() {
    if (userid != null && userid != "") {
      if (usertype != null && usertype == "customer") {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            maintainState: true,
            opaque: true,
            pageBuilder: (context, _, __) => CustomerDashboardScreen(),
            transitionDuration: const Duration(seconds: 2),
            transitionsBuilder: (context, anim1, anim2, child) {
              return FadeTransition(
                child: child,
                opacity: anim1,
              );
            },
          ),
        );
      } else if (usertype != null && usertype == "vendor") {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            maintainState: true,
            opaque: true,
            pageBuilder: (context, _, __) => VendorDashboardScreen(),
            transitionDuration: const Duration(seconds: 2),
            transitionsBuilder: (context, anim1, anim2, child) {
              return FadeTransition(
                child: child,
                opacity: anim1,
              );
            },
          ),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          maintainState: true,
          opaque: true,
          pageBuilder: (context, _, __) => WelcomeScreen(),
          transitionDuration: const Duration(seconds: 2),
          transitionsBuilder: (context, anim1, anim2, child) {
            return FadeTransition(
              child: child,
              opacity: anim1,
            );
          },
        ),
      );
    }
  }
}
