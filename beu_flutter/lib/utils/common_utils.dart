import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CommonUtils {
  void saveUserData(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', data["userid"]);
    prefs.setString('fullname', data["fullname"]);
    prefs.setString('profilepic', data["profilepic"]);
    prefs.setString('usertype', data["usertype"]);
    prefs.setString('email', data["email"]);
    prefs.setString('address', data["address"]);
    prefs.setString('mobileno', data["mobileno"]);
    prefs.setBool('messageShow', true);
  }

  showMessage(BuildContext context, String message, Function onClickBtn) {
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
                onPressed: onClickBtn)
          ],
        );
      },
    );
    return;
  }
}
