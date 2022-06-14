import 'dart:convert';
import 'dart:io';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/screens/customer/customer_dashboard_screen.dart';
import 'package:beu_flutter/screens/customer/customer_profile_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/utils/validations.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:beu_flutter/widgets/regularTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerEditProfileScreen extends StatefulWidget {
  @override
  _CustomerEditProfileScreenState createState() =>
      _CustomerEditProfileScreenState();
}

class _CustomerEditProfileScreenState extends State<CustomerEditProfileScreen> {
  TextEditingController _phoneController, _add1Controller, _nameController;
  File _image;
  String _profilepic, _email, _phone, _address1, _address2, _name, _userId;

  final GlobalKey<FormState> _updateInFormKey = GlobalKey<FormState>();

  bool _isImageUploading = false;
  SharedPreferences prefs;
  bool _isLoading = false;
  @override
  initState() {
    super.initState();
    _getSharedPrefs();
  }

  void _saveUserData(data) async {
    prefs.setString('userid', data["userid"]);
    prefs.setString('fullname', data["fullname"]);
    prefs.setString('profilepic', data["profilepic"]);
    prefs.setString('usertype', data["usertype"]);
    prefs.setString('email', data["email"]);
    prefs.setString('address', data["address"]);
    prefs.setString('mobileno', data["mobileno"]);
    print("Stored Data");
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString("userid");
      _email = prefs.getString("email");
      _name = prefs.getString("fullname");
      _nameController = TextEditingController(text: _name);
      _phone = prefs.getString("mobileno");
      _phoneController = TextEditingController(text: _phone);
      _address1 = prefs.getString("address");
      _add1Controller = TextEditingController(text: _address1);
      var pPic = prefs.getString("profilepic");
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
        child: Form(
          key: _updateInFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                  onTap: onNavigateBack,
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                    size: 30,
                  )),
              SizedBox(
                height: 6,
              ),
              Text(
                "Edit Profile",
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontFamily: 'Poppins-ExtraBold',
                    letterSpacing: 0.4),
              ),
              SizedBox(
                height: 12,
              ),
              Center(child: _buildImage()),
              SizedBox(
                height: 12,
              ),
              RegularTextField(
                regularText: "Name",
                regularTextColor: Colors.black,
                textColor: Colors.black,
                obsecureText: false,
                controller: _nameController,
                inputType: TextInputType.text,
                validator: Validations().validateName,
                value: (String val) {
                  setState(() {
                    _name = val;
                  });
                },
                underLineColorDefault: Colors.white,
                underLineColorSelected: Colors.white,
              ),
              SizedBox(
                height: 12,
              ),
              RegularTextField(
                regularText: "Phone No",
                regularTextColor: Colors.black,
                textColor: Colors.black,
                obsecureText: false,
                controller: _phoneController,
                inputType: TextInputType.number,
                validator: Validations().validateMobile,
                value: (String val) {
                  setState(() {
                    _phone = val;
                  });
                },
                underLineColorDefault: Colors.white,
                underLineColorSelected: Colors.white,
              ),
              SizedBox(
                height: 12,
              ),

              RegularTextField(
                regularText: "Address1",
                regularTextColor: Colors.black,
                textColor: Colors.black,
                obsecureText: false,
                controller: _add1Controller,
                validator: Validations().validateAddress,
                inputType: TextInputType.text,
                value: (String val) {
                  setState(() {
                    _address1 = val;
                  });
                },
                underLineColorDefault: Colors.white,
                underLineColorSelected: Colors.white,
              ),
              SizedBox(
                height: 6,
              ),
              // RegularTextField(
              //   regularText: "Address2",
              //   regularTextColor: Colors.black,
              //   textColor: Colors.black,
              //   obsecureText: false,
              //   controller: _add2Controller,
              //   inputType: TextInputType.text,
              //   value: (String val) {
              //     setState(() {
              //       _address2 = val;
              //     });
              //   },
              //   underLineColorDefault: Colors.white,
              //   underLineColorSelected: Colors.white,
              // ),
              SizedBox(
                height: 12,
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : GestureDetector(
                      onTap: () {
                        _submit();
                      },
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
      children: <Widget>[
        Container(
          width: 134,
          height: 128,
        ),
        Container(
          height: 128,
          width: 128,
          margin: EdgeInsets.only(top: 2, bottom: 2),
          decoration: BoxDecoration(
              color: Colours.darkGrey, borderRadius: BorderRadius.circular(10)),
          child: _isImageUploading
              ? _image == null
                  ? Image.asset("assets/images/man.png")
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: FileImage(_image),
                        width: 128,
                        height: 128,
                        fit: BoxFit.cover,
                      ),
                    )
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
                  : Image.asset("assets/images/man.png"),
        ),
        Positioned(
          left: 108,
          top: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.redAccent,
                child: Image.asset("assets/images/edit.png",
                    height: 12, width: 12)),
          ),
        )
      ],
    );
  }

  void _pickImage() async {
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
          _image = croppedFile;
          _isImageUploading = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: true,
    );
  }

  void onNavigateBack() {
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new CustomerProfileScreen(),
    ));
  }

  void onNavigateDashboard() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new CustomerDashboardScreen(),
    ));
  }

  _submit() async {
    if (_updateInFormKey.currentState.validate()) {
      _updateInFormKey.currentState.save();

      setState(() {
        _isLoading = true;
      });
      if (_image != null) {
        final response = await ApiService().imageUploadCustomer(_userId, _image);
        if (response != null) {
          final json = jsonDecode(response.toString());
          print(json.toString());
          if (json['errorcode'] != null && json['errorcode'] == 0) {
            setState(() {
              _profilepic = json['data']['profilepic'];
            });
            _updateData();
          } else {
            setState(() {
              _isLoading = false;
            });
            CommonUtils().showMessage(context, json['message'], () {
              Navigator.pop(context);
            });
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          CommonUtils().showMessage(
              context, "Image Is not Uploaded.Please try again", () {
            Navigator.pop(context);
          });
        }
      } else {
        _updateData();
      }
    }
  }

  void _updateData() async {
    final response = await ApiService().customerProfileUpdation(
        _userId, _address1, _address2, _phone, _name);

    if (response != null) {
      final json = jsonDecode(response.toString());

      if (json['errorcode'] != null && json['errorcode'] == 0) {
        setState(() {
          _isLoading = false;
        });
        _saveUserData(json['data'][0]);
        CommonUtils()
            .showMessage(context, "Profileupdate Successfully", onNavigateBack);
      } else {
        setState(() {
          _isLoading = false;
        });
        CommonUtils().showMessage(context, json['message'], onNavigatorPop);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      CommonUtils().showMessage(context, "Please try again", onNavigatorPop);
    }
  }

  onNavigatorPop() {
    Navigator.pop(context);
  }
}
