import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/data/article_repository.dart';
import 'package:rss_reader/data/feed_repository.dart';
import 'package:rss_reader/networking/feed_search_api.dart';
import 'package:rss_reader/providers/feed_provider.dart';
import 'package:rss_reader/networking/rss_feed_api.dart';
import 'package:rss_reader/providers/search_provider.dart';
import 'package:rss_reader/providers/theme_provider.dart';
import 'package:rss_reader/view/start_page.dart';
import 'package:workmanager/workmanager.dart';

import 'providers/articles_provider.dart';
import 'package:http/http.dart' as http;

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return await fetchArticles();
  });
}

Future<bool> fetchArticles() async {
  var feedRepository = FeedRepository.instance;
  var feeds = await feedRepository.getAll();
  var rssRepository = RssFeedApi(http.Client());
  var articleRepository = ArticleRepository.instance;
  for (var feed in feeds) {
    try {
      var articles = await rssRepository.getArticles(feed.url);
      for (var article in articles) {
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  //Workmanager().registerOneOffTask("task-identifier", "simpleTask");
  Workmanager().registerPeriodicTask(
    "1",
    "simpleTask",
  );
  runApp(const FutureTest());
}

class FutureTest extends StatelessWidget {
  const FutureTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchArticles(),
        builder: (BuildContext, AsyncSnapshot<bool> snapShot) {
          return Container(child: Text('Teste'));
        });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = http.Client();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FeedProvider>(
            create: (_) =>
                FeedProvider(RssFeedApi(client), FeedRepository.instance)),
        ChangeNotifierProvider<SearchProvider>(
            create: (_) => SearchProvider(FeedSearchApi(client))),
        ChangeNotifierProvider<ArticleProvider>(
            create: (_) => ArticleProvider(ArticleRepository.instance)),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, __) => MaterialApp(
          title: 'Flutter Demo',
          theme: themeProvider.getTheme(),
          home: const SafeArea(
            child: StartPage(),
          ),
        ),
      ),
    );
  }
}
