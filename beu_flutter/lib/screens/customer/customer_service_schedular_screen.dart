import 'dart:convert';

import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/slot_available.dart';

import 'package:beu_flutter/screens/customer/customer_book_service_screen.dart';
import 'package:beu_flutter/screens/customer/service_vendor_details.dart';
import 'package:beu_flutter/screens/customer/vendor_service_gallery.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:beu_flutter/models/vendor_price_list.dart' as ven;

class ServiceSchedularScreen extends StatefulWidget {
  ven.Services data;
  ven.Vendor vendor;
  ServiceSchedularScreen({this.data, this.vendor});
  @override
  _ServiceSchedularScreenState createState() => _ServiceSchedularScreenState();
}

class _ServiceSchedularScreenState extends State<ServiceSchedularScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _slotScrollController = ScrollController();
  CalendarController _calendarController = CalendarController();
  final Map<CalendarFormat, String> _calendarFormat = {
    CalendarFormat.month: "month",
  };
  Map<DateTime, List<dynamic>> _events;

  SharedPreferences prefs;
  bool _isBooked = true;
  String userid, _day, _month, _year, _slotId;
  bool _isAvailable = false;
  int _defaultChoiceIndex = -1;
  var now;
  @override
  initState() {
    setState(() {
      now = new DateTime.now();
      _day = new DateTime.now().day.toString();
      _month = new DateTime.now().month.toString();
      _year = new DateTime.now().year.toString();
    });
    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
    });
    print(userid);
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 42, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.keyboard_backspace,
                        color: Colors.white,
                        size: 30,
                      )),
                  Spacer(),
                  GestureDetector(
                      child: Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 24,
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Text(
                "Calendar",
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontFamily: 'Poppins-ExtraBold',
                    letterSpacing: 0.4),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: TableCalendar(
                calendarController: _calendarController,
                headerVisible: true,
                rowHeight: 42,
                startDay: DateTime.now(),
                initialCalendarFormat: CalendarFormat.month,
                availableCalendarFormats: _calendarFormat,
                availableGestures: AvailableGestures.none,
                onUnavailableDaySelected: null,
                initialSelectedDay: DateTime.now(),
                onDaySelected: _onDaySelected,
                events: _events,
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonVisible: true,
                  formatButtonShowsNext: false,
                  titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins-Bold",
                      fontSize: 20),
                  leftChevronIcon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                  rightChevronIcon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 0.6))),
                  headerMargin: EdgeInsets.only(bottom: 12),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.white),
                  weekdayStyle: TextStyle(color: Colors.white),
                ),
                calendarStyle: CalendarStyle(
                  selectedColor: Colors.white,
                  selectedStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.blue),
                  highlightSelected: true,
                  holidayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white),
                  weekdayStyle: TextStyle(color: Colors.white),
                  outsideWeekendStyle: TextStyle(color: Colors.white),
                  todayColor: Colors.transparent,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.white),
                  renderDaysOfWeek: true,
                  markersMaxAmount: 0,
                  outsideDaysVisible: false,
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
              ),
            ),
            Divider(
              color: Colors.white,
              indent: 24,
              endIndent: 24,
            ),
            _buildAvailableService(),
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
    setState(() {
      now = new DateTime.now();
    });
    return new Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildAvailableService() {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 24, top: 8),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 140,
                      padding: EdgeInsets.only(
                          left: 120, right: 12, top: 4, bottom: 4),
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 10, top: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Poppins-ExtraBold'),
                                      text: widget
                                          .data.innercategory.categoryName),
                                ),
                              ),
                            ],
                          ),
                          RatingBar(
                            itemSize: 14,
                            initialRating: widget.vendor.ratevalue.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            unratedColor: Colors.black,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: null,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.vendor.mobileno,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins-Bold',
                                    fontSize: 10),
                              ),
                              Spacer(),
                              Icon(
                                Icons.location_on,
                                color: Colours.welcome_bg,
                                size: 14,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 10),
                                      text: widget.vendor.address),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Slots available:",
                            style: TextStyle(
                                color: Colours.wel_bg_gd6,
                                fontFamily: 'Poppins-Bold',
                                fontSize: 12),
                            maxLines: 3,
                          ),
                          Container(height: 30, child: _slotting()),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 120,
                        height: 150,
                        //padding: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            color: Colours.darkGrey,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.data.innercategory.image,
                            width: 120,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          onNavigateToGallery(
                              widget.vendor.userid, widget.data.innercategory);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          child: Image.asset(
                            "assets/images/art.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: onNavigateBookService,
                  child: RegularButton(
                    regularText: "Done",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onDaySelected(DateTime day, List events, List lists) {
    setState(() {
      _day = day.day.toString();
      _month = day.month.toString();
      _year = day.year.toString();
      _isAvailable = true;
      _isBooked = false;
    });
    _getslots();
  }

  void onNavigate() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new ServiceVendorDetailsScreen(),
    ));
  }

  Future<slot_availability> _getslots() async {
    final response = await ApiService().getSlotList(
        userid, widget.vendor.userid, _day, _month, _year);
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

  void onNavigateBookService() {
    if (_slotId == null || _slotId == "") {
      CommonUtils().showMessage(context, "Please Select the time slot", () {
        Navigator.pop(context);
      });
    } else {
      Navigator.of(context).push(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new BookServiceScreen(
            userid: userid,
            vendorid: widget.vendor.userid,
            day: _day,
            month: _month,
            year: _year,
            slotId: _slotId,
            innercategory: widget.data),
      ));
    }
  }

  void onNavigateToGallery(String userid, ven.ServiceInnercategory inner) {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new VendorGalleryPhotosScreen(
        vendorid: userid,
        inner: inner,
      ),
    ));
  }

  _slotting() {
    return Container(
      height: 30,
      child: FutureBuilder<slot_availability>(
          future: _getslots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              if (snapshot.data.slotTime.length == 0) {
                return Center(child: Text("No slot found"));
              } else {
                return Container(
                  height: 28,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      controller: _slotScrollController,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data.slotTime.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _defaultChoiceIndex = index;
                              _slotId = snapshot.data.slotTime[index].slotid;
                            });
                          },
                          child: Container(
                            height: 28,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(18),
                                color: _defaultChoiceIndex == index
                                    ? Colours.welcome_bg
                                    : Colours.darkGrey),
                            margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.only(
                                top: 2, bottom: 1, left: 14, right: 14),
                            child: Center(
                              child: Text(
                                "${snapshot.data.slotTime[index].slot_starttime}:00 - ${snapshot.data.slotTime[index].slot_endtime}:00",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Poppins-Light',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
            }
            return Text("Loading .... ");
          }),
    );
  }
}
