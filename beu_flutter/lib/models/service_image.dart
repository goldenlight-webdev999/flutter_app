class ServiceImage {
  String id;
  String vendorid;
  String serviceid;
  String image;

  ServiceImage({
    this.id,
    this.vendorid,
    this.serviceid,
    this.image,
  });

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    return ServiceImage(
      id: json["id"].toString(),
      vendorid: json["vendorid"].toString(),
      serviceid: json["serviceid"].toString(),
      image: json["image"].toString(),
    );
  }
}