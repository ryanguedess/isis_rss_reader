import 'package:flutter/material.dart';
import 'package:rss_reader/model/feed.dart';
import 'package:rss_reader/networking/feed_search_api.dart';

class SearchProvider extends ChangeNotifier{

  SearchProvider(this.feedSearchApi);

  final FeedSearchApi feedSearchApi;

  List<Feed> results = [];
  bool isSearching = false;

  Future<void> searchFeedsBySite(String site) async {
    isSearching = true;
    notifyListeners();
    results = await feedSearchApi.searchFeedsBySite(site);
    isSearching = false;
    notifyListeners();
  }

  clearResults() {
    results.clear();
    notifyListeners();
  }
}