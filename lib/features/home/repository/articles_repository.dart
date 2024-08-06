import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinews_news_reader/core/constants/api_urls.dart';
import 'package:vinews_news_reader/core/models/news_response.dart';
import 'package:vinews_news_reader/services/dio/dio.dart';
import 'package:vinews_news_reader/services/dio/dio_exceptions.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class ArticlesRepository {
  final DioClient _dioClient;
  final Ref _ref;

  ArticlesRepository({required DioClient dioClient, required Ref ref})
      : _dioClient = dioClient,
        _ref = ref;

  Future<List<Article>> getArticleList() async {
    try {
      final Map<String, dynamic> responseInMap =
          await _dioClient.get(path: AppUrls.getHomeArticlesUrl);

      // Deserialize the response using your model class
      final newsResponse = NewsResponse.fromJson(responseInMap);

      // Return the list of articles from the news response
      return newsResponse.articles;
    } on DioException catch (exception) {
      final appDioException =
          AppDioException.fromDIOException(dioException: exception);
      appDioException.errorMessage.log(); // Logging the error message
      return []; // Return an empty list to indicate an error
    } catch (e) {
      final errorMessage = 'Error fetching articles: $e';
      errorMessage.log(); // Logging the error message
      return []; // Return an empty list to indicate an error
    }
  }

  Future<List<Article>> getCategorySpecificArticles(
      {required String category}) async {
    try {
      "Category Req Made".log();
      final Map<String, dynamic> responseInMap =
          await _dioClient.get(path: AppUrls.getCategoryUrl(category));

      // Deserialize the response using your model class
      final newsResponse = NewsResponse.fromJson(responseInMap);

      // Return the list of articles from the news response
      return newsResponse.articles;
    } on DioException catch (exception) {
      final appDioException =
          AppDioException.fromDIOException(dioException: exception);
      appDioException.errorMessage.log(); // Logging the error message
      return []; // Return an empty list to indicate an error
    } catch (e) {
      final errorMessage = 'Error fetching articles: $e';
      errorMessage.log(); // Logging the error message
      return []; // Return an empty list to indicate an error
    }
  }

  Future<List<Article>> getSearchRequestArticles(
      {required String searchKeyword}) async {
    try {
      "Search Req Made".log();
      final Map<String, dynamic> responseInMap =
          await _dioClient.get(path: AppUrls.searchArticleUrl(searchKeyword));

      // Deserialize the response using your model class
      final newsResponse = NewsResponse.fromJson(responseInMap);

      // Return the list of articles from the news response
      return newsResponse.articles;
    } on DioException catch (exception) {
      final appDioException =
          AppDioException.fromDIOException(dioException: exception);
      appDioException.errorMessage.log(); // Logging the error message
      return []; // Return an empty list to indicate an error
    } catch (e) {
      final errorMessage = 'Error fetching articles: $e';
      errorMessage.log(); // Logging the error message
      return []; // Return an empty list to indicate an error
    }
  }
}

final articlesRepositoryProvider = Provider<ArticlesRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return ArticlesRepository(dioClient: dioClient, ref: ref);
});

final isLoadingArticlesProvider = StateProvider<bool>((ref) {
  return true;
});
