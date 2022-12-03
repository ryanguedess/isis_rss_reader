import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rss_reader/widgets/navigation_controls.dart';
import 'package:rss_reader/widgets/next_articles_sheet.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key, required this.url, required this.controller})
      : super(key: key);

  final Completer<WebViewController> controller;
  final String url;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  int loadingPercentage = 0;
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [NavigationControls(controller: widget.controller)],
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: widget.url,
              onWebViewCreated: (webViewController) {
                widget.controller.complete(webViewController);
                controller = webViewController;
              },
              onPageStarted: (url) {
                setState(() {
                  loadingPercentage = 0;
                });
              },
              onProgress: (progress) {
                setState(() {
                  loadingPercentage = progress;
                });
              },
              onPageFinished: (url) {
                setState(() {
                  loadingPercentage = 100;
                });
              },
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              )
          ],
        ),
        floatingActionButton: NextArticlesButton(
          onTap: (article) {
            setState(() {
              controller.loadUrl(article.link);
              Navigator.pop(context);
            });
          },
        ),
      ),
    );
  }
}
