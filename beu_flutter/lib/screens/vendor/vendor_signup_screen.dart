import 'dart:convert';
import 'dart:io';
import 'package:beu_flutter/utils/colours.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/screens/vendor/set_price_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_signin_screen.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/utils/validations.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:beu_flutter/widgets/regularTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorSignUpScreen extends StatefulWidget {
  @override
  _VendorSignUpScreenState createState() => _VendorSignUpScreenState();
}

class _VendorSignUpScreenState extends State<VendorSignUpScreen> {
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

  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      _profilePic;
  bool _isChecked = false;
  bool _isLoading = false;
  bool _autoValidate = false;
  String _loginVia = "n";
  String fcmToken = "";
  File drivingLicenseImage;
  File cosmetologyLicenseImage;

  @override
  initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    fcmToken = prefs.getString("fcm_token");
    _getLocation();
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
    prefs.setString('companyname', data["companyname"]);
    prefs.setString('address', data["address"]);
    prefs.setString('mobileno', data["mobileno"]);
    prefs.setString('instalink', data["instalink"]);
    prefs.setString('fblink', data["fblink"]);
    prefs.setString('licenseimage', data["licenseimage"]);
    prefs.setBool('messageShow', true);
  }

  void _validateInputs() async {
    if (_signUpFormKey.currentState.validate()) {
      _signUpFormKey.currentState.save();
      var confirm = _confirmPassword;
      var pass = _password;

      if (confirm == pass) {
        if (drivingLicenseImage == null) {
          CommonUtils().showMessage(context, "Please select driving license",
              () {
            Navigator.pop(context);
          });
          return;
        }
        if (cosmetologyLicenseImage == null) {
          CommonUtils().showMessage(context, "Please select cosmetology license",
                  () {
                Navigator.pop(context);
              });
          return;
        }
        if (_isChecked) {
          setState(() {
            _isLoading = true;
          });
          _submit();
        } else {
          CommonUtils().showMessage(context, "Please accept terms & conditions",
              () {
            Navigator.pop(context);
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        CommonUtils().showMessage(context, Strings.cfValid, () {
          Navigator.pop(context);
        });
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
    var address = _addressController.text;
    var companyName = _companyName;
    var profilePic = _profilePic;
    var sId = _sId;

    if (_lat == null || _lat == "" || _long == null || _long == "") {
      CommonUtils().showMessage(context,
          "Unable to find your location, please open settings app and give permission for the same.",
          () {
        Navigator.pop(context);
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().signUp(
      email,
      password,
      fullname,
      "vendor",
      mobileNo,
      loginVia,
      address,
      fcmToken,
      companyName,
      sId,
      profilePic,
      drivingLicenseImage,
      cosmetologyLicenseImage
    );

    if (response != null) {
      final json = jsonDecode(response.body);
      print("JSON Data: ");
      print(json);
      if (json['errorcode'] != null && json['errorcode'] == 0) {
        _saveUserData(json["data"][0]);
        setState(() {
          _isLoading = false;
        });
        onNavigateDashboard();
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
        CommonUtils().showMessage(context, "Something went wrong!", () {
          Navigator.pop(context);
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        setState(() {
          _loginVia = "n";
        });
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
       /* var graphResponse = await http.get();
*/
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
      await _googleSignIn.signIn();
      print(_googleSignIn.currentUser);
      setState(() {
        _loginVia = "g";
        _userName = _googleSignIn.currentUser.displayName;
        _email = _googleSignIn.currentUser.email;
        _profilePic = _googleSignIn.currentUser.photoUrl;

        _sId = _googleSignIn.currentUser.id;
        _emailController = TextEditingController(text: _email);
        _usernameController = TextEditingController(text: _userName);
      });
    } catch (err) {
      setState(() {
        _loginVia = "n";
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
                  RegularTextField(
                    regularText: Strings.company,
                    regularTextColor: Colors.white,
                    textColor: Colors.white,
                    obsecureText: false,
                    controller: _companyNameController,
                    inputType: TextInputType.text,
                    validator: Validations().validateCompanyName,
                    value: (String val) {
                      _companyName = val;
                    },
                    underLineColorDefault: Colors.white,
                    underLineColorSelected: Colors.white,
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
                    height: 12,
                  ),
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => _pickDrivingLicenseImage(),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16),
                                color: Colours.darkGrey),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: drivingLicenseImage == null
                                  ? Container()
                                  : Image(
                                      image: FileImage(drivingLicenseImage),
                                      width: MediaQuery.of(context).size.width,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () => _pickDrivingLicenseImage(),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/images/camera.png",
                                  width: 48,
                                  height: 48,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Upload Driving License Photo",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'OktaNeue-Regular',
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => _pickCosmetologyLicenseImage(),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16),
                                color: Colours.darkGrey),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: cosmetologyLicenseImage == null
                                  ? Container()
                                  : Image(
                                image: FileImage(cosmetologyLicenseImage),
                                width: MediaQuery.of(context).size.width,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () => _pickCosmetologyLicenseImage(),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/images/camera.png",
                                  width: 48,
                                  height: 48,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Upload Cosmetology License Photo",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'OktaNeue-Regular',
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            checkColor: Colors.white,
                            autofocus: false,
                            value: _isChecked,
                            onChanged: (bool value) {
                              setState(() {
                                _isChecked = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "I accept the terms & conditions of the",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Poppins-LightItalic',
                                    fontStyle: FontStyle.normal),
                              ),
                              Text(
                                "Vendor's Agreement",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                    fontFamily: 'Poppins-LightItalic',
                                    fontStyle: FontStyle.normal),
                              ),
                            ],
                          ),
                        )
                      ]),
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

  void _pickCosmetologyLicenseImage() async {
    final image = await _pickImage();
    setState(() => cosmetologyLicenseImage = image);
  }

  void _pickDrivingLicenseImage() async {
    final image = await _pickImage();
    setState(() => drivingLicenseImage = image);
  }

  _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        File croppedFile = await ImageCropper.cropImage(
          sourcePath: file.path,
          maxWidth: 512,
          maxHeight: 512,
        );
        return croppedFile;
      }
    }
    return null;
  }

  void onNavigateDashboard() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => SetPriceScreen(true),
    ));
  }

  void onNavigateSignIn() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => VendorSignInScreen(),
    ));
  }
}
