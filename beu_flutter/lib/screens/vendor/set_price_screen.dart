import 'dart:convert';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/service.dart';
import 'package:beu_flutter/screens/vendor/set_price_subcategory_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_edit_profile_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetPriceScreen extends StatefulWidget {
  final bool showAppbar;

  SetPriceScreen(this.showAppbar);

  @override
  _SetPriceScreenState createState() => _SetPriceScreenState();
}

class _SetPriceScreenState extends State<SetPriceScreen> {
  List<Service> serviceList;
  String setting;
  bool _isDashboard = true;
  bool visible = false;
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    _getServices();
  }

  void _getServices() async {
    print("_getServices");
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().getServices();
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['data'] != null && json['data'].length > 0) {
        var services = json['data'] as List;
        if (mounted) {
          setState(() {
            serviceList = services
                .map<Service>((json) => Service.fromJson(json))
                .toList();
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

  void _handleService(Service service) {
    onNavigateToCategoryScreen(service);
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
          widget.showAppbar ? SizedBox(height: 48) : SizedBox(height: 0),
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
            height: 36,
          ),
          serviceList != null && serviceList.length > 0
              ? GridView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(4.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.3),
                  ),
                  children: serviceList.map((service) {
                    return _buildGridTile(service);
                  }).toList(),
                )
              : Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildGridTile(Service service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => _handleService(service),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            child: Image.network(
              service.service_image,
              height: 40,
              width: 40,
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Flexible(
          child: Text(
            service.service_name,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins-Bold",
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: widget.showAppbar
          ? AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: onNavigateBack,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            )
          : PreferredSize(
              preferredSize: Size(0.0, 0.0),
              child: Container(),
            ),
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  void onNavigateToCategoryScreen(Service service) {
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) =>
            SetPriceSubCategoryScreen(serviceId: service.serviceid),
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
