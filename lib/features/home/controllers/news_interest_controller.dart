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

final selectedNewsInterestsProvider =
    StateNotifierProvider<SelectedNewsInterestsNotifier, List<String>>(
  (ref) => SelectedNewsInterestsNotifier(),
);

final newsInterestSelectionProvider =
    StateNotifierProvider<NewsInterestSelectionNotifier, List<String>>(
  (ref) => NewsInterestSelectionNotifier(),
);
