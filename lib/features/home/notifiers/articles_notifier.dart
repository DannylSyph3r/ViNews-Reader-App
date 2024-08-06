import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinews_news_reader/core/models/news_response.dart';
import 'package:vinews_news_reader/features/home/repository/articles_repository.dart';

// class ArticleNotifier extends StateNotifier {
//   // Fetch all articles on listen
//   //Pass Ref, to access other providers inside this.
//    ArticleNotifier({required this.ref}) : super([]) {
//     fetchArticles(ref: ref);
//    }
//    final Ref ref;

//    Future fetchArticles({required Ref ref}) async {
//     await ref
//     .read(articlesRepositoryProvider)
//     .getArticleList()
//     .then((value) {
//     // Set current 'state' to the fetched article list
//     state = value;
//     // Set isLoading to false
//     ref.read(isLoadingArticlesProvider.notifier).update((state) => false);
//     });
//    }
// }

// final articleListProvider = StateNotifierProvider<ArticleNotifier, dynamic>((ref) {
//   return ArticleNotifier(ref: ref);
// });

  final homeArticlesListProvider = FutureProvider<List<Article>>((ref) async {
  final articlesRepository = ref.read(articlesRepositoryProvider);
  final response = await articlesRepository.getArticleList();
  return response;
});

final explorePageArticlesListProvider = FutureProvider.family<List<Article>, String>((ref, category) async {
  final articlesRepository = ref.read(articlesRepositoryProvider);
  final response = await articlesRepository.getCategorySpecificArticles(category: category);
  return response;
});

final searchedArticlesListProvider = FutureProvider.family<List<Article>, String>((ref, searchKeyword) async {
  final articlesRepository = ref.read(articlesRepositoryProvider);
  final response = await articlesRepository.getSearchRequestArticles(searchKeyword: searchKeyword);
  return response;
});

