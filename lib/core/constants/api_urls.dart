abstract class AppUrls {
  static const String _apiKey = "f20c9aa9d9e04c549f83826f7e89c0c6";
  static const String topHeadlinebaseUrl = 'https://newsapi.org/v2/top-headlines';
  static const String baseSearchUrl = 'https://newsapi.org/v2/everything';
  static const String getHomeArticlesUrl = '$topHeadlinebaseUrl?country=us&category=&pageSize=20&apiKey=$_apiKey';
  static String getCategoryUrl(String category) {
    return '$topHeadlinebaseUrl?country=us&category=$category&pageSize=20&apiKey=$_apiKey';
  }
  static String searchArticleUrl(String searchKeyword) {
  return '$baseSearchUrl?q=$searchKeyword&sortBy=relevancy&apiKey=$_apiKey';
  }
}