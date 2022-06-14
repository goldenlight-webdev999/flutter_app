import 'package:beu_flutter/screens/notifications_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/widgets/searchField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VendorSearchScreen extends StatefulWidget {
  @override
  _VendorSearchScreenState createState() => _VendorSearchScreenState();
}

class _VendorSearchScreenState extends State<VendorSearchScreen> {
  final ScrollController _scrollController = ScrollController();

  List<String> _serviceList = List();

  @override
  initState() {
    super.initState();
  }

  Widget _bodyWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
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
          Container(
            padding: EdgeInsets.only(top: 42, left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: onNavigate,
                    child: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                      size: 30,
                    )),
                Flexible(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(top: 12, left: 24, right: 24),
                    child: SearchField(
                      regularText: Strings.search,
                      inputType: TextInputType.text,
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: onNavigateNotification,
                    child: Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 24,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          _buildServiceList(),
          SizedBox(
            height: 24,
          )
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

  Widget _buildServiceList() {
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
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 18),
                  child: GestureDetector(
                    onTap: onNavigate,
                    child: Container(
                      padding: EdgeInsets.only(left: 24),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 130,
                          ),
                          Container(
                            height: 110,
                            padding: EdgeInsets.only(
                                left: 120, right: 8, top: 4, bottom: 4),
                            margin: EdgeInsets.only(left: 10, top: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle, color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  "BeautyZoo Studio",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins-ExtraBold'),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colours.welcome_bg,
                                      size: 14,
                                    ),
                                    Text(
                                      "address",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "+918234567893",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 10),
                                    ),
                                    Spacer(),
                                    Text(
                                      "350.00",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                Text(
                                  Strings.monthly_subs_desc,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Poppins-Light',
                                      fontSize: 8),
                                  maxLines: 3,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "completed",
                                      style: TextStyle(
                                          color: Colours.welcome_bg,
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 8),
                                    ),
                                    Text(
                                      "18th April 2020",
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: 'Poppins-Light',
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "7:00pm - 8:00pm",
                                      style: TextStyle(
                                          color: Colours.welcome_bg,
                                          fontFamily: 'Poppins-Light',
                                          fontSize: 8),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            child: Container(
                              width: 120,
                              height: 130,
                              //padding: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                  color: Colours.darkGrey,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/images/home_image.png",
                                  width: 120,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  void onNavigate() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => VendorDashboardScreen(),
    ));
  }

  void onNavigateNotification() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => NotificationsScreen(),
    ));
  }
}
