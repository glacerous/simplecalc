import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tarif_warnet.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const int _dbVersion = 4;

  DatabaseHelper._init();

  Future<Database> get database async => _database ??= await _initDB('warnet.db');

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);
    return openDatabase(path, version: _dbVersion, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE rentals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        nomor_pc TEXT NOT NULL,
        tipe_pc TEXT NOT NULL DEFAULT 'reguler',
        tanggal TEXT NOT NULL,
        jam_mulai TEXT NOT NULL DEFAULT '00:00',
        durasi INTEGER NOT NULL,
        total INTEGER NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    final hariIni = DateTime.now().toIso8601String().substring(0, 10);
    await db.insert('users', {'username': 'admin', 'password': 'admin123'});
    await db.insert('rentals', {
      'nama': 'Dimas',
      'nomor_pc': 'PC-01',
      'tipe_pc': TipePc.reguler.name,
      'tanggal': hariIni,
      'jam_mulai': '10:00',
      'durasi': 3,
      'total': TipePc.hitungTotal(tipe: TipePc.reguler, durasiJam: 3),
      'status': 'Aktif',
    });
    await db.insert('rentals', {
      'nama': 'Budi',
      'nomor_pc': 'PC-02',
      'tipe_pc': TipePc.vip.name,
      'tanggal': hariIni,
      'jam_mulai': '14:00',
      'durasi': 2,
      'total': TipePc.hitungTotal(tipe: TipePc.vip, durasiJam: 2),
      'status': 'Selesai',
    });
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE rentals ADD COLUMN tipe_pc TEXT NOT NULL DEFAULT '${TipePc.reguler.name}'");
    }
    if (oldVersion < 3) {
      final hariIni = DateTime.now().toIso8601String().substring(0, 10);
      await db.execute("ALTER TABLE rentals ADD COLUMN tanggal TEXT NOT NULL DEFAULT '$hariIni'");
    }
    if (oldVersion < 4) {
      await db.execute("ALTER TABLE rentals ADD COLUMN jam_mulai TEXT NOT NULL DEFAULT '00:00'");
    }
  }

  Future<bool> login(String username, String password) async {
    final db = await database;
    final res = await db.query('users', where: 'username = ? AND password = ?', whereArgs: [username, password]);
    return res.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getRentals() async {
    final db = await database;
    return db.query('rentals', orderBy: 'id DESC');
  }

  Future<int> insertRental(Map<String, dynamic> row) async {
    final db = await database;
    return db.insert('rentals', row);
  }

  Future<int> updateRental(int id, Map<String, dynamic> row) async {
    final db = await database;
    return db.update('rentals', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteRental(int id) async {
    final db = await database;
    return db.delete('rentals', where: 'id = ?', whereArgs: [id]);
  }

  /// Cek bentrok jam pemakaian PC pada tanggal yang sama
  Future<bool> adaBentrokJadwal({
    required String nomorPc,
    required String tipePc,
    required String tanggal,
    required int jamMulaiMenit,
    required int durasiJam,
    int? excludeId,
  }) async {
    final db = await database;
    final where = StringBuffer('nomor_pc = ? AND tipe_pc = ? AND tanggal = ?');
    final args = <Object?>[nomorPc, tipePc, tanggal];
    if (excludeId != null) {
      where.write(' AND id != ?');
      args.add(excludeId);
    }
    final kandidat = await db.query('rentals', where: where.toString(), whereArgs: args);

    final mulaiBaru = jamMulaiMenit;
    final selesaiBaru = jamMulaiMenit + durasiJam * 60;

    for (final row in kandidat) {
      final parts = (row['jam_mulai'] as String).split(':');
      final mulaiLama = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      final selesaiLama = mulaiLama + (row['durasi'] as int) * 60;

      if (mulaiBaru < selesaiLama && mulaiLama < selesaiBaru) return true;
    }
    return false;
  }
}
