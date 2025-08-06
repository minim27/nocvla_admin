class LoginModel {
  dynamic id, accessToken;

  LoginModel({this.id, this.accessToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    accessToken = json["access_token"];
  }
}
