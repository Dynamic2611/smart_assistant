class ChatMessage {
  final String message;
  final String sender; 
  final bool isUser;

  ChatMessage({
    required this.message,
    required this.sender,
  }) : isUser = sender == 'user';

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] ?? '',
      sender: json['sender'] ?? 'user',
    );
  }
}