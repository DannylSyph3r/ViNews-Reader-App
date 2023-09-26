import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarksViewSearchHistory extends StateNotifier<List<String>> {
  BookmarksViewSearchHistory() : super([]);

  void addToBookmarksHistory(String query) {
    state = [...state, query];
  }

    void removeFromBookmarksHistory(String query) {
    state = state.where((item) => item != query).toList();
  }
}

final bookmarksSearchHistoryProvider = StateNotifierProvider<BookmarksViewSearchHistory, List<String>>((ref) {
  return BookmarksViewSearchHistory();
});