class BankTypeModel {
  dynamic id, name;

  BankTypeModel({this.id, this.name});

  BankTypeModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
}
