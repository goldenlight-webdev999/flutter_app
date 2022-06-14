class User {
  String userid;
  String fullname;
  String mobileno;
  String email;
  String address;
  String profilepic;

  User({
    this.userid,
    this.fullname,
    this.mobileno,
    this.email,
    this.address,
    this.profilepic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userid: json["userid"].toString(),
      fullname: json["fullname"].toString(),
      mobileno: json["mobileno"].toString(),
      email: json["email"].toString(),
      address: json["address"].toString(),
      profilepic: json["profilepic"].toString(),
    );
  }
}

class chatUser {
  String sId;
  String refuserid;
  String firstname;
  String lastname;
  String profilepic;
  String email;
  String app;
  String createdTs;
  String updatedTs;
  int iV;

  chatUser(
      {this.sId,
      this.refuserid,
      this.firstname,
      this.lastname,
      this.profilepic,
      this.email,
      this.app,
      this.createdTs,
      this.updatedTs,
      this.iV});

  chatUser.fromJson(Map<String, dynamic> json) {
    // if (json['chatusers'] != null) {
    // 	chatusers = new List<chatter>();
    // 	json['chatusers'].forEach((v) { chatusers.add(new chatter.fromJson(v)); });
    // }
    sId = json['_id'];
    refuserid = json['refuserid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    profilepic = json['profilepic'];
    email = json['email'];
    app = json['app'];
    createdTs = json['created_ts'];
    updatedTs = json['updated_ts'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.chatusers != null) {
    //   data['chatusers'] = this.chatusers.map((v) => v.toJson()).toList();
    // }
    data['_id'] = this.sId;
    data['refuserid'] = this.refuserid;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['profilepic'] = this.profilepic;
    data['email'] = this.email;
    data['app'] = this.app;
    data['created_ts'] = this.createdTs;
    data['updated_ts'] = this.updatedTs;
    data['__v'] = this.iV;
    return data;
  }
}

class chatElement {
  String mesage;
  String name;
  String profileImage;
  bool me;
  chatElement({this.mesage, this.name, this.profileImage, this.me});
}
