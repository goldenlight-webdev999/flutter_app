class VendorGallery {
  List<Data> data;

  VendorGallery({this.data});

  VendorGallery.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  List<Vendorimages> vendorimages;

  Data({this.vendorimages});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['vendorimages'] != null) {
      vendorimages = new List<Vendorimages>();
      json['vendorimages'].forEach((v) {
        vendorimages.add(new Vendorimages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vendorimages != null) {
      data['vendorimages'] = this.vendorimages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vendorimages {
  String id;
  String vendorid;
  String serviceid;
  String image;

  Vendorimages({this.id, this.vendorid, this.serviceid, this.image});

  Vendorimages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorid = json['vendorid'];
    serviceid = json['serviceid'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendorid'] = this.vendorid;
    data['serviceid'] = this.serviceid;
    data['image'] = this.image;
    return data;
  }
}
