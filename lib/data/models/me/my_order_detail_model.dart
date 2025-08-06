class MyOrderDetailModel {
  dynamic id,
      date,
      statusId,
      statusName,
      invoiceNo,
      payment,
      shipping,
      user,
      address,
      items,
      subTotal,
      adminFee,
      totalAmount;

  MyOrderDetailModel({
    this.id,
    this.date,
    this.statusId,
    this.statusName,
    this.invoiceNo,
    this.payment,
    this.shipping,
    this.address,
    this.user,
    this.items,
    this.subTotal,
    this.adminFee,
    this.totalAmount,
  });

  MyOrderDetailModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    date = json["date"];
    statusId = json["status_id"];
    statusName = json["status_name"];
    invoiceNo = json["invoice_no"];
    payment = json["payment"];
    shipping = json["shipping"];
    user = json["user"];
    address = json["address"];
    items = json["items"];
    subTotal = json["sub_total"];
    adminFee = json["admin_fee"];
    totalAmount = json["total_amount"];
  }
}
