import 'package:beu_flutter/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'dart:convert';

class VendorContactUsScreen extends StatefulWidget {
  final String userId;
  VendorContactUsScreen({this.userId}): super();
  _VendorContactUsScreenState createState() => _VendorContactUsScreenState();
}

class _VendorContactUsScreenState extends State<VendorContactUsScreen>{

  String userId;
  String _message = "";

  void sendMessage(){
    print('Sending message: $_message');
    ApiService().sendContactUsMessage(_message, widget.userId)
      .then((response) {
        var messageText = "";

        print("We've made it back to the alert: ${response.body}");
        if(response == null){
          messageText = "Received no response from server";
        }
        else {
          messageText = jsonDecode(response.body)['message'].toString();
        }
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Message"),
            content: Text(messageText),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Ok'),
                child: const Text('Ok'),
              )
            ],
          )
        );
      }
    );
  }


  Widget mainColumn(){
    return Column(
      children: [
        TextFormField(
          onChanged: (text) => setState(() => _message = text),
          minLines: 1,
          maxLines: 50,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintStyle: new TextStyle(
              color: Colors.blueGrey,
              fontFamily: 'Poppins-Light',
              fontSize: 15,
            )
          ),
        ),
      ],
    );
  }

  Widget bodyWidget(BuildContext context){
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 75, left: 32, right: 32, bottom: 44),
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
      child: Wrap(
        children: [
          Container(
            padding: EdgeInsets.only(left: 24, right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: mainColumn(),
          ),
          Center(
            child: GestureDetector(
              onTap: () => {
                sendMessage(),
                },
              child: RegularButton(
                regularText: "Send Message",
              ),
            ),
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: bodyWidget(context),
      resizeToAvoidBottomInset: true,
    );
  }

}