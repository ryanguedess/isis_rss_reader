import 'package:flutter/material.dart';
import 'package:rss_reader/model/article.dart';
import 'package:rss_reader/widgets/content_for_article_card.dart';

import '../view/article_readermode_page_.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ContentForArticleCard(article: article),
    );
  }
}
