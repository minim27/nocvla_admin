class ProductNameModel {
  dynamic id, name;

  ProductNameModel({this.id, this.name});

  ProductNameModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
}
