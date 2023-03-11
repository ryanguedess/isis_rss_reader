import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/data/article_repository.dart';
import 'package:rss_reader/model/article.dart';
import 'package:rss_reader/providers/feed_provider.dart';
import 'package:rss_reader/widgets/composed_card.dart';
import 'package:rss_reader/widgets/shimmer_loading.dart';

import '../providers/articles_provider.dart';

class FeedPageHome extends StatelessWidget {
  const FeedPageHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Article> articles = [];

    return Consumer<FeedProvider>(
      builder: (context, feedProvider, child) => Scaffold(
        body: FutureBuilder(
          future: ArticleProvider(ArticleRepository.instance).listArticlesByDate(interval: 7),
          builder: (context,
              AsyncSnapshot<List<Map<String, List<Article>>>> snapshot) {
            if (snapshot.hasData) {
              var articlesByValue = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async =>
                    articles = await feedProvider.getArticlesToHomePage(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Home Page',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text('\sort by date', style: Theme.of(context).textTheme.titleLarge,)
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: articlesByValue.length, (context, index) {
                      Map<String, List<Article>> item = articlesByValue.elementAt(index);
                      return ComposedCard(articlesByCategory: item);
                    }))
                  ],
                ),
              );
            } else {
              return const Center(
                child: ShimmerLoading(),
              );
            }
          },
        ),
      ),
    );
  }
}
