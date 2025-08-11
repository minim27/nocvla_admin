class SizeModel {
  dynamic id, name, active, createdAt, updatedAt;

  SizeModel({
    this.id,
    this.name,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  SizeModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    active = json["active"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}
