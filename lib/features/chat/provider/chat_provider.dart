import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import '../../../core/storage/chat_storage.dart';
import '../model/chat_model.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final String? sessionId;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.sessionId,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    String? sessionId,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState());

  final ApiService _api = ApiService();

  Future<void> startNewSession() async {
    final sessionId = await ChatStorage.createSession();
    state = ChatState(sessionId: sessionId);
  }

  Future<void> loadSession(String sessionId) async {
    state = state.copyWith(isLoading: true, sessionId: sessionId);

    try {
      final response = await _api.getSessionMessages(sessionId);
      final data = response['data'] as List;
      final messages = data
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList();

      state = ChatState(
        messages: messages,
        sessionId: sessionId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load chat. Please try again.',
      );
    }
  }

  Future<void> sendMessage(String message) async {
    if (state.sessionId == null) {
      await startNewSession();
    }

    final userMsg = ChatMessage(message: message, sender: 'user');
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      error: null,
    );

    try {
      final response = await _api.sendMessage(
        message,
        sessionId: state.sessionId!,
      );
      final reply = response['reply'] as String;

      final assistantMsg = ChatMessage(message: reply, sender: 'assistant');
      state = state.copyWith(
        messages: [...state.messages, assistantMsg],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to get reply. Please try again.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}