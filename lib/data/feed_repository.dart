import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/article.dart';
import '../model/feed.dart';

class FeedRepository {
  static Database? _database;

  static final FeedRepository instance = FeedRepository._init();

  FeedRepository._init();

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
       )
    ''');
    await db.execute('''
    CREATE TABLE $articleTable (
      ${ArticleFields.id} $idType,
      ${ArticleFields.publisher} $textType,
      ${ArticleFields.title} $textType,
      ${ArticleFields.content} $textType,
      ${ArticleFields.link} $textType,
      ${ArticleFields.image} $textType,
      ${ArticleFields.pubDate} $textType
      )
    ''');
  }

  Future<List<Feed>> getAll() async {
    final db = await instance.database;
    final maps = await db.query(feedTable, columns: FeedFields.columns);
    return maps.map((record) => Feed.fromMap(record)).toList();
  }

  Future<Feed> insert(Feed feed) async {
    final db = await instance.database;
    final id = await db.insert(feedTable, feed.toMap());
    return feed.copy(id: id);
  }

  Future<Feed> get(int id) async {
    final db = await instance.database;

    final maps = await db.query(feedTable,
        columns: FeedFields.columns,
        where: '${FeedFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Feed.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(feedTable, where: '${FeedFields.id} = ?', whereArgs: [id]);
  }

  Future<int> update(Feed feed) async {
    final db = await instance.database;
    return await db.update(feedTable, feed.toMap(),
        where: '${FeedFields.id} = ?', whereArgs: [feed.id]);
  }

  Future close() async {
    final db = await instance.database;
    return db.close();
  }
}
