import 'dart:convert';
import 'dart:io';

import 'package:beu_flutter/models/card.dart';
import 'package:beu_flutter/screens/customer/customer_dashboard_screen.dart';
import 'package:beu_flutter/screens/customer/customer_edit_profile_screen.dart';
import 'package:beu_flutter/screens/customer/payment_info_screen.dart';
import 'package:beu_flutter/screens/vendor/set_price_screen.dart';
import 'package:beu_flutter/screens/vendor/set_service_price_screen.dart';
import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class AddCardScreen extends StatefulWidget {
  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  TextEditingController _nameController,
      _cardController,
      _expYearController,
      _expMonthController,
      _cvvController;
  String _name, _card, _espMonth, _espYear, _cvv;
  final GlobalKey<FormState> _paymentForm = GlobalKey<FormState>();

  SharedPreferences prefs;
  List<String> myCard = new List<String>();

  @override
  initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    myCard = prefs.containsKey("cardList")
        ? prefs.getStringList("cardList")
        : new List<String>();
    print(myCard.length);
  }

  Widget _bodyWidget() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
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
          child: Form(
            key: _paymentForm,
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
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
                        "Card Details",
                        style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontFamily: 'Poppins-ExtraBold',
                            letterSpacing: 0.4),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      RegularTextField(
                        regularText: "Card Number",
                        regularTextColor: Colors.white,
                        textColor: Colors.black,
                        obsecureText: false,
                        controller: _cardController,
                        inputType: TextInputType.number,
                        validator: Validations().validateCard,
                        value: (String val) {
                          _card = val;
                        },
                        underLineColorDefault: Colors.white,
                        underLineColorSelected: Colors.white,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      RegularTextField(
                        regularText: "Card Holder's Name",
                        regularTextColor: Colors.white,
                        textColor: Colors.black,
                        obsecureText: false,
                        controller: _nameController,
                        inputType: TextInputType.text,
                        validator: Validations().validateName,
                        value: (String val) {
                          _name = val;
                        },
                        underLineColorDefault: Colors.white,
                        underLineColorSelected: Colors.white,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: RegularTextField(
                              regularText: "Exp.Year(YYYY)",
                              regularTextColor: Colors.white,
                              textColor: Colors.black,
                              obsecureText: false,
                              controller: _expYearController,
                              inputType: TextInputType.text,
                              validator: Validations().validateExpYear,
                              value: (String val) {
                                _espYear = val;
                              },
                              underLineColorDefault: Colors.white,
                              underLineColorSelected: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: RegularTextField(
                              regularText: "Exp.Month (MM)",
                              regularTextColor: Colors.white,
                              textColor: Colors.black,
                              obsecureText: false,
                              controller: _expMonthController,
                              inputType: TextInputType.text,
                              validator: Validations().validateExpMonth,
                              value: (String val) {
                                _espMonth = val;
                              },
                              underLineColorDefault: Colors.white,
                              underLineColorSelected: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: onNavigate,
            child: RegularButton(
              regularText: "Save",
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  void onNavigate() {
    if (_paymentForm.currentState.validate()) {
      _paymentForm.currentState.save();
      saveDataOnPref();

      Navigator.of(context).pushReplacement(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new PaymentInfoScreen(),
      ));
    }
  }

  void saveDataOnPref() {
    CardDetails data = CardDetails(
        cardHolderName: _name,
        cardNumber: _card,
        expMonth: _espMonth,
        expYear: _espYear);
    print(data.toJson());
    setState(() {
      if (!myCard.contains(data.toJson())) myCard.add(jsonEncode(data));
      prefs.setStringList("cardList", myCard);
    });
  }
}
