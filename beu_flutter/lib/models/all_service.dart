class AllService {
  String message;
  int errorcode;
  String status;
  List<Data> data;

  AllService({this.message, this.errorcode, this.status, this.data});

  AllService.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errorcode = json['errorcode'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }
}

class Data {
  String serviceid;
  String serviceName;
  String serviceDesc;
  String serviceImage;
  List<Subcategory> subcategory;

  Data(
      {this.serviceid,
      this.serviceName,
      this.serviceDesc,
      this.serviceImage,
      this.subcategory});

  Data.fromJson(Map<String, dynamic> json) {
    serviceid = json['serviceid'];
    serviceName = json['service_name'];
    serviceDesc = json['service_desc'];
    serviceImage = json['service_image'];
    if (json['subcategory'] != null) {
      subcategory = new List<Subcategory>();
      json['subcategory'].forEach((v) {
        subcategory.add(new Subcategory.fromJson(v));
      });
    }
  }
}

class Subcategory {
  String subcategoryid;
  String categoryName;
  List<Innercategory> innercategory;

  Subcategory({this.subcategoryid, this.categoryName, this.innercategory});

  Subcategory.fromJson(Map<String, dynamic> json) {
    subcategoryid = json['subcategoryid'];
    categoryName = json['category_name'];
    if (json['innercategory'] != null) {
      innercategory = new List<Innercategory>();
      json['innercategory'].forEach((v) {
        innercategory.add(new Innercategory.fromJson(v));
      });
    }
  }
}

class Innercategory {
  String innercategoryid;
  String categoryName;

  Innercategory({this.innercategoryid, this.categoryName});

  Innercategory.fromJson(Map<String, dynamic> json) {
    innercategoryid = json['innercategoryid'];
    categoryName = json['category_name'];
  }
}
