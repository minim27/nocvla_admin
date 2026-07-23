class ProductDetailParams {
  dynamic id, slug;

  ProductDetailParams({this.id, this.slug});

  ProductDetailParams.fromMap(Map<String, String?> json) {
    id = json["id"];
    slug = json["slug"];
  }
}
