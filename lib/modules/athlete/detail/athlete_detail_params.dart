class AthleteDetailParams {
  dynamic id;

  AthleteDetailParams({this.id});

  AthleteDetailParams.fromMap(Map<String, String?> json) {
    id = json["id"];
  }
}
