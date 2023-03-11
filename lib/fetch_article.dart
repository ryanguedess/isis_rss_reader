import 'package:http/http.dart';
import 'package:rss_reader/model/article.dart';
import 'data/article_repository.dart';
import 'data/feed_repository.dart';
import 'model/feed.dart';
import 'networking/rss_feed_api.dart';

Future<void> main() async {
        var feedRepository = FeedRepository.instance;
        var feeds = await feedRepository.getAll();
        var rssRepository = RssFeedApi(Client());
        var articleRepository = ArticleRepository.instance;
        for (Feed feed in feeds) {
            try {
                var articles = await rssRepository.getArticles(feed.url);
                for (Article article in articles) {
                    await articleRepository.insert(article);
                }
            } on Exception catch (exception) {
                print(exception);
            } catch (error) {
                print(error);
            }
        }
        return Future.value(true);
}