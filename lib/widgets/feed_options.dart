import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/feed.dart';
import '../providers/feed_provider.dart';

showOptions(context, Feed feed) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 200,
        child: DraggableScrollableSheet(
          initialChildSize: 1.0,
          maxChildSize: 1.0,
          builder: (BuildContext context, ScrollController scrollController) {
            var theme = Theme.of(context);
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary,
                      child: const Icon(Icons.rss_feed)),
                  title: Text(feed.title, style: theme.textTheme.titleLarge,),
                  subtitle: Text(feed.siteUrl),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.remove_circle),
                  title: Text('Remove', style: theme.textTheme.labelLarge,),
                  onTap: () {
                    Provider.of<FeedProvider>(context, listen: false).remove(feed);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        ),
      );
    },
  );
}
