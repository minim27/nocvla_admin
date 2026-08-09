class EarlyAccessSettingsModel {
  dynamic id, isEarlyAccess, earlyAccessEndAt, earlyAccessPassword;

  EarlyAccessSettingsModel({
    this.id,
    this.isEarlyAccess,
    this.earlyAccessEndAt,
    this.earlyAccessPassword,
  });

  EarlyAccessSettingsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    isEarlyAccess = json["is_early_access"];
    earlyAccessEndAt = json["early_access_end_at"];
    earlyAccessPassword = json["early_access_password"];
  }
}
