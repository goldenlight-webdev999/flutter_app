import 'dart:convert';
import 'dart:io';

import 'package:beu_flutter/models/card.dart';
import 'package:beu_flutter/screens/customer/add_card_screen.dart';
import 'package:beu_flutter/screens/customer/customer_dashboard_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentInfoScreen extends StatefulWidget {
  @override
  _PaymentInfoScreenState createState() => _PaymentInfoScreenState();
}

class _PaymentInfoScreenState extends State<PaymentInfoScreen> {
  bool _isImageUploading = false;
  SharedPreferences prefs;
  List<String> myCard = new List<String>();

  @override
  initState() {
    super.initState();
  }

  Future<List<String>> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("cardList")) {
      myCard = await prefs.getStringList("cardList");
    } else {
      myCard = new List<String>();
    }
    if (myCard.length != 0)
      return myCard;
    else
      return Future.error("No Card Found");
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
                      "Payment Info",
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'Poppins-ExtraBold',
                          letterSpacing: 0.4),
                    ),
                    _buildSummary(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: onNavigate,
            child: RegularButton(
              regularText: "Add New Card",
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSummary() {
    return FutureBuilder<List<String>>(
        future: _getSharedPrefs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Align(
              alignment: Alignment.topCenter,
              child: Text(
                "No Card Found",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Poppins-ExtraBold',
                    letterSpacing: 0.4),
              ),
            );
          } else {
            return Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: myCard.length,
                  itemBuilder: (BuildContext context, int index) {
                    var jsonObj = jsonDecode(snapshot.data[index]);

                    return InkWell(
                      onTap: () {
                        _showPaymentInfoMessage(context, index, jsonObj);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            jsonObj['cardHolderName'],
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Poppins-LightItalic',
                                color: Colors.black),
                          ),
                          Text(
                            jsonObj['cardNumber'],
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-Light',
                                color: Colors.white),
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1,
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  void onNavigateDashboard() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new CustomerDashboardScreen(),
    ));
  }

  void onNavigate() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new AddCardScreen(),
    ));
  }

  void saveCardDetails(String _card, String year, String month) {
    prefs.setString('cardNumber', _card);
    prefs.setString('expYear', year);
    prefs.setString('expMonth', month);

    print("Stored in SharedPerfences");
  }

  _showPaymentInfoMessage(BuildContext context, int index, var jsonObj) {
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
            "Choice the Options ",
            textScaleFactor: 1.0,
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                    child: Text(
                      'Delete Card',
                      textScaleFactor: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        myCard.removeAt(index);
                        prefs.setStringList("cardList", myCard);
                        Navigator.pop(context);
                      });
                    }),
                FlatButton(
                    child: Text(
                      'Set default',
                      textScaleFactor: 1.0,
                    ),
                    onPressed: () {
                      saveCardDetails(jsonObj['cardNumber'], jsonObj['expYear'],
                          jsonObj['expMonth']);
                      Navigator.pop(context);
                    }),
                FlatButton(
                    child: Text(
                      'Cancel',
                      textScaleFactor: 1.0,
                    ),
                    onPressed: () => Navigator.pop(context)),
              ],
            )
          ],
        );
      },
    );
    return;
  }
}
