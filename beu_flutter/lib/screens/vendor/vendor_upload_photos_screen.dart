import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/service_image.dart';
import 'package:beu_flutter/screens/vendor/vendor_edit_profile_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorUploadPhotosScreen extends StatefulWidget {
  final String serviceId;

  const VendorUploadPhotosScreen({Key key, this.serviceId}) : super(key: key);

  @override
  _VendorUploadPhotosScreenState createState() =>
      _VendorUploadPhotosScreenState();
}

class _VendorUploadPhotosScreenState extends State<VendorUploadPhotosScreen> {
  SharedPreferences prefs;
  String userid;
  List<ServiceImage> serviceImageList;

  bool _isLoading = false;

  // peter: When set, this will be the index (from 0-5) of the
  // photo being selected by the user.
  int selectingImageIndex;

  // peter: Indexes in this set belong to images that are being uploaded
  Set<int> _uploadingImageIndexes = Set();

  @override
  initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<Null> _getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
      _getServiceImages();
    });
  }

  void _getServiceImages() async {
    print("_getInnerServices");
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().getServiceImages(
      userid,
      widget.serviceId,
    );
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['data'] != null && json['data'].length > 0) {
        var sI = json['data'][0]['vendorimages'] as List;
        if (sI.length > 0) {
          setState(() {
            serviceImageList = sI
                .map<ServiceImage>((json) => ServiceImage.fromJson(json))
                .toList();
          });
        }
      } else {
        _showMessage(context, json["message"]);
      }
    } else {
      _showMessage(context, "Something went wrong!");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _bodyWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(32),
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
            SizedBox(
              height: 48,
            ),
            Text(
              "Upload Photos",
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontFamily: 'Poppins-ExtraBold',
                  letterSpacing: 0.4),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildImageInput(0),
                _buildImageInput(1)
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildImageInput(2),
                _buildImageInput(3)
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildImageInput(4),
                _buildImageInput(5)
              ],
            ),
            SizedBox(
              height: 8,
            ),
            // Center(
            //   child: GestureDetector(
            //     onTap: onNavigate,
            //     child: RegularButton(
            //       regularText: "Save",
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildImageInput(int imageIndex) {
    String imageUrl;

    if (serviceImageList != null && imageIndex < serviceImageList.length) {
      imageUrl = serviceImageList[imageIndex].image;
    }

    // peter: Only show one more image input than the current number of images
    // so we don't have to change too much on the backend. I tried wrapping the entire
    // container in a Visibility widget, but the layout got weird.
    bool inputShouldBeVisible = serviceImageList != null && imageIndex <= serviceImageList.length;

    return Container(
        height: 108,
        width: 108,
        margin: EdgeInsets.only(top: 2, bottom: 2),
        decoration: BoxDecoration(
            color: inputShouldBeVisible ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: GestureDetector(
          onTap: () {
            if (inputShouldBeVisible) {
              setState(() {
                selectingImageIndex = imageIndex;
              });
              _pickImage();
            }
          },
          child: _uploadingImageIndexes.contains(imageIndex)
              ? Center(child: CircularProgressIndicator())
              : imageUrl != null && imageUrl != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "$imageUrl",
                        width: 108,
                        height: 108,
                        fit: BoxFit.cover,
                      ),
                    )
                  :Container(
                          padding: EdgeInsets.all(28),
                          child: inputShouldBeVisible ? Image.asset(
                            "assets/images/upload.png",
                            height: 20,
                          ) : null,
                        ),
        )
      );

  }

  void _pickImage() async {
    bool isEditingImage = false;
    String editingImageId = "";

    if (serviceImageList != null &&
        selectingImageIndex < serviceImageList.length) {
      isEditingImage = serviceImageList[selectingImageIndex].image != null;
      editingImageId = serviceImageList[selectingImageIndex].id;
    }

    List<Widget> actions = [
      MaterialButton(
        child: Text("Camera"),
        onPressed: () => Navigator.pop(context, ImageSource.camera),
      ),
      MaterialButton(
        child: Text("Gallery"),
        onPressed: () => Navigator.pop(context, ImageSource.gallery),
      )
    ];

    print("isEditingImage: " + isEditingImage.toString());

    // peter: We'll have a third action to remove the image if the user
    // is editing an input with an image that has already been set.
    if (isEditingImage) {
      actions.add(MaterialButton(
        child: Text("Remove"),
        onPressed: () {
          Navigator.pop(context);
          _removeImageAtIndex(selectingImageIndex);
        },
      ));
    }

    String title = isEditingImage ? "Edit Image" : "Select Image";

    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        actions: actions,
      ),
    );

    if (imageSource != null) {
      var file = await ImagePicker.pickImage(
          source: imageSource, maxWidth: 512, maxHeight: 512, imageQuality: 40);
      if (file != null) {
        File croppedFile = await ImageCropper.cropImage(
          sourcePath: file.path,
          maxWidth: 512,
          maxHeight: 512,
        );

        setState(() {
          _uploadingImageIndexes.add(selectingImageIndex);
        });

        File _image = croppedFile;

        if (_image != null) {
          setState(() {
            _uploadingImageIndexes.add(selectingImageIndex);
          });

          if (isEditingImage) {
            // peter: Use a different API endpoint to update the image, since
            // the regular serviceImageUpload call only tacks on a new image to the
            // end of all the others.
            final response = await ApiService().replaceServiceImage(
              _image, "serviceimage", editingImageId
            );

            if (response != null) {
              final json = jsonDecode(response.toString());
              print("JSON Data: ");
              print(json);
              if (json['errorcode'] != null && json['errorcode'] == 0) {
                setState(() {
                  _image = null;
                });
                _getServiceImages();
              } else {
                _showMessage(context, json["message"]);
              }
            } else {
              _showMessage(context, "Something went wrong!");
            }
          } else {
            final response = await ApiService().serviceImageUpload(
                userid, widget.serviceId, _image, "serviceimage");
            if (response != null) {
              final json = jsonDecode(response.toString());
              print("JSON Data: ");
              print(json);
              if (json['errorcode'] != null && json['errorcode'] == 0) {
                setState(() {
                  _image = null;
                });
                _getServiceImages();
              } else {
                _showMessage(context, json["message"]);
              }
            } else {
              _showMessage(context, "Something went wrong!");
            }
          }

          setState(() {
            _uploadingImageIndexes.remove(selectingImageIndex);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  void onNavigate() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => VendorEditProfileScreen(),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
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
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
    return;
  }

  void _changeImageAtIndex(int changeIndex, String imageId, File newImage) {
    
  }

  void _removeImageAtIndex(int removeIndex) async {
    // peter: Make a backend call to remove the image from the database
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().deleteServiceImage(
      serviceImageList[removeIndex].id,
    );
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['data'] != null && json['data'].length > 0) {
        var sI = json['data'][0]['vendorimages'] as List;
        if (sI.length > 0) {
          setState(() {
            serviceImageList = sI
                .map<ServiceImage>((json) => ServiceImage.fromJson(json))
                .toList();
          });
        }
      } else {
        _showMessage(context, json["message"]);
      }
    } else {
      _showMessage(context, "Something went wrong!");
    }
    setState(() {
      _isLoading = false;
      if (serviceImageList != null && removeIndex < serviceImageList.length) {
        serviceImageList.removeAt(removeIndex);
      }
    });
  }
}
