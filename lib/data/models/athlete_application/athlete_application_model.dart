class AthleteApplicationModel {
  dynamic id,
      name,
      email,
      phone,
      instagramUsername,
      tiktokUsername,
      city,
      reason,
      status,
      createdAt;

  AthleteApplicationModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.instagramUsername,
    this.tiktokUsername,
    this.city,
    this.reason,
    this.status,
    this.createdAt,
  });

  AthleteApplicationModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    instagramUsername = json["instagram_username"];
    tiktokUsername = json["tiktok_username"];
    city = json["city"];
    reason = json["reason"];
    status = json["status"];
    createdAt = json["created_at"];
  }
}
