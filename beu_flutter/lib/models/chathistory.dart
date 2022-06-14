class Chathistory {
  String sId;
  Sender sender;
  Sender reciever;
  String message;
  String createdTs;
  String updatedTs;
  int iV;

  Chathistory(
      {this.sId,
      this.sender,
      this.reciever,
      this.message,
      this.createdTs,
      this.updatedTs,
      this.iV});

  Chathistory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    reciever =
        json['reciever'] != null ? new Sender.fromJson(json['reciever']) : null;
    message = json['message'];
    createdTs = json['created_ts'];
    updatedTs = json['updated_ts'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    if (this.reciever != null) {
      data['reciever'] = this.reciever.toJson();
    }
    data['message'] = this.message;
    data['created_ts'] = this.createdTs;
    data['updated_ts'] = this.updatedTs;
    data['__v'] = this.iV;
    return data;
  }
}

class Sender {
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

  Sender(
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

  Sender.fromJson(Map<String, dynamic> json) {
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
