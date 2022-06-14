class SubCategory {
  String id;
  String service_id;
  String category_name;

  SubCategory({
    this.id,
    this.service_id,
    this.category_name,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json["id"].toString(),
      service_id: json["service_id"].toString(),
      category_name: json["category_name"].toString(),
    );
  }
}
