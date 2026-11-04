class WaOrderModel {
  dynamic id,
      code,
      customerName,
      customerPhone,
      address,
      subtotal,
      discount,
      shippingFee,
      courier,
      awb,
      status,
      createdAt,
      athleteCode,
      athleteName;
  List<WaOrderItemModel>? items;

  WaOrderModel({
    this.id,
    this.code,
    this.customerName,
    this.customerPhone,
    this.address,
    this.subtotal,
    this.discount,
    this.shippingFee,
    this.courier,
    this.awb,
    this.status,
    this.createdAt,
    this.athleteCode,
    this.athleteName,
    this.items,
  });

  WaOrderModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    code = json["code"];
    customerName = json["customer_name"];
    customerPhone = json["customer_phone"];
    address = json["address"];
    subtotal = json["subtotal"];
    discount = json["discount"];
    shippingFee = json["shipping_fee"];
    courier = json["courier"];
    awb = json["awb"];
    status = json["status"];
    createdAt = json["created_at"];
    athleteCode = json["athlete"]?["code"];
    athleteName = json["athlete"]?["name"];
    items = (json["items"] as List?)
        ?.map((e) => WaOrderItemModel.fromJson(e))
        .toList();
  }

  String get itemSummary => (items ?? []).map((e) => e.summary).join("\n");

  num get total =>
      ((subtotal ?? 0) as num) -
      ((discount ?? 0) as num) +
      ((shippingFee ?? 0) as num);
}

class WaOrderItemModel {
  dynamic productName, colorName, size, qty, unitPrice;

  WaOrderItemModel({
    this.productName,
    this.colorName,
    this.size,
    this.qty,
    this.unitPrice,
  });

  WaOrderItemModel.fromJson(Map<String, dynamic> json) {
    productName = json["product_name"];
    colorName = json["color_name"];
    size = json["size"];
    qty = json["qty"];
    unitPrice = json["unit_price"];
  }

  String get summary => "$productName · $colorName / ${size ?? "-"} × $qty";
}
