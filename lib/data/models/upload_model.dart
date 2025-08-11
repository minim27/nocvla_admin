class UploadModel {
  dynamic url;

  UploadModel({this.url});

  UploadModel.fromJson(Map<String, dynamic> json) {
    url = json["url"];
  }
}
