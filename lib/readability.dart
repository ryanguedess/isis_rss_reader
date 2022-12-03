import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;


class Readability {
  static const MethodChannel _channel = MethodChannel('readability');


  static Future<String> parseFromUrl (String url, String html) async {
    final arguments = {'url' : url, 'html' : html};
    String parsedContent = await _channel.invokeMethod('parse', arguments);
    var document = parse(parsedContent);
    parsedContent = document.querySelectorAll('p').map((element) => element.text.trim()).toList().join('\n');
    return parsedContent;
  }

  // static Future<Map<String, String>> _getArticle () async {
  //   String url = 'https://www.androidauthority.com/nothing-ear-stick-review-3229214/';
  //   final response = await http.Client().get(Uri.parse((url)));
  //   if (response.statusCode == 200) {
  //     return {'url' : url, 'html': response.body};
  //   } else {
  //     return {'url' : '', 'html': ''};
  //   }
  // }
}
