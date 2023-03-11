import 'package:flutter/material.dart';
import 'package:rss_reader/model/feed.dart';
import 'package:rss_reader/widgets/feed_icon.dart';

class FeedMenuItem extends StatelessWidget {
  const FeedMenuItem({Key? key, required this.feed, required this.onTap, required this.onLongPress})
      : super(key: key);

  final Feed feed;
  final void Function() onTap;
  final void Function() onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: onLongPress,
      onTap: onTap,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
          child: SizedBox(
              height: 30,
              child: FeedIcon(feed: feed,)),
        ),
        Flexible(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(feed.title, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,)
            /*Text(
              '${feed.title.substring(0, feed.title.length < 20 ? feed.title.length : 20)}${feed.title.length < 20 ? '' : '...'}',
            )*/,
          ),
        ),
        Flexible(child: const Icon(Icons.arrow_forward_ios))
      ]),
    );
  }
}
