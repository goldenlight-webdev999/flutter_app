import 'dart:convert';

import 'package:beu_flutter/api/api_service.dart';

import 'package:beu_flutter/models/vendorList.dart';
import 'package:beu_flutter/models/vendor_price_list.dart' as vendor;
import 'package:beu_flutter/screens/customer/customer_notifications_screen.dart';
import 'package:beu_flutter/screens/customer/customer_service_schedular_screen.dart';
import 'package:beu_flutter/screens/customer/vendor_service_gallery.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/widgets/searchField.dart';
import 'package:beu_flutter/widgets/socialMediaLinks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fuzzy/fuzzy.dart';

class ServiceVendorDetailsScreen extends StatefulWidget {
  VendorList vendorDetails;
  ServiceVendorDetailsScreen({this.vendorDetails});
  @override
  _ServiceVendorDetailsScreenState createState() =>
      _ServiceVendorDetailsScreenState();
}

class _ServiceVendorDetailsScreenState
    extends State<ServiceVendorDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  List<vendor.Services> _searchServiceList = new List<vendor.Services>();
  List<vendor.Services> _serviceList;
  bool _isSearching = false;
  vendor.Vendor vendorDetails;
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
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                      size: 30,
                    )),
                GestureDetector(
                    onTap: onNavigateNotifications,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 50,
                height: 50,
                //padding: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                    color: Colours.darkGrey,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(100)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    widget.vendorDetails.vendor.profilepic,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 24),
                    child: Text(
                      widget.vendorDetails.vendor.companyname == null
                          ? "Company Name"
                          : widget.vendorDetails.vendor.companyname,
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontFamily: 'Poppins-ExtraBold',
                          letterSpacing: 0.4),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.only(left: 5, right: 24),
                    child: Text(
                      widget.vendorDetails.vendor.address == null
                          ? "Address"
                          : widget.vendorDetails.vendor.address,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: 'Poppins-ExtraBold',
                          letterSpacing: 0.4),
                    ),
                  ),
                ],
              )
            ],
          ),
          // peter: Show two buttons that when tapped will try to 
          // open this vendor's Facebook and Instagram profiles. 
          Container(
            padding: EdgeInsets.only(left: 60, right: 24),
            child: SocialMediaLinks(vendor: widget.vendorDetails.vendor, context: context,),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.only(top: 12, left: 24, right: 24),
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
              ? _searchServiceList == null
                  ? Text("No Search Result")
                  : ServiceListView(_searchServiceList)
              : _buildServiceList(),
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

  void onNavigateNotifications() {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => CustomerNotificationsScreen(),
    ));
  }

  Widget _buildServiceList() {
    return FutureBuilder<vendor.VendorServicePriceData>(
        future: _getVendorServicePriceList(),
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
            vendorDetails = snapshot.data.vendor;
            _serviceList = snapshot.data.services;

            return ServiceListView(_serviceList);
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

  ServiceListView(List<vendor.Services> data) {
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
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 140,
                  margin: EdgeInsets.only(bottom: 18),
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(left: 24),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 130,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Container(
                            height: 110,
                            padding: EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 4,
                            ),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 120, top: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle, color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Poppins-ExtraBold'),
                                      text: data[index]
                                          .innercategory
                                          .categoryName),
                                ),
                                RatingBar(
                                  itemSize: 14,
                                  minRating: 1,
                                  initialRating:
                                      vendorDetails.ratevalue.toDouble(),
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
                                          0.4,
                                      child: Text(
                                        vendorDetails.address,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 8),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    onNavigateSchedular(
                                        data[index], vendorDetails);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Book Now",
                                        style: TextStyle(
                                            color: Colours.welcome_bg,
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 10),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Image.asset(
                                        "assets/images/arrow_forward.png",
                                        color: Colours.welcome_bg,
                                        width: 16,
                                        height: 16,
                                      ),
                                      Spacer(),
                                      Text(
                                        "\$${data[index].price}",
                                        style: TextStyle(
                                            color: Colours.welcome_bg,
                                            fontFamily: 'Poppins-Bold',
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
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
                                  data[index].innercategory.image,
                                  width: 120,
                                  height: 130,
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
                                onNavigateToGallery(vendorDetails.userid,
                                    data[index].innercategory);
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
                  ),
                );
              }),
        ),
      ),
    );
  }

  Future<vendor.VendorServicePriceData> _getVendorServicePriceList() async {
    final response =
        await ApiService().getVendorPriceList(widget.vendorDetails.vendor.userid);
    if (response != null) {
      final json = jsonDecode(response.toString());
      if (json['data'] != null && json['errorcode'] == 0) {
        if (json['data'][0]['services'] != null) {
          return vendor.VendorServicePriceData.fromJson(json['data'][0]);
        } else {
          return Future.error("No Service Available");
        }
      } else {
        return Future.error(json['message']);
      }
    } else {
      return Future.error("Something went Wrong !!");
    }
  }

  void onNavigateToGallery(String userid, vendor.ServiceInnercategory inner) {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new VendorGalleryPhotosScreen(
        vendorid: userid,
        inner: inner,
      ),
    ));
  }

  void onNavigateSchedular(vendor.Services data, vendor.Vendor vendor) {
    Navigator.of(context).push(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) =>
            new ServiceSchedularScreen(data: data, vendor: vendor)));
  }

  onSearchFunctionCall(String value) {
    print(value);
    List<String> values = new List<String>();
    _searchServiceList.clear();

    print(value);

    if (value.length != 0) {
      _serviceList.asMap().forEach((index, value) {
        values.add(index.toString() + "-" + value.innercategory.categoryName);
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

        _searchServiceList.add(_serviceList[index]);
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
