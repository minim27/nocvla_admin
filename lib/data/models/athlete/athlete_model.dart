class AthleteModel {
  dynamic id, picture, code, name, createdAt, updatedAt;

  AthleteModel({
    this.id,
    this.picture,
    this.code,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  AthleteModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    picture = json["picture"];
    code = json["code"];
    name = json["name"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}
