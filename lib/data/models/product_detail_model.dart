class ProductDetailModel {
  dynamic id, name, slug, description, gallery, variation;

  ProductDetailModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.gallery,
    this.variation,
  });

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    slug = json["slug"];
    description = json["description"];
    gallery = json["gallery"];
    variation = json["variation"];
  }
}
