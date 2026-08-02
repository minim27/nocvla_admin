class AthleteModel {
  dynamic id, picture, code, name, createdAt, updatedAt, isActive;
  List<String>? assignedProducts;

  AthleteModel({
    this.id,
    this.picture,
    this.code,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.assignedProducts,
  });

  AthleteModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    picture = json["picture"];
    code = json["code"];
    name = json["name"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    isActive = json["is_active"];
    assignedProducts = (json["assignments"] as List?)
        ?.map((e) => e["product"]["name"] as String)
        .toList();
  }
}
