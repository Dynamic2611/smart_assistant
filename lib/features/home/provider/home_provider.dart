import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import '../model/suggestion_model.dart';

// State class to hold suggestions + loading + pagination info
class HomeState {
  final List<Suggestion> suggestions;
  final bool isLoading;
  final bool hasNext;
  final int currentPage;
  final String? error;

  const HomeState({
    this.suggestions = const [],
    this.isLoading = false,
    this.hasNext = true,
    this.currentPage = 0,
    this.error,
  });

  HomeState copyWith({
    List<Suggestion>? suggestions,
    bool? isLoading,
    bool? hasNext,
    int? currentPage,
    String? error,
  }) {
    return HomeState(
      suggestions: suggestions ?? this.suggestions,
      isLoading: isLoading ?? this.isLoading,
      hasNext: hasNext ?? this.hasNext,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  final ApiService _api = ApiService();

  Future<void> fetchSuggestions() async {
    if (state.isLoading || !state.hasNext) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final nextPage = state.currentPage + 1;
      final response = await _api.getSuggestions(page: nextPage);

      final data = response['data'] as List;
      final pagination = PaginationInfo.fromJson(response['pagination']);
      final newSuggestions = data
          .map((e) => Suggestion.fromJson(e as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        suggestions: [...state.suggestions, ...newSuggestions],
        isLoading: false,
        hasNext: pagination.hasNext,
        currentPage: pagination.currentPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load suggestions. Tap to retry.',
      );
    }
  }
}