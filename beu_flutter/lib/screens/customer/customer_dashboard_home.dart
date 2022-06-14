import 'dart:convert';

import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/dashboardServices.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beu_flutter/widgets/pageIndicator.dart';

import 'select_service_screen.dart';

class CustomerDashboardHomeScreen extends StatefulWidget {
  String userId;
  CustomerDashboardHomeScreen({this.userId});
  @override
  _CustomerDashboardHomeScreenState createState() =>
      _CustomerDashboardHomeScreenState();
}

class _CustomerDashboardHomeScreenState
    extends State<CustomerDashboardHomeScreen> {
  final _controller = new PageController();
  DashboardService _dashboardService;
  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);
  bool _isLoading = false;
  @override
  initState() {
    super.initState();
  }

  Widget _bodyWidget() {
    return Container(
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
      child: FutureBuilder<dynamic>(
          future: _getService(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(snapshot.error.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins-Bold",
                          fontSize: 10)));
            }
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 24, top: 8),
                    child: Text(
                      "Recommended \nServices",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins-Bold",
                          fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 280,
                      child: snapshot.data.recommanded != null
                          ? new PageView.builder(
                              physics: new AlwaysScrollableScrollPhysics(),
                              controller: _controller,
                              itemCount: snapshot.data.recommanded.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 200,
                                      margin: EdgeInsets.only(
                                          top: 8, left: 24, right: 24),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          child: Image.network(
                                            snapshot
                                                .data.recommanded[index].image,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      right: 2,
                                      left: 2,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(18)),
                                        margin: EdgeInsets.only(
                                            left: 44, right: 44),
                                        padding: EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data.recommanded[index]
                                                  .categoryName,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22,
                                                  fontFamily: 'Poppins-Bold'),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              snapshot.data.recommanded[index]
                                                  .serviceDesc,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Poppins-Regular",
                                                  fontSize: 12),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            GestureDetector(
                                              onTap: onNavigate,
                                              child: Row(
                                                children: <Widget>[
                                                  Spacer(),
                                                  Text(
                                                    "View Details",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          "Poppins-Bold",
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Image.asset(
                                                    "assets/images/arrow_forward.png",
                                                    height: 20,
                                                    width: 20,
                                                    color: Colors.blue,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              })
                          : Container(
                              height: 180,
                              child: Center(
                                child: Text(
                                  "Not Available !!",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins-Bold",
                                      fontSize: 14),
                                ),
                              ),
                            )),
                  new Center(
                    child: new DotsIndicator(
                      controller: _controller,
                      itemCount: snapshot.data.recommanded.length,
                      onPageSelected: (int page) {
                        _controller.animateToPage(
                          page,
                          duration: _kDuration,
                          curve: _kCurve,
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 24, top: 8),
                    child: Text(
                      "Trending Services",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins-Bold",
                          fontSize: 16),
                    ),
                  ),
                  _buildTrendingServices(snapshot.data.trending)
                ],
              );
            }
            return Container(
              margin: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                backgroundColor: Colors.white,
              ),
            );
          }),
    );
  }

  Widget _buildTrendingServices(List<DashBoardModel> data) {
    if (data.length == 0) {
      return Container(
        height: 180,
        child: Center(
          child: Text(
            "Not Available !!",
            style: TextStyle(
                color: Colors.white, fontFamily: "Poppins-Bold", fontSize: 14),
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(left: 24, top: 12),
        width: MediaQuery.of(context).size.width,
        height: 180,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(right: 8),
                width: 120,
                height: 160,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14)),
                        child: Image.network(
                          data[index].image,
                          height: 80,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.all(3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            data[index].categoryName,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins-Bold",
                                fontSize: 12),
                          ),
                          Text(
                            data[index].serviceDesc,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins-Regular",
                                fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
          onRefresh: _getService,
          child: SingleChildScrollView(child: _bodyWidget()),
        ));
  }

  void onNavigate() {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new SelectServiceScreen(
        userId: widget.userId,
      ),
    ));
  }

  Future<dynamic> _getService() async {
    return ApiService().getCustomerDashboardServices(widget.userId)
        .then((response) {
      if (response != null) {
        final json = jsonDecode(response.toString());
        print("JSON Data");
        print(json);
        if (json['data'] != null && json['data'].length > 0) {
          return DashboardService.fromJson(json['data'][0]);
        } else {
          return Future.error(json['message']);
        }
      } else {
        return Future.error("Loading ...");
      }
    }).catchError((e) {
      return Future.error("Not Available!");
    });
  }
}
