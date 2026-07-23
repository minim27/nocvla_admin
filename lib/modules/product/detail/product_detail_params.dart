class ProductDetailParams {
  dynamic id, slug, duplicateId;

  ProductDetailParams({this.id, this.slug, this.duplicateId});

  ProductDetailParams.fromMap(Map<String, String?> json) {
    id = json["id"];
    slug = json["slug"];
    duplicateId = json["duplicateId"];
  }
}
