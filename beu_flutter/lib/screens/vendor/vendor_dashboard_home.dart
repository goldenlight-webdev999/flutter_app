import 'dart:convert';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/booking.dart';
import 'package:beu_flutter/screens/vendor/set_service_price_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beu_flutter/widgets/pageIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorDashboardHomeScreen extends StatefulWidget {
  @override
  _VendorDashboardHomeScreenState createState() =>
      _VendorDashboardHomeScreenState();
}

class _VendorDashboardHomeScreenState extends State<VendorDashboardHomeScreen> {
  SharedPreferences prefs;
  final _controller = PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  List<Booking> bookingList;
  List<Booking> onGoingBookingList;
  List<Booking> completedBookingList;
  String userid, usertype;
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
      usertype = prefs.getString("usertype");
      print("$userid : $usertype");
      _getAllBookings(userid, usertype);
    });
  }

  void _getAllBookings(String userid, String userType) async {
    print("_getAllBookings");
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().getAllBookings(
      userid,
      userType,
    );
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['errorcode'] == 0) {
        if (json['data'] != null) {
          var bookings = json['data'] as List;
          setState(() {
            bookingList = bookings
                .map<Booking>((json) => Booking.fromJson(json))
                .toList();
            print("Booking List Count: ${bookingList.length}");
            onGoingBookingList = [];
            completedBookingList = [];
            bookingList.forEach((booking) {
              print(booking.bookingstatus);
              if (booking.bookingstatus == "null") {
                onGoingBookingList.add(booking);
              } else {
                completedBookingList.add(booking);
              }
            });
            setState(() {
              onGoingBookingList = onGoingBookingList.reversed.toList();
              completedBookingList = completedBookingList.reversed.toList();
            });
          });
        }
      } else {
        CommonUtils().showMessage(context, json["message"], () {
          Navigator.pop(context);
        });
      }
    } else {
      CommonUtils().showMessage(context, "Something went wrong!", () {
        Navigator.pop(context);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _completeBooking(String vendorid, String bookingid) async {
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().completeBooking(
      vendorid,
      bookingid,
    );
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['errorcode'] == 0) {
        CommonUtils().showMessage(context, json["message"], () {
          Navigator.pop(context);
        });
        _getAllBookings(userid, usertype);
      } else {
        CommonUtils().showMessage(context, json["message"], () {
          Navigator.pop(context);
        });
      }
    } else {
      CommonUtils().showMessage(context, "Something went wrong!", () {
        Navigator.pop(context);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _cancelBooking(String vendorid, String bookingid) async {
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().cancelBooking(
      vendorid,
      bookingid,
    );
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['errorcode'] == 0) {
        CommonUtils().showMessage(context, json["message"], () {
          Navigator.pop(context);
        });
        _getAllBookings(userid, usertype);
      } else {
        CommonUtils().showMessage(context, json["message"], () {
          Navigator.pop(context);
        });
      }
    } else {
      CommonUtils().showMessage(context, "Something went wrong!", () {
        Navigator.pop(context);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _bodyWidget() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 24, top: 8),
              child: Text(
                "On-going Services",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins-Bold",
                    fontSize: 14),
              ),
            ),
            onGoingBookingList != null && onGoingBookingList.length > 0
                ? Container(
                    height: 280,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: onGoingBookingList.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildOnGoingCell(
                            onGoingBookingList[index]); // you forgot this
                      },
                    ),
                  )
                : Container(
                    height: 280,
                    child: Center(
                      child: Text(
                        "Not Available!",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins-Bold",
                            fontSize: 16),
                      ),
                    ),
                  ),
            Center(
              child: onGoingBookingList != null && onGoingBookingList.length > 0
                  ? DotsIndicator(
                      controller: _controller,
                      itemCount: onGoingBookingList.length,
                      onPageSelected: (int page) {
                        _controller.animateToPage(
                          page,
                          duration: _kDuration,
                          curve: _kCurve,
                        );
                      },
                    )
                  : Container(),
            ),
            Container(
              margin: EdgeInsets.only(left: 24, top: 8),
              child: Text(
                "Completed Services",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins-Bold",
                    fontSize: 16),
              ),
            ),
            _buildTrendingServices(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnGoingCell(Booking booking) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
        ),
        Container(
          width: double.infinity,
          height: 200,
          margin: EdgeInsets.only(top: 8, left: 24, right: 24),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                booking.vendor.profilepic,
                fit: BoxFit.cover,
              )),
        ),
        Positioned(
          bottom: 10,
          right: 2,
          left: 2,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(18)),
            margin: EdgeInsets.only(left: 44, right: 44),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  booking.innerCategory.category_name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins-Bold'),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  booking.user.fullname,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Poppins-Bold'),
                ),
                SizedBox(
                  height: 2,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        booking.user.mobileno,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: "Poppins-Bold",
                        ),
                        maxLines: 2,
                      ),
                    ),
                    // Icon(
                    //   Icons.location_on,
                    //   color: Colors.blue,
                    //   size: 18,
                    // ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        booking.address,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 10,
                          fontFamily: "Poppins-Bold",
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "\$${booking.price}",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontFamily: "Poppins-Bold",
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _showBookingCompleteMessage(
                                context,
                                "Are you sure, want to complete booking?",
                                booking.vendor.userid,
                                booking.bookingid,
                              ),
                              child: Text(
                                "Complete Booking",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "Poppins-Bold",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Image.asset(
                              "assets/images/arrow_forward.png",
                              height: 20,
                              width: 20,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _showBookingCancelMessage(
                                context,
                                "Are you sure you want to cancel this booking?",
                                booking.vendor.userid,
                                booking.bookingid,
                              ),
                              child: Text(
                                "Cancel Booking",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontFamily: "Poppins-Bold",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCompletedCell(Booking booking) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      width: 180,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 92,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: Image.network(
                      booking.vendor.profilepic,
                      height: 86,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    )),
                Positioned(
                  bottom: 12,
                  left: 6,
                  child: Text(
                    booking.user.fullname,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins-Bold",
                        fontSize: 12),
                  ),
                ),
                // Positioned(
                //   right: 10,
                //   bottom: 0,
                //   child: CircleAvatar(
                //       radius: 12,
                //       backgroundColor: Colors.blue,
                //       child: Icon(
                //         Icons.send,
                //         color: Colors.white,
                //         size: 12,
                //       )),
                // ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6, right: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  booking.innerCategory.category_name,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins-Bold",
                      fontSize: 11),
                ),
                SizedBox(height: 2),
                Text(
                  booking.user.mobileno,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontFamily: "Poppins-Bold",
                  ),
                ),
                Text(
                  booking.address,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 8,
                    fontFamily: "Poppins-Bold",
                  ),
                  maxLines: 2,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "\$${booking.price}",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontFamily: "Poppins-LightItalic",
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            booking.date,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontFamily: "Poppins-Light",
                            ),
                          ),
                          // Text(
                          //   "Time",
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 8,
                          //     fontFamily: "Poppins-Light",
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingServices() {
    return Container(
      margin: EdgeInsets.only(left: 24, top: 12),
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: completedBookingList != null && completedBookingList.length > 0
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: completedBookingList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildCompletedCell(completedBookingList[index]);
              },
            )
          : Container(
              height: 280,
              child: Center(
                child: Text(
                  "Not Available!",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins-Bold",
                      fontSize: 16),
                ),
              ),
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
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => SetServicePriceScreen(),
    ));
  }

  void _showBookingCompleteMessage(
      BuildContext context, String message, String vendorid, String bookingid) {
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
                'Yes',
                textScaleFactor: 1.0,
              ),
              onPressed: () {
                Navigator.pop(context);
                _completeBooking(vendorid, bookingid);
              },
            ),
            FlatButton(
              child: Text(
                'No',
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

  void _showBookingCancelMessage(
      BuildContext context, String message, String vendorid, String bookingid) {
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
                'Yes',
                textScaleFactor: 1.0,
              ),
              onPressed: () {
                Navigator.pop(context);
                _cancelBooking(vendorid, bookingid);
              },
            ),
            FlatButton(
              child: Text(
                'No',
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
}
