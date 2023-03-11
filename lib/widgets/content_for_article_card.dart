import 'package:flutter/material.dart';
import 'package:rss_reader/model/article.dart';
import 'package:transparent_image/transparent_image.dart';

import '../view/article_readermode_page_.dart';

class ContentForArticleCard extends StatelessWidget {
  const ContentForArticleCard({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () => ReaderModeArticlePage.show(context, article),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: article.hasImage()
                      ? FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: article.image!,
                          width: 130,
                          height: 90,
                          fit: BoxFit.fitHeight,
                        )
                      : SizedBox(
                          width: 130,
                          height: 90,
                          child: Container(
                            color: theme.colorScheme.primary,
                            child: const Icon(
                              Icons.newspaper,
                              size: 60,
                            ),
                          ),
                        ),
                ),
              ],
            ),
            Flexible(
              child: ListTile(
                title: Text(
                  article.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium,
                ),
                subtitle: Text(
                  '${article.getTime()} - ${article.publisher}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
