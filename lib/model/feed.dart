const String feedTable = 'feeds';

class FeedFields {
  static const List<String> columns = [
    id,
    description,
    favIconUrl,
    isPodcast,
    siteName,
    title,
    siteUrl,
    url
  ];
  static const String id = 'id';
  static const String description = 'description';
  static const String favIconUrl = 'favIconUrl';
  static const String isPodcast = 'isPodcast';
  static const String siteName = 'siteName';
  static const String title = 'title';
  static const String siteUrl = 'siteUrl';
  static const String url = 'url';
}

class Feed {
  final int? id;
  final String description;
  final String favIconUrl;
  final bool isPodcast;
  final String siteName;
  final String title;
  final String siteUrl;
  final String url;

  bool subscribed = false;

  Feed(
      {this.id,
      required this.description,
      required this.favIconUrl,
      required this.isPodcast,
      required this.siteName,
      required this.title,
      required this.siteUrl,
      required this.url});

  copy(
          {int? id,
          String? description,
          String? favIconUrl,
          bool? isPodcast,
          String? siteName,
          String? title,
          String? siteUrl,
          String? url}) =>
      Feed(
          id: id ?? this.id,
          description: description ?? this.description,
          favIconUrl: favIconUrl ?? this.favIconUrl,
          isPodcast: isPodcast ?? this.isPodcast,
          siteName: siteName ?? this.siteName,
          title: title ?? this.title,
          siteUrl: siteUrl ?? this.siteUrl,
          url: url ?? this.url);

  Feed.fromJson(Map<String, dynamic> json)
      : id = json[FeedFields.id],
        description = json['description'] ?? '',
        favIconUrl = json['favicon'] ?? '',
        isPodcast = json['is_podcast'],
        siteName = json['site_name'] ?? '',//TODO extract site name
        title = json['title'],
        siteUrl = json['site_url'] ?? '', //TODO extract site url
        url = json['url'];

  Feed.fromMap(Map<String, dynamic> map)
      : id = map[FeedFields.id],
        description = map[FeedFields.description],
        favIconUrl = map[FeedFields.favIconUrl] ?? '',
        isPodcast = map[FeedFields.isPodcast] == 1,
        siteName = map[FeedFields.siteName],
        title = map[FeedFields.title],
        siteUrl = map[FeedFields.siteUrl],
        url = map[FeedFields.url];

  Map<String, dynamic> toMap() => {
        FeedFields.id: id,
        FeedFields.description: description,
        FeedFields.favIconUrl: favIconUrl,
        FeedFields.isPodcast: isPodcast ? 1 : 0,
        FeedFields.siteName: siteName,
        FeedFields.title: title,
        FeedFields.siteUrl: siteUrl,
        FeedFields.url: url
      };
}
