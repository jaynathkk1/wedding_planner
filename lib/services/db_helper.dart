import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';
import '../models/guest.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'wedding_planner.db';
  static const int _databaseVersion = 1;

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        emailOrPhone TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        name TEXT
      )
    ''');

    // Tasks table
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        category TEXT DEFAULT 'General',
        priority TEXT DEFAULT 'Medium',
        completed INTEGER DEFAULT 0,
        dueDate INTEGER,
        notes TEXT
      )
    ''');

    // Venues table (for favorites/custom venues)
    await db.execute('''
      CREATE TABLE venues(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        priceRange TEXT NOT NULL,
        capacity INTEGER NOT NULL,
        rating REAL DEFAULT 4.0,
        amenities TEXT,
        description TEXT,
        imageUrl TEXT
      )
    ''');

    // Guests table
    await db.execute('''
      CREATE TABLE guests(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        rsvpStatus TEXT DEFAULT 'pending',
        category TEXT DEFAULT 'friends'
      )
    ''');

    // Insert default sample data
    await _insertDefaultData(db);
  }

  Future<void> _insertDefaultData(Database db) async {
    // Insert default tasks
    final defaultTasks = [
      Task(title: '🏛️ Book Wedding Venue', category: 'Venue', priority: 'High'),
      Task(title: '📸 Hire Photographer', category: 'Photography', priority: 'High'),
      Task(title: '🍽️ Arrange Catering', category: 'Catering', priority: 'High'),
      Task(title: '🎨 Plan Mehendi Ceremony', category: 'Events', priority: 'Medium'),
      Task(title: '🎵 Finalize Sangeet Program', category: 'Events', priority: 'Medium'),
      Task(title: '✈️ Book Honeymoon Trip', category: 'Travel', priority: 'Low'),
      Task(title: '💍 Buy Wedding Rings', category: 'Shopping', priority: 'High'),
      Task(title: '👗 Wedding Dress Shopping', category: 'Shopping', priority: 'High'),
      Task(title: '💐 Order Flower Decorations', category: 'Decoration', priority: 'Medium'),
      Task(title: '🎂 Order Wedding Cake', category: 'Catering', priority: 'Medium'),
    ];

    for (var task in defaultTasks) {
      await db.insert('tasks', task.toMap());
    }
  }

  // User CRUD operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String emailOrPhone, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'emailOrPhone = ? AND password = ?',
      whereArgs: [emailOrPhone, password],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Task CRUD operations
  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // Guest CRUD operations
  Future<List<Guest>> getGuests() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('guests');
    return maps.map((map) => Guest.fromMap(map)).toList();
  }

  Future<int> insertGuest(Guest guest) async {
    final db = await database;
    return await db.insert('guests', guest.toMap());
  }

  Future<int> updateGuest(Guest guest) async {
    final db = await database;
    return await db.update(
      'guests',
      guest.toMap(),
      where: 'id = ?',
      whereArgs: [guest.id],
    );
  }

  Future<int> deleteGuest(int id) async {
    final db = await database;
    return await db.delete('guests', where: 'id = ?', whereArgs: [id]);
  }
}
