import 'list_products_model.dart';

class AddProductsModel {
  dynamic id,
      name,
      color,
      description,
      createdAt,
      updatedAt,
      shopeeUrl,
      tiktokUrl,
      tokopediaUrl,
      productTypeId;
  List<ProductImagesModel>? images;
  List<ProductVariationModel>? variation;

  AddProductsModel({
    this.id,
    this.name,
    this.color,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.shopeeUrl,
    this.tiktokUrl,
    this.tokopediaUrl,
    this.productTypeId,
    this.images,
    this.variation,
  });

  AddProductsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    color = json["color"];
    description = json["description"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    shopeeUrl = json["shopee_url"];
    tiktokUrl = json["tiktok_url"];
    tokopediaUrl = json["tokopedia_url"];
    productTypeId = json["product_type_id"];

    images = (json["images"] as List?)
        ?.map((e) => ProductImagesModel.fromJson(e))
        .toList();

    variation = (json["variation"] as List?)
        ?.map((e) => ProductVariationModel.fromJson(e))
        .toList();
  }
}
