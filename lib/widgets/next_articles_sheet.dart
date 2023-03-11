import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/model/article.dart';
import 'package:rss_reader/providers/feed_provider.dart';
import 'package:rss_reader/widgets/article_card.dart';

class NextArticlesButton extends StatelessWidget {
  const NextArticlesButton({super.key, required this.onTap});
  final void Function(Article article) onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.next_plan_outlined),
      onPressed: () {
        showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 400,
              child: DraggableScrollableSheet(
                initialChildSize: 1.0,
                maxChildSize: 1.0,
                builder: (BuildContext context, ScrollController scrollController) {
                  return NextArticles(onTap: onTap);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class NextArticles extends StatelessWidget {
  NextArticles({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final List<Article> articles = [];
  final void Function(Article article) onTap;

  @override
  Widget build(BuildContext context) {
    var articles = Provider.of<FeedProvider>(context).articles..shuffle;
    var nextArticles = articles.sublist(0,4 > articles.length ? articles.length : 4);

    return Column(children: [
      const Text('Next articles:', style: TextStyle(fontWeight: FontWeight.bold),),
      for (var article in nextArticles)
        ArticleCard(article: article,)
      ],);
  }
}
