import 'database_service.dart';

class StudentService {
  static Future<int> add({
    required String name, required String fatherName, required String motherName,
    required String parentContact, required String address,
    required int classNumber, required String section, String? photoPath,
  }) async {
    final db = await DatabaseService.database;
    final adm = await DatabaseService.generateAdmissionNumber();
    final roll = await DatabaseService.generateRollNumber(classNumber);
    return db.insert('students', {
      'admissionNumber': adm, 'rollNumber': roll, 'name': name,
      'fatherName': fatherName, 'motherName': motherName,
      'parentContact': parentContact, 'address': address,
      'classNumber': classNumber, 'section': section, 'photoPath': photoPath,
      'admissionDate': DateTime.now().toIso8601String(), 'status': 'active',
    });
  }

  static Future<List<Map<String, dynamic>>> byClass(int c) async {
    final db = await DatabaseService.database;
    return db.query('students', where: 'classNumber = ? AND status = ?', whereArgs: [c, 'active'], orderBy: 'rollNumber ASC');
  }

  static Future<List<Map<String, dynamic>>> all() async {
    final db = await DatabaseService.database;
    return db.query('students', where: 'status = ?', whereArgs: ['active'], orderBy: 'classNumber ASC, rollNumber ASC');
  }

  static Future<Map<String, dynamic>?> byId(int id) async {
    final db = await DatabaseService.database;
    final r = await db.query('students', where: 'id = ?', whereArgs: [id]);
    return r.isNotEmpty ? r.first : null;
  }

  static Future<int> count() async {
    final db = await DatabaseService.database;
    final r = await db.rawQuery('SELECT COUNT(*) c FROM students WHERE status=?', ['active']);
    return (r.first['c'] as int?) ?? 0;
  }

  static Future<int> countByClass(int c) async {
    final db = await DatabaseService.database;
    final r = await db.rawQuery('SELECT COUNT(*) c FROM students WHERE classNumber=? AND status=?', [c, 'active']);
    return (r.first['c'] as int?) ?? 0;
  }

  static Future<void> delete(int id) async {
    final db = await DatabaseService.database;
    await db.update('students', {'status': 'inactive'}, where: 'id = ?', whereArgs: [id]);
  }
}
