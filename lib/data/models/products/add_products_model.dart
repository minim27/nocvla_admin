class AddProductsModel {
  dynamic productId;
  dynamic productName,
      description,
      createdAt,
      updatedAt,
      shopeeUrl,
      tiktokUrl,
      tokopediaUrl,
      productTypeId;

  AddProductsModel({
    this.productId,
    this.productName,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.shopeeUrl,
    this.tiktokUrl,
    this.tokopediaUrl,
    this.productTypeId,
  });

  AddProductsModel.fromProductJson(Map<String, dynamic> json) {
    productId = json["id"];
    productName = json["name"];
    description = json["description"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    shopeeUrl = json["shopee_url"];
    tiktokUrl = json["tiktok_url"];
    tokopediaUrl = json["tokopedia_url"];
    productTypeId = json["product_type_id"];
  }
}
