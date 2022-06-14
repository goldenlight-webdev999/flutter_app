import 'package:beu_flutter/screens/customer/customer_dashboard_screen.dart';
import 'package:beu_flutter/screens/customer/customer_edit_profile_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProfileScreen extends StatefulWidget {
  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  String _profilepic = "",
      _email = "email",
      _phone = "",
      _address1 = "",
      _address2 = "",
      _fb = "",
      _insta = "";
  bool _isImageUploading = false;
  String _name = "Name";
  SharedPreferences prefs;
  @override
  initState() {
    super.initState();

    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString("email");
      _name = prefs.getString("fullname");
      var pPic = prefs.getString("profilepic");

      _address1 = prefs.getString("address");
      _phone = prefs.getString("mobileno");
      if (pPic != null && pPic != "") {
        if (!pPic.contains("http")) {
          setState(() {
            _profilepic = "http://18.188.224.232/beu/$_profilepic";
          });
        } else {
          _profilepic = pPic;
        }
      }
    });
  }

  Widget _bodyWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 44, left: 32, right: 32),
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: onNavigateDashboard,
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.white,
                  size: 30,
                )),
            SizedBox(
              height: 6,
            ),
            Text(
              "Profile",
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontFamily: 'Poppins-ExtraBold',
                  letterSpacing: 0.4),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildImage(),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      _name != null ? _name : "Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins-Bold",
                        fontSize: 20,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 12,
            ),
            Text(
              "Phone No.",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Poppins-LightItalic",
                fontSize: 18,
              ),
            ),
            Text(
              _phone != null ? _phone : "Phone Number",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins-Light",
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Email ID",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Poppins-LightItalic",
                fontSize: 18,
              ),
            ),
            Text(
              _email != null ? _email : "Email",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins-Light",
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Address",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Poppins-LightItalic",
                fontSize: 18,
              ),
            ),
            Text(
              _address1 != null ? _address1 : "address",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins-Light",
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: onNavigate,
              child: RegularButton(
                regularText: "Edit",
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
        height: 160,
        width: 150,
        margin: EdgeInsets.only(top: 2, bottom: 2),
        decoration: BoxDecoration(
            color: Colours.darkGrey, borderRadius: BorderRadius.circular(10)),
        child: _isImageUploading
            ? Center(child: CircularProgressIndicator())
            : _profilepic != null && _profilepic != ""
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _profilepic,
                      width: 128,
                      height: 128,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset("assets/images/man.png"));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  void onNavigateDashboard() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new CustomerDashboardScreen(),
    ));
  }

  void onNavigate() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new CustomerEditProfileScreen(),
    ));
  }
}
