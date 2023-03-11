import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/providers/feed_provider.dart';
import 'package:rss_reader/view/feed_page.dart';
import 'package:rss_reader/widgets/feed_menu_item.dart';
import 'package:rss_reader/widgets/feed_options.dart';


class FeedListCard extends StatelessWidget {
  const FeedListCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(builder: (context, feedProvider, child) {
      var feeds = feedProvider.subscribedFeedList;
      return Card(
        elevation: 8.0,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: feeds.length,
            itemBuilder: (context, index) {
              var feed = feeds.elementAt(index);
              return Column(
                children: [
                  FeedMenuItem(
                    feed: feed,
                    onLongPress: () => showOptions(context, feed),
                    onTap: () => FeedPage.show(context, feed),
                  ),
                ],
              );
            }),
      );
    });
  }
}
