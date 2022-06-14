class InnerCategory {
  String id;
  String subcategoryid;
  String category_name;
  String price;

  InnerCategory({
    this.id,
    this.subcategoryid,
    this.category_name,
    this.price,
  });

  factory InnerCategory.fromJson(Map<String, dynamic> json) {
    return InnerCategory(
      id: json["id"].toString(),
      subcategoryid: json["subcategoryid"].toString(),
      category_name: json["category_name"].toString(),
      price: json["price"].toString(),
    );
  }
}
