import 'dart:convert';
import 'dart:io';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/screens/vendor/set_price_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_select_service_for_photos_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/utils/validations.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:beu_flutter/widgets/regularTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorEditProfileScreen extends StatefulWidget {
  @override
  _VendorEditProfileScreenState createState() =>
      _VendorEditProfileScreenState();
}

class _VendorEditProfileScreenState extends State<VendorEditProfileScreen> {
  SharedPreferences prefs;
  String userid,
      email,
      fullname,
      profilepic,
      mobileno,
      address,
      fblink,
      instalink;
  final GlobalKey<FormState> _editProfileFormKey = GlobalKey<FormState>();

  TextEditingController _fullNameController,
      _emailController,
      _phoneController,
      _addressController,
      _fbController,
      _instaController;
  File _image;
  String _profilepic, _fullName, _email, _phone, _address, _fb, _insta, companyName;
  bool _isImageUploading = false;
  bool _isLoading = false;
  bool _autoValidate = false;

  @override
  initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
      email = prefs.getString("email");
      fullname = prefs.getString("fullname");
      mobileno = prefs.getString("mobileno");
      address = prefs.getString("address");
      fblink = prefs.getString("fblink");
      companyName = prefs.getString("companyname");
      instalink = prefs.getString("instalink");
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
    _fullNameController = TextEditingController(text: fullname);
    _phoneController = TextEditingController(text: mobileno);
    _emailController = TextEditingController(text: email);
    _addressController = TextEditingController(text: address);
    _fbController = TextEditingController(text: fblink);
    _instaController = TextEditingController(text: instalink);
  }

  void _saveUserData(data) async {
    prefs.setString('userid', data["userid"]);
    prefs.setString('fullname', data["fullname"]);
    prefs.setString('profilepic', data["profilepic"]);
    prefs.setString('usertype', data["usertype"]);
    prefs.setString('email', data["email"]);
    prefs.setString('address', data["addressline1"]);
    prefs.setString('mobileno', data["mobileno"]);
    prefs.setString('fblink', data["fblink"]);
    prefs.setString('instalink', data["instalink"]);
  }

  void _validateInputs() async {
    if (_editProfileFormKey.currentState.validate()) {
      _editProfileFormKey.currentState.save();
      email = _email;
      if (_fullName != null){
        fullname = _fullName;
      }
      if (_address != null) {
        address = _address;
      }
      var insta = "";
      if (_insta != null) {
        insta = _insta;
      }
      var fb = "";
      if (_fb != null) {
        fb = _fb;
      }
      if (_phone != null) {
        mobileno = _phone;
      }
      setState(() {
        _isLoading = true;
      });
      final response = await ApiService().vendorProfileUpdate(
          fullname, userid, address, "", insta, fb, mobileno);
      if (response != null) {
        final json = jsonDecode(response.toString());
        print("JSON Data: ");
        print(json);
        if (json['errorcode'] != null && json['errorcode'] == 0) {
          _saveUserData(json["data"][0]);
          CommonUtils().showMessage(context, "Profile updated successfully",
              () {
            Navigator.pop(context);
          });
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
        child: Form(
          key: _editProfileFormKey,
          autovalidateMode: _autoValidate?AutovalidateMode.always:AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 48,
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildImage(),
                    SizedBox(height: 4),
                    Text(
                      fullname ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins-Bold",
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      companyName ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins-Bold",
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),

              RegularTextField(
                regularText: Strings.username,
                regularTextColor: Colors.black,
                textColor: Colors.black,
                obsecureText: false,
                controller: _fullNameController,
                inputType: TextInputType.text,
                validator: Validations().validateName,
                value: (String val) {
                  _fullName = val;
                },
                underLineColorDefault: Colors.white,
                underLineColorSelected: Colors.white,
              ),
              SizedBox(
                height: 12,
              ),

              RegularTextField(
                regularText: Strings.mobile,
                regularTextColor: Colors.black,
                textColor: Colors.black,
                obsecureText: false,
                controller: _phoneController,
                inputType: TextInputType.number,
                validator: Validations().validateMobile,
                value: (String val) {
                  _phone = val;
                },
                underLineColorDefault: Colors.white,
                underLineColorSelected: Colors.white,
              ),
              SizedBox(
                height: 12,
              ),
              AbsorbPointer(
                absorbing: true,
                child: RegularTextField(
                  regularText: Strings.email,
                  regularTextColor: Colors.black,
                  textColor: Colors.black,
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
              ),
              SizedBox(
                height: 6,
              ),
              RegularTextField(
                regularText: "Address",
                regularTextColor: Colors.black,
                textColor: Colors.black,
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
              // SizedBox(
              //   height: 6,
              // ),
              // RegularTextField(
              //   regularText: "Address2",
              //   regularTextColor: Colors.black,
              //   textColor: Colors.black,
              //   obsecureText: false,
              //   controller: _add2Controller,
              //   inputType: TextInputType.text,
              //   value: (String val) {
              //     _address2 = val;
              //   },
              //   underLineColorDefault: Colors.white,
              //   underLineColorSelected: Colors.white,
              // ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Add Social Media Account Links",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins-Light",
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12,
              ),
              RegularTextField(
                icon: GestureDetector(
                  onTap: () {
                    _launchURL(_fb ?? fblink);
                  },
                  child: Image.asset(
                    "assets/images/fb.png",
                    width: 4,
                    height: 4,
                  ),
                ), 
                regularText: "Add facebook link here",
                regularTextColor: Colors.black,
                textColor: Colors.black,
                obsecureText: false,
                controller: _fbController,
                inputType: TextInputType.text,
                value: (String val) {
                  _fb = val;
                },
                underLineColorDefault: Colors.white,
                underLineColorSelected: Colors.white,
              ),
              SizedBox(
                height: 6,
              ),
              RegularTextField(
                icon: GestureDetector(
                 onTap: () {
                    _launchURL(_insta ?? instalink);
                  },
                  child: Image.asset(
                    "assets/images/insta.png",
                    width: 8,
                    height: 8,
                  )
                ),
                regularText: "Add instagram link here",
                regularTextColor: Colors.black,
                textColor: Colors.black,
                obsecureText: false,
                controller: _instaController,
                inputType: TextInputType.text,
                value: (String val) {
                  _insta = val;
                },
                underLineColorDefault: Colors.white,
                underLineColorSelected: Colors.white,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: onNavigateSetPrice,
                    child: Container(
                      width: 140,
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colours.welcome_bg)),
                      alignment: Alignment.center,
                      child: Text(
                        'Set Price',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins-Light",
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onNavigateSelectServiceToAddPhotos,
                    child: Container(
                      width: 140,
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colours.welcome_bg)),
                      alignment: Alignment.center,
                      child: Text(
                        'Add Photos',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins-Light",
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              _isLoading
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 32),
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.white))
                  : GestureDetector(
                      onTap: _validateInputs,
                      child: RegularButton(
                        regularText: "Done",
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          height: 128,
          width: 128,
          margin: EdgeInsets.only(top: 2, bottom: 2),
          decoration: BoxDecoration(
            color: Colours.darkGrey,
            borderRadius: BorderRadius.circular(16),
          ),
          child: _isImageUploading
              ? Center(child: CircularProgressIndicator())
              : profilepic != null && profilepic != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        profilepic,
                        width: 128,
                        height: 128,
                        fit: BoxFit.cover,
                      ),
                    )
                  : _image == null
                      ? Image.asset("assets/images/man.png")
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image(
                            image: FileImage(_image),
                            width: 128,
                            height: 128,
                            fit: BoxFit.cover,
                          ),
                        ),
        ),
        Positioned(
          right: -8,
          top: -6,
          child: GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.redAccent,
              child: Image.asset(
                "assets/images/edit.png",
                height: 12,
                width: 12,
              ),
            ),
          ),
        )
      ],
    );
  }

  void _pickImage() async {
    print("_pickImage");
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select Image"),
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
      ),
    );

    if (imageSource != null) {
      var file = await ImagePicker.pickImage(
          source: imageSource, maxWidth: 512, maxHeight: 512, imageQuality: 40);
      if (file != null) {
        //Cropping the image
        File croppedFile = await ImageCropper.cropImage(
          sourcePath: file.path,
          maxWidth: 512,
          maxHeight: 512,
        );
        setState(() {
          if (croppedFile != null) {
            _image = croppedFile;
            _isImageUploading = true;
          }
        });
        print(userid);
        final response =
            await ApiService().imageUpload(userid, _image, "profilepic");
        if (response != null) {
          final json = jsonDecode(response.toString());
          print("JSON Data: ");
          print(json);
          if (json['errorcode'] != null && json['errorcode'] == 0) {
            if (json["data"]["profilepic"] != null &&
                json["data"]["profilepic"] != "") {
              var pP = json["data"]["profilepic"];
              print(pP);
              prefs.setString("profilepic", profilepic);
              setState(() {
                profilepic = pP;
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
          _isImageUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
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
          ],
        ),
      ),
      body: _bodyWidget(),
      resizeToAvoidBottomInset: true,
    );
  }

  void onNavigateSetPrice() {
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => SetPriceScreen(true),
      ),
    );
  }

  void onNavigateSelectServiceToAddPhotos() {
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => VendorSelectServiceForPhotosScreen(),
      ),
    );
  }

  void onNavigateDashboard() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => VendorDashboardScreen(),
    ));
  }

  // peter: This will try to open a URL 
  void _launchURL(String url) async {
    String encodedUrl = Uri.encodeFull(url);

    try {
      bool canLaunchUrl = await canLaunch(encodedUrl);
      print("canLaunchUrl: $canLaunchUrl");

      if (!canLaunchUrl) {
        // peter: Display an error message since we can't launch the URL
        _showAlert("Error", "Unable to open this link: $url");
      } else {
        await launch(url);
      }
    } catch (_) {
      _showAlert("Error", "Unable to open this link $url");
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: Text("Ok")
            )
          ]
        );
      });
  }
}
