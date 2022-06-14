import 'dart:convert';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/screens/customer/customer_signin_screen.dart';
import 'package:beu_flutter/screens/customer/customer_signup_screen.dart';
import 'package:beu_flutter/screens/set_password_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_signin_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/widgets/pin_view.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotVerifyScreen extends StatefulWidget {
  String email;
  String userType;
  ForgotVerifyScreen({this.email, this.userType});
  @override
  _ForgotVerifyScreenState createState() => _ForgotVerifyScreenState();
}

class _ForgotVerifyScreenState extends State<ForgotVerifyScreen> {
  String _otp;
  bool _error = false;

  bool _isLoading = false;
  String _userId = "";
  @override
  initState() {
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
      response = await ApiService().verifyOTP(widget.email, otpFinal);
      print(response);
      if (response != null) {
        final json = jsonDecode(response.toString());

        if (json['errorcode'] != null && json['errorcode'] == 0) {
          if (json['data'][0]['user']['userid'] != null) {
            setState(() {
              _userId = json['data'][0]['user']['userid'];
              //  print("RESPONSE ID:+=" + _userId);
            });
          }
          setState(() {
            _error = false;
            _isLoading = false;
          });
          if (_userId != null || _userId != "") onNavigateResetScreen(_userId);
        } else {
          setState(() {
            _isLoading = false;
          });
          _showMessage(context, json["message"]);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showMessage(context, "Something went wrong!");
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
              onTap: onNavigateSignUp,
              child: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
                size: 30,
              )),
          SizedBox(
            height: 32,
          ),
          Text(
            Strings.email_or_mobile,
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
          Container(
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
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) =>
            SetPasswordScreen(userId: userId, userType: widget.userType),
      ),
    );
  }

  // void onNavigate() {
  //   Navigator.of(context).pushReplacement(new PageRouteBuilder(
  //     maintainState: true,
  //     opaque: true,
  //     pageBuilder: (context, _, __) => new CustomerDashboardScreen(),
  //   ));
  // }

  void onNavigateSignUp() {
    if (widget.userType == "customer") {
      Navigator.of(context).push(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new CustomerSignInScreen(),
      ));
    } else {
      Navigator.of(context).push(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new VendorSignInScreen(),
      ));
    }
  }

  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          title: Text(
            'BEU',
            textScaleFactor: 1.0,
          ),
          content: Text(
            message,
            textScaleFactor: 1.0,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                textScaleFactor: 1.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
    return;
  }
}
