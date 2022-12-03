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

import 'providers/articles_provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = http.Client();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FeedProvider>(create: (_) => FeedProvider(RssFeedApi(client), FeedRepository.instance)),
        ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider(FeedSearchApi(client))),
        ChangeNotifierProvider<ArticleProvider>(create: (_) => ArticleProvider(ArticleRepository.instance)),
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

