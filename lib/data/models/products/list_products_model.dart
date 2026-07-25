class ListProductsModel {
  dynamic id, productId, name, colorName, type, isFeatured;
  List<ProductImagesModel>? images;
  List<ProductVariationModel>? variation;

  ListProductsModel({
    this.id,
    this.productId,
    this.name,
    this.colorName,
    this.type,
    this.isFeatured,
    this.images,
    this.variation,
  });

  ListProductsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    colorName = json["name"];
    productId = json["product_id"];

    final product = json["product"];
    if (product != null) {
      name = product["name"];
      isFeatured = product["is_featured"];
    }

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
  dynamic sortOrder;

  ProductImagesModel({this.imageUrl, this.sortOrder});

  ProductImagesModel.fromJson(Map<String, dynamic> json) {
    imageUrl = json["image_url"];
    sortOrder = json["sort_order"];
  }
}
