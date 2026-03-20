import '../../chat/model/chat_model.dart';

class ChatSessionModel {
  final String sessionId;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  ChatSessionModel({
    required this.sessionId,
    required this.createdAt,
    required this.messages,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    final messageList = json['messages'] as List;
    return ChatSessionModel(
      sessionId: json['session_id'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      messages: messageList
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  String get previewTitle {
    final firstUserMsg = messages.where((m) => m.isUser).toList();
    if (firstUserMsg.isNotEmpty) {
      final title = firstUserMsg.first.message;
      return title.length > 50 ? '${title.substring(0, 50)}...' : title;
    }
    return 'Chat Session';
  }
}
