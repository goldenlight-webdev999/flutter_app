import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/vendorList.dart';

class SocialMediaLinks extends StatelessWidget {
  final Vendor vendor;
  final BuildContext context;

  SocialMediaLinks({
    @required this.vendor,
    @required this.context
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // Try opening the link to the vendor's Facebook profile
            _launchURL(vendor.fblink);
          },
          child: Image.asset(
            "assets/images/fb.png",
            width: 32,
            height: 32,
          )
        ),
        GestureDetector(
          onTap: () {
            // Try opening the link to the vendor's Instagram profile
            _launchURL(vendor.instalink);
          },
          child: Image.asset(
            "assets/images/insta.png",
            width: 32,
            height: 32,
          )
        )
    ]);
  }

  // peter: This will try to open a URL 
  void _launchURL(String url) async {
    String encodedUrl = Uri.encodeFull(url);

    try {
      bool canLaunchUrl = await canLaunch(encodedUrl);
      print("canLaunchUrl: $canLaunchUrl");

      if (!canLaunchUrl) {
        // peter: Display an error message since we can't launch the URL
        _showAlert("Error", "Unable to open this link: $url");
      } else {
        await launch(url);
      }
    } catch (_) {
      _showAlert("Error", "Unable to open this link $url");
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: Text("Ok")
            )
          ]
        );
      });
  }
}