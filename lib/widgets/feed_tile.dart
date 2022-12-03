import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/model/feed.dart';
import 'package:rss_reader/providers/feed_provider.dart';
import 'package:rss_reader/widgets/feed_icon.dart';

class FeedTile extends StatelessWidget {
  const FeedTile({Key? key, required this.feed, required this.onTap}) : super(key: key);
  final Feed feed;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Consumer<FeedProvider>(
        builder: (context, feedProvider, child) {
          return Container(
            color: theme.primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: feedProvider.isSubscribed(feed) ? theme.colorScheme.primary.withOpacity(0.2) : theme.primaryColor,
                  child: ListTile(
                    leading: FeedIcon(feed: feed,),
                    title: Text(feed.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(feed.url,
                            style: TextStyle(
                                color: theme.colorScheme.secondary)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        feedProvider.isSubscribed(feed) ? Icons.check : Icons.add_circle,
                        size: 35,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () => feedProvider.add(feed),
                    ),
                  ),
                ),
                const Divider()
              ],
            ),
          );
        },
      ),
    );
  }
}
