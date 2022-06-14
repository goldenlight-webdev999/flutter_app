import 'package:beu_flutter/models/inner_category.dart';
import 'package:beu_flutter/models/user.dart';
import 'package:beu_flutter/models/vendor.dart';

class Booking {
  String bookingid;
  String address;
  String mobileno;
  String fullname;
  String price;
  String status;
  String bookingstatus;
  String date;
  Vendor vendor;
  User user;
  InnerCategory innerCategory;

  Booking(
      {this.bookingid,
      this.address,
      this.mobileno,
      this.fullname,
      this.price,
      this.status,
      this.bookingstatus,
      this.date,
      this.vendor,
      this.user,
      this.innerCategory});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingid: json["bookingid"].toString(),
      address: json["address"].toString(),
      mobileno: json["mobileno"].toString(),
      fullname: json["fullname"].toString(),
      price: json["price"].toString(),
      status: json["status"].toString(),
      bookingstatus: json["bookingstatus"].toString(),
      date: json["date"].toString(),
      vendor: json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      innerCategory: json['innercategory'] != null
          ? InnerCategory.fromJson(json['innercategory'])
          : null,
    );
  }
}
