import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/providers/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            'Themes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,),
          ),
        ),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    avatar: const Icon(Icons.light_mode_outlined),
                    label: const Text('Light'),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    selected: !themeProvider.isDarkTheme,
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    onSelected: (selected) {
                      if (selected) themeProvider.changeTheme();
                    },
                  ),
                  ChoiceChip(
                      avatar: const Icon(Icons.dark_mode_outlined),
                      label: const Text('Dark'),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      selected: themeProvider.isDarkTheme,
                      selectedColor: Theme.of(context).colorScheme.secondary,
                      onSelected: (selected) {
                        if (selected) themeProvider.changeTheme();
                      }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}