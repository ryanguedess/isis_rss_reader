import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/providers/feed_provider.dart';
import 'package:rss_reader/providers/search_provider.dart';
import 'package:rss_reader/view/feed_page.dart';
import 'package:rss_reader/widgets/feed_tile.dart';
import 'package:rss_reader/widgets/search_field.dart';
import 'package:rss_reader/widgets/shimmer_loading.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        return Column(
          children: [
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  if (searchProvider.isSearching) {
                    return const ShimmerLoading();
                  } else if (searchProvider.results.isEmpty) {
                    return const Center(
                      child: Text('Feed not found'),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.builder(
                          reverse: searchProvider.results.length < 5,
                          itemCount: searchProvider.results.length,
                          itemBuilder: (context, index) {
                            var feed = searchProvider.results[index];
                            return FeedTile(
                                feed: feed,
                                onTap: () => FeedPage.show(context, feed));
                          }),
                    );
                  }
                },
              ),
            ),
            SearchField(
                onPressed: () {
                  searchProvider.clearResults();
                  searchTextController.clear();
                },
                onSubmitted: (value) => searchProvider.searchFeedsBySite(value),
                textEditingController: searchTextController)
          ],
        );

      },
    );
  }
}
