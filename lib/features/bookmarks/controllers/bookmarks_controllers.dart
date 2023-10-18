import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinews_news_reader/core/models/article_selections.dart';

// Bookmarks Managing State Notifier Class
class UserBookmarksListNotifier extends StateNotifier<List<ArticleSelections>> {
  UserBookmarksListNotifier() : super(articleDisplayList);

  //  void addArticleToBookmarks(ArticleSelections article) {
  //   state = [...state, article];
  // }

  void removeArticleFromBookmarks(ArticleSelections article) {
    state = state.where((a) => a != article).toList();
  }
}

class QueryStringNotifier extends StateNotifier<String> {
  QueryStringNotifier() : super('');

  // Method to update the string
  void updateQueryString(String newValue) {
    state = newValue;
  }
}

final bookmarksProvider =
    StateNotifierProvider<UserBookmarksListNotifier, List<ArticleSelections>>(
  (ref) => UserBookmarksListNotifier(),
);

final bookmarksQueryStringProvider =
    StateNotifierProvider<QueryStringNotifier, String>((ref) {
  return QueryStringNotifier();
});

