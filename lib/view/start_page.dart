import 'package:flutter/material.dart';
import 'package:rss_reader/view/bookmarks_page.dart';
import 'package:rss_reader/view/home_page.dart';
import 'package:rss_reader/view/search_page.dart';
import 'package:rss_reader/widgets/menu_drawer.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _selectedIndex = 1;

  final List<Widget> _widgetOptions = [
    // FeedPage(
    //   feed: Feed(
    //       siteName: "9to5google.com",
    //       description: "Google news, Pixel, Android, Home, Chrome OS, more",
    //       url: "https://9to5google.com/feed/",
    //       favIconUrl: 'https://9to5google.com/favicon.ico',
    //       siteUrl: 'https://9to5google.com/feed/')
    //     ..subscribed = true,
    // ),
    const FeedPageHome(),
    SearchPage(),
    BookmarksPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Menu(),
        body: _widgetOptions[_selectedIndex - (_selectedIndex > 0 ? 1 : 0)],
        bottomNavigationBar: Builder(
          builder: (context) => NavigationBar(
            height: 60,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.menu), label: 'Menu'),
              NavigationDestination(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmarks_outlined),
                label: 'Saved',
              )
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
                if (_selectedIndex == 0) Scaffold.of(context).openDrawer();
              });
            },
          ),
        ));
  }
}
