import 'dart:convert';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/screens/customer/customer_signin_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_signin_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/utils/validations.dart';

import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:beu_flutter/widgets/regularTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetPasswordScreen extends StatefulWidget {
  final String userType;
  final String userId;

  SetPasswordScreen({this.userId, this.userType});

  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  TextEditingController _newPasswordController, _confirmPasswordController;
  String _password, _confirmPassword;
  bool _isLoading = false;

  final GlobalKey<FormState> _resetFormKey = GlobalKey<FormState>();
  @override
  initState() {
    super.initState();
  }

  void _validateInputs() async {
    if (_resetFormKey.currentState.validate()) {
      _resetFormKey.currentState.save();
      if (_password == _confirmPassword) {
        setState(() {
          _isLoading = true;
        });
        final response = await ApiService().resetPassword(
            widget.userId, _password, _confirmPassword);
        print(response);
        if (response != null) {
          print("Not Response");
          final json = jsonDecode(response.toString());

          print("JSON Data: ");
          print(json);

          if (json['errorcode'] != null && json['errorcode'] == 0) {
            CommonUtils()
                .showMessage(context, json["message"], onNavigateSignIn);
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
          _isLoading = false;
        });
        _showMessage(context, "Password is not match");
      }
    }
  }

  Widget _bodyWidget() {
    print("Id" + widget.userId);
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
              onTap: onNavigateSignIn,
              child: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
                size: 30,
              )),
          SizedBox(
            height: 32,
          ),
          Text(
            Strings.set,
            style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontFamily: 'Poppins-ExtraBold',
                letterSpacing: 0.4),
          ),
          Text(
            Strings.password,
            style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontFamily: 'Poppins-ExtraBold',
                letterSpacing: 0.4),
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 32,
          ),
          Form(
              key: _resetFormKey,
              child: Column(
                children: <Widget>[
                  RegularTextField(
                    regularText: Strings.newPassword,
                    regularTextColor: Colors.white,
                    textColor: Colors.white,
                    obsecureText: false,
                    controller: _newPasswordController,
                    inputType: TextInputType.text,
                    validator: Validations().validatePassword,
                    value: (String val) {
                      setState(() {
                        _password = val;
                      });
                    },
                    underLineColorDefault: Colors.white,
                    underLineColorSelected: Colors.white,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  RegularTextField(
                    regularText: Strings.confirmPassword,
                    regularTextColor: Colors.white,
                    textColor: Colors.white,
                    obsecureText: false,
                    controller: _confirmPasswordController,
                    inputType: TextInputType.text,
                    validator: Validations().validateConfirmPassword,
                    value: (String val) {
                      setState(() {
                        _confirmPassword = val;
                      });
                    },
                    underLineColorDefault: Colors.white,
                    underLineColorSelected: Colors.white,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
              )),
          _isLoading
              ? CircularProgressIndicator()
              : GestureDetector(
                  onTap: _validateInputs,
                  child: RegularButton(
                    regularText: Strings.reset,
                  ),
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          body: _bodyWidget(),
          resizeToAvoidBottomInset: false,
        ));
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

  void onNavigateSignIn() {
    if (widget.userType == "vendor") {
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            maintainState: true,
            opaque: true,
            pageBuilder: (context, _, __) => VendorSignInScreen(),
          ),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            maintainState: true,
            opaque: true,
            pageBuilder: (context, _, __) => CustomerSignInScreen(),
          ),
          (Route<dynamic> route) => false);
    }
  }
}
