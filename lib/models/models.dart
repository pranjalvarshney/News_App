class Article{
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article({this.source, this.author, this.title, this.description, this.url,
    this.urlToImage, this.publishedAt, this.content});

  factory Article.fromJson(Map<String, dynamic> json){
    return Article(

      source: Source.fromJsonForArcticle(json["source"]),
      author: json["author"],
      title: json["title"],
      description: json["title"],
      url: json["url"],
      urlToImage: json["urlToImage"],
      publishedAt: json["publishedAt"],
      content: json["content"]
    );
  }

}

class Source{

  final String id;
  final String name;
  final String description;
  final String url;
  final String category;
  final String language;
  final String country;

  Source({this.id, this.name, this.description, this.url, this.category, this.language, this.country});
  factory Source.fromJson(Map<String, dynamic> json){
    return Source(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      url: json["url"],
      category: json["category"],
      language: json["language"],
      country: json["category"]
    );
  }
  factory Source.fromJsonForArcticle(Map<String, dynamic> json){
    return Source(
      id: json["id"],
      name: json["name"]
    );
  }
}

class RootObjectsOfAPI{

  final String status;
  final List<Source> sources;

  RootObjectsOfAPI({this.status , this.sources});
  factory RootObjectsOfAPI.fromJson(Map<String, dynamic> json)
  {
    return RootObjectsOfAPI(status: json["status"] , sources: (json["sources"] as List).map((source) => Source.fromJson(source)).toList());
  }

}