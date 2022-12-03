import 'package:flutter/material.dart';

import '../model/feed.dart';

class FeedIcon extends StatelessWidget {
  const FeedIcon({Key? key, required this.feed}) : super(key: key);

  final Feed feed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Image.network(
        feed.favIconUrl,
        errorBuilder: (context, object, stackTrace) =>
            Text(feed.title[0].toUpperCase(),style: const TextStyle(fontWeight: FontWeight.bold),),
      ),
    );
  }
}
