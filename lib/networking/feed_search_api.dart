import 'dart:convert';

import 'package:http/http.dart';

import '../model/feed.dart';
import '../utils/endpoints.dart';

class FeedSearchApi {
  FeedSearchApi(this.client);

  final Client client;

  Future<List<Feed>> searchFeedsBySite(String site) async {
    final response =
        await client.get(Uri.parse((Endpoints.feedSearch + site)));

    if (response.statusCode == 200) {
      List<Feed> feeds = [];
      var items = jsonDecode(response.body);
      for (var i = 0; i < items.length; ++i) {
        var feed = Feed.fromJson(items[i]);
        if (!feed.isPodcast) feeds.add(feed);
      }
      return feeds;
    } else {
      return [];
    }
  }


}
