class ProductTypeModel {
  dynamic id, name, value, isActive, sortOrder;

  ProductTypeModel({
    this.id,
    this.name,
    this.value,
    this.isActive,
    this.sortOrder,
  });

  ProductTypeModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    value = json["value"];
    isActive = json["is_active"];
    sortOrder = json["sort_order"];
  }
}
