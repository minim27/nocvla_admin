class ContactTopicModel {
  dynamic id, name, isActive, sortOrder;

  ContactTopicModel({this.id, this.name, this.isActive, this.sortOrder});

  ContactTopicModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    isActive = json["is_active"];
    sortOrder = json["sort_order"];
  }
}
