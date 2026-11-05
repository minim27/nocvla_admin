class TrainingFocusModel {
  dynamic id, name, isActive, sortOrder;

  TrainingFocusModel({this.id, this.name, this.isActive, this.sortOrder});

  TrainingFocusModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    isActive = json["is_active"];
    sortOrder = json["sort_order"];
  }
}
