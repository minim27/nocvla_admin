class ProductDetailModel {
  dynamic id,
      aliasName,
      name,
      identity,
      slug,
      gender,
      type,
      description,
      gallery,
      variation;

  ProductDetailModel({
    this.id,
    this.name,
    this.aliasName,
    this.identity,
    this.slug,
    this.gender,
    this.type,
    this.description,
    this.gallery,
    this.variation,
  });

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    aliasName = json["alias_name"];
    name = json["name"];
    identity = json["identity"];
    slug = json["slug"];
    gender = json["gender"];
    type = json["type"];
    description = json["description"];
    gallery = json["gallery"];
    variation = json["variation"];
  }
}
