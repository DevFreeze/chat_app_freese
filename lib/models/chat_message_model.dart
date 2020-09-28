class ChatMessageModel {
  final String id;
  final String message;
  final String sender;
  final int modified_at;

  ChatMessageModel({this.id, this.message, this.sender, this.modified_at});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
        id: json['id'] ?? "",
        message: json['message'] ?? "",
        sender: json['sender'] ?? "",
        modified_at: json['modified_at']);
  }

  // Messages are sorted by their timestamp
  static List<ChatMessageModel> getChatMessages(List jsonList) {
    List<ChatMessageModel> messages = jsonList.map((p) => ChatMessageModel.fromJson(p)).toList();
    messages.sort((a, b) => a.modified_at.compareTo(b.modified_at));
    return messages;
  }
}
