import 'dart:convert';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/screens/forgot_password_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_signup_screen.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/utils/validations.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:beu_flutter/widgets/regularTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorSignInScreen extends StatefulWidget {
  @override
  _VendorSignInScreenState createState() => _VendorSignInScreenState();
}

class _VendorSignInScreenState extends State<VendorSignInScreen> {
  SharedPreferences prefs;
  TextEditingController _emailController=new TextEditingController(text:  "daxpault@gmail.com");
  TextEditingController _passwordController=new TextEditingController(text: "testpass");

  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _autoValidate = false;
  String _email, _password;

  @override
  initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _saveUserData(data) async {
    prefs.setString('userid', data["userid"]);
    prefs.setString('fullname', data["fullname"]);
    prefs.setString('profilepic', data["profilepic"]);
    prefs.setString('usertype', data["usertype"]);
    prefs.setString('email', data["email"]);
    prefs.setString('companyname', data["companyname"]);
    prefs.setString('address', data["address"]);
    prefs.setString('mobileno', data["mobileno"]);
    prefs.setString('instalink', data["instalink"]);
    prefs.setString('fblink', data["fblink"]);
    prefs.setString('licenseimage', data['licenseimage']);
    prefs.setBool('messageShow', true);
  }

  void _validateInputs() async {
    if (_signInFormKey.currentState.validate()) {
      _signInFormKey.currentState.save();
      var email = _email;
      var password = _password;

      setState(() {
        _isLoading = true;
      });
      final response = await ApiService().signIn(email, password, "vendor");
      if (response != null) {
        final json = jsonDecode(response.toString());

        print("JSON Data: ");
        print(json);
        if (json['errorcode'] != null && json['errorcode'] == 0) {
          _saveUserData(json["data"][0]);
          onNavigateDashboard();
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
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Widget _bodyWidget() {
    return Stack(
      children: <Widget>[
        Container(
          child: Image.asset(
            "assets/images/sigin_bg.png",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 28, right: 28),
          color: Colors.black.withOpacity(0.9),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _signInFormKey,
              autovalidateMode: _autoValidate?AutovalidateMode.always:AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/beu_logo.png",
                    height: 80,
                    width: 120,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    Strings.signIn,
                    style: TextStyle(
                        fontFamily: 'Poppins-ExtraBold',
                        fontSize: 34,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  RegularTextField(
                    regularText: Strings.email,
                    regularTextColor: Colors.white,
                    textColor: Colors.white,
                    obsecureText: false,
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                    validator: Validations().validateEmail,
                    value: (String val) {
                      _email = val;
                    },
                    underLineColorDefault: Colors.white,
                    underLineColorSelected: Colors.white,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  RegularTextField(
                    regularText: Strings.password,
                    regularTextColor: Colors.white,
                    textColor: Colors.white,
                    obsecureText: true,
                    validator: Validations().validatePassword,
                    controller: _passwordController,
                    inputType: TextInputType.visiblePassword,
                    value: (String val) {
                      _password = val;
                    },
                    underLineColorDefault: Colors.white,
                    underLineColorSelected: Colors.white,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  GestureDetector(
                      onTap: onNavigateForgotPassword,
                      child: Text(
                        Strings.forgot_password,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins-Light',
                            fontSize: 16),
                      )),
                  SizedBox(
                    height: 24,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : GestureDetector(
                          onTap: _validateInputs,
                          child: RegularButton(
                            regularText: Strings.signIn,
                          ),
                        ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: onNavigateSignup,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            Strings.new_here,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins-Light',
                                fontSize: 16),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            Strings.signup,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins-Bold',
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 32,
          top: 36,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  void onNavigateSignup() {
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => VendorSignUpScreen(),
      ),
    );
  }

  void onNavigateForgotPassword() {
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => ForgotScreen(userType: "vendor"),
      ),
    );
  }

  void onNavigateDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => VendorDashboardScreen(),
      ),
    );
  }
}
