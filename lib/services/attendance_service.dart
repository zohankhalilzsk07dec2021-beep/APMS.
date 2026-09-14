import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class AttendanceService {
  static Future<void> mark({
    required int studentId,
    required String date,
    required String status,
    int verified = 0,
  }) async {
    final db = await DatabaseService.database;
    await db.insert(
      'attendance',
      {
        'studentId': studentId,
        'date': date,
        'status': status,
        'verified': verified,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> byDateClass(
      String date, int classNumber) async {
    final db = await DatabaseService.database;
    return db.rawQuery('''
      SELECT s.id, s.name, s.rollNumber, s.parentContact,
             IFNULL(a.status, "absent") AS status,
             IFNULL(a.verified, 0) AS verified
      FROM students s
      LEFT JOIN attendance a ON a.studentId = s.id AND a.date = ?
      WHERE s.classNumber = ? AND s.status = "active"
      ORDER BY s.rollNumber ASC
    ''', [date, classNumber]);
  }
}
