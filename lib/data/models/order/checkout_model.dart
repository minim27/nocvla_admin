class CheckoutModel {
  dynamic id, invoiceUrl, accessToken;

  CheckoutModel({this.id, this.invoiceUrl, this.accessToken});

  CheckoutModel.fromJson(Map<String, dynamic> json) {
    id = json["order_id"];
    invoiceUrl = json["invoice_url"];
    accessToken = json["access_token"];
  }
}
