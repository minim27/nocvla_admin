class HomeADModel {
  dynamic availableDate;

  HomeADModel({this.availableDate});

  HomeADModel.fromJson(Map<String, dynamic> json) {
    availableDate = json["available_date"];
  }
}

class HomeContentModel {
  dynamic title, description, gallery, products;

  HomeContentModel({this.title, this.description, this.gallery, this.products});

  HomeContentModel.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    description = json["description"];
    gallery = json["gallery"];
    products = json["products"];
  }
}
