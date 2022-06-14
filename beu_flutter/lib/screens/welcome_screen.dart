import 'package:beu_flutter/screens/customer/customer_signup_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_signin_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customer/customer_signin_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  initState() {
    super.initState();
  }

  Widget _bodyWidget() {
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 64,
          ),
          Text(
            Strings.welcome,
            style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontFamily: 'Poppins-ExtraBold',
                letterSpacing: 0.4),
          ),
          Text(
            Strings.select_ac_type,
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontFamily: 'Poppins-Regular'),
          ),
          SizedBox(
            height: 34,
          ),
          GestureDetector(
              onTap: onNavigate,
              child: CircleAvatar(
                backgroundColor: Colours.welcome_bg,
                radius: 60,
                child: Image.asset(
                  "assets/images/customer.png",
                  height: 60,
                  width: 60,
                ),
              )),
          SizedBox(
            height: 12,
          ),
          Text(
            Strings.customer,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Poppins-Regular'),
          ),
          SizedBox(
            height: 22,
          ),
          Divider(
            thickness: 1,
            color: Colors.white,
            indent: 100,
            endIndent: 100,
          ),
          SizedBox(
            height: 22,
          ),
          GestureDetector(
              onTap: onNavigateVendorSignIn,
              child: CircleAvatar(
                backgroundColor: Colours.welcome_bg,
                radius: 60,
                child: Image.asset(
                  "assets/images/vendor.png",
                  height: 60,
                  width: 60,
                ),
              )),
          SizedBox(
            height: 12,
          ),
          Text(
            Strings.vendor,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Poppins-Regular'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  void onNavigate() {
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => CustomerSignInScreen(),
      ),
    );
  }

  void onNavigateVendorSignIn() {
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => VendorSignInScreen(),
      ),
    );
  }
}
