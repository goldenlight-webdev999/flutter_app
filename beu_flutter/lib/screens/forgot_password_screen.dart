import 'dart:convert';

import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/screens/customer/account_verify_screen.dart';
import 'package:beu_flutter/screens/forgot_password_verify_screen.dart';
import 'package:beu_flutter/screens/set_password_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/utils/validations.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:beu_flutter/widgets/regularTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotScreen extends StatefulWidget {
  final String userType;

  const ForgotScreen({Key key, this.userType}) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  TextEditingController _emailController;

  GlobalKey<FormState> _forgotFormKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _autoValidate = false;
  String _email;

  @override
  initState() {
    super.initState();
  }

  void _validateInputs() async {
    if (_forgotFormKey.currentState.validate()) {
      _forgotFormKey.currentState.save();
      var email = _email;

      setState(() {
        _isLoading = true;
      });
      final response = await ApiService().forgotPassword(email.trim());
      if (response != null) {
        final json = jsonDecode(response.toString());

        setState(() {
          _isLoading = false;
        });
        if (json['errorcode'] != null && json['errorcode'] == 0) {
          onNavigateAccountScreen();
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
        _autoValidate = true;
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
            Strings.forgot,
            style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontFamily: 'Poppins-ExtraBold',
                letterSpacing: 0.4),
          ),
          Text(
            Strings.pass_word,
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
            Strings.please_enter,
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontFamily: 'Poppins-Regular'),
          ),
          SizedBox(
            height: 32,
          ),
          Form(
            key: _forgotFormKey,
            autovalidateMode: _autoValidate?AutovalidateMode.always:AutovalidateMode.disabled,
            child: RegularTextField(
              regularText: Strings.email_or_mobile,
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

  void onNavigateAccountScreen() {
    print(_email + widget.userType);
    Navigator.of(context).push(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => ForgotVerifyScreen(
          email: _email,
          userType: widget.userType,
        ),
      ),
    );
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
