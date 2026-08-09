class EarlyAccessImageModel {
  dynamic id, imageUrl, sortOrder;

  EarlyAccessImageModel({this.id, this.imageUrl, this.sortOrder});

  EarlyAccessImageModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    imageUrl = json["image_url"];
    sortOrder = json["sort_order"];
  }
}
