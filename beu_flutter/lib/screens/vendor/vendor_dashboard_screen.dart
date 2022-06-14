import 'dart:convert';

import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/screens/chat_history_screen.dart';
import 'package:beu_flutter/screens/vendor/Vendor_payment_info_screen.dart';
import 'package:beu_flutter/screens/notifications_screen.dart';
import 'package:beu_flutter/screens/vendor/set_price_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_dashboard_home.dart';
import 'package:beu_flutter/screens/vendor/vendor_profile_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_search_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_set_availability_screen_.dart';
import 'package:beu_flutter/screens/vendor/vendor_contact_us_screen.dart';
import 'package:beu_flutter/screens/welcome_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/utils/confirmationAlertDialoge.dart';
import 'package:flutter/cupertino.dart';
import 'package:beu_flutter/screens/vendor/my_vendor_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorDashboardScreen extends StatefulWidget {
  @override
  _VendorDashboardScreenState createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SharedPreferences prefs;
  String profilepic;
  String fullname;
  String userid, token;

  bool _isHome = true;
  bool _isRecent = false;
  bool _isSetting = false;
  bool _isChat = false;
  bool popMessage = false;

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
      token = prefs.getString("fcm_token");
      popMessage = prefs.getBool("messageShow");
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
    _updateToken();
    if (popMessage) {
      // ignore: await_only_futures
      await showPopUpMessage(
          context, "COVID-19\nSlow down the spread of Covid-19, Wear a mask.",
          () {
        Navigator.pop(context);
        // showPopUpBackgroundCheck(
        //   context,
        //   "To become a BEU vendor, \nwe require a background check, please click the link and purchase the Starter Check and send the report to info@beu.salon.\nhttps://www.goodhire.com/personal-background-checks/ ",
        //   "https://www.goodhire.com/personal-background-checks/");
      });
      

      prefs.setBool("messageShow", false);
    }
    print(profilepic);
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      CommonUtils()
          .showMessage(context, "Cannot open", () => Navigator.pop(context));
    }
  }

  Widget _navView() {
    return Drawer(
      child: Container(
        padding: EdgeInsets.all(42),
        color: Colours.welcome_bg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 120,
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.redAccent)),
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: onNavigateProfile,
                child: Container(
                  width: 110,
                  height: 110,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: profilepic != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(55),
                          child: Image.network(
                            profilepic,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          "assets/images/man.png",
                          width: 92,
                          height: 92,
                        ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  fullname != null ? fullname : "Fullname",
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Poppins-Bold',
                      fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 24,
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
              height: 16,
            ),
            Divider(
              height: 2,
              color: Colors.white,
              endIndent: 0,
              thickness: 1,
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: onNavigateBooking,
              child: Text(
                "My Bookings".toUpperCase(),
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              height: 2,
              color: Colors.white,
              endIndent: 0,
              thickness: 1,
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => VendorPaymentInfoScreen(userid: userid)));
              },
              child: Text(
                "Payment Info".toUpperCase(),
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              height: 2,
              color: Colors.white,
              endIndent: 0,
              thickness: 1,
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: onNavigateSetting,
              child: Text(
                "Set Price".toUpperCase(),
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 16,
                    color: Colors.white),
              ),
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
              onTap: () {
                Navigator.of(context).pop();
                _showLogoutMessage(context, "Are you sure, want to logout?");
              },
              child: Text(
                "Logout",
                style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 20,
                    color: Colors.redAccent),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Divider(
              height: 2,
              color: Colors.white,
              endIndent: 0,
              thickness: 1,
            ),
            SizedBox(
              height: 12,
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
              height: 8,
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
              height: 12,
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
          length: 4,
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
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: onNavigateNotifications,
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                VendorDashboardHomeScreen(),
                VendorSetAvailabilityScreen(),
                SetPriceScreen(false),
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
                        _isSetting = false;
                        _isChat = false;
                      });
                    } else if (index == 1) {
                      setState(() {
                        _isHome = false;
                        _isRecent = true;
                        _isSetting = false;
                        _isChat = false;
                      });
                    } else if (index == 2) {
                      setState(() {
                        _isHome = false;
                        _isRecent = false;
                        _isSetting = true;
                        _isChat = false;
                      });
                    } else if (index == 3) {
                      setState(() {
                        _isHome = false;
                        _isRecent = false;
                        _isSetting = false;
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
                      Icons.settings,
                      color: _isSetting ? Colours.welcome_bg : Colors.blueGrey,
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

  void onNavigateProfile() {
    Navigator.pop(context);
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => VendorProfileScreen(),
      ),
    );
  }

  void onNavigateSetting() {
    Navigator.pop(context);
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => SetPriceScreen(true),
      ),
    );
  }

  void onNavigateBooking() {
    Navigator.pop(context);
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => MyVendorBookingScreen(
            bookScreen: "book", userid: userid, usertype: "vendor"),
      ),
    );
  }

  void onNavigateNotifications() {
    Navigator.pop(context);
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => NotificationsScreen(),
      ),
    );
  }

  void onNavigateSearch() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => VendorSearchScreen(),
      ),
    );
  }

  void onNavigateContactUs() {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => VendorContactUsScreen(userId: userid),
    ));
  }

  void _showLogoutMessage(BuildContext context, String message) {
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
                await prefs.clear();
                await Future.delayed(Duration(seconds: 0));
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) => WelcomeScreen(),
                  ),
                  (Route route) => false,
                );
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

  void _updateToken() async {
    if (userid != null || token != null) {
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
}
