import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String regularText;
  final TextInputType inputType;
  Function onchange;

  SearchField(
      {@required this.regularText, @required this.inputType, this.onchange});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 24, right: 10),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(24),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              keyboardType: inputType,
              onChanged: onchange,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintStyle: new TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: 'Poppins-Light',
                      fontSize: 15),
                  hintText: regularText,
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                    size: 20,
                  )),
              autofocus: false,
            ),
          ],
        ));
  }
}
