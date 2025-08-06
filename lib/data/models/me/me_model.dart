class MeModel {
  dynamic id, firstName, lastName, email, phoneNumber;

  MeModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
  });

  MeModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    firstName = json["first_name"];
    lastName = json["last_name"];
    email = json["email"];
    phoneNumber = json["phone_number"];
  }
}
