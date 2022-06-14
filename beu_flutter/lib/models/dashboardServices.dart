class DashboardService {
  List<DashBoardModel> recommanded;
  List<DashBoardModel> trending;

  DashboardService({this.recommanded, this.trending});

  DashboardService.fromJson(Map<String, dynamic> json) {
    if (json['recommanded'] != null) {
      recommanded = new List<DashBoardModel>();
      json['recommanded'].forEach((v) {
        recommanded.add(new DashBoardModel.fromJson(v));
      });
    }
    if (json['trending'] != null) {
      trending = new List<DashBoardModel>();
      json['trending'].forEach((v) {
        trending.add(new DashBoardModel.fromJson(v));
      });
    }
  }
}

class DashBoardModel {
  String categoryName;
  String vendorid;
  String serviceDesc;
  String image;

  DashBoardModel(
      {this.categoryName, this.vendorid, this.serviceDesc, this.image});

  DashBoardModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'] as String;
    vendorid = json['vendorid'] as String;
    serviceDesc = json['service_desc'] as String;
    image = json['image'] as String;
  }
}
