class MyOrderModel {
  dynamic id, invoiceNo, date, statusId, statusName, totalAmount;

  MyOrderModel({
    this.id,
    this.invoiceNo,
    this.date,
    this.statusId,
    this.statusName,
    this.totalAmount,
  });

  MyOrderModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    invoiceNo = json["invoice_no"];
    date = json["date"];
    statusId = json["status_id"];
    statusName = json["status_name"];
    totalAmount = json["total_amount"];
  }
}
