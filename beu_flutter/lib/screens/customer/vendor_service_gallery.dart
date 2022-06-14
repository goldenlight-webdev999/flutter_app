import 'dart:convert';

import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/vendor_gallery.dart';
import 'package:beu_flutter/models/vendor_price_list.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorGalleryPhotosScreen extends StatefulWidget {
  String vendorid;
  ServiceInnercategory inner;
  VendorGalleryPhotosScreen({this.vendorid, this.inner});
  @override
  _VendorGalleryPhotosScreenState createState() =>
      _VendorGalleryPhotosScreenState();
}

class _VendorGalleryPhotosScreenState extends State<VendorGalleryPhotosScreen> {
  @override
  initState() {
    super.initState();
  }

  Widget _bodyWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 44, left: 32, right: 32),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              widget.inner.categoryName,
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontFamily: 'Poppins-ExtraBold',
                  letterSpacing: 0.4),
            ),
            SizedBox(
              height: 18,
            ),
            FutureBuilder<VendorGallery>(
                future: _getImagegallery(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.hasData)
                    return ImageGridView(snapshot.data.data[0].vendorimages);

                  return Container(
                    margin: EdgeInsets.all(8),
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      backgroundColor: Colors.white,
                    ),
                  );
                }),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage1(String img) {
    return Container(
        height: 128,
        width: 128,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            img,
            width: 128,
            height: 128,
            fit: BoxFit.cover,
          ),
        ));
  }

  Future<VendorGallery> _getImagegallery() async {
    final response = await ApiService().getVendorGalleryImageList(
        widget.vendorid, widget.inner.serviceid);
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json['data'].runtimeType);
      if (json['data'] != null) {
        if (json['data'][0]['vendorimages'] != null) {
          return VendorGallery.fromJson(json);
        } else {
          return Future.error("No Image in Gallery ");
        }
      } else {
        return Future.error(json['message']);
      }
    } else {
      return Future.error("Something went Wrong !!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget ImageGridView(List<Vendorimages> data) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
          itemCount: data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  MediaQuery.of(context).size.height *
                  1.5,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return _buildImage1(data[index].image);
          }),
    );
  }
}
