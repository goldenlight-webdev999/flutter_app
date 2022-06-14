import 'package:beu_flutter/screens/vendor/vendor_edit_profile_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorProfileScreen extends StatefulWidget {
  @override
  _VendorProfileScreenState createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SharedPreferences prefs;
  String userid, email, fullname, profilepic, mobileno, address, licenseimage;
  String compnayName;
  @override
  initState() {
    super.initState();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
      email = prefs.getString("email");
      compnayName = prefs.getString("companyname");
      fullname = prefs.getString("fullname");
      mobileno = prefs.getString("mobileno");
      address = prefs.getString("address");
      licenseimage = prefs.getString("licenseimage");
      var pPic = prefs.getString("profilepic");
      if (pPic != null && pPic != "") {
        if (!pPic.contains("http")) {
          setState(() {
            profilepic = "http://18.188.224.232/beu/$profilepic";
          });
        } else {
          setState(() {
            profilepic = pPic;
          });
        }
      }
    });
  }

  Widget _bodyWidget() {
    return Stack(
      children: <Widget>[
        profilepic != null && profilepic != ""
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(profilepic),
                    fit: BoxFit.cover,
                  ),
                ),
                height: MediaQuery.of(context).size.height,
              )
            : Container(),
        Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              tileMode: TileMode.mirror,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colours.welcome_bg_gd2.withOpacity(0.2),
                Colours.welcome_bg.withOpacity(1),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              Text(
                fullname ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins-Light",
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RatingBar(
                    itemSize: 20,
                    initialRating: 3.5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    unratedColor: Colors.white,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: null,
                  ),
                  Text(
                    compnayName ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins-Light",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    mobileno ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins-Light",
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    email ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins-Light",
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: <Widget>[
                  //     Icon(
                  //       Icons.location_on,
                  //       color: Colors.amber,
                  //       size: 16,
                  //     ),
                  Text(address ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins-Light",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                  //   ],

                  // ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _getSharedPrefs();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colours.welcome_bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black12,
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
            GestureDetector(
              onTap: () => onNavigateEditProfile(),
              child: Icon(
                Icons.edit,
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

  void onNavigateEditProfile() {
    Navigator.of(context).push(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => VendorEditProfileScreen(),
    ));
  }
}
