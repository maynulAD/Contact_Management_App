import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'contact_management.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        address TEXT NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final result = await db.query(
      'contacts',
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return result.map(Contact.fromMap).toList();
  }

  Future<List<Contact>> searchContacts(String query) async {
    final db = await database;
    final result = await db.query(
      'contacts',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return result.map(Contact.fromMap).toList();
  }

  Future<List<Contact>> getFavoriteContacts() async {
    final db = await database;
    final result = await db.query(
      'contacts',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return result.map(Contact.fromMap).toList();
  }

  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return db.insert('contacts', contact.toMap());
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> toggleFavorite(Contact contact) async {
    final db = await database;
    return db.update(
      'contacts',
      {'isFavorite': contact.isFavorite ? 0 : 1},
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }
}
