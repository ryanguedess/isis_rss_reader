import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/model/article.dart';
import 'package:rss_reader/providers/articles_provider.dart';
import 'package:rss_reader/view/article_readermode_page_.dart';
import 'package:rss_reader/widgets/search_field.dart';

class BookmarksPage extends StatelessWidget {
  BookmarksPage({Key? key}) : super(key: key);

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Consumer<ArticleProvider>(
            builder: (context, articleProvider, child) {
              return FutureBuilder<List<Article>>(
                future: articleProvider.getAll(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    var bookmarkedArticles = snapshot.data!;
                    return ListView.builder(
                        reverse: true,
                        itemCount: bookmarkedArticles.length,
                        itemBuilder: (context, index) {
                          var article = bookmarkedArticles[index];
                          return ListTile(
                            title: GestureDetector(
                              onTap: ()=> ReaderModeArticlePage.show(context, article),
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(article.image!))),
                                child: Stack(
                                  children: [
                                    Text(
                                      article.title,
                                      style: TextStyle(
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 2
                                          ..color = Colors.black,
                                      ),
                                    ),
                                    Text(article.title)
                                  ],
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.bookmark_remove_rounded),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () => articleProvider.remove(article),
                            ),
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator(),);
                  }
                },
              );
            },
          )),
          SearchField(onPressed: ()=> print, onSubmitted: (string)=> print, textEditingController: textController,)
        ],
      ),
    );
  }
}
