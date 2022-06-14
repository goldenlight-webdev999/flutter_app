class Vendor {
  String userid;
  String fullname;
  String companyname;
  String mobileno;
  String email;
  String address;
  String isactive;
  String ratevalue;
  String profilepic;

  Vendor({
    this.userid,
    this.fullname,
    this.companyname,
    this.mobileno,
    this.email,
    this.address,
    this.isactive,
    this.ratevalue,
    this.profilepic,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      userid: json["userid"].toString(),
      fullname: json["fullname"].toString(),
      companyname: json["companyname"].toString(),
      mobileno: json["mobileno"].toString(),
      email: json["email"].toString(),
      address: json["address"].toString(),
      isactive: json["isactive"].toString(),
      ratevalue: json["ratevalue"].toString(),
      profilepic: json["profilepic"].toString(),
    );
  }
}
