import 'dart:convert';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/screens/customer/customer_dashboard_screen.dart';
import 'package:beu_flutter/screens/customer/customer_signup_screen.dart';
import 'package:beu_flutter/screens/set_password_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_signin_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/widgets/pin_view.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beu_flutter/utils/common_utils.dart';

class AccountVerifyScreen extends StatefulWidget {
  var json;
  String userType;
  AccountVerifyScreen({this.json, this.userType});
  @override
  _AccountVerifyScreenState createState() => _AccountVerifyScreenState();
}

class _AccountVerifyScreenState extends State<AccountVerifyScreen> {
  String _otp;
  bool _error = false;
  bool _isLoading = false;
  String _userId = "";
  @override
  initState() {
    print(widget.json);
    super.initState();
  }

  void _validateInputs() async {
    if (_otp.length == 6 || _otp != null) {
      setState(() {
        _error = false;
        _isLoading = true;
      });
      String otpFinal = _otp;
      var response;
      response = await ApiService().verifyAccount(
          widget.json['data'][0]['userid'], otpFinal);

      print(response);
      if (response != null) {
        final json = jsonDecode(response.toString());

        if (json['errorcode'] != null && json['errorcode'] == 0) {
          CommonUtils().saveUserData(json['data'][0]);
          onNavigate();
        } else {
          setState(() {
            _isLoading = false;
          });
          CommonUtils().showMessage(context, json["message"], () {
            Navigator.pop(context);
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        CommonUtils().showMessage(context, "Something went wrong!", () {
          Navigator.pop(context);
        });
      }
    } else {
      setState(() {
        _error = true;
      });
    }
  }

  Widget _bodyWidget() {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: 64, left: 32, right: 32),
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
          GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
                size: 30,
              )),
          SizedBox(
            height: 32,
          ),
          Text(
            Strings.account,
            style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontFamily: 'Poppins-ExtraBold',
                letterSpacing: 0.4),
          ),
          Text(
            Strings.verify,
            style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontFamily: 'Poppins-ExtraBold',
                letterSpacing: 0.4),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            Strings.acc_verification,
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontFamily: 'Poppins-Regular'),
          ),
          SizedBox(
            height: 32,
          ),
          Flexible(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: PinEntryTextField(
                    fieldWidth: 32.0,
                    fields: 6, // count of the fields, excluding dashes
                    onSubmit: (String pin) {
                      setState(() {
                        _otp = pin;
                      });
                    } // gets triggered when all the fields are filled
                    )),
          ),
          SizedBox(
            height: 32,
          ),
          _isLoading
              ? CircularProgressIndicator()
              : GestureDetector(
                  onTap: _validateInputs,
                  child: RegularButton(
                    regularText: Strings.verify,
                  ),
                ),
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

  void onNavigateResetScreen(String userId) {
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) =>
            SetPasswordScreen(userId: userId, userType: widget.userType),
      ),
    );
  }

  void onNavigate() {
    if (widget.userType == "customer") {
      Navigator.of(context).pushReplacement(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new CustomerDashboardScreen(),
      ));
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          maintainState: true,
          opaque: true,
          pageBuilder: (context, _, __) => VendorDashboardScreen(),
        ),
      );
    }
  }

  void onNavigateSignUp() {
    if (widget.userType == "customer") {
      Navigator.of(context).push(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new SignUpScreen(),
      ));
    } else {
      Navigator.of(context).push(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new VendorSignInScreen(),
      ));
    }
  }
}
