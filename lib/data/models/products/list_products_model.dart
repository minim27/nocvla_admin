class ListProductsModel {
  dynamic id, name, type, color, isFeatured;
  List<ProductImagesModel>? images;
  List<ProductVariationModel>? variation;

  ListProductsModel({
    this.id,
    this.name,
    this.type,
    this.color,
    this.isFeatured,
    this.images,
    this.variation,
  });

  ListProductsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    type = json["type"];
    color = json["color"];
    isFeatured = json["is_featured"];

    images = (json["images"] as List?)
        ?.map((e) => ProductImagesModel.fromJson(e))
        .toList();

    variation = (json["variation"] as List?)
        ?.map((e) => ProductVariationModel.fromJson(e))
        .toList();
  }
}

class ProductVariationModel {
  dynamic size, qty, price;

  ProductVariationModel({this.size, this.qty, this.price});

  ProductVariationModel.fromJson(Map<String, dynamic> json) {
    size = json["size"];
    qty = json["qty"];
    price = json["price"];
  }
}

class ProductImagesModel {
  String? imageUrl;
  dynamic isMain, sortOrder;

  ProductImagesModel({this.imageUrl, this.isMain, this.sortOrder});

  ProductImagesModel.fromJson(Map<String, dynamic> json) {
    imageUrl = json["image_url"];
    isMain = json["is_main"];
    sortOrder = json["sort_order"];
  }
}
