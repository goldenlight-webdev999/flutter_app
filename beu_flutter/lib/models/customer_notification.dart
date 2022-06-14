class CustomerNotification {
  List<Notification> notification;

  CustomerNotification({this.notification});

  CustomerNotification.fromJson(Map<String, dynamic> json) {
    if (json['notification'] != null) {
      notification = new List<Notification>();
      json['notification'].forEach((v) {
        notification.add(new Notification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notification != null) {
      data['notification'] = this.notification.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notification {
  String id;
  String userid;
  String title;
  String type;
  String message;
  String status;
  String createdts;
  Null updatedts;

  Notification(
      {this.id,
      this.userid,
      this.title,
      this.type,
      this.message,
      this.status,
      this.createdts,
      this.updatedts});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    title = json['title'];
    type = json['type'];
    message = json['message'];
    status = json['status'];
    createdts = json['createdts'];
    updatedts = json['updatedts'];
  }

  void setUpdatedTS(String updatedts){
    this.updatedts = updatedts;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['title'] = this.title;
    data['type'] = this.type;
    data['message'] = this.message;
    data['status'] = this.status;
    data['createdts'] = this.createdts;
    data['updatedts'] = this.updatedts;
    return data;
  }
}
