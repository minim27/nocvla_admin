class ContactMessageModel {
  dynamic id, name, contact, topic, message, status, createdAt;

  ContactMessageModel({
    this.id,
    this.name,
    this.contact,
    this.topic,
    this.message,
    this.status,
    this.createdAt,
  });

  ContactMessageModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    contact = json["contact"];
    topic = json["topic"];
    message = json["message"];
    status = json["status"];
    createdAt = json["created_at"];
  }
}
