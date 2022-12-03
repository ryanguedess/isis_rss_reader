import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:collection/collection.dart';

import '../model/article.dart';

class RssFeedApi {
  RssFeedApi(this.client);

  final Client client;

  Future<List<Article>> getArticles(String rssLink) async {
    final response = await client.get(Uri.parse((rssLink)));
    if (response.statusCode == 200) {
      var document = RssFeed.parse(response.body);
      var articles = extractArticlesFromFeeds(document);
      return articles;
    } else {
      return [];
    }
  }
}

List<Article> extractArticlesFromFeeds(RssFeed document) {
  List<Article> articles = [];

  var rssItems = document.items ?? [];

  for (var item in rssItems) {
    String content = '';
    String? image;
    if (item.content != null) {
      content = item.content!.value;
      try {
        image = item.content!.images.first;
      } catch (ex) {
        image = item.media!.contents?.firstOrNull?.url;
      }
    } else if (item.description != null) {
      var fragment = parseFragment(item.description ?? '');
      content = fragment.querySelector('p')?.text ?? '';
      var img = fragment.querySelectorAll('img');
      image = img.isNotEmpty ? img.first.attributes['src'].toString() : null;
    }
    articles.add(Article(
      publisher: document.title ?? '',
      title: item.title ?? '',
      content: content,
      image: image,
      link: item.link ?? '',
      pubDate: item.pubDate,
    ));
  }
  // articles = document.items?.map((e) {
  //   String content = '';
  //   String? image;
  //   if (e.content != null) {
  //     content = e.content!.value;
  //     try {
  //       image = e.content!.images.first;
  //     } catch (ex) {
  //       image = e.media!.contents?.first.url;
  //     }
  //   } else if (e.description != null) {
  //     var fragment = parseFragment(e.description ?? '');
  //     content = fragment.querySelector('p')?.text ?? '';
  //     var img = fragment.querySelectorAll('img');
  //     image = img.isNotEmpty ? img.first.attributes['src'].toString() : null;
  //   }
  //   return Article(
  //     publisher: document.title ?? '',
  //     title: e.title ?? '',
  //     content: content,
  //     image: image,
  //     link: e.link ?? '',
  //     pubDate: e.pubDate,
  //   );
  // }).toList();

  return articles;
}
