import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/model/article.dart';
import 'package:rss_reader/providers/articles_provider.dart';
import 'package:rss_reader/readability.dart';
import 'package:rss_reader/widgets/next_articles_sheet.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:http/http.dart' as http;

class ReaderModeArticlePage extends StatefulWidget {
  const ReaderModeArticlePage({Key? key, required this.article,})
      : super(key: key);

  final Article article;

  static void show (BuildContext context, Article article) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ReaderModeArticlePage(article: article);
    }));
  }

  @override
  State<ReaderModeArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ReaderModeArticlePage> {

  String? url;
  String? img;
  String? title;

  bool showFab = false;
  late Future<String> _parseUrl;


  @override
  void initState() {
    _parseUrl = parseUrl(widget.article.link);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    url ??= widget.article.link;
    img ??= widget.article.image ?? '';
    title ??= widget.article.title;

    var controller = ScrollController();

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<String>(
          future: _parseUrl,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.forward) {
                  if (!showFab) setState(()=> showFab = true);
                } else if (notification.direction == ScrollDirection.reverse) {
                  if (showFab) setState(()=> showFab = false);
                }
                return true;
              } ,
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  const SliverAppBar(floating: true, snap: true),
                    SliverToBoxAdapter(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: img!,
                      ),
                    ),
                    SliverList(delegate: SliverChildListDelegate(<Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('${title!}\n', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(snapshot.data, style: const TextStyle(fontSize: 20),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: NextArticles(onTap: (article) {
                            setState(() {
                            url = article.link;
                            img = article.image;
                            title = article.title;
                          });
                            controller.animateTo(0,duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                        },),
                      )

                    ])),
                  ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }

        },),
        floatingActionButton:
        showFab ?
        Consumer<ArticleProvider>(
          builder: (context, articleProvider, child) {
            if (articleProvider.isSaved(widget.article)) return Container();
            return FloatingActionButton(
                child: const Icon(Icons.bookmark_border),
                onPressed: () => articleProvider.add(widget.article));
          },
        )
        : null,
        //TODO Reuse in Webview Page
        // floatingActionButton: NextArticlesButton(
        //   onTap: (url) {
        //     setState(() {
        //       Navigator.pop(context);
        //     });
        //   },
        // ),
      ),
    );
  }
}

Future<String> parseUrl (String url) async {
  final response = await http.Client().get(Uri.parse((url)));
  if (response.statusCode == 200) {
    return await Readability.parseFromUrl(url, response.body);
  } else {
    return '';
  }

}