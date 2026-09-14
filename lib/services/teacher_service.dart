import 'database_service.dart';

class TeacherService {
  static Future<int> add({
    required String name,
    String? cnic,
    String? subject,
    String? contact,
    String? qualification,
    String? photoPath,
  }) async {
    final db = await DatabaseService.database;
    return db.insert('teachers', {
      'name': name,
      'cnic': cnic,
      'subject': subject,
      'contact': contact,
      'qualification': qualification,
      'photoPath': photoPath,
      'joiningDate': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> all() async {
    final db = await DatabaseService.database;
    return db.query('teachers', where: 'status = ?', whereArgs: ['active'], orderBy: 'name');
  }

  static Future<int> count() async {
    final db = await DatabaseService.database;
    final r = await db.rawQuery('SELECT COUNT(*) c FROM teachers WHERE status=?', ['active']);
    return (r.first['c'] as int?) ?? 0;
  }

  static Future<void> delete(int id) async {
    final db = await DatabaseService.database;
    await db.update('teachers', {'status': 'inactive'}, where: 'id = ?', whereArgs: [id]);
  }
}
