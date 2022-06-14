import 'dart:convert';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/inner_category.dart';
import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetServicePriceScreen extends StatefulWidget {
  final String subCategoryId, subCategoryName;

  const SetServicePriceScreen(
      {Key key, this.subCategoryId, this.subCategoryName})
      : super(key: key);

  @override
  _SetServicePriceScreenState createState() => _SetServicePriceScreenState();
}

class _SetServicePriceScreenState extends State<SetServicePriceScreen> {
  final ScrollController _scrollController = ScrollController();
  Map<String, String> quantities = {};
  int i;
  List<bool> _selected = [];

  SharedPreferences prefs;
  List<InnerCategory> serviceInnerCategoryList;
  bool _isLoading = false;
  String userid;

  @override
  initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userid = prefs.getString("userid");
    _getInnerServices(widget.subCategoryId);
  }

  void _getInnerServices(String subCategoryId) async {
    print("_getInnerServices");
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().getInnerCategories(
      userid,
      subCategoryId,
    );
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      serviceInnerCategoryList = [];
      if (json['data'] != null && json['data'].length > 0) {
        var innerCats = json['data'] as List;
        setState(() {
          serviceInnerCategoryList = innerCats
              .map<InnerCategory>((json) => InnerCategory.fromJson(json))
              .toList();
          _selected =
              List.generate(serviceInnerCategoryList.length, (i) => false);
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

  void _takePriceChanges(String value, String id) {
    try {
      quantities[id] = value;
      print(quantities);
    } on FormatException {}
  }

  void _setInnerServicePrice() async {
    print("_setInnerServicePrice");
    if (quantities.length == 0) {
      return;
    }
    List<Map<String, String>> data = [];
    quantities.forEach((key, value) {
      Map<String, String> map = {};
      map["innercategoryid"] = key;
      map["price"] = value;
      data.add(map);
    });
    Map mapData = {
      "userid": userid,
      "innercategories": data,
    };
    print(mapData);

    setState(() {
      _isLoading = true;
    });

    final response = await ApiService().setServicePrice(mapData);
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['errorcode'] == 0) {
        CommonUtils().showMessage(context, "Price updated successfully", () {
          Navigator.pop(context);
        });
        _getInnerServices(widget.subCategoryId);
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
      height: double.infinity,
      padding: EdgeInsets.all(32),
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
          SizedBox(
            height: 48,
          ),
          Text(
            widget.subCategoryName,
            style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontFamily: 'Poppins-ExtraBold',
                letterSpacing: 0.4),
          ),
          // SizedBox(
          //   height: 12,
          // ),
          // SearchField(
          //   regularText: Strings.search,
          //   inputType: TextInputType.text,
          // ),
          _buildServiceList(),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () => _setInnerServicePrice(),
            child: RegularButton(
              regularText: "Submit",
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
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
          child: _isLoading
              ? Container(
                  height: 40,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white),
                )
              : ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: serviceInnerCategoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => setState(
                                () => _selected[index] = !_selected[index]),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              child: Row(
                                children: <Widget>[
                                  // CircleAvatar(
                                  //   backgroundColor: _selected[index]
                                  //       ? Colours.welcome_bg
                                  //       : Colors.white,
                                  //   radius: 30,
                                  //   child: Image.asset("assets/images/makeup.png",
                                  //       height: 30, width: 30, color: Colors.black),
                                  // ),
                                  // SizedBox(
                                  //   width: 12,
                                  // ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          serviceInnerCategoryList[index]
                                              .category_name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Poppins-Bold',
                                              color: Colors.white),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Price: \$",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins-Light',
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            _selected[index]
                                                ? Container(
                                                    height: 26,
                                                    width: 80,
                                                    alignment: Alignment.center,
                                                    child: TextFormField(
                                                      onChanged: (text) {
                                                        _takePriceChanges(
                                                            text,
                                                            serviceInnerCategoryList[
                                                                    index]
                                                                .id);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-SemiBold',
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 26,
                                                    width: 80,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Colors.white),
                                                    padding: EdgeInsets.only(
                                                        left: 16,
                                                        right: 12,
                                                        top: 2,
                                                        bottom: 2),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        serviceInnerCategoryList[
                                                                index]
                                                            .price,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Poppins-SemiBold'),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                  )
                                          ],
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

  void onNavigate() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => VendorDashboardScreen(),
      ),
    );
  }
}
