class ColorsModel {
  dynamic id, name, active, hex, createdAt, updatedAt;

  ColorsModel({
    this.id,
    this.name,
    this.active,
    this.hex,
    this.createdAt,
    this.updatedAt,
  });

  ColorsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    active = json["active"];
    hex = json["hex"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}
