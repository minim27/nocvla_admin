import 'package:get/get.dart';

class ColorsModel {
  dynamic id, name, active, hex, createdAt, updatedAt;
  RxBool selected;
  ColorsModel({
    this.id,
    this.name,
    this.active,
    this.hex,
    this.createdAt,
    this.updatedAt,
    bool? selected,
  }) : selected = RxBool(selected ?? false);

  ColorsModel.fromJson(Map<String, dynamic> json) : selected = RxBool(false) {
    id = json["id"];
    name = json["name"];
    active = json["active"];
    hex = json["hex"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}
