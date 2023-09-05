import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsInterestSelectionNotifier extends StateNotifier<List<String>> {
  NewsInterestSelectionNotifier()
      : super([
          "Business",
          "Finance",
          "Politics",
          "World Affairs",
          "Climate",
          "Health",
          "Science",
          "Culture",
          "Breaking News",
          "Sports",
          "Economy",
          "Personal Growth",
          "Tech",
          "Beauty & Style",
          "Food",
          "Learning",
          "Automotive",
          "Dance",
          "Arts & Crafts",
          "Comedy",
          "Animals",
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

final selectedNewsInterestsProvider =
    StateNotifierProvider<SelectedNewsInterestsNotifier, List<String>>(
  (ref) => SelectedNewsInterestsNotifier(),
);

final newsInterestSelectionProvider =
    StateNotifierProvider<NewsInterestSelectionNotifier, List<String>>(
  (ref) => NewsInterestSelectionNotifier(),
);
