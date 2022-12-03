import 'package:flutter/material.dart';
import 'package:rss_reader/data/article_repository.dart';
import 'package:rss_reader/model/article.dart';

class ArticleProvider extends ChangeNotifier {

  ArticleProvider(this.articleRepository);

  List<Article> bookmarkedArticles = [];

  ArticleRepository articleRepository;

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
