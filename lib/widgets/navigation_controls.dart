import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls({Key? key, required this.controller})
      : super(key: key);

  final Completer<WebViewController> controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
        future: controller.future,
        builder: (context, snapshot) {
          final WebViewController? controller = snapshot.data;
          if (snapshot.connectionState != ConnectionState.done ||
              controller == null) {
            return Row(
              children: const [
                Icon(Icons.arrow_back_ios),
                Icon(Icons.arrow_forward_ios),
                Icon(Icons.replay)
              ],
            );
          }
          return Row(
            children: [
              IconButton(onPressed: () async {
                if (await controller.canGoBack()) {
                  await controller.goBack();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No back history item'),));
                  return;
                }
              }, icon: const Icon(Icons.arrow_back_ios)),
             IconButton(onPressed: () async {
               if (await controller.canGoForward()) {
                 await controller.goForward();
               } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('No forward history item'),)
                 );
                 return;
               }
             }, icon:  const Icon(Icons.arrow_forward_ios)),
             IconButton(onPressed: () => controller.reload(), icon: const Icon(Icons.replay))
            ],
          );
        }
    );
  }
}
