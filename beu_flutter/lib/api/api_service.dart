import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:beu_flutter/services/http.service.dart';


class ApiService extends HttpService{

  Future getVendorList(
    String userId,
    String innerCategoryId,
  ) async {
    try {
      Map data = {
        "userid": userId,
        "innercategoryid": innerCategoryId,
      };
      print(data);
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "service/getallvendorsforservices",
          data
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }


      //var url = Uri.parse('https://example.com/whatsit/create');
      // final response = await http.post(
      //     '${Urls.BASE_API_URL}service/getallvendorsforservices',
      //     body: data,
      //     headers: headers);
      // print(response.body);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getBankDetails(
    String userId,
  ) async {
    try {
      Map data = {
        "userid": userId,
      };
      print(data);
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "user/getbankdetail",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post('${Urls.BASE_API_URL}user/getbankdetail',
      //     body: data, headers: headers);
      //
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getChatHistory(
      String userId, String otherId) async {
    try {
      Map data = {
        "userid": userId,
        "otheruserid": otherId,
        "apikey": "5ee9e0ee5561ed74d4818643"
      };

      final response = await post(
          "user/getchathistory",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     'http://3.130.157.207:3033/api/users/getchathistory',
      //     body: data);
      // print(data);
      // print(response.body);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> setRating(String userid, String bookid, String vendorid, String rating) async {
    try {
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
        "content-type": "application/json"
      };*/

      Map data = {
        "userid": userid,
        "bookingid": bookid,
        "vendorid": vendorid,
        "ratevalue": rating,
        "commnets": ""
      };

      final response = await post(
          "bookings/ratevendor",
          data
      );
      var json = jsonDecode(response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(json);
        if (json['errorcode'] == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}bookings/ratevendor',
      //     body: jsonEncode(data),
      //     headers: headers);
      // print(data);
      // print(response.statusCode);
      // var json = jsonDecode(response.body.toString());
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print(json);
      //   if (json['errorcode'] == 0) {
      //     return true;
      //   } else {
      //     return false;
      //   }
      // } else {
      //   return false;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateBankDetails(
    String userid,
    String bankName,
    String accountName,
    String accountNumber,
    String routingNumber,
    String accountState,
  ) async {
    try {
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
        "content-type": "application/json"
      };*/

      Map data = {
        "userid": userid,
        "bankname": bankName,
        "accountname": accountName,
        "accountnumber": accountNumber,
        "routingnumber": routingNumber,
        "accountstate": accountState
      };

      final response = await post(
          "user/updatebankdetail",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }
      // final response = await http.post(
      //     '${Urls.BASE_API_URL}user/updatebankdetail',
      //     body: jsonEncode(data),
      //     headers: headers);
      // print(data);
      //
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }



    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getVendorPriceList(String vendorid) async {
    try {
      Map data = {
        "vendorid": vendorid,
      };
      print(data);
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/
      // final response = await http.post(
      //     '${Urls.BASE_API_URL}service/getallvendorservice',
      //     body: data,
      //     headers: headers);
      // print(response.body);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }

      final response = await post(
          "service/getallvendorservice",
          data
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

   Future getBookingList(
      String userId, String usertype) async {
    try {
      Map data = {
        "userid": userId,
        "usertype": usertype,
      };
      print(data);
      // final response = await http.post(
      //     '${Urls.BASE_API_URL}bookings/getallbookings',
      //     body: data,
      //     headers: headers);
      // print(response.statusCode);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
      final response = await post(
          "bookings/getallbookings",
          data
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getNotificationList(String userId) async {
    try {
      Map data = {
        "userid": userId,
      };
      print(data);
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/
      // final response = await http.post(
      //     '${Urls.BASE_API_URL}user/getallnotification',
      //     body: data,
      //     headers: headers);
      // print(response.statusCode);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
      final response = await post(
          "user/getallnotification",
          data
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

   Future signIn(String email, String password, String userType) async {
    var url='${Urls.BASE_API_URL}user/signin';
    print(url);
    try {
      Map data = {"email": email, "password": password, "usertype": userType};
      print(data);

      final response = await post(
        "user/signin",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future verifyAccount(String userId, String otp) async {
    print('${Urls.BASE_API_URL}user/verifyaccount');
    try {
      Map data = {"userid": userId, "otp": otp};
      print(data);
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/
    /*  final response = await http.post('${Urls.BASE_API_URL}user/verifyaccount',
          body: data, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }*/

      final response = await post(
          "user/verifyaccount",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

   Future signUp(
    String email,
    String password,
    String fullname,
    String userType,
    String mobileNo,
    String loginVia,
    String address,
    String fcmToken,
    String companyName,
    String sId,
    String profilePic,
    File licenseImage,
    File cosmetologyLicenseImage,
  ) async {
    try {
      var platform = "";
      if (Platform.isAndroid) {
        platform = "a";
      } else if (Platform.isIOS) {
        platform = "i";
      }
      Map data;
      if (loginVia == "n") {
        data = {
          "email": email ?? " ",
          "password": password ?? " ",
          "fullname": fullname ?? " ",
          "usertype": userType ?? " ",
          "mobileno": mobileNo ?? " ",
          "loginvia": loginVia ?? " ",
          "address": address ?? " ",
          "fcm_token": fcmToken ?? " ",
          "device_type": platform
        };
      } else {
        data = {
          "email": email ?? " ",
          "password": password ?? " ",
          "fullname": fullname ?? " ",
          "usertype": userType ?? " ",
          "mobileno": mobileNo ?? " ",
          "loginvia": loginVia ?? " ",
          "address": address ?? " ",
          "fcm_token": fcmToken ?? " ",
          "device_type": platform,
          "socialid": sId ?? " ",
          "profilepic": profilePic == null
              ? '${Urls.BASE_URL}images/avatar.jpg'
              : profilePic
        };
      }
      print(data);
    /*  Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/


      if (userType == "vendor") {
        print("vendor");

        final response = await postWithFiles(
          "user/signupvendor",
          {
            "fullname": fullname ?? '',
            "password": password ?? '',
            "companyname": companyName ?? '',
            "email": email ?? '',
            "mobileno": mobileNo ?? '',
            "loginvia": loginVia ?? '',
            "address": address ?? '',
            "fcm_token": fcmToken ?? '',
            "device_type": platform ?? '',
            "socialid": sId ?? '',
            "cosmetologyLicenseImage": cosmetologyLicenseImage != null
                ? await MultipartFile.fromFile(cosmetologyLicenseImage.path,) : null,
            "licenseimage": licenseImage != null
                ? await MultipartFile.fromFile(licenseImage.path,) : null,
            "profilepic": profilePic == null ? '${Urls.BASE_URL}images/avatar.jpg' : profilePic,
          },
        );


        print('${Urls.BASE_API_URL}user/signupvendor');
        // var request = http.MultipartRequest(
        //     "POST", Uri.parse("${Urls.BASE_API_URL}user/signupvendor"));
        // request.fields["fullname"] = fullname ?? '';
        // request.fields["password"] = password ?? '';
        // request.fields["companyname"] = companyName ?? '';
        // request.fields["email"] = email ?? '';
        // request.fields["mobileno"] = mobileNo ?? '';
        // request.fields["loginvia"] = loginVia ?? '';
        // request.fields["address"] = address ?? '';
        // request.fields["fcm_token"] = fcmToken ?? '';
        // request.fields["device_type"] = platform ?? '';
        // request.fields["socialid"] = sId ?? '';
        // request.fields["profilepic"] = profilePic == null
        //     ? '${Urls.BASE_URL}images/avatar.jpg'
        //     : profilePic;
        // var pic = await http.MultipartFile.fromPath(
        //     "licenseimage", licenseImage.path);
        // var cosmPic = await http.MultipartFile.fromPath(
        //     "cosmetologyLicenseImage", cosmetologyLicenseImage.path);
        // try {
        //   request.files.add(pic);
        //   request.files.add(cosmPic);
        //   request.headers.addAll(headers);
        //   var streamResponse = await request.send();


          if (response.statusCode == 200 || response.statusCode == 201) {
           //var response = await Response.fromStream(streamResponse);
            print(response.statusCode);
            print(response);
            return response;
          } else {
            return null;
          }
        // } catch (e) {
        //   print(e.toString());
        //   return null;
        // }
      }

      print("customer");
      print('${Urls.BASE_API_URL}user/signup');
     /* final response = await http.post('${Urls.BASE_API_URL}user/signup',
          body: data, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }*/
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateToken(
    String userid,
    String fcmToken,
  ) async {
    print('${Urls.BASE_API_URL}user/update_token');
    try {
      var platform = "";
      if (Platform.isAndroid) {
        platform = "a";
      } else if (Platform.isIOS) {
        platform = "i";
      }
      Map data;
      Random value = new Random();

      data = {
        "userid": userid,
        "fcm_token": fcmToken,
        "deviceid": (value.nextInt(999) * 754).toString(),
        "device_type": platform,
      };

      final response = await post(
          "user/update_token",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/
      print(data);
     /* final response = await http.post('${Urls.BASE_API_URL}user/update_token',
          body: data, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        return response;
      } else {
        return null;
      }*/
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future vendorProfileUpdate(
    String fullName,
    String userid,
    String addressline1,
    String addressline2,
    String instalink,
    String fblink,
    String mobileno,
  ) async {
    print('${Urls.BASE_API_URL}user/updatevendorprofile');
    try {
      Map data = {
        "fullname": fullName,
        "userid": userid,
        "addressline1": addressline1,
        "addressline2": addressline2,
        "instalink": instalink,
        "fblink": fblink,
        "mobileno": mobileno,
      };
      print(data);

      final response = await post(
          "user/updatevendorprofile",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/
      /*final response = await http.post(
          '${Urls.BASE_API_URL}user/updatevendorprofile',
          body: data,
          headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }*/
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future customerProfileUpdate(String userid,
      String address1, String address2, String mobileNo, String name) async {
    print('${Urls.BASE_API_URL}user/updatecustomerprofile');
    try {
      Map data;
      if (address2 == null || address2 == "") {
        data = {
          "userid": userid,
          "mobileno": mobileNo,
          "fullname": name,
          "addressline1": address1
        };
      } else {
        data = {
          "userid": userid,
          "fullname": name,
          "mobileno": mobileNo,
          "addressline1": address1,
          "addressline2": address2
        };
      }
      print(data);

      final response = await post(
          "user/updatecustomerprofile",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/


      /*final response = await http.post(
          '${Urls.BASE_API_URL}user/updatecustomerprofile',
          body: data,
          headers: headers);
      print(response.statusCode);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return response;
      } else {
        print("qwertyuio");
        return null;
      }*/
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getSlotList(String userid, String vendorid,
      String day, String month, String year) async {
    try {
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/
      Map data = {
        "userid": userid,
        "vendorid": vendorid,
        "date": day,
        "month": month,
        "year": year
      };

      final response = await post(
          "slot/getallvendoravailableslot",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }



      print(data);
      /*final response = await http.post(
          '${Urls.BASE_API_URL}slot/getallvendoravailableslot',
          body: data,
          headers: headers);
      print(response.body);
      print(data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }*/
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getVendorGalleryImageList(
      String vendorid, String serviceid) async {
    try {
      Map data = {"vendorid": vendorid, "serviceid": serviceid};
      print(data);
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "user/getallvendorserviceimage",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }
      /*final response = await http.post(
          '${Urls.BASE_API_URL}user/getallvendorserviceimage',
          body: data,
          headers: headers);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }*/
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

   Future imageUpload(String id, File file, String imageName) async {
     print("${Urls.BASE_API_URL}user/upload_profilepic");
  /*
    var request = http.MultipartRequest(
        "POST", Uri.parse("${Urls.BASE_API_URL}user/upload_profilepic"));
    request.fields["userid"] = id;
    Map<String, String> headers = {
      "x-api-key": "FDgtnvSf9x",
    };
    request.headers.addAll(headers);
    var pic = await http.MultipartFile.fromPath(imageName, file.path);
    try {
      request.files.add(pic);
      var streamResponse = await request.send();
      if (streamResponse.statusCode == 200 ||
          streamResponse.statusCode == 201) {
        // var response = await Response.fromStream(streamResponse);
        // return response;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }*/

    final response = await postWithFiles(
      "user/upload_profilepic",
      {
        "userid": id ?? '',
        "$imageName": file != null
            ? await MultipartFile.fromFile(file.path,) : null,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // var response = await Response.fromStream(streamResponse);
      return response;
    } else {
      return null;
    }

  }

  Future getServiceImages(String vendorId, String serviceId) async {
    print('${Urls.BASE_API_URL}user/getallvendorserviceimage');
    try {
      Map data = {
        "vendorid": vendorId,
        "serviceid": serviceId,
      };
      print(data);

      final response = await post(
          "user/getallvendorserviceimage",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/
      // final response = await http.post(
      //     '${Urls.BASE_API_URL}user/getallvendorserviceimage',
      //     body: data,
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future setServicePrice(Map data) async {
    print('${Urls.BASE_API_URL}service/setcategorypricemultiple');
    try {
      print(jsonEncode(data));
      Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
        "content-type": "application/json"
      };

      final response = await post(
          "service/setcategorypricemultiple",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}service/setcategorypricemultiple',
      //     body: jsonEncode(data),
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print(response.body);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getTimeSlotById(String timeSlotId) async {
    print('${Urls.BASE_API_URL}slot/getslot');
    try {
      Map data = {
        "slotid": timeSlotId,
      };
      print(jsonEncode(data));
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "slot/getslot",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post('${Urls.BASE_API_URL}slot/getslot',
      //     body: data, headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print(response.body);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getTimeSlots(String id) async {
    print('${Urls.BASE_API_URL}slot/getallslot');
    try {
      Map data = {
        "userid": id,
      };
      print(jsonEncode(data));
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "slot/getallslot",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post('${Urls.BASE_API_URL}slot/getallslot',
      //     body: data, headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print(response.body);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getAllAvailableSlots(String userid,
      String vendorid, String date, String month, String year) async {
    print('${Urls.BASE_API_URL}slot/getallvendoravailableslot');
    try {
      Map data = {
        "userid": userid,
        "vendorid": vendorid,
        "date": date,
        "month": month,
        "year": year,
      };
      print(jsonEncode(data));

      final response = await post(
          "slot/getallvendoravailableslot",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/
      // final response = await http.post(
      //     '${Urls.BASE_API_URL}slot/getallvendoravailableslot',
      //     body: data,
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   //print(response.body);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getMonthAvailability(
      String userid, String date, String month, String year) async {
    print('${Urls.BASE_API_URL}slot/getmonthavailability');
    try {
      Map data = {
        "userid": userid,
        "date": date,
        "month": month,
        "year": year,
      };
      print(jsonEncode(data));
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "slot/getmonthavailability",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}slot/getmonthavailability',
      //     body: data,
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print(response.body);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateVendorByMonth(String userid, String date,
      String month, String year, String availability) async {
    print('${Urls.BASE_API_URL}slot/updatevendorslotbymonth');
    try {
      Map data = {
        "userid": userid,
        "date": date,
        "month": month,
        "year": year,
        "availability": availability,
      };
      print(jsonEncode(data));
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "slot/updatevendorslotbymonth",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}slot/updatevendorslotbymonth',
      //     body: data,
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print(response.body);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateVendorByDate(
    String userid,
    String date,
    String month,
    String year,
    String availabilityid,
    String slotid,
    String status,
  ) async {
    print('${Urls.BASE_API_URL}slot/saveavailibilitydatewise');
    try {
      Map data = {
        "userid": userid,
        "date": date,
        "month": month,
        "year": year,
        "availabilityid": availabilityid,
        "slotid": slotid,
        "status": status,
      };
      print(jsonEncode(data));
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "slot/saveavailibilitydatewise",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}slot/saveavailibilitydatewise',
      //     body: data,
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   //print(response.body);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getAllBookings(
    String userid,
    String userType,
  ) async {
    print('${Urls.BASE_API_URL}bookings/getallbookings');
    try {
      Map data = {
        "userid": userid,
        "usertype": userType,
      };
      print(jsonEncode(data));
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "bookings/getallbookings",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}bookings/getallbookings',
      //     body: data,
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print(response.body);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future cancelBooking(
    String vendorid,
    String bookingid,
  ) async {
    print('${Urls.BASE_API_URL}bookings/cancelbooking');
    try {
      Map data = {
        "vendorid": vendorid,
        "bookingid": bookingid,
      };
      print(jsonEncode(data));
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "bookings/cancelbooking",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}bookings/cancelbooking',
      //     body: data,
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print(response.body);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future completeBooking(
    String vendorid,
    String bookingid,
  ) async {
    print('${Urls.BASE_API_URL}bookings/completebooking');
    try {
      Map data = {
        "vendorid": vendorid,
        "bookingid": bookingid,
      };
      print(jsonEncode(data));
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "bookings/completebooking",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}bookings/completebooking',
      //     body: data,
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print(response.body);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future serviceImageUpload(
      String vendorId, String serviceId, File file, String imageName) async {
    print("${Urls.BASE_API_URL}user/updateserviceimage");
   /* var request = http.MultipartRequest(
        "POST", Uri.parse("${Urls.BASE_API_URL}/user/updateserviceimage"));
    request.fields["vendorid"] = vendorId;
    request.fields["serviceid"] = serviceId;
    Map<String, String> headers = {
      "x-api-key": "FDgtnvSf9x",
    };
    request.headers.addAll(headers);
    var pic = await http.MultipartFile.fromPath(imageName, file.path);
    try {
      request.files.add(pic);
      // var streamResponse = await request.send();
      // if (streamResponse.statusCode == 200 ||
      //     streamResponse.statusCode == 201) {
      //   var response = await Response.fromStream(streamResponse);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }*/

    final response = await postWithFiles(
      "user/updateserviceimage",
      {
        "vendorid": vendorId ?? '',
        "serviceid": serviceId ?? '',

        "$imageName": file != null
            ? await MultipartFile.fromFile(file.path,) : null,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      return null;
    }

  }

  Future replaceServiceImage(File file, String imageName, String serviceImageId) async {
    print("${Urls.BASE_API_URL}user/replaceserviceimage");
    /*var request = http.MultipartRequest(
        "POST", Uri.parse("${Urls.BASE_API_URL}/user/replaceserviceimage"));
    request.fields["serviceimageid"] = serviceImageId;
    Map<String, String> headers = {
      "x-api-key": "FDgtnvSf9x",
    };
    request.headers.addAll(headers);
    var pic = await http.MultipartFile.fromPath(imageName, file.path);*/
    // try {
    //   request.files.add(pic);
    //   var streamResponse = await request.send();
    //   if (streamResponse.statusCode == 200 ||
    //       streamResponse.statusCode == 201) {
    //     var response = await Response.fromStream(streamResponse);
    //     return response;
    //   } else {
    //     return null;
    //   }
    // } catch (e) {
    //   print(e.toString());
    //   return null;
    // }

    final response = await postWithFiles(
      "user/replaceserviceimage",
      {
        "serviceimageid": serviceImageId ?? '',
        "$imageName": file != null
            ? await MultipartFile.fromFile(file.path,) : null,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      return null;
    }
  }

  Future deleteServiceImage(
    String serviceImageId,
  ) async {
    print('${Urls.BASE_API_URL}user/deleteserviceimage');
    try {
      Map data = {
        "serviceimageid": serviceImageId,
      };
      print(jsonEncode(data));
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "user/deleteserviceimage",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}user/deleteserviceimage',
      //     body: data,
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print(response.body);
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }



  Future forgotPassword(String email) async {
    print('${Urls.BASE_API_URL}user/forgotpassword');
    try {
      Map data = {
        "email": email,
      };
      print(data);
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "user/forgotpassword",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}user/forgotpassword',
      //     body: data,
      //     headers: headers);
      // print(response.statusCode);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future verifyOTP(String email, String otp) async {
    print('${Urls.BASE_API_URL}user/verifyOTP');
    try {
      Map data = {"email": email, "otp": otp};
      print(data);
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "user/verifyotp",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post('${Urls.BASE_API_URL}user/verifyotp',
      //     body: data, headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(
      String id, String password, String cfpassword) async {
    print('${Urls.BASE_API_URL}user/changepassword');
    try {
      Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };

      Map data = {
        "userid": id,
        "password": password,
        "cnfpassword": cfpassword
      };
      print(data);

      final response = await post(
          "user/changepassword",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}user/changepassword',
      //     body: data,
      //     headers: headers);
      // print(response.body);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getHierarchicalServices() async {
    print('${Urls.BASE_API_URL}service/gethierarchicalservice');
    try {
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await get(
          "service/gethierarchicalservice"
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.get(
      //     '${Urls.BASE_API_URL}service/gethierarchicalservice',
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getServices() async {
    print('${Urls.BASE_API_URL}service/getallservice');
    try {
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await get(
          "service/getallservice"
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http
      //     .get('${Urls.BASE_API_URL}service/getallservice', headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getSubCategories(
    String userId,
    String serviceId,
  ) async {
    print('${Urls.BASE_API_URL}service/getallsubcategory');
    try {
      Map data = {
        "userid": userId,
        "serviceid": serviceId,
      };
      print(data);
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "service/getallsubcategory",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}service/getallsubcategory',
      //     body: data,
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getInnerCategories(
    String userId,
    String subCategoryId,
  ) async {
    print('${Urls.BASE_API_URL}service/getallinnercategory');
    try {
      Map data = {
        "userid": userId,
        "subcategoryid": subCategoryId,
      };
      print(data);
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "service/getallinnercategory",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}service/getallinnercategory',
      //     body: data,
      //     headers: headers);
      // print(response.body);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future createBooking(
      String userid,
      String vendorid,
      String day,
      String month,
      String year,
      String slotId,
      String innerCategoryId,
      String name,
      String mobile,
      String address) async {
    try {
      print('${Urls.BASE_API_URL}bookings/createbooking');
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/
      Map data = {
        "userid": userid,
        "vendorid": vendorid,
        "date": day,
        "month": month,
        "year": year,
        "slotid": slotId,
        "innercategoryid": innerCategoryId,
        "fullname": name,
        "mobileno": mobile,
        "address": address
      };

      print(data);

      final response = await post(
          "bookings/createbooking",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}bookings/createbooking',
      //     body: data,
      //     headers: headers);
      // print(response.body);
      // print(data);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future authorizeNetPayment(
      String nameService,
      String amount,
      String cardNumber,
      String date,
      String cvv,
      String name,
      String mobile,
      String address,
      String bookingId,
      String userId) async {
    try {
      print("https://api.authorize.net/xml/v1/request.api");
      /*Map<String, String> headers = {
        //"x-api-key": "FDgtnvSf9x",
        "x-api-key": "4mn54Uhc3Rn",
      };*/

      String data =
          "{\"createTransactionRequest\":{\"merchantAuthentication\":{\"name\":\"4mn54Uhc3Rn\",\"transactionKey\":\"95mA9J48pzj6KV7d\"},\"refId\":\"$bookingId\",\"transactionRequest\":{\"transactionType\":\"authCaptureTransaction\",\"amount\":\"$amount\",\"payment\":{\"creditCard\":{\"cardNumber\":\"$cardNumber\",\"expirationDate\":\"$date\",\"cardCode\":\"$cvv\"}},\"lineItems\":{\"lineItem\":{\"itemId\":\"1\",\"name\":\"$nameService\",\"description\":\"\",\"quantity\":\"1\",\"unitPrice\":\"$amount\"}},\"poNumber\":\"$bookingId\",\"customer\":{\"id\":\"$userId\"},\"billTo\":{\"firstName\":\"$name\",\"lastName\":\"\",\"company\":\"\",\"address\":\"$address\",\"city\":\"\",\"state\":\"\",\"zip\":\"\",\"country\":\"\"}}}}";

      final response = await post_with_url(
          //"https://apitest.authorize.net/xml/v1/request.api",
          "https://api.authorize.net/xml/v1/request.api",
          data
      );

      //print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      /*final response = await http.post(
          'https://api.authorize.net/xml/v1/request.api',
          body: data,
          headers: headers);
      print(response.body);
      print(data);
      if (response.statusCode == 200 || response.statusCode == 201) {
         return response;
      } else {
         return null;
      }*/
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getChargeCreditCard(
      String id, String bookingId, var paymentdata) async {
    print('${Urls.BASE_API_URL}bookings/chargecreditcard');
    try {
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
        "content-type": "application/json"
      };*/

      Map data = {
        "userid": id.toString(),
        "bookingid": bookingId.toString(),
        "paymentdata": jsonEncode(paymentdata)
      };

      final response = await post(
          "bookings/chargecreditcard",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}bookings/chargecreditcard',
      //     body: jsonEncode(data),
      //     headers: headers);
      // print(data);
      // print(response.statusCode);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getCustomerDashboardServices(
      String userid) async {
    print('${Urls.BASE_API_URL}service/getdashboardservice');
    try {
      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      Map data = {
        "userid": userid,
      };
      print(userid);

      final response = await post(
          "service/getdashboardservice",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}service/getdashboardservice',
      //     body: data,
      //     headers: headers);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future customerProfileUpdation(String userid,
      String address1, String address2, String mobileNo, String name) async {
    print('${Urls.BASE_API_URL}user/updatecustomerprofile');
    try {
      Map data;
      if (address2 == null || address2 == "") {
        data = {
          "userid": userid,
          "mobileno": mobileNo,
          "fullname": name,
          "addressline1": address1
        };
      } else {
        data = {
          "userid": userid,
          "fullname": name,
          "mobileno": mobileNo,
          "addressline1": address1,
          "addressline2": address2
        };
      }
      print(data);

      /*Map<String, String> headers = {
        "x-api-key": "FDgtnvSf9x",
      };*/

      final response = await post(
          "user/updatecustomerprofile",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //     '${Urls.BASE_API_URL}user/updatecustomerprofile',
      //     body: data,
      //     headers: headers);
      // print(response.statusCode);
      // if (response.statusCode == 201 || response.statusCode == 200) {
      //   return response;
      // } else {
      //   print("qwertyuio");
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
    }
  }

  Future imageUploadCustomer(String id, File file) async {
    print("http://18.188.224.232/beu/index.php/api/user/upload_profilepic");
    print(file);
    // var request = http.MultipartRequest(
    //     "POST", Uri.parse("${Urls.BASE_API_URL}user/upload_profilepic"));
    // request.fields["userid"] = id;
    //
    // request.headers["x-api-key"] = "FDgtnvSf9x";
    // var pic = await http.MultipartFile.fromPath("profilepic", file.path);
    // print(request);
    /*try {
      // request.files.add(pic);
      // var streamResponse = await request.send();
      // var response = await Response.fromStream(streamResponse);
      //
      // if (streamResponse.statusCode == 200) {
      //   print("JSON DATA" + response.toString());
      //   return response;
      // } else {
      //   return response;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }*/


    final response = await postWithFiles(
      "user/upload_profilepic",
      {
        "userid": id ?? '',
        "profilepic": file != null
            ? await MultipartFile.fromFile(file.path,) : null,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      return null;
    }

  }

  Future getAllChatUsers(
      String userid, String apiKey) async {
    print("http://3.130.157.207:3033/api/users/getallchatuser");
    try {
      Map data = {"userid": userid, "apikey": apiKey};
      print(data);

      final response = await post(
          "user/getallchatuser",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      // final response = await http.post(
      //   'http://3.130.157.207:3033/api/users/getallchatuser',
      //   body: data,
      // );
      // print(response.statusCode);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getAllEvents(
      String id, String month, String year) async {
    print('${Urls.BASE_API_URL}events/getall');
    try {
      Map data = {"userid": id, "month": month, "year": year};
      print(data);

      final response = await post(
          "events/getall",
          data
      );

      if (response.statusCode == 200) {
          return response;
        } else {
          return null;
        }

      // final response =
      //     await http.post('${Urls.BASE_API_URL}events/getall', body: data);
      // if (response.statusCode == 200) {
      //   return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future sendContactUsMessage(String message, String userId) async{
    try{
      Map<String, String> data = {"userid": userId, "message": message};

      final response = await post(
          "user/contactus",
          data
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return null;
      }

      //Map<String, String> headers = {'x-api-key': 'FDgtnvSf9x', 'Accept': 'applicatio/json'};
      // final response = await http.post('${Urls.BASE_API_URL}user/contactus', body: data, headers: headers);
      //
      // if(response.statusCode == 200 || response.statusCode == 201){
      //   return response;
      // }
      // else {
      //   return null;
      // }
    } catch (e){
      print(e.toString());
      return null;
    }
  }

}

class Urls {
  // Development BASE URL
  static const BASE_URL = "http://3.23.77.164/beu/";
  //static const BASE_URL = "http://3.23.77.164/beu-dev/";

  // API URL
  static const BASE_API_URL = "${BASE_URL}index.php/api/";
}
