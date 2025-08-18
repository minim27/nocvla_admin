class ProductModel {
  dynamic id,
      aliasName,
      image,
      name,
      identity,
      slug,
      description,
      gallery,
      variation;

  ProductModel({
    this.id,
    this.aliasName,
    this.image,
    this.name,
    this.slug,
    this.identity,
    this.description,
    this.gallery,
    this.variation,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    aliasName = json["alias_name"];
    image = json["image"];
    name = json["name"];
    identity = json["identity"];
    slug = json["slug"];
    description = json["description"];
    gallery = json["gallery"];
    variation = json["variation"];
  }
}
