class Service {
  String serviceid;
  String service_name;
  String service_desc;
  String service_image;
  String subcategoryid;

  Service({
    this.serviceid,
    this.service_name,
    this.service_desc,
    this.service_image,
    this.subcategoryid,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceid: json["serviceid"].toString(),
      service_name: json["service_name"].toString(),
      service_desc: json["service_desc"].toString(),
      service_image: json["service_image"].toString(),
      subcategoryid: json["subcategoryid"].toString(),
    );
  }
}
