import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/article.dart';
import '../model/feed.dart';

class ArticleRepository {
  static Database? _database;

  static final ArticleRepository instance = ArticleRepository._init();

  ArticleRepository._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('isis_reader.db');
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
    ''');
    await db.execute('''
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

  Future<List<Article>> listByDate(DateTime start, DateTime end) async {
    final db = await instance.database;
    final maps = await db.query(
        articleTable,
        columns: ArticleFields.columns,
        where: 'pubdate between ? AND ? ',
        whereArgs: [start.toIso8601String(), end.toIso8601String()]
    );
    if (maps.isNotEmpty) {
      return maps.map((record) => Article.fromMap(record)).toList();
    } else {
      return [];
    }
  }

  Future<List<Article>> getAll() async {
    final db = await instance.database;
    final maps = await db.query(articleTable, columns: ArticleFields.columns);
    return maps.map((record) => Article.fromMap(record)).toList();
  }

  Future<Article> insert(Article article) async {
    final db = await instance.database;
    final id = await db.insert(articleTable, article.toMap());
    return article.copy(id: id);
  }

  Future<List<Article>> searchArticle(String keyword) async {
    final db = await instance.database;
    final maps = await db.query(articleTable,
        columns: ArticleFields.columns,
        where: '${ArticleFields.title} LIKE  \'%?%\' ',
        whereArgs: [keyword]);
    if (maps.isNotEmpty) {
      return maps.map((e) => Article.fromMap(e)).toList();
    } else {
      return [];
    }
  }

  Future<Article> get(int id) async {
    final db = await instance.database;

    final maps = await db.query(articleTable,
        columns: ArticleFields.columns,
        where: '${ArticleFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Article.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(articleTable, where: '${ArticleFields.id} = ?', whereArgs: [id]);
  }

  Future<int> update(Article article) async {
    final db = await instance.database;
    return await db.update(articleTable, article.toMap(),
        where: '${ArticleFields.id} = ?', whereArgs: [article.id]);
  }

  Future close() async {
    final db = await instance.database;
    return db.close();
  }
}
