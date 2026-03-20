import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import '../model/history_model.dart';

class HistoryState {
  final List<ChatSessionModel> sessions;
  final bool isLoading;
  final String? error;

  const HistoryState({
    this.sessions = const [],
    this.isLoading = false,
    this.error,
  });

  HistoryState copyWith({
    List<ChatSessionModel>? sessions,
    bool? isLoading,
    String? error,
  }) {
    return HistoryState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier();
});

class HistoryNotifier extends StateNotifier<HistoryState> {
  HistoryNotifier() : super(const HistoryState());

  final ApiService _api = ApiService();

  Future<void> fetchHistory() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _api.getChatHistory();
      final data = response['data'] as List;
      final sessions = data
          .map((e) => ChatSessionModel.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        sessions: sessions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load history. Tap to retry.',
      );
    }
  }
}
