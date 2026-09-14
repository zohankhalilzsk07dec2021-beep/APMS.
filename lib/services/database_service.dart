import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseService {
  static Database? _db;
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'apms.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int v) async {
    await db.execute('CREATE TABLE students (id INTEGER PRIMARY KEY AUTOINCREMENT, admissionNumber TEXT UNIQUE NOT NULL, rollNumber INTEGER NOT NULL, name TEXT NOT NULL, fatherName TEXT, motherName TEXT, parentContact TEXT, address TEXT, classNumber INTEGER NOT NULL, section TEXT DEFAULT "A", photoPath TEXT, admissionDate TEXT, status TEXT DEFAULT "active")');
    await db.execute('CREATE TABLE teachers (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, cnic TEXT, subject TEXT, contact TEXT, qualification TEXT, photoPath TEXT, joiningDate TEXT, status TEXT DEFAULT "active")');
    await db.execute('CREATE TABLE attendance (id INTEGER PRIMARY KEY AUTOINCREMENT, studentId INTEGER NOT NULL, date TEXT NOT NULL, status TEXT NOT NULL, verified INTEGER DEFAULT 0, UNIQUE(studentId, date))');
    await db.execute('CREATE TABLE results (id INTEGER PRIMARY KEY AUTOINCREMENT, studentId INTEGER NOT NULL, examName TEXT NOT NULL, subject TEXT NOT NULL, totalMarks INTEGER, obtainedMarks INTEGER)');
    await db.execute('CREATE TABLE timetable (id INTEGER PRIMARY KEY AUTOINCREMENT, classNumber INTEGER, day TEXT, periodNumber INTEGER, subject TEXT, startTime TEXT, endTime TEXT)');
    await db.execute('CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE NOT NULL, passwordHash TEXT NOT NULL, role TEXT NOT NULL)');
    await db.execute('CREATE TABLE counters (name TEXT PRIMARY KEY, value INTEGER NOT NULL)');
    await db.execute('CREATE TABLE announcements (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, body TEXT, date TEXT)');

    await db.insert('users', {'username': 'admin', 'passwordHash': _hash('admin123'), 'role': 'admin'});
    await db.insert('counters', {'name': 'admission', 'value': 0});
    for (int i = 1; i <= 10; i++) {
      await db.insert('counters', {'name': 'roll_$i', 'value': 0});
    }
  }

  static String _hash(String s) => sha256.convert(utf8.encode(s)).toString();

  static Future<int> nextCounter(String name) async {
    final db = await database;
    final r = await db.query('counters', where: 'name = ?', whereArgs: [name]);
    final next = (r.first['value'] as int) + 1;
    await db.update('counters', {'value': next}, where: 'name = ?', whereArgs: [name]);
    return next;
  }

  static Future<String> generateAdmissionNumber() async {
    final n = await nextCounter('admission');
    return 'APMS-${DateTime.now().year}-${n.toString().padLeft(4, '0')}';
  }

  static Future<int> generateRollNumber(int c) async => nextCounter('roll_$c');

  static Future<Map<String, dynamic>?> login(String u, String p) async {
    final db = await database;
    final r = await db.query('users', where: 'username = ? AND passwordHash = ?', whereArgs: [u, _hash(p)]);
    return r.isNotEmpty ? r.first : null;
  }

  static Future<bool> changePassword(int userId, String oldP, String newP) async {
    final db = await database;
    final r = await db.query('users', where: 'id = ? AND passwordHash = ?', whereArgs: [userId, _hash(oldP)]);
    if (r.isEmpty) return false;
    await db.update('users', {'passwordHash': _hash(newP)}, where: 'id = ?', whereArgs: [userId]);
    return true;
  }

  static Future<String> getDbPath() async => join(await getDatabasesPath(), 'apms.db');
}
