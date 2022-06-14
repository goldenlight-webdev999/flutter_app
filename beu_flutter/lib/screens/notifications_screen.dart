import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/customer_notification.dart' as not;
import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<not.Notification> item = new List<not.Notification>();
  final ScrollController _scrollController = ScrollController();
  Duration timeZoneOffSet = null;
  final int SERVER_TIMEZONE_OFFSET = 5;
  int i;
  String userid;
  SharedPreferences prefs;
  @override
  initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
    });
  }

  Widget _bodyWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 44, left: 32, right: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          tileMode: TileMode.mirror,
          end: Alignment.bottomCenter,
          colors: [
            Colours.welcome_bg,
            Colours.wel_bg_gd4,
            Colours.wel_bg_gd5,
            Colours.wel_bg_gd6,
            Colours.welcome_bg_gd2
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
              onTap: onNavigate,
              child: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
                size: 30,
              )),
          SizedBox(
            height: 16,
          ),
          Text(
            "Notifications",
            style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontFamily: 'Poppins-ExtraBold',
                letterSpacing: 0.4),
          ),
          _buildNotificationList(),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildNotificationList() {



    return FutureBuilder<dynamic>(
        future: _getNotificationDataList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
                alignment: Alignment.topCenter,
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins-ExtraBold'),
                ));
          }
          if (snapshot.hasData) {
            if (snapshot.data.notification.length == 0) {
              return Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "No Notification",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins-ExtraBold'),
                  ));
            } else {
              item = snapshot.data.notification.reversed.toList();
              return Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: item.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: null,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 8),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            child: Image.asset(
                                              "assets/images/beu_logo.png",
                                              height: 80,
                                              width: 80,
                                              color: Colours.welcome_bg,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                item[index].message,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'Poppins-Light',
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                //new DateFormat("MMM-dd hh:mm")
                                                    //.format(DateTime.tryParse(
                                                        //item[index].createdts).toLocal()),
                                                    new DateFormat("MMM-dd hh:mm").format(DateTime.tryParse(item[index].createdts).add(timeZoneOffSet)),
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    fontFamily: 'Poppins-Light',
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                )
                              ]);
                        }),
                  ),
                ),
              );
            }
          }
          return Container(
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator());
        });
  }

  void setTimeZoneOffSet(){

    var currentOffSetToUtc = DateTime.now().timeZoneOffset;
    timeZoneOffSet = currentOffSetToUtc;

    timeZoneOffSet = timeZoneOffSet - new Duration(hours: SERVER_TIMEZONE_OFFSET);
  }

  Future<dynamic> _getNotificationDataList() async {
    final response = await ApiService().getNotificationList(userid);

    //Calculates the timezone offset between the user and the server
    setTimeZoneOffSet();

    if (response != null) {
      var json = jsonDecode(response.toString());
      print("JSON Data" + response.toString());
      print(json);
      if (json['data'] != null && json['errorcode'] == 0) {
        print(json['data']);
        var notificationList = not.CustomerNotification.fromJson(json['data'][0]);

        return notificationList;
      } else {
        return Future.error(json['message']);
      }
    } else {
      return Future.error("Loading...");
    }
  }

  void onNavigate() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new VendorDashboardScreen(),
    ));
  }
}
