class MyAddressModel {
  dynamic id, city, district, village, address, postalCode;

  MyAddressModel({
    this.id,
    this.city,
    this.district,
    this.village,
    this.address,
    this.postalCode,
  });

  MyAddressModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    city = json["city"];
    district = json["district"];
    village = json["village"];
    address = json["address"];
    postalCode = json["postal_code"];
  }
}
