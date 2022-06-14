import 'dart:convert';

import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/all_service.dart';
import 'package:beu_flutter/models/vendorList.dart';
import 'package:beu_flutter/screens/customer/select_service_screen.dart';
import 'package:beu_flutter/screens/customer/service_list_screen.dart';
import 'package:beu_flutter/screens/customer/service_vendor_details.dart';
import 'package:beu_flutter/screens/forgot_password_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/widgets/searchField.dart';
import 'package:beu_flutter/widgets/socialMediaLinks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceVendorScreen extends StatefulWidget {
  String userid;
  Innercategory data;

  ServiceVendorScreen({this.data, this.userid});
  @override
  _ServiceVendorScreenState createState() => _ServiceVendorScreenState();
}

class _ServiceVendorScreenState extends State<ServiceVendorScreen> {
  final ScrollController _scrollController = ScrollController();
  List<VendorList> _vendorList;
  List<VendorList> _searchVendorList = new List<VendorList>();

  bool _isSearching = false;

  @override
  initState() {
    super.initState();
  }

  Widget _bodyWidget() {
    return Container(
      width: double.infinity,
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
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                      size: 30,
                    )),
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
            child: RichText(
              text: TextSpan(
                  style: new TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Poppins-ExtraBold',
                      letterSpacing: 0.4),
                  text: widget.data.categoryName),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: SearchField(
              regularText: Strings.search,
              inputType: TextInputType.text,
              onchange: onSearchFunctionCall,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          _isSearching
              ? _searchVendorList == null
                  ? Text("No Search Result")
                  : VendorListView(_searchVendorList.sublist(1))
              : _buildVendorList(),
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

  Widget _buildVendorList() {
    return FutureBuilder<List<dynamic>>(
        future: _getService(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              snapshot.error.toString(),
              style: TextStyle(
                  fontFamily: "Poppins-ExtraBold",
                  color: Colors.white,
                  fontSize: 18),
            ));
          }
          if (snapshot.hasData) {
            _vendorList = snapshot.data;

            //Checks vendors for null values, and removes them
            for(int i = 0; i < snapshot.data.length; i++){
              if(snapshot.data[i].vendor == null){
                snapshot.data.removeAt(i);
                print("Removing vendor at ${i}");
              }
            }

            return VendorListView(snapshot.data);
          }

          return Container(
            margin: EdgeInsets.all(8),
            alignment: Alignment.topCenter,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              backgroundColor: Colors.white,
            ),
          );
        });
  }

  VendorListView(List<VendorList> data) {
    return Expanded(
      child: Container(
        child: Scrollbar(
          controller: _scrollController,
          child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 18),
                  child: GestureDetector(
                    onTap: () {
                      onNavigate(data[index]);
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 24),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 130,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Container(
                            height: 144,
                            padding: EdgeInsets.only(
                                left: 120, right: 12, top: 4, bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 10, top: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle, color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  data[index].vendor.companyname,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins-ExtraBold'),
                                ),
                                RatingBar(
                                  itemSize: 12,
                                  initialRating:
                                      data[index].vendor.ratevalue.toDouble(),
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
                                  height: 2,
                                ),
                                Text(
                                  data[index].vendor.mobileno,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins-Bold',
                                      fontSize: 10),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colours.welcome_bg,
                                      size: 14,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        data[index].vendor.address,
                                        //'test',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                                // peter: Show two buttons that when tapped will try to
                                // open this vendor's Facebook and Instagram profiles.
                                SocialMediaLinks(vendor: data[index].vendor, context: context,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "SELECT SERVICES",
                                      style: TextStyle(
                                          color: Colours.welcome_bg,
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 10),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colours.welcome_bg,
                                      size: 16,
                                    )
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
                                child: Image.network(
                                  data[index].vendor.profilepic,
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

  void onNavigate(VendorList data) {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new ServiceVendorDetailsScreen(
        vendorDetails: data,
      ),
    ));
  }

  void onNavigateServiceList() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new SelectServiceScreen(),
    ));
  }

  Future<List<dynamic>> _getService() async {
    List<VendorList> vendor = new List<VendorList>();
    final response = await ApiService().getVendorList(
        widget.userid, widget.data.innercategoryid);
    if (response != null) {
      final json = jsonDecode(response.toString());
      print(json);
      if (json['data'] != null && json['errorcode'] == 0) {
        List<dynamic> value = json['data'];
        value.forEach((v) {
          //if(v['companyname'] != null){
            VendorList x = VendorList.fromJson(v);
            print(x.toJson());
            vendor?.add(x);
          //}
        });
        return vendor;
      } else {
        return Future.error(json['message']);
      }
    } else {
      return Future.error("Something went Wrong !!");
    }
  }

  onSearchFunctionCall(String value) {
    print(value);
    List<String> values = new List<String>();
    _searchVendorList.clear();

    print(value);

    if (value.length != 0) {
      _vendorList.asMap().forEach((index, value) {
        values.add(index.toString() + "-" + value.vendor.companyname);
      });
      final fuse = Fuzzy(
        values,
        options: FuzzyOptions(
          findAllMatches: true,
          tokenize: true,
          threshold: 0.5,
        ),
      );

      final result = fuse.search(value);
      result.forEach((r) {
        int index = int.parse(r.item.toString().split('-')[0]);

        _searchVendorList.add(_vendorList[index]);
      });

      setState(() {
        _isSearching = true;
      });
    } else {
      setState(() {
        _isSearching = false;
      });
    }
  }
}
