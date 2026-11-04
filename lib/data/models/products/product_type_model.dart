class ProductTypeModel {
  dynamic id, name, value, isActive, sortOrder, productCount;

  ProductTypeModel({
    this.id,
    this.name,
    this.value,
    this.isActive,
    this.sortOrder,
    this.productCount,
  });

  ProductTypeModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    value = json["value"];
    isActive = json["is_active"];
    sortOrder = json["sort_order"];
    final products = json["products"] as List?;
    productCount = products == null || products.isEmpty
        ? 0
        : products.first["count"];
  }
}
