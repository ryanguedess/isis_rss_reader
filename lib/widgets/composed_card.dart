import 'package:flutter/material.dart';
import 'package:rss_reader/model/article.dart';
import 'package:rss_reader/widgets/content_for_article_card.dart';

class ComposedCard extends StatelessWidget {
  const ComposedCard({
    Key? key,
    required this.articlesByCategory,
  }) : super(key: key);

  final Map<String, List<Article>> articlesByCategory;

  @override
  Widget build(BuildContext context) {
    var articles = articlesByCategory.values.first;
    var category = articlesByCategory.keys.first;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.circle,
                    size: 10,
                  ),
                  Text(
                    ' $category - ${articles.length} articles',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            for (var article in articles)
              ContentForArticleCard(article: article)
          ],
        ),
      ),
    );
  }
}
