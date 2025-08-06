class PaymentMethodModel {
  dynamic id, image, type, bankCode, name, active, createdAt, updatedAt;

  PaymentMethodModel({
    this.id,
    this.image,
    this.type,
    this.bankCode,
    this.name,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    image = json["image"];
    type = json["type"];
    bankCode = json["bank_code"];
    name = json["name"];
    active = json["active"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}
