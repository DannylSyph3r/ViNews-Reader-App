class NewsResponse {
    final String status;
    final int totalResults;
    final List<Article> articles;

    NewsResponse({
        required this.status,
        required this.totalResults,
        required this.articles,
    });

    NewsResponse copyWith({
        String? status,
        int? totalResults,
        List<Article>? articles,
    }) => 
        NewsResponse(
            status: status ?? this.status,
            totalResults: totalResults ?? this.totalResults,
            articles: articles ?? this.articles,
        );

    factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
    );

}

class Article {
    final Source source;
    final String? author;
    final String title;
    final String? description;
    final String url;
    final String? urlToImage;
    final DateTime publishedAt;
    final String? content;

    Article({
        required this.source,
        required this.author,
        required this.title,
        required this.description,
        required this.url,
        required this.urlToImage,
        required this.publishedAt,
        required this.content,
    });

    Article copyWith({
        Source? source,
        String? author,
        String? title,
        String? description,
        String? url,
        String? urlToImage,
        DateTime? publishedAt,
        String? content,
    }) => 
        Article(
            source: source ?? this.source,
            author: author ?? this.author,
            title: title ?? this.title,
            description: description ?? this.description,
            url: url ?? this.url,
            urlToImage: urlToImage ?? this.urlToImage,
            publishedAt: publishedAt ?? this.publishedAt,
            content: content ?? this.content,
        );

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: Source.fromJson(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
    );
}

class Source {
    final String? id;
    final String name;

    Source({
        required this.id,
        required this.name,
    });

    Source copyWith({
        String? id,
        String? name,
    }) => 
        Source(
            id: id ?? this.id,
            name: name ?? this.name,
        );

    factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
    );
}
