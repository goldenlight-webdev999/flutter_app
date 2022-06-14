import 'dart:convert';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/time_slot.dart';
import 'package:beu_flutter/screens/vendor/set_service_price_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class VendorSetAvailabilityScreen extends StatefulWidget {
  @override
  _VendorSetAvailabilityScreenState createState() =>
      _VendorSetAvailabilityScreenState();
}

class _VendorSetAvailabilityScreenState
    extends State<VendorSetAvailabilityScreen> {
  SharedPreferences prefs;
  CalendarController _calendarController = CalendarController();
  ScrollController _controller = ScrollController();
  final Map<CalendarFormat, String> _calendarFormat = {
    CalendarFormat.month: "month",
  };
  final int AVAIL_SCREEN_RATIO = 3;
  Map<DateTime, List<dynamic>> _events;
  List<TimeSlot> timeSlotList;
  List<TimeSlot> availableTimeSlotList;
  bool _isLoading = false;
  bool isSwitched = false;
  String isAvailableForMonth = "no";
  String availabilityId = "";
  String userid;
  DateTime selectedDate;

  @override
  initState() {
    super.initState();
    _calendarController = CalendarController();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userid = prefs.getString("userid");
    var d = DateTime.now();
    _getAvaialabilityByMonth(d);
    _getAllAvailableTimeSlots(d);
  }

  void _getAvaialabilityByMonth(DateTime date) async {
    print("_getAvaialabilityByMonth");
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().getMonthAvailability(
      userid,
      Jiffy(date).format("dd"),
      Jiffy(date).format("MM"),
      Jiffy(date).format("yyyy"),
    );
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['errorcode'] == 0) {
        setState(() {
          isAvailableForMonth = json['data'][0]['availability'];
          availabilityId = json['data'][0]['availabilityid'];
          if (isAvailableForMonth == "yes") {
            //setState(() {
            isSwitched = true;
            //});
          }
        });
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

  void _updateAvaialabilityByMonth(String availability, DateTime date) async {
    print("_updateAvaialabilityByMonth");
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().updateVendorByMonth(
      userid,
      Jiffy(date).format("dd"),
      Jiffy(date).format("MM"),
      Jiffy(date).format("yyyy"),
      availability,
    );
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['errorcode'] == 0) {
        CommonUtils().showMessage(context, json["message"], () {
          Navigator.pop(context);
        });
      } else {
        CommonUtils().showMessage(context, json["message"], () {
          Navigator.pop(context);
        });
      }

      //Updates UI with available slots
      _getAllAvailableTimeSlots(date);

    } else {
      CommonUtils().showMessage(context, "Something went wrong!", () {
        Navigator.pop(context);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _getAllAvailableTimeSlots(DateTime date) async {
    print("_getAllAvailableTimeSlots");
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().getAllAvailableSlots(
      userid,
      userid,
      Jiffy(date).format("dd"),
      Jiffy(date).format("MM"),
      Jiffy(date).format("yyyy"),
    );
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print("Getting data for time slots on ${date}: ${json}");
      availableTimeSlotList = [];
      if (json['data'] != null && json['data'].length > 0) {
        var slots = json['data'] as List;
        setState(() {
          availableTimeSlotList =
              slots.map<TimeSlot>((json) => TimeSlot.fromJson(json)).toList();
        });
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

  void _updateAvaialabilityByDate(String status, String slotId,
      String availabilityId, DateTime date) async {
    print("_updateAvaialabilityByDate:" + status);
    setState(() {
      _isLoading = true;
    });

    final response = await ApiService().updateVendorByDate(
      userid,
      Jiffy(date).format("dd"),
      Jiffy(date).format("MM"),
      Jiffy(date).format("yyyy"),
      availabilityId,
      slotId,
      status,
    );
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['errorcode'] == 0) {
        CommonUtils().showMessage(context, json["message"], () {
          Navigator.pop(context);
        });

        //Update data after change
        _getAllAvailableTimeSlots(date);

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

  Widget _buildCell(TimeSlot timeSlot) {
    var isAvailable;
    setState(() {
      isAvailable = (timeSlot.status == "yes") ? true : false;
    });
    print("_buildCell: " + isAvailable.toString());
    return GestureDetector(
      onTap: () => {
        _updateAvaialabilityByDate(
          isAvailable ? "no" : "yes",
          timeSlot.slotid,
          availabilityId,
          selectedDate,
        )
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isAvailable ? Colours.welcome_bg : Colors.white)),
        alignment: Alignment.center,
        child: Text(
          "${timeSlot.slot_starttime} - ${timeSlot.slot_endtime}",
          style: TextStyle(
              color: isAvailable ? Colours.welcome_bg : Colors.white,
              fontFamily: "Poppins-Light"),
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = 54;
    final double itemWidth = (size.width / 2) - 16;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 4, left: 20, right: 20),
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
      height: double.infinity,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Set Availability",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: "Poppins-ExtraBold"),
                ),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                      print(isSwitched);
                      isSwitched
                          ? _updateAvaialabilityByMonth("yes", DateTime.now())
                          : _updateAvaialabilityByMonth("no", DateTime.now());
                    });
                  },
                  activeTrackColor: Color(0xffffffff),
                  activeColor: Color(0xff8cb3e5),
                ),
              ],
            ),
            TableCalendar(
              calendarController: _calendarController,
              headerVisible: true,
              rowHeight: 42,
              initialCalendarFormat: CalendarFormat.month,
              availableCalendarFormats: _calendarFormat,
              availableGestures: AvailableGestures.none,
              onUnavailableDaySelected: null,
              initialSelectedDay: null,
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
                    bottom: BorderSide(color: Colors.white, width: 0.6),
                  ),
                ),
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
            Divider(
              color: Colors.white,
            ),
            Center(
              heightFactor: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Row(
                  //   children: <Widget>[
                  //     Container(
                  //       width: 18,
                  //       height: 18,
                  //       decoration: BoxDecoration(
                  //           shape: BoxShape.rectangle,
                  //           borderRadius: BorderRadius.circular(9),
                  //           color: Colors.white),
                  //       alignment: Alignment.center,
                  //     ),
                  //     SizedBox(width: 8),
                  //     Text(
                  //         "Booked",
                  //         style: TextStyle(
                  //             color: Colors.white70,
                  //             fontSize: 14,
                  //             fontFamily: "Poppins-Bold"),
                  //       ),
                  //   ],
                  // ),
                  // SizedBox(width: 16),
                  availableTimeSlotList != null &&
                          availableTimeSlotList.length > 0
                      ? Row(
                          children: <Widget>[
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(9),
                                  color: Colours.welcome_bg),
                              alignment: Alignment.center,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Available",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontFamily: "Poppins-Bold"),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            Center(
              child: Container(
                  height: MediaQuery.of(context).size.height / AVAIL_SCREEN_RATIO,
                  padding: EdgeInsets.only(top: 12, left: 16, right: 16),
                  child: Scrollbar(
                    controller: _controller,
                    child: availableTimeSlotList != null && availableTimeSlotList.length > 0
                        ? GridView(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: (itemWidth / itemHeight),
                            ),
                            children: availableTimeSlotList.map((slot) {
                              return _buildCell(slot);
                            }).toList(),
                          )
                        : Container(),
                  )
                )
            )
          ],
        ),
      ),
    );
  }

  void _onDaySelected(DateTime day, List events, List list) {
    print('_onDaySelected');
    print(day);
    _getAllAvailableTimeSlots(day);
    setState(() {
      selectedDate = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  void onNavigate() {
    Navigator.of(context).pushReplacement(
      new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new SetServicePriceScreen(),
      ),
    );
  }
}
