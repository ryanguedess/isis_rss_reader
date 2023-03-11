import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/providers/feed_provider.dart';
import 'package:rss_reader/view/feed_page.dart';
import 'package:rss_reader/widgets/feed_list_card.dart';
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
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              'Feeds',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                FeedListCard(),
                const SizedBox(
                  height: 40,
                ),
                const ThemeSelector()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
