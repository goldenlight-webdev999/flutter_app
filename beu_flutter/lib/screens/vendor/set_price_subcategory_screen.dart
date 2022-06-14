import 'dart:convert';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/sub_category.dart';
import 'package:beu_flutter/screens/vendor/vendor_edit_profile_screen.dart';
import 'package:beu_flutter/screens/vendor/set_service_price_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPriceSubCategoryScreen extends StatefulWidget {
  final String serviceId;

  const SetPriceSubCategoryScreen({Key key, this.serviceId}) : super(key: key);

  @override
  _SetPriceSubCategoryScreenState createState() =>
      _SetPriceSubCategoryScreenState();
}

class _SetPriceSubCategoryScreenState extends State<SetPriceSubCategoryScreen> {
  SharedPreferences prefs;
  List<SubCategory> serviceCategoryList;
  String userid;
  bool _isDashboard = false;
  bool visible = false;
  bool _sizeBoxVisibility = false;
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userid = prefs.getString("userid");
    _getSubServices();
  }

  void _getSubServices() async {
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().getSubCategories(
      userid,
      widget.serviceId,
    );
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['data'] != null && json['data'].length > 0) {
        var subCats = json['data'] as List;
        setState(() {
          serviceCategoryList = subCats
              .map<SubCategory>((json) => SubCategory.fromJson(json))
              .toList();
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

  void _handleSubCategoryService(SubCategory subCategory) {
    onNavigateToInnerCategory(subCategory);
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
            "Set Price",
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
          SizedBox(
            height: 0,
          ),
          serviceCategoryList != null && serviceCategoryList.length > 0
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: serviceCategoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildTile(serviceCategoryList[index]);
                  },
                )
              : Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTile(SubCategory subCategory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => _handleSubCategoryService(subCategory),
          child: Card(
            elevation: 8.0,
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Container(
              height: 48,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                subCategory.category_name,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins-Bold",
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
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

  void onNavigateToInnerCategory(SubCategory subCategory) {
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => SetServicePriceScreen(
            subCategoryId: subCategory.id,
            subCategoryName: subCategory.category_name),
      ),
    );
  }

  void onNavigateBack() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) =>
            _isDashboard ? VendorDashboardScreen() : VendorEditProfileScreen(),
      ),
    );
  }
}
