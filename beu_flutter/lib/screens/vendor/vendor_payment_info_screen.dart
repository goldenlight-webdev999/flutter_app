import 'dart:convert';
import 'dart:io';

import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/utils/validations.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:beu_flutter/widgets/regularTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorPaymentInfoScreen extends StatefulWidget {
  String userid;
  VendorPaymentInfoScreen({this.userid});
  @override
  _VendorpaymentInfoScreenState createState() =>
      _VendorpaymentInfoScreenState();
}

class _VendorpaymentInfoScreenState extends State<VendorPaymentInfoScreen> {
  final GlobalKey<FormState> _bankDetailsFormKey = GlobalKey<FormState>();
  TextEditingController _bankNameController,
      _accountNameController,
      _accountNumberController,
      _rountingNumberController,
      _accountStateController;

  String bankName, accountNam, accountNumber, routingNumber, accountState;

  @override
  initState() {
    super.initState();
    _getBankDetails();
  }

  _getBankDetails() async {
    final response = await ApiService().getBankDetails(widget.userid);
    if (response != null) {
      final json = jsonDecode(response.toString());

      if (json['errorcode'] != null && json['errorcode'] == 0) {
        setState(() {
          _bankNameController = TextEditingController(
              text: json['data']['bankname'] != null
                  ? json['data']['bankname']
                  : "");
          _accountNameController = TextEditingController(
              text: json['data']['accountname'] != null
                  ? json['data']['accountname']
                  : "");
          _accountNumberController = TextEditingController(
              text: json['data']['accountnumber'] != null
                  ? json['data']['accountnumber']
                  : "");
          _accountStateController = TextEditingController(
              text: json['data']['accountstate'] != null
                  ? json['data']['accountstate']
                  : "");
          _rountingNumberController = TextEditingController(
              text: json['data']['routingnumber'] != null
                  ? json['data']['routingnumber']
                  : "");
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
  }

  Widget _bodyWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(
        top: 44,
        left: 32,
        right: 32,
      ),
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
          key: _bankDetailsFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                    size: 30,
                  )),
              SizedBox(
                height: 6,
              ),
              Text(
                "Payment Info",
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontFamily: 'Poppins-ExtraBold',
                    letterSpacing: 0.4),
              ),
              _buildDetailsSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSummary() {
    return Column(children: <Widget>[
      SizedBox(
        height: 12,
      ),
      RegularTextField(
        regularText: "Bank Name",
        regularTextColor: Colors.white,
        textColor: Colors.white,
        obsecureText: false,
        controller: _bankNameController,
        inputType: TextInputType.text,
        validator: Validations().validateCommon,
        value: (String val) {
          bankName = val;
        },
        underLineColorDefault: Colors.white,
        underLineColorSelected: Colors.white,
      ),
      SizedBox(
        height: 12,
      ),
      RegularTextField(
        regularText: "Account Name",
        regularTextColor: Colors.white,
        textColor: Colors.white,
        obsecureText: false,
        controller: _accountNameController,
        inputType: TextInputType.text,
        validator: Validations().validateCommon,
        value: (String val) {
          accountNam = val;
        },
        underLineColorDefault: Colors.white,
        underLineColorSelected: Colors.white,
      ),
      SizedBox(
        height: 12,
      ),
      RegularTextField(
        regularText: "Account Number",
        regularTextColor: Colors.white,
        textColor: Colors.white,
        obsecureText: false,
        controller: _accountNumberController,
        inputType: TextInputType.number,
        validator: Validations().validateCommon,
        value: (String val) {
          accountNumber = val;
        },
        underLineColorDefault: Colors.white,
        underLineColorSelected: Colors.white,
      ),
      SizedBox(
        height: 12,
      ),
      RegularTextField(
        regularText: "Routing Number",
        regularTextColor: Colors.white,
        textColor: Colors.white,
        obsecureText: false,
        validator: Validations().validateCommon,
        controller: _rountingNumberController,
        inputType: TextInputType.text,
        value: (String val) {
          routingNumber = val;
        },
        underLineColorDefault: Colors.white,
        underLineColorSelected: Colors.white,
      ),
      SizedBox(
        height: 12,
      ),
      RegularTextField(
        regularText: "Account State",
        regularTextColor: Colors.white,
        textColor: Colors.white,
        obsecureText: false,
        validator: Validations().validateCommon,
        controller: _accountStateController,
        inputType: TextInputType.text,
        value: (String val) {
          accountState = val;
        },
        underLineColorDefault: Colors.white,
        underLineColorSelected: Colors.white,
      ),
      SizedBox(
        height: 12,
      ),
      SizedBox(
        height: 15,
      ),
      GestureDetector(
        onTap: _onSubmit,
        child: RegularButton(
          regularText: "Save",
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyWidget(),
    );
  }

  Future<Null> _onSubmit() async {
    if (_bankDetailsFormKey.currentState.validate()) {
      _bankDetailsFormKey.currentState.save();

      final response = await ApiService().updateBankDetails(
        widget.userid,
        bankName,
        accountNam,
        accountNumber,
        routingNumber,
        accountState,
      );

      if (response != null) {
        final json = jsonDecode(response.toString());
        print("JSON Data: ");
        print(json);
        if (json['errorcode'] != null && json['errorcode'] == 0) {
          CommonUtils().showMessage(context, json["message"], () {
            Navigator.pop(context);
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
    }
  }
}
