class ChatModel {

  final String id;
  final String last_message;
  final List<dynamic> members;
  final String topic;
  final int modified_at;

  ChatModel({this.id, this.last_message, this.members, this.topic, this.modified_at});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        id: json['id'] ?? "",
        last_message: json['last_message'] ?? "",
        members: json['members'] as List,
        topic: json['topic'] ?? "",
        modified_at: json['modified_at'],
    );
  }

  static List<ChatModel> getChats(List jsonList) {
    return jsonList.map((p) => ChatModel.fromJson(p)).toList();
  }

}