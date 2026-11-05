class AthleteApplicationModel {
  dynamic id,
      name,
      email,
      phone,
      instagramUsername,
      tiktokUsername,
      city,
      trainingFocus,
      reason,
      photoPath,
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
    this.trainingFocus,
    this.reason,
    this.photoPath,
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
    trainingFocus = json["training_focus"];
    reason = json["reason"];
    photoPath = json["photo_path"];
    status = json["status"];
    createdAt = json["created_at"];
  }
}
