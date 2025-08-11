class TypeModel {
  dynamic id, title, active, description, gallery, createdAt, updatedAt;

  TypeModel({
    this.id,
    this.title,
    this.active,
    this.description,
    this.gallery,
    this.createdAt,
    this.updatedAt,
  });

  TypeModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    active = json["active"];
    description = json["description"];
    gallery = json["gallery"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}
