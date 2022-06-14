import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegularButton extends StatelessWidget {
  final String regularText;

  RegularButton({
    @required this.regularText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 480,
      height: 90,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/signup_button_bg.png"),
          fit: BoxFit.cover
        ),
      ),
      child:
        Text(regularText,style: TextStyle(fontFamily: 'Poppins-Bold',color: Colors.white,fontSize: 22),)

    );
  }
}