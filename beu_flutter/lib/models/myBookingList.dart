import 'package:beu_flutter/models/vendor.dart' as ven;
import 'package:beu_flutter/models/user.dart';
import 'package:beu_flutter/models/vendor_price_list.dart';

class BookingList {
  List<BookingItem> data;

  BookingList({this.data});

  BookingList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<BookingItem>();
      json['data'].forEach((v) {
        data.add(new BookingItem.fromJson(v));
      });
    }
  }
}

class BookingItem {
  String bookingid;
  String address;
  String mobileno;
  String fullname;
  String price;
  String date;
  String status;
  String bookingstatus;
  String slotid;
  User user;
  ven.Vendor vendor;
  ServiceInnercategory innercategory;

  BookingItem(
      {this.bookingid,
      this.address,
      this.mobileno,
      this.fullname,
      this.price,
      this.date,
      this.status,
      this.bookingstatus,
      this.vendor,
      this.innercategory});

  BookingItem.fromJson(Map<String, dynamic> json) {
    bookingid = json['bookingid'] ?? " ";
    address = json['address'] ?? " ";
    mobileno = json['mobileno'] ?? " ";
    fullname = json['fullname'] ?? " ";
    price = json['price'] ?? " ";
    date = json['date'] ?? " ";
    status = json['status'] ?? " ";
    bookingstatus = json['bookingstatus'] ?? " ";
    slotid = json['slotid'] ?? " ";
    vendor =
        json['vendor'] != null ? new ven.Vendor.fromJson(json['vendor']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;

    innercategory = json['innercategory'] != null
        ? new ServiceInnercategory.fromJson(json['innercategory'])
        : null;
  }
}
