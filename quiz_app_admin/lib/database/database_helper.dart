import 'dart:io'; // detect platform (Windows/Linux/Android)
import 'package:path/path.dart'; // Import path package
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // SQLite for all platforms
import '../models/question.dart';
import '../models/result.dart'; // Import the new Result model

// This class handles all the database operations like creating, reading, updating, and deleting.
class DatabaseHelper {
  // Creating a single instance (Singleton) of DatabaseHelper to be used throughout the app.
  // Singleton = only ONE object of this class ever exists
  // No matter how many times you call it — same object, same database
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Getter to provide the database instance.
  Future<Database> get database async {
    if (_database != null) return _database!;

    // DESKTOP SETUP: Windows and Linux need a special 'Factory' to work.
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit(); // initialize FFI bridge
      databaseFactory = databaseFactoryFfi; // use FFI mode
    }

    _database = await _initDB('quiz_database.db');
    return _database!;
  }

  // Initialize the database and define where to store it.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3, // Increased version to 3 to apply the table structure change
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Define the structure of the database tables.
  Future _createDB(Database db, int version) async {
    // Create Questions table
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        option1 TEXT NOT NULL,
        option2 TEXT NOT NULL,
        option3 TEXT NOT NULL,
        option4 TEXT NOT NULL,
        answer TEXT NOT NULL
      )
    ''');

    // Create Results table with studentId as a TEXT Primary Key (Manually entered)
    await db.execute('''
      CREATE TABLE results (
        studentId TEXT PRIMARY KEY,
        studentName TEXT NOT NULL,
        score INTEGER NOT NULL,
        total INTEGER NOT NULL,
        accuracy REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  // Handle updates to the database structure
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // If we are upgrading from version 1 or 2, we need to change the 'results' table.
      await db.execute('DROP TABLE IF EXISTS results');

      // Recreate the table
      await db.execute('''
        CREATE TABLE results (
          studentId TEXT PRIMARY KEY,
          studentName TEXT NOT NULL,
          score INTEGER NOT NULL,
          total INTEGER NOT NULL,
          accuracy REAL NOT NULL,
          date TEXT NOT NULL
        )
      ''');
    }
  }

  // --- QUESTION METHODS ---
  Future<int> createQuestion(Question question) async {
    final db = await instance.database;
    return await db.insert('questions', question.toMap());
  }

  Future<List<Question>> readAllQuestions() async {
    final db = await instance.database;
    final result = await db.query('questions');
    return result.map((json) => Question.fromMap(json)).toList();
  }

  Future<int> updateQuestion(Question question) async {
    final db = await instance.database;
    return await db.update(
      'questions',
      question.toMap(),
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  Future<int> deleteQuestion(int id) async {
    final db = await instance.database;
    return await db.delete('questions', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all questions from the table
  Future<int> deleteAllQuestions() async {
    final db = await instance.database;
    return await db.delete('questions');
  }

  // --- RESULT METHODS ---
  // Save a student's score
  Future<int> createResult(QuizResult result) async {
    final db = await instance.database;
    // We use conflictAlgorithm: ConflictAlgorithm.replace so if a student
    // plays again with the same ID, it updates their previous score.
    return await db.insert(
      'results',
      result.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all scores for the Admin to see
  Future<List<QuizResult>> readAllResults() async {
    final db = await instance.database;
    final result = await db.query(
      'results',
      orderBy: 'date DESC',
    ); // Show newest first
    return result.map((json) => QuizResult.fromMap(json)).toList();
  }

  Future<int> deleteResult(String studentId) async {
    final db = await instance.database;
    return await db.delete(
      'results',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );
  }

  // Delete all results from the table
  Future<int> deleteAllResults() async {
    final db = await instance.database;
    return await db.delete('results');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}