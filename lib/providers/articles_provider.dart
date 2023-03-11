import 'package:flutter/material.dart';
import 'package:rss_reader/data/article_repository.dart';
import 'package:rss_reader/model/article.dart';

class ArticleProvider extends ChangeNotifier {

  ArticleProvider(this.articleRepository);

  List<Article> bookmarkedArticles = [];

  ArticleRepository articleRepository;

  Future<List<Map<String, List<Article>>>> listArticlesByDate({int interval = 1}) async {
    var now = DateTime.now();
    List<Map<String, List<Article>>> articlesByDate = [];
    for (var i = 0; i <= interval; ++i) {
      var start = DateTime(now.year, now.month, now.day, 00, 00, 00, 000, 000).subtract(Duration(days: i));
      var end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999, 999).subtract(Duration(days: i));
      var articles = await articleRepository.listByDate(start, end);
      if (articles.length > 0) articlesByDate.add({'${start.day}/${start.month}/${start.year}' : articles});
    }
    return articlesByDate;
  }

  Future<List<Article>> getAll() {
    return articleRepository.getAll();
  }

  add(Article article) async {
    article = await articleRepository.insert(article);
    bookmarkedArticles.add(article);
    notifyListeners();
  }

  remove(Article article) async {
    if (article.id != null) {
      await articleRepository.delete(article.id!);
      bookmarkedArticles.remove(article);
      notifyListeners();
    }
  }

  isSaved(Article article) {
    return bookmarkedArticles.map((e) => e.link).toList().contains(article.link);
  }

  searchArticle (String keyword) async {
    await articleRepository.searchArticle(keyword);
    notifyListeners();
  }
}
