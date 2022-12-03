const String articleTable = 'articles';

class ArticleFields {
  static const List<String> columns = [
    id,
    publisher,
    title,
    content,
    link,
    image,
    pubDate,
  ];
  static const String id = 'id';
  static const String publisher = 'publisher';
  static const String title = 'title';
  static const String content = 'content';
  static const String link = 'link';
  static const String image = 'image';
  static const String pubDate = 'pubdate';
}

class Article {
  Article(
      {this.id,
      required this.publisher,
      required this.title,
      required this.content,
      required this.link,
      this.image,
      required this.pubDate});

  final int? id;
  final String publisher;
  final String title;
  final String content;
  final String link;
  String? image;
  DateTime? pubDate;

  bool hasImage() => image != null;

  copy({
    int? id,
    String? publisher,
    String? title,
    String? content,
    String? link,
    String? image,
    DateTime? pubDate,
  }) =>
      Article(
          id: id ?? this.id,
          publisher: publisher ?? this.publisher,
          title: title ?? this.title,
          content: content ?? this.content,
          link: link ?? this.link,
          pubDate: pubDate ?? this.pubDate);

  Article.fromMap(Map<String, dynamic> map)
      : id = map[ArticleFields.id],
        publisher = map[ArticleFields.publisher],
        title = map[ArticleFields.title],
        content = map[ArticleFields.content],
        link = map[ArticleFields.link],
        image = map[ArticleFields.image],
        pubDate = DateTime.tryParse(map[ArticleFields.pubDate]);

  Map<String, dynamic> toMap() => {
        ArticleFields.id: id,
        ArticleFields.publisher: publisher,
        ArticleFields.title: title,
        ArticleFields.content: content,
        ArticleFields.link: link,
        ArticleFields.image: image,
        ArticleFields.pubDate: pubDate?.toIso8601String()
      };

  String getTime() {
    if (pubDate == null) return '';
    var time = pubDate!.difference(DateTime.now());

    if (time.inDays.abs() > 0) {
      return '${pubDate!.day}/${pubDate!.month}/${pubDate!.year}';
    } else if (time.inHours.abs() > 0) {
      return '${time.inHours.abs()}h';
    } else {
      return '${time.inMinutes.abs()} min';
    }
  }
}
