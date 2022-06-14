import 'dart:convert';
import 'package:beu_flutter/models/booking.dart';
import 'package:beu_flutter/models/myBookingList.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/screens/notifications_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:beu_flutter/models/slot_available.dart';

class MyVendorBookingScreen extends StatefulWidget {
  final String bookScreen;
  String usertype;
  String userid;
  MyVendorBookingScreen({this.bookScreen, this.userid, this.usertype});
  @override
  _MyVendorBookingScreenState createState() =>
      _MyVendorBookingScreenState(bookScreen);
}

class _MyVendorBookingScreenState extends State<MyVendorBookingScreen> {
  String bookScreen;
  _MyVendorBookingScreenState(this.bookScreen);
  final ScrollController _scrollController = ScrollController();

  bool visible = false;
  List<BookingItem> myList = new List<BookingItem>();
  List<String> _serviceList = List();
  Map<String, slot_availability> _slotDetailsById = Map();

  @override
  initState() {
    super.initState();
    _isVisible();
    print("vendor");
  }

  _isVisible() {
    if (bookScreen == "book") {
      setState(() {
        visible = true;
      });
    }
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
          Visibility(
            visible: visible,
            child: Container(
              padding:
                  EdgeInsets.only(top: 42, left: 24, right: 24, bottom: 12),
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
                  Spacer(),
                  // GestureDetector(
                  //     onTap: onNavigateNotification,
                  //     child: Icon(
                  //       Icons.search,
                  //       color: Colors.white,
                  //       size: 24,
                  //     )),
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
          ),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "My \nBookings",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontFamily: 'Poppins-ExtraBold',
                      letterSpacing: 0.2),
                ),
              ],
            ),
          ),
          _buildBookingList(),
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

  Widget _buildBookingList() {
    return FutureBuilder<dynamic>(
        future: _getBookingDataList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
                alignment: Alignment.topCenter,
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins-ExtraBold'),
                ));
          }
          if (snapshot.hasData) {
            if (snapshot.data.data.length == 0) {
              return Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "No Booking",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins-ExtraBold'),
                  ));
            } else {
              myList = snapshot.data.data.reversed.toList();
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
                        itemCount: myList.length,
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
                                      height: 140,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 128,
                                          right: 12,
                                          top: 4,
                                          bottom: 4),
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.only(left: 10, top: 16),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                myList[index].user.fullname,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'Poppins-ExtraBold'),
                                              ),
                                              RatingBar(
                                                itemSize: 14,
                                                initialRating: double.parse(
                                                    myList[index]
                                                        .vendor
                                                        .ratevalue),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                unratedColor: Colors.black,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: null,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(
                                              myList[index]
                                                  .innercategory
                                                  .categoryName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontFamily: "Poppins-Bold",
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                Icons.location_on,
                                                color: Colours.welcome_bg,
                                                size: 14,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: Text(
                                                  myList[index].address,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontFamily:
                                                          'Poppins-Bold',
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  myList[index].mobileno,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'Poppins-Bold',
                                                      fontSize: 10),
                                                ),
                                                Text(
                                                  myList[index].fullname,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontFamily:
                                                          'Poppins-Bold',
                                                      fontSize: 8),
                                                  maxLines: 3,
                                                ),
                                              ]),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                _buildDateTimeString(
                                                    myList[index]),
                                                style: TextStyle(
                                                    color: Colours.welcome_bg,
                                                    fontFamily: 'Poppins-Bold',
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "\$${myList[index].price}",
                                                style: TextStyle(
                                                    color: Colours.welcome_bg,
                                                    fontFamily: 'Poppins-Bold',
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      child: Container(
                                        width: 130,
                                        height: 140,
                                        //padding: const EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                            color: Colours.darkGrey,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            myList[index].user.profilepic,
                                            width: 120,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
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
          }
          return Container(
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator());
        });
  }

  String _buildDateTimeString(BookingItem bookingItem) {
    String startTimeString =
        _slotDetailsById[bookingItem.slotid].slotTime[0].slot_starttime + ":00";
    String endTimeString =
        _slotDetailsById[bookingItem.slotid].slotTime[0].slot_endtime + ":00";
    return bookingItem.date + "\n$startTimeString to $endTimeString";
  }

  void onNavigate() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => VendorDashboardScreen(),
    ));
  }

  void onNavigateNotification() {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => NotificationsScreen(),
    ));
  }

  Future<dynamic> _getBookingDataList() async {
    final response = await ApiService().getBookingList(widget.userid, "vendor");
    if (response != null) {
      var json = jsonDecode(response.toString());
      print("JSON Data" + response.toString());
      print(json);
      if (json['data'] != null && json['errorcode'] == 0) {
        print(json['data']);

        BookingList bookingList = BookingList.fromJson(json);

        // peter: Get the time ranges for each slot associated
        // with each booking. We need this so we can display the
        // time on each booking.
        for (var bookingItem in bookingList.data) {
          if (bookingItem.slotid != " ") {
            slot_availability slotDetails = await _getslot(bookingItem.slotid);

            // peter: Store the slot details
            _slotDetailsById[bookingItem.slotid] = slotDetails;
          }
        }

        return bookingList;
      } else {
        return Future.error(json['message']);
      }
    } else {
      return Future.error("Something went Wrong !!");
    }
  }

  Future<slot_availability> _getslot(String timeSlotId) async {
    final response = await ApiService().getTimeSlotById(timeSlotId);
    if (response != null) {
      final json = jsonDecode(response.toString());
      print(json);
      if (json['data'] != null) {
        return slot_availability.fromJson(json);
      } else {
        return Future.error(json['message']);
      }
    } else {
      return Future.error("Something went Wrong !!");
    }
  }
}
