import 'dart:convert';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/vendor_price_list.dart';
import 'package:beu_flutter/screens/customer/customer_dashboard_screen.dart';
import 'package:beu_flutter/screens/customer/customer_notifications_screen.dart';
import 'package:beu_flutter/screens/customer/service_list_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/utils/confirmationAlertDialoge.dart';
import 'package:beu_flutter/utils/validations.dart';
import 'package:beu_flutter/widgets/regularTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentDetailsScreen extends StatefulWidget {
  Services category;
  String name, phone, address, bookingId, userid;

  PaymentDetailsScreen(
      {this.category,
      this.name,
      this.phone,
      this.address,
      this.bookingId,
      this.userid});
  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  SharedPreferences prefs;
  TextEditingController _nameController,
      _cardController,
      _expYearController,
      _expMonthController,
      _cvvController;
  String _name, _card, _espMonth, _espYear, _cvv, _transId;

  List<String> _services = new List<String>();
  List<String> _price = new List<String>();
  bool _isLoading = false;
  int _total;

  final GlobalKey<FormState> _paymentForm = GlobalKey<FormState>();
  @override
  initState() {
    _services.add(widget.category.innercategory.categoryName);
    _price.add(widget.category.price);

    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _cardController = TextEditingController(
          text: prefs.containsKey("cardNumber")
              ? prefs.getString("cardNumber")
              : "");
      _expMonthController = TextEditingController(
          text:
              prefs.containsKey("expMonth") ? prefs.getString("expMonth") : "");

      _expYearController = TextEditingController(
          text: prefs.containsKey("expYear") ? prefs.getString("expYear") : "");
    });
  }

  int calculateTotal() {
    int sum = 0;
    for (var i = 0; i < _price.length; i++) {
      sum = sum + int.parse(_price[i]);
    }
    return sum;
  }

  Widget _bodyWidget() {
    return Container(
        padding: EdgeInsets.only(top: 42, left: 28, right: 28),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_backspace,
                          color: Colors.white,
                          size: 30,
                        )),
                    Spacer(),
                    GestureDetector(
                        child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24,
                    )),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Payment Details",
                  style: TextStyle(
                      fontSize: 34,
                      color: Colors.white,
                      fontFamily: 'Poppins-ExtraBold',
                      letterSpacing: 0.4),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Summary",
                  maxLines: 3,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins-Light",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                _buildSummary(),
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins-Light',
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$ ${calculateTotal().toString()}",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins-Light',
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    "Payment Method",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontFamily: 'Poppins-Bold',
                        letterSpacing: 0.4),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.all(12),
                  child: Form(
                    key: _paymentForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RegularTextField(
                          regularText: "Card Number",
                          regularTextColor: Colors.black,
                          textColor: Colors.blue,
                          obsecureText: false,
                          controller: _cardController,
                          inputType: TextInputType.number,
                          validator: Validations().validateCard,
                          value: (String val) {
                            _card = val;
                          },
                          underLineColorDefault: Colors.blueGrey,
                          underLineColorSelected: Colors.blue,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        RegularTextField(
                          regularText: "Card Holder's Name",
                          regularTextColor: Colors.black,
                          textColor: Colors.blue,
                          obsecureText: false,
                          controller: _nameController,
                          inputType: TextInputType.text,
                          validator: Validations().validateName,
                          value: (String val) {
                            _name = val;
                          },
                          underLineColorDefault: Colors.blueGrey,
                          underLineColorSelected: Colors.blue,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: RegularTextField(
                                regularText: "Exp.Year(YYYY)",
                                regularTextColor: Colors.black,
                                textColor: Colors.blue,
                                obsecureText: false,
                                controller: _expYearController,
                                inputType: TextInputType.text,
                                validator: Validations().validateExpYear,
                                value: (String val) {
                                  _espYear = val;
                                },
                                underLineColorDefault: Colors.blueGrey,
                                underLineColorSelected: Colors.blue,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              flex: 1,
                              child: RegularTextField(
                                regularText: "Exp.Month (MM)",
                                regularTextColor: Colors.black,
                                textColor: Colors.blue,
                                obsecureText: false,
                                controller: _expMonthController,
                                inputType: TextInputType.text,
                                validator: Validations().validateExpMonth,
                                value: (String val) {
                                  _espMonth = val;
                                },
                                underLineColorDefault: Colors.blueGrey,
                                underLineColorSelected: Colors.blue,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              flex: 1,
                              child: RegularTextField(
                                regularText: "CVV",
                                regularTextColor: Colors.black,
                                textColor: Colors.blue,
                                obsecureText: true,
                                controller: _cvvController,
                                inputType: TextInputType.text,
                                validator: Validations().validateCvv,
                                value: (String val) {
                                  _cvv = val;
                                },
                                underLineColorDefault: Colors.blueGrey,
                                underLineColorSelected: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 480,
                          height: 48,
                          margin: EdgeInsets.only(
                            left: 18,
                            right: 18,
                          ),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/splash_bg.png",
                                  ),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(28)),
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : GestureDetector(
                                  onTap: _submit,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.lock_outline,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Make Payment",
                                        style: TextStyle(
                                            fontFamily: 'Poppins-Bold',
                                            color: Colors.white,
                                            fontSize: 22),
                                      )
                                    ],
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                )
              ]),
        ));
  }

  Widget _buildSummary() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _services.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  _services[index],
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins-Light',
                      color: Colors.white),
                ),
              ),
              Text(
                "\$ ${_price[index]}",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins-Light',
                    color: Colors.white),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: true,
    );
  }

  void onNavigate() {
    Navigator.of(context).pushAndRemoveUntil(
      new PageRouteBuilder(
          maintainState: true,
          opaque: true,
          pageBuilder: (context, _, __) => new CustomerDashboardScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void onNavigateNotifications() {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => CustomerNotificationsScreen(),
    ));
  }

  void onNavigateServiceList() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new ServiceListScreen(),
    ));
  }

  _submit() async {
    if (_paymentForm.currentState.validate()) {
      _paymentForm.currentState.save();

      setState(() {
        _isLoading = true;
      });

      final response = await ApiService().authorizeNetPayment(
          widget.category.innercategory.categoryName,
          widget.category.price,
          _card,
          _espYear + "-" + _espMonth,
          _cvv,
          widget.name,
          widget.phone,
          widget.address,
          widget.bookingId,
          widget.userid);
      if (response != null) {
        print(response);
        final json = jsonDecode(response.toString());
        print("JSON " + json.toString());
        if (json['messages']['resultCode'] == "Ok") {
          setState(() {
            _transId = json['transactionResponse']['transId'];
          });
          _updateData(json);
        } else {
          setState(() {
            _isLoading = false;
          });
          if (json['transactionResponse']["errors"] != null) {
            CommonUtils().showMessage(
                context, json['transactionResponse']["errors"][0]['errorText'],
                () {
              Navigator.pop(context);
            });
          } else {
            CommonUtils().showMessage(
                context, json['messages']['message'][0]['text'], () {
              Navigator.pop(context);
            });
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        CommonUtils().showMessage(context, "Something went Wrong", () {
          Navigator.pop(context);
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateData(var jsonTrans) async {
    final response = await ApiService().getChargeCreditCard(
        widget.userid, widget.bookingId, jsonTrans);
    print(response);
    if (response != null) {
      print(response);
      final json = jsonDecode(response.toString());
      if (json['errorcode'] != null && json['errorcode'] == 0) {
        setState(() {
          _isLoading = true;
        });
        showConfirmationMessage(
            context, "Your service has been booked successfully", onNavigate);
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
    }
  }
}
