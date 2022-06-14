import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beu_flutter/utils/colours.dart';

void showMessage(BuildContext context, String message, Function onOkclick,bool visibility,MainAxisAlignment mainAxisAlignment) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          //this right here
          child: Container(
            decoration: BoxDecoration(
                color: Colours.alertBg,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10)),
            height: 176,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                ),
                Text(
                  'BEU',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colours.ok_bg,shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10),bottomRight: Radius.circular(10))
                  ),
                  child: Row(
                    mainAxisAlignment: mainAxisAlignment,
                    children: <Widget>[
                      Visibility(
                        visible:visibility,
                        child: MaterialButton(
                          onPressed:onOkclick,
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: visibility,
                        child: VerticalDivider(
                          color: Colours.alertBg,
                          width: 2,
                          thickness: 2,
                        ),
                      ),
                      MaterialButton(
                        onPressed:(){
                          Navigator.pop(context);
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });

  return;
}
