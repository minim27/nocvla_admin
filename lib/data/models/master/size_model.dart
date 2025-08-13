import 'package:get/get.dart';

class SizeModel {
  dynamic id, name, sort, active, createdAt, updatedAt;
  RxBool selected;

  SizeModel({
    this.id,
    this.name,
    this.sort,
    this.active,
    this.createdAt,
    this.updatedAt,
    bool? selected,
  }) : selected = RxBool(selected ?? false);

  SizeModel.fromJson(Map<String, dynamic> json) : selected = RxBool(false) {
    id = json["id"];
    name = json["name"];
    sort = json["sort"];
    active = json["active"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}
