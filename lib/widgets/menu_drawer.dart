import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/providers/feed_provider.dart';
import 'package:rss_reader/view/feed_page.dart';
import 'package:rss_reader/widgets/feed_menu_item.dart';
import 'package:rss_reader/widgets/feed_options.dart';
import 'package:rss_reader/widgets/theme_selector.dart';

class Menu extends StatelessWidget {
  const Menu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Column(
            children: [
              Text('IRIS', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 40, fontWeight: FontWeight.bold),),
              Text(
                'RSS Reader',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.dark_mode_sharp,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.account_balance_outlined,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.menu_book_sharp,
                    ),
                  )
                ],
              )
            ],
          )),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              'Feeds',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          Consumer<FeedProvider>(builder: (context, feedProvider, child) {
            var feeds = feedProvider.subscribedFeedList;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: feeds.length,
                        itemBuilder: (context, index) {
                          var feed = feeds.elementAt(index);
                          return Column(
                            children: [
                              FeedMenuItem(
                                feed: feed,
                                onLongPress: () => showOptions(context, feed),
                                onTap: () => FeedPage.show(context, feed),
                              ),
                              if (index != feeds.length - 1) const Divider(),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(height: 40,),
                  const ThemeSelector()
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}


