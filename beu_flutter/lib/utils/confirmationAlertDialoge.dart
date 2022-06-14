import 'package:beu_flutter/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:url_launcher/url_launcher.dart';

void showConfirmationMessage(
    BuildContext context, String message, Function onOkclick) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          //this right here
          child: SizedBox.expand(
            child: Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 12, bottom: 26),
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/dialog.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(28)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/red_shirt_boy.png",
                                width: 52,
                                height: 52,
                              ),
                              Image.asset(
                                "assets/images/blue_top_girl.png",
                                width: 52,
                                height: 52,
                              ),
                              Image.asset(
                                "assets/images/blue_shirt_boy.png",
                                width: 52,
                                height: 52,
                              ),
                              Image.asset(
                                "assets/images/red_top_girl.png",
                                width: 52,
                                height: 52,
                              ),
                              Image.asset(
                                "assets/images/grey_top_girl.png",
                                width: 52,
                                height: 52,
                              ),
                            ],
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(left: 14),
                              child: Text(message,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontFamily: "Poppins-Bold",
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                          GestureDetector(
                            onTap: onOkclick,
                            child: Container(
                              padding: EdgeInsets.only(top: 2, bottom: 2),
                              margin: EdgeInsets.only(left: 16, right: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                color: Colors.redAccent,
                              ),
                              child: Text(
                                "Done",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontFamily: "Poppins-Bold"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Positioned(
                  //   right: 0,
                  //   top: 140,
                  //   child: GestureDetector(
                  //     onTap: (){
                  //       Navigator.pop(context);
                  //     },
                  //     child: CircleAvatar(
                  //       radius: 22,
                  //       backgroundColor: Colors.redAccent,
                  //       child: Icon(Icons.close,color: Colors.white,size: 28,),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        );
      });

  return;
}

void showPopUpMessage(BuildContext context, String message, Function onclick) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          //this right here
          child: SizedBox.expand(
            child: Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 12, bottom: 26),
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/dialog.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(28)),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("assets/images/covid.png",
                                    width: 52, height: 52, fit: BoxFit.contain),
                                SizedBox(width: 10),
                                Image.asset("assets/images/covid.png",
                                    width: 30, height: 30, fit: BoxFit.contain),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 14),
                              child: Text(message,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontFamily: "Poppins-Bold",
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left),
                            ),
                            GestureDetector(
                              onTap: onclick,
                              child: Container(
                                padding: EdgeInsets.only(top: 2, bottom: 2),
                                margin: EdgeInsets.only(left: 16, right: 16),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: Colors.redAccent,
                                ),
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: "Poppins-Bold"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 135,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.redAccent,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });

  return;
}

void showPopUpBackgroundCheck(
    BuildContext context, String message, String link) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          //this right here
          child: SizedBox.expand(
            child: Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 26),
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/dialog.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(28)),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.all(14),
                              padding: EdgeInsets.all(8),
                              child: Text(message,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: "Poppins-Bold",
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (await canLaunch(link)) {
                                  await launch(link);
                                } else {
                                  CommonUtils().showMessage(
                                      context,
                                      "Cannot open",
                                      () => Navigator.pop(context));
                                }
                              },
                              child: Container(
                                width: 150,
                                height: 50,
                                padding: EdgeInsets.only(top: 2, bottom: 2),
                                margin: EdgeInsets.only(left: 16, right: 16),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: Colors.redAccent,
                                ),
                                child: Text(
                                  "Check Link",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "Poppins-Bold"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 120,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.redAccent,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });

  return;
}
