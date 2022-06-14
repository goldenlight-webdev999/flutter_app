import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegularTextField extends StatelessWidget {
  final String regularText;
  final TextInputType inputType;
  final Color textColor;
  final Color regularTextColor;
  final Color underLineColorDefault;
  final Color underLineColorSelected;
  final TextEditingController controller;
  final Function validator;
  final Function value;
  final bool obsecureText;
  final Widget icon;

  RegularTextField({
    @required this.regularText,
    @required this.inputType,
    @required this.textColor,
    @required this.regularTextColor,
    @required this.underLineColorDefault,
    @required this.underLineColorSelected,
    @required this.controller,
    this.validator,
    @required this.value,
    @required this.obsecureText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          // decoration:
          //     BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: TextFormField(
            obscureText: obsecureText,
            validator: validator,
            onSaved: value,
            controller: controller,
            keyboardType: inputType,
            style: TextStyle(
              fontFamily: 'Poppins-LightItalic',
              fontStyle: FontStyle.normal,
              fontSize: 14,
              letterSpacing: 1,
              color: regularTextColor,
            ),
            decoration: InputDecoration(
                prefixIcon: icon,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: underLineColorDefault)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: underLineColorSelected)),
                hintStyle: TextStyle(
                  fontFamily: 'Poppins-LightItalic',
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  letterSpacing: 1,
                  color: textColor,
                ),
                hintText: regularText),
          ),
        ),
      ],
    );
  }
}
