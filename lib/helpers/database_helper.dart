import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('warnet.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabel Pengguna untuk Login
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Tabel Rental PC untuk CRUD
    await db.execute('''
      CREATE TABLE rentals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        nomor_pc TEXT NOT NULL,
        durasi INTEGER NOT NULL,
        total INTEGER NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    // Akun default
    await db.insert('users', {
      'username': 'admin',
      'password': 'admin123',
    });

    // Data sewa awal
    await db.insert('rentals', {
      'nama': 'Dimas',
      'nomor_pc': 'PC-01',
      'durasi': 3,
      'total': 21000,
      'status': 'Aktif',
    });
    await db.insert('rentals', {
      'nama': 'Budi',
      'nomor_pc': 'PC-02',
      'durasi': 2,
      'total': 8000,
      'status': 'Selesai',
    });
  }

  // Login
  Future<bool> login(String username, String password) async {
    final db = await instance.database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return res.isNotEmpty;
  }

  // CRUD Rentals
  Future<List<Map<String, dynamic>>> getRentals() async {
    final db = await instance.database;
    return await db.query('rentals', orderBy: 'id DESC');
  }

  Future<int> insertRental(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('rentals', row);
  }

  Future<int> updateRental(int id, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update('rentals', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteRental(int id) async {
    final db = await instance.database;
    return await db.delete('rentals', where: 'id = ?', whereArgs: [id]);
  }
}
