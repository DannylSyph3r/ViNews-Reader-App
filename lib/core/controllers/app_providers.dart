import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsInterestSelectionNotifier extends StateNotifier<List<String>> {
  NewsInterestSelectionNotifier()
      : super([
          "Business",
          "Entertainment",
          "Food",
          "Environment",   
          "Health",
          "Politics",
          "Science",
          "Sports",
          "Technology",
          "Top News",
          "Tourism",
          "World",
        ]);
}

class SelectedNewsInterestsNotifier extends StateNotifier<List<String>> {
  SelectedNewsInterestsNotifier() : super([]);

  void toggleInterest(String interest) {
    if (state.contains(interest)) {
      state = state.where((item) => item != interest).toList();
    } else {
      state = [...state, interest];
    }
  }
}

// Providers

final dialogOpenProvider = StateProvider<bool>((ref) => false);

final homeScreenOverlayActiveProvider = StateProvider<bool>((ref) => false);

final exploreScreenOverlayActiveProider = StateProvider<bool>((ref) => false);

final bookmarksScreenOverlayActiveProvider = StateProvider<bool>((ref) => false);

final readArticlesScreenOverlayActiveProvider = StateProvider<bool>((ref) => false);

final likedArticlesScreenOverlayActiveProvider = StateProvider<bool>((ref) => false);

final animatedBarOpenProvider = StateProvider((ref) => false);

final selectedNewsInterestsProvider =
    StateNotifierProvider<SelectedNewsInterestsNotifier, List<String>>(
  (ref) => SelectedNewsInterestsNotifier(),
);

final newsInterestSelectionProvider =
    StateNotifierProvider<NewsInterestSelectionNotifier, List<String>>(
  (ref) => NewsInterestSelectionNotifier(),
);
