class AthleteApplicationDetailParams {
  dynamic id;

  AthleteApplicationDetailParams({this.id});

  AthleteApplicationDetailParams.fromMap(Map<String, String?> json) {
    id = json["id"];
  }
}
