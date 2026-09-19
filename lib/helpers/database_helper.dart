import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tarif_warnet.dart';

/// Kolom `tipe_pc` menyimpan nama enum [TipePc] (mis. 'reguler'/'vip') supaya
/// tarif yang dipakai CRUD selalu berasal dari sumber yang sama dengan
/// layar Komputasi — bukan angka hardcode terpisah.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const int _dbVersion = 4;

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
      version: _dbVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
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

    await db.insert('users', {
      'username': 'admin',
      'password': 'admin123',
    });

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
      // Baris lama dianggap tarif Reguler; total lama dibiarkan apa adanya
      // (data historis), yang berubah cuma baris baru ke depannya.
      await db.execute(
        "ALTER TABLE rentals ADD COLUMN tipe_pc TEXT NOT NULL DEFAULT '${TipePc.reguler.name}'",
      );
    }
    if (oldVersion < 3) {
      // Baris lama (belum ada kolom tanggal) dianggap terjadi hari ini,
      // supaya nggak melanggar NOT NULL. Data historis tetap terekam,
      // cuma tanggalnya jadi tanggal migrasi berjalan.
      final hariIni = DateTime.now().toIso8601String().substring(0, 10);
      await db.execute(
        "ALTER TABLE rentals ADD COLUMN tanggal TEXT NOT NULL DEFAULT '$hariIni'",
      );
    }
    if (oldVersion < 4) {
      // Baris lama dianggap mulai jam 00:00 — nggak presisi buat data
      // historis, tapi baris baru ke depannya sudah tercatat jam mulainya
      // beneran, jadi cek bentrok jadi akurat per jam mulai saat ini.
      await db.execute(
        "ALTER TABLE rentals ADD COLUMN jam_mulai TEXT NOT NULL DEFAULT '00:00'",
      );
    }
  }

  /// Login. Melempar [DatabaseException] apa adanya ke pemanggil supaya UI
  /// yang memutuskan pesan error yang ditampilkan ke user.
  Future<bool> login(String username, String password) async {
    final db = await instance.database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return res.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getRentals() async {
    final db = await instance.database;
    return db.query('rentals', orderBy: 'id DESC');
  }

  Future<int> insertRental(Map<String, dynamic> row) async {
    final db = await instance.database;
    return db.insert('rentals', row);
  }

  Future<int> updateRental(int id, Map<String, dynamic> row) async {
    final db = await instance.database;
    return db.update('rentals', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteRental(int id) async {
    final db = await instance.database;
    return db.delete('rentals', where: 'id = ?', whereArgs: [id]);
  }

  /// Cek apakah PC yang sama (nomor + tipe) sudah dipakai di RENTANG JAM
  /// yang bertabrakan pada tanggal yang sama. `excludeId` dipakai waktu
  /// edit, supaya baris yang sedang diedit tidak bentrok dengan dirinya
  /// sendiri.
  ///
  /// Batasan yang disengaja: sesi wajib mulai & selesai di hari kalender
  /// yang sama (tidak boleh nyebrang tengah malam) — makanya cek overlap
  /// cukup dibandingkan dengan baris-baris di tanggal yang sama saja,
  /// tidak perlu lihat tanggal sebelum/sesudahnya.
  Future<bool> adaBentrokJadwal({
    required String nomorPc,
    required String tipePc,
    required String tanggal,
    required int jamMulaiMenit,
    required int durasiJam,
    int? excludeId,
  }) async {
    final db = await instance.database;
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
      final jamMulaiLama = _menitDariString(row['jam_mulai'] as String);
      final durasiLama = row['durasi'] as int;
      final mulaiLama = jamMulaiLama;
      final selesaiLama = jamMulaiLama + durasiLama * 60;

      // Dua rentang waktu dianggap bertabrakan kalau salah satu mulai
      // sebelum yang lain selesai, dua-duanya (overlap interval klasik).
      final overlap = mulaiBaru < selesaiLama && mulaiLama < selesaiBaru;
      if (overlap) return true;
    }
    return false;
  }

  static int _menitDariString(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
