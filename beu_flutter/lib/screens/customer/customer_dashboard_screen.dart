import 'dart:convert';
import 'package:beu_flutter/screens/customer/customer_contact_us_screen.dart';
import 'package:beu_flutter/screens/welcome_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/screens/chat_history_screen.dart';
import 'package:beu_flutter/screens/customer/customer_dashboard_home.dart';
import 'package:beu_flutter/screens/customer/customer_notifications_screen.dart';
import 'package:beu_flutter/screens/customer/customer_profile_screen.dart';
import 'package:beu_flutter/screens/customer/customer_signin_screen.dart';
import 'package:beu_flutter/screens/customer/my_booking_screen.dart';
import 'package:beu_flutter/screens/customer/payment_info_screen.dart';
import 'package:beu_flutter/screens/customer/select_service_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/utils/confirmationAlertDialoge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDashboardScreen extends StatefulWidget {
  @override
  _CustomerDashboardScreenState createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SharedPreferences prefs;
  String profilepic;
  String fullname;
  String userid;
  String token;

  bool _isHome = true;
  bool _isRecent = false;
  bool _isChat = false;
  bool popMessage = false;
  SharedPreferences preferences;
  @override
  initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
      fullname = prefs.getString("fullname");
      popMessage = prefs.getBool("messageShow");
      token = prefs.getString("fcm_token");
      var pPic = prefs.getString("profilepic");
      if (pPic != null && pPic != "") {
        if (!pPic.contains("http")) {
          setState(() {
            profilepic = "http://18.188.224.232/beu/$profilepic";
          });
        } else {
          profilepic = pPic;
        }
      }
    });
    _updateToken(token);
    if (popMessage) {
      prefs.setBool("messageShow", false);
      showPopUpMessage(
          context, "COVID-19\nSlow down the spread of Covid-19, Wear a mask.",
          () {
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _navView() {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: 42, left: 42),
        color: Colours.welcome_bg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: onNavigate,
              child: Container(
                width: 110,
                height: 110,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: profilepic != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          profilepic,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        "assets/images/man.png",
                        width: 80,
                        height: 80,
                      ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12),
              child: Text(
                fullname != null ? fullname : "Fullname",
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Poppins-Bold',
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 42,
            ),
            GestureDetector(
              onTap: onNavigateNotifications,
              child: Text(
                "Notifications".toUpperCase(),
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Divider(
              height: 3,
              color: Colors.white,
              endIndent: 140,
              thickness: 1,
            ),
            SizedBox(
              height: 18,
            ),
            GestureDetector(
              onTap: onNavigateSelectService,
              child: Text(
                "New Bookings".toUpperCase(),
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: onNavigateMyBookings,
              child: Text(
                "My Bookings".toUpperCase(),
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Divider(
              height: 3,
              color: Colors.white,
              endIndent: 140,
              thickness: 1,
            ),
            SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: () {
                launchURL("http://3.23.77.164/beu/index.php/home/termsanduses");
              },
              child: Text(
                "Terms & Conditions",
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 12,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            GestureDetector(
              onTap: () {
                launchURL("http://3.23.77.164/beu/index.php/home/privacy");
              },
              child: Text(
                "Privacy Policy",
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 12,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            GestureDetector(
              onTap: onNavigateContactUs,
              child: Text(
                "Contact Us",
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 12,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Divider(
              height: 3,
              color: Colors.white,
              endIndent: 140,
              thickness: 1,
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white)),
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => _logOut("Are you sure, want to logout?"),
              child: Text(
                "Logout",
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 20,
                    color: Colors.redAccent),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          SystemNavigator.pop();
        },
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colours.welcome_bg,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        if (_scaffoldKey.currentState.isDrawerOpen) {
                          _scaffoldKey.currentState.openEndDrawer();
                        } else {
                          _scaffoldKey.currentState.openDrawer();
                        }
                      },
                      child: Image.asset(
                        "assets/images/menu.png",
                        width: 28,
                        height: 28,
                      )),
                  Row(
                    children: <Widget>[
                      // GestureDetector(
                      //     child: Icon(
                      //   Icons.search,
                      //   color: Colors.white,
                      //   size: 24,
                      // )),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                          onTap: onNavigateNotifications,
                          child: Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 24,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                CustomerDashboardHomeScreen(userId: userid),
                MyBookingScreen(
                  bookScreen: "",
                  userid: userid,
                  usertype: "customer",
                ),
                ChatHistoryScreen(),
              ],
            ),
            resizeToAvoidBottomInset: false,
            drawer: _navView(),
            bottomNavigationBar: SafeArea(
              child: Material(
                child: TabBar(
                  onTap: (index) {
                    if (index == 0) {
                      setState(() {
                        _isHome = true;
                        _isRecent = false;
                        _isChat = false;
                      });
                    } else if (index == 1) {
                      setState(() {
                        _isHome = false;
                        _isRecent = true;
                        _isChat = false;
                      });
                    } else if (index == 2) {
                      setState(() {
                        _isHome = false;
                        _isRecent = false;
                        _isChat = false;
                      });
                    } else if (index == 3) {
                      setState(() {
                        _isHome = false;
                        _isRecent = false;
                        _isChat = true;
                      });
                    }
                  },
                  indicatorColor: Colors.transparent,
                  tabs: <Widget>[
                    Icon(
                      Icons.home,
                      color: _isHome ? Colours.welcome_bg : Colors.blueGrey,
                    ),
                    Icon(
                      Icons.access_alarm,
                      color: _isRecent ? Colours.welcome_bg : Colors.blueGrey,
                    ),
                    Icon(
                      Icons.chat,
                      color: _isChat ? Colours.welcome_bg : Colors.blueGrey,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void onNavigate() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new CustomerProfileScreen(),
    ));
  }

  void onNavigateMyBookings() {
    String bookScreen = "book";
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new MyBookingScreen(
        bookScreen: bookScreen,
        userid: userid,
        usertype: "customer",
      ),
    ));
  }

void onNavigateContactUs() {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => CustomerContactUsScreen(userId: userid),
    ));
  }

  void onNavigateNotifications() {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => CustomerNotificationsScreen(),
    ));
  }

  void onNavigateSelectService() {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => SelectServiceScreen(userId: userid),
    ));
  }

  void onNavigatePayment() {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => PaymentInfoScreen(),
    ));
  }

  void _logOut(String message) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          title: Text(
            'BEU',
            textScaleFactor: 1.0,
          ),
          content: Text(
            message,
            textScaleFactor: 1.0,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                textScaleFactor: 1.0,
              ),
              onPressed: () async {
                Navigator.pop(context);
                preferences = await SharedPreferences.getInstance();
                preferences.clear().then((onValue) {
                  print("LogOut");
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (Route<dynamic> route) => false);
                });
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                textScaleFactor: 1.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
    return;
  }

  void _updateToken(String _token) async {
    if (userid != null || _token != null || _token.isNotEmpty) {
      final response = await ApiService().updateToken(userid, token);
      if (response != null) {
        final json = jsonDecode(response.toString());
        print(json.toString());
        if (json['errorcode'] != null && json['errorcode'] == 0) {
          print("Token is updated.");
        } else {
          print("Token is not updated");
        }
      }
    }
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      CommonUtils()
          .showMessage(context, "Cannot open", () => Navigator.pop(context));
    }
  }
}
