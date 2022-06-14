class VendorServicePriceData {
  Vendor vendor;
  List<Services> services;

  VendorServicePriceData({this.vendor, this.services});

  VendorServicePriceData.fromJson(Map<String, dynamic> json) {
    vendor =
        json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
    if (json['services'] != null) {
      services = new List<Services>();
      json['services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vendor != null) {
      data['vendor'] = this.vendor.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vendor {
  String userid;
  String usertype;
  String username;
  String fullname;
  String companyname;
  String mobileno;
  String email;
  String address;
  String profilepic;
  String socialid;
  String password;
  String bio;
  String loginvia;
  String fcmToken;
  String deviceType;
  String deviceid;
  String otp;
  String addressline1;
  String addressline2;
  String instalink;
  String fblink;
  String isactive;
  String createdts;
  String updatedts;
  int ratevalue;

  Vendor(
      {this.userid,
      this.usertype,
      this.username,
      this.fullname,
      this.companyname,
      this.mobileno,
      this.email,
      this.address,
      this.profilepic,
      this.socialid,
      this.password,
      this.bio,
      this.loginvia,
      this.fcmToken,
      this.deviceType,
      this.deviceid,
      this.otp,
      this.addressline1,
      this.addressline2,
      this.instalink,
      this.fblink,
      this.isactive,
      this.createdts,
      this.updatedts,
      this.ratevalue});

  Vendor.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    usertype = json['usertype'];
    username = json['username'];
    fullname = json['fullname'];
    companyname = json['companyname'];
    mobileno = json['mobileno'];
    email = json['email'];
    address = json['address'];
    profilepic = json['profilepic'];
    socialid = json['socialid'];
    password = json['password'];
    bio = json['bio'];
    loginvia = json['loginvia'];
    fcmToken = json['fcm_token'];
    deviceType = json['device_type'];
    deviceid = json['deviceid'];
    otp = json['otp'];
    addressline1 = json['addressline1'];
    addressline2 = json['addressline2'];
    instalink = json['instalink'];
    fblink = json['fblink'];
    isactive = json['isactive'];
    createdts = json['createdts'];
    updatedts = json['updatedts'];
    ratevalue = json['ratevalue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['usertype'] = this.usertype;
    data['username'] = this.username;
    data['fullname'] = this.fullname;
    data['companyname'] = this.companyname;
    data['mobileno'] = this.mobileno;
    data['email'] = this.email;
    data['address'] = this.address;
    data['profilepic'] = this.profilepic;
    data['socialid'] = this.socialid;
    data['password'] = this.password;
    data['bio'] = this.bio;
    data['loginvia'] = this.loginvia;
    data['fcm_token'] = this.fcmToken;
    data['device_type'] = this.deviceType;
    data['deviceid'] = this.deviceid;
    data['otp'] = this.otp;
    data['addressline1'] = this.addressline1;
    data['addressline2'] = this.addressline2;
    data['instalink'] = this.instalink;
    data['fblink'] = this.fblink;
    data['isactive'] = this.isactive;
    data['createdts'] = this.createdts;
    data['updatedts'] = this.updatedts;
    data['ratevalue'] = this.ratevalue;
    return data;
  }
}

class Services {
  String price;
  ServiceInnercategory innercategory;

  Services({this.price, this.innercategory});

  Services.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    innercategory = json['innercategory'] != null
        ? new ServiceInnercategory.fromJson(json['innercategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    if (this.innercategory != null) {
      data['innercategory'] = this.innercategory.toJson();
    }
    return data;
  }
}

class ServiceInnercategory {
  String id;
  String subcategoryid;
  String serviceid;
  String categoryName;
  String image;

  ServiceInnercategory(
      {this.id,
      this.subcategoryid,
      this.serviceid,
      this.categoryName,
      this.image});

  ServiceInnercategory.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? " ";
    subcategoryid = json['subcategoryid'] ?? " ";
    serviceid = json['serviceid'] ?? " ";
    categoryName = json['category_name'] ?? " ";
    image = json['image'] ?? " ";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subcategoryid'] = this.subcategoryid;
    data['serviceid'] = this.serviceid;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    return data;
  }
}
