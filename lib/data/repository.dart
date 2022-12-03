import 'package:rss_reader/model/article.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/feed.dart';

class Repository {
  static Database? _database;

  static final Repository instance = Repository._init();

  Repository._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('iris_reader.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $feedTable (
      ${FeedFields.id} $idType,
      ${FeedFields.description} $textType,
      ${FeedFields.favIconUrl} $textType,
      ${FeedFields.isPodcast} $boolType,
      ${FeedFields.siteName} $textType,
      ${FeedFields.title} $textType,
      ${FeedFields.siteUrl} $textType,
      ${FeedFields.url} $textType
      );
    CREATE TABLE $articleTable (
      ${ArticleFields.id} $idType,
      ${ArticleFields.publisher} $textType,
      ${ArticleFields.title} $textType,
      ${ArticleFields.content} $boolType,
      ${ArticleFields.link} $textType,
      ${ArticleFields.image} $textType,
      ${ArticleFields.pubDate} $textType,
      );
    ''');
  }
}