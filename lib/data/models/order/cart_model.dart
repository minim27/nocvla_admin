class CartModel {
  dynamic id, product, qty, note;

  CartModel({this.id, this.product, this.qty, this.note});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    product = json["product"];
    qty = json["qty"];
    note = json["note"];
  }
}
