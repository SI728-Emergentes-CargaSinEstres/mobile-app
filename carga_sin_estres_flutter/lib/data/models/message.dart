class Message {
  final int id;
  final String content;
  final DateTime messageDate;
  final String userType;

  Message({
    required this.id,
    required this.content,
    required this.messageDate,
    required this.userType,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      messageDate: DateTime.parse(json['messageDate']),
      userType: json['userType'],
    );
  }
}
