import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:rss_reader/data/feed_repository.dart';
import 'package:rss_reader/model/feed.dart';
import 'package:rss_reader/networking/rss_feed_api.dart';
import 'package:rss_reader/utils/utils.dart';
import 'package:webfeed/domain/rss_feed.dart';
import '../model/article.dart';
import 'package:http/http.dart' as http;

class FeedProvider extends ChangeNotifier {

  FeedProvider(this.rssFeedApi, this.feedRepository);

  final FeedRepository feedRepository;
  final RssFeedApi rssFeedApi;

  List<Article> articles = [];

  List<Feed> subscribedFeedList = [
    Feed(
        description: "Google news, Pixel, Android, Home, Chrome OS, more",
        favIconUrl: 'https://9to5google.com/favicon.ico',
        isPodcast: false,
        siteName: "9to5google.com",
        url: "https://9to5google.com/feed/",
        title: "9to5Google",
        siteUrl: 'https://9to5google.com/feed/'),
    // Feed(
    //     siteName:
    //         "Android Authority: Tech Reviews, News, Buyer's Guides, Deals, How-To",
    //     description: "Android News, Reviews, How To",
    //     url: "https://www.androidauthority.com/feed/",
    //     favIconUrl: 'https://www.androidauthority.com/favicon.ico',
    //     siteUrl: 'https://www.androidauthority.com'),
  ];


  Future<void> loadFeeds() async {
    subscribedFeedList = await feedRepository.getAll();
  }

  Future<List<Article>> getArticles(String rssLink) async {
    articles.clear();
    articles = await rssFeedApi.getArticles(rssLink);
    return articles;
  }

  Future<List<Article>> getArticlesToHomePage() async {
    await loadFeeds();
    articles.clear();
    for (var feed in subscribedFeedList) {
      articles.addAll(await rssFeedApi.getArticles(feed.url));
    }
    return articles
      ..sort((b, a) =>
          (a.pubDate ?? DateTime.now()).compareTo(b.pubDate ?? DateTime.now()));
  }

  Future<List<Map<String, List<Article>>>> getArticlesSeparateByDate() async {
    await loadFeeds();
    List<Map<String, List<Article>>> articleSeparateByDate = [];
    List<Map<DateTime, Article>> map = [];
    Set<DateTime> dates = {};

    for (var feed in subscribedFeedList) {
      articles = await getArticles(feed.url);
      int differenceInDays = 0;
      for (var article in articles) {
        var pubDate = article.pubDate!;
        differenceInDays = calculateDifference(pubDate);
        map.add({
          DateTime(pubDate.year, pubDate.month, pubDate.day - differenceInDays):
              article
        });
        dates.add(DateTime(
            pubDate.year, pubDate.month, pubDate.day - differenceInDays));
      }
    }
    articleSeparateByDate = dates.map((date) {
      var filteredArticles = map
          .where((element) => element.keys.first.compareTo(date) == 0)
          .toList()
          .map((e) => e.values.toList().first)
          .toList();
      return {'${date.day}/${date.month}/${date.year}': filteredArticles};
    }).toList();

    return articleSeparateByDate;
  }

  add(Feed feed) async {
    if (!feed.subscribed) {
      feed = await feedRepository.insert(feed);
      subscribedFeedList.add(feed);
      feed.subscribed = true;
      notifyListeners();
    }
  }

  remove(Feed feed) async {
    if (feed.id != null) {
      subscribedFeedList.remove(feed);
      await feedRepository.delete(feed.id!);
    }
    notifyListeners();
  }

  isSubscribed(Feed feed) {
    return subscribedFeedList.map((e) => e.url).toList().contains(feed.url);
  }
}
