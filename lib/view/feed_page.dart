import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/model/article.dart';
import 'package:rss_reader/model/feed.dart';
import 'package:rss_reader/providers/feed_provider.dart';
import 'package:rss_reader/widgets/article_card.dart';
import 'package:rss_reader/widgets/shimmer_loading.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key, required this.feed}) : super(key: key);

  final Feed feed;

  static void show(BuildContext context, Feed feed) {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return FeedPage(feed: feed,);
    }));
  }

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  bool showFab = false;
  late Future<List<Article>> _loadFeed;
  late FeedProvider _feedProvider;

  @override
  void initState() {
    _feedProvider = Provider.of<FeedProvider>(context, listen: false);
    _loadFeed = _feedProvider.getArticles(widget.feed.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Article> articles = [];
    var controller = ScrollController();

    return  Scaffold(
        body: FutureBuilder(
          future: _loadFeed,
          builder: (context, AsyncSnapshot<List<Article>> snapshot) {
            if (snapshot.hasData) {
              articles = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async => articles = await _loadFeed,
                child: NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    if (notification.direction == ScrollDirection.forward) {
                      if (!showFab) setState(()=> showFab = true);
                    } else if (notification.direction == ScrollDirection.reverse) {
                      if (showFab) setState(()=> showFab = false);
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        snap: true,
                        title: Text(widget.feed.siteName),
                        centerTitle: true,
                      ),
                      SliverToBoxAdapter(
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.feed.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )),
                      ),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              childCount: articles.length, (context, index) {
                        var article = articles[index];
                        return ArticleCard(
                          article: article,
                        );
                      }))
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: ShimmerLoading(),
              );
            }
          },
        ),
        floatingActionButton:
        showFab ?
        FloatingActionButton.extended(
            onPressed: () => _feedProvider.add(widget.feed),
            icon: const Icon(Icons.add),
            label: const Text('Subscribe'))
      : null,
    );
  }
}
