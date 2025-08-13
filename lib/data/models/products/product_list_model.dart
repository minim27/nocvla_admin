class ProductModel {
  dynamic id,
      image,
      aliasName,
      name,
      identity,
      slug,
      description,
      gallery,
      variation;

  ProductModel({
    this.id,
    this.image,
    this.name,
    this.aliasName,
    this.slug,
    this.identity,
    this.description,
    this.gallery,
    this.variation,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    image = json["image"];
    aliasName = json["alias_name"];
    name = json["name"];
    identity = json["identity"];
    slug = json["slug"];
    description = json["description"];
    gallery = json["gallery"];
    variation = json["variation"];
  }
}
