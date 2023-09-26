import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreViewSearchHistory extends StateNotifier<List<String>> {
  ExploreViewSearchHistory() : super([]);

  void addToExploreHistory(String query) {
    state = [...state, query];
  }

  void removeFromExploreHistory(String query) {
    state = state.where((item) => item != query).toList();
  }
}

class QueryStringNotifier extends StateNotifier<String> {
  QueryStringNotifier() : super('');

  // Method to update the string
  void updateQueryString(String newValue) {
    state = newValue;
  }
}

final queryStringProvider =
    StateNotifierProvider<QueryStringNotifier, String>((ref) {
  return QueryStringNotifier();
});

final exploreSearchHistoryProvider =
    StateNotifierProvider<ExploreViewSearchHistory, List<String>>((ref) {
  return ExploreViewSearchHistory();
});
