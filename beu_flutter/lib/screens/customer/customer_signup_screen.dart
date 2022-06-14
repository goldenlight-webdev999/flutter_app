import 'dart:convert';

import 'package:beu_flutter/screens/customer/account_verify_screen.dart';
import 'package:beu_flutter/screens/customer/customer_dashboard_screen.dart';
import 'package:beu_flutter/screens/customer/customer_signin_screen.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/utils/validations.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:beu_flutter/widgets/regularTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  SharedPreferences prefs;
  TextEditingController _usernameController,
      _companyNameController,
      _emailController,
      _mobileController,
      _passwordController,
      _conformPassController,
      _addressController;
  Dio  dio = new Dio();

  GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  String _userName,
      _companyName,
      _email,
      _mobile,
      _password,
      _confirmPassword,
      _address,
      _lat,
      _long,
      _sId,
      _profilePic,
      _isActive,
      userId,
      fcm_token;

  bool _isChecked = false;
  bool _isLoading = false;
  bool _autoValidate = false;
  String _loginVia = "n";

  @override
  initState() {
    super.initState();
    _getSharedPrefs();
    _getLocation();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      fcm_token = prefs.getString("fcm_token");
    });
  }

  void _getLocation() async {
    print("_getLocation");
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }
    _locationData = await location.getLocation();
    setState(() {
      _lat = _locationData.latitude.toString();
      _long = _locationData.longitude.toString();
    });
    print(_locationData);
    final coordinates =
        Coordinates(_locationData.latitude, _locationData.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      _address =
          "${addresses.first.featureName}, ${addresses.first.locality}, ${addresses.first.subAdminArea}, ${addresses.first.adminArea}, ${addresses.first.postalCode}";
    });
    _addressController = TextEditingController(text: _address);
    print(_address);
  }

  void _saveUserData(data) async {
    prefs.setString('userid', data["userid"]);
    prefs.setString('fullname', data["fullname"]);
    prefs.setString('profilepic', data["profilepic"]);
    prefs.setString('usertype', data["usertype"]);
    prefs.setString('email', data["email"]);
    prefs.setString('address', data["address"]);
    prefs.setString('mobileno', data["mobileno"]);
  }

  void _validateInputs() {
    if (_signUpFormKey.currentState.validate()) {
      _signUpFormKey.currentState.save();
      var confirm = _confirmPassword;
      var pass = _password;

      if (confirm == pass) {
        setState(() {
          _isLoading = true;
        });
        _submit();
      } else {
        setState(() {
          _isLoading = false;
        });
        _showMessage(context, Strings.cfValid);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _submit() async {
    var email = _email;
    var password = _password;
    var fullname = _userName;
    var mobileNo = _mobile;
    var loginVia = _loginVia;
    var address = _address;
    var fcmToken = fcm_token;
    var companyName = _companyName;
    var profilePic = _profilePic;
    var sId = _sId;

    if (_lat == null || _lat == "" || _long == null || _long == "") {
      setState(() {
        _isLoading = false;
      });
      _showMessage(context,
          "Unable to find your location, please open settings app and give permission for the same.");
      return;
    }
    final response = await ApiService().signUp(
      email,
      password,
      fullname,
      "customer",
      mobileNo,
      loginVia,
      address,
      fcmToken,
      companyName,
      sId,
      profilePic,
      null,
      null
    );

    if (response != null) {
      print(response.body);
      final json = jsonDecode(response.body);

      print("Json Index" + json.toString());

      if (json['errorcode'] != null && json['errorcode'] == 0) {
        setState(() {
          userId = json['data'][0]['userid'];
          _isActive = json['data'][0]['isactive'];
        });

        if (_isActive == "yes") {
          _saveUserData(json["data"][0]);

          onNavigateDashboard();
        } else
          onNavigateAccountScreen(json);
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
  }

  void _initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin.logIn(["email"]);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        setState(() {
          _loginVia = "n";
        });
        _showMessage(context, "Something went wrong!");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        setState(() {
          _loginVia = "n";
        });
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        /*var graphResponse = await http.get(
            '');*/

        var url ='https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(100).height(100)&access_token=${facebookLoginResult.accessToken.token}';
        var graphResponse= await dio.get(
          url,
        );
        var profile = json.decode(graphResponse.toString());
        print(profile.toString());
        setState(() {
          _loginVia = "f";
          _userName = profile['name'];
          _email = profile['email'];
          _profilePic = profile['picture']['data']['url'];
          _sId = profile['id'];
          _emailController = TextEditingController(text: _email);
          _usernameController = TextEditingController(text: _userName);
        });
        break;
    }
  }

  void _initiateGoogleLogin() async {
    try {
      await _googleSignIn.signIn().then((onValue) {
        setState(() {
          print(_googleSignIn.currentUser);
          _loginVia = "g";
          _userName = _googleSignIn.currentUser.displayName;
          _email = _googleSignIn.currentUser.email;
          _profilePic = _googleSignIn.currentUser.photoUrl;

          _sId = _googleSignIn.currentUser.id;
          _emailController = TextEditingController(text: _email);
          _usernameController = TextEditingController(text: _userName);
        });
        _validateInputs();
      });
    } catch (err) {
      setState(() {
        _loginVia = "n";
        _isLoading = false;
      });
      print(err);
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
          height: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 42, left: 28, right: 28),
          color: Colors.black.withOpacity(0.9),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _signUpFormKey,
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
                    Strings.signup,
                    style: TextStyle(
                        fontFamily: 'Poppins-ExtraBold',
                        fontSize: 34,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  RegularTextField(
                    regularText: Strings.username,
                    regularTextColor: Colors.white,
                    textColor: Colors.white,
                    obsecureText: false,
                    controller: _usernameController,
                    inputType: TextInputType.text,
                    validator: Validations().validateName,
                    value: (String val) {
                      _userName = val;
                    },
                    underLineColorDefault: Colors.white,
                    underLineColorSelected: Colors.white,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 12,
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
                    regularText: Strings.mobile,
                    regularTextColor: Colors.white,
                    textColor: Colors.white,
                    obsecureText: false,
                    controller: _mobileController,
                    inputType: TextInputType.number,
                    validator: Validations().validateMobile,
                    value: (String val) {
                      _mobile = val;
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
                    obsecureText: false,
                    controller: _passwordController,
                    inputType: TextInputType.visiblePassword,
                    validator: Validations().validatePassword,
                    value: (String val) {
                      _password = val;
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
                    controller: _conformPassController,
                    inputType: TextInputType.text,
                    validator: Validations().validateConfirmPassword,
                    value: (String val) {
                      _confirmPassword = val;
                    },
                    underLineColorDefault: Colors.white,
                    underLineColorSelected: Colors.white,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 32),
                        child: RegularTextField(
                          regularText: Strings.address,
                          regularTextColor: Colors.white,
                          textColor: Colors.white,
                          obsecureText: false,
                          controller: _addressController,
                          inputType: TextInputType.text,
                          validator: Validations().validateAddress,
                          value: (String val) {
                            _address = val;
                          },
                          underLineColorDefault: Colors.white,
                          underLineColorSelected: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 12,
                        child: GestureDetector(
                          onTap: () => _getLocation(),
                          child: Image.asset(
                            "assets/images/current_location.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : GestureDetector(
                          onTap: _validateInputs,
                          child: RegularButton(
                            regularText: Strings.signup,
                          ),
                        ),
                  // GestureDetector(
                  //     onTap: onNavigateSignIn,
                  //     child: Text(
                  //       Strings.signin_using,
                  //       style: TextStyle(
                  //           color: Colors.white,
                  //           fontFamily: 'Poppins-Light',
                  //           fontSize: 12),
                  //     )),
                  SizedBox(
                    height: 18,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     GestureDetector(
                  //       onTap: () => _initiateGoogleLogin(),
                  //       child: Image.asset(
                  //         "assets/images/google.png",
                  //         height: 44,
                  //         width: 44,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 18,
                  //     ),
                  //     GestureDetector(
                  //       onTap: () => _initiateFacebookLogin(),
                  //       child: Image.asset(
                  //         "assets/images/facebook.png",
                  //         height: 44,
                  //         width: 44,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 32,
          top: 36,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
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
      resizeToAvoidBottomInset: true,
    );
  }

  void onNavigateDashboard() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => CustomerDashboardScreen(),
    ));
  }

  void onNavigateSignIn() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => CustomerSignInScreen(),
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

  void onNavigateAccountScreen(var _json) {
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) =>
            AccountVerifyScreen(json: _json, userType: "customer"),
      ),
    );
  }
}
