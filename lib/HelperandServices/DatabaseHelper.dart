import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../dataModel/transaction.dart' as model; // Make sure the model.Transaction class is imported

class DatabaseHelper {
  static const _databaseName = "transactions.db";
  static const _databaseVersion = 1;
  static const table = 'transactions';

  // Column names
  static const columnDateTime = 'dateTime';
  static const columnName = 'name';
  static const columnAmount = 'amount';
  static const columnDescription = 'description';
  static const columnDeducted = 'deducted';

  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper.init();

  // SQLite database reference
  static Database? _database;

  // Private constructor
  DatabaseHelper.init();


  // Open the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Create the table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table(
      $columnDateTime TEXT PRIMARY KEY,
      $columnName TEXT,
      $columnAmount INTEGER,
      $columnDescription TEXT,
      $columnDeducted INTEGER
    )
    ''');
  }

  // Insert a transaction
  Future<void> insertTransaction(model.Transaction transaction) async {
    Database db = await instance.database;
    await db.insert(
      table,
      transaction.toJsonMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if dateTime exists
    );
  }

  // Get all transactions
  Future<List<model.Transaction>> getAllTransactions() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return model.Transaction.fromJsonMap(maps[i]);
    });
  }

  // Find a transaction by DateTime
  Future<model.Transaction?> getTransactionByDateTime(DateTime dateTime) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnDateTime = ?',
      whereArgs: [dateTime.toIso8601String()],
    );

    if (maps.isNotEmpty) {
      return model.Transaction.fromJsonMap(maps.first);
    } else {
      return null;
    }
  }

  // Update a transaction
  Future<int> updateTransaction(model.Transaction transaction) async {
    Database db = await instance.database;
    return await db.update(
      table,
      transaction.toJsonMap(),
      where: '$columnDateTime = ?',
      whereArgs: [transaction.dateTime.toIso8601String()],
    );
  }

  // Delete a transaction
  Future<int> deleteTransaction(DateTime dateTime) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnDateTime = ?',
      whereArgs: [dateTime.toIso8601String()],
    );
  }

  // Close the database
  Future close() async {
    Database db = await instance.database;
    db.close();
  }
}
