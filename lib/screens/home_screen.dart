import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/language_service.dart';
import '../services/student_service.dart';
import '../services/teacher_service.dart';
import 'classes_screen.dart';
import 'students_list_screen.dart';
import 'add_student_screen.dart';
import 'teachers_screen.dart';
import 'attendance_screen.dart';
import 'result_screen.dart';
import 'timetable_screen.dart';
import 'announcements_screen.dart';
import 'sms_screen.dart';
import 'backup_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  const HomeScreen({super.key, required this.userId});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalStudents = 0;
  int totalTeachers = 0;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final s = await StudentService.count();
    final t = await TeacherService.count();
    if (mounted) setState(() { totalStudents = s; totalTeachers = t; });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    final dateStr = DateFormat('dd-MM-yyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: Text(lang.t('dashboard')), backgroundColor: const Color(0xFF198754),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
          IconButton(icon: const Icon(Icons.language), onPressed: () => lang.toggle()),
        ]),
      body: RefreshIndicator(onRefresh: _load, child: ListView(padding: const EdgeInsets.all(12), children: [
        Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF198754), Color(0xFF0F5132)]), borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            const CircleAvatar(radius: 28, backgroundColor: Colors.white24, child: Icon(Icons.school, color: Colors.white, size: 32)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(lang.t('school_name'), style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('📅 $dateStr', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ])),
          ])),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _statCard(Icons.people, '$totalStudents', lang.t('students'), const Color(0xFF0D6EFD))),
          const SizedBox(width: 10),
          Expanded(child: _statCard(Icons.person, '$totalTeachers', lang.t('teachers'), const Color(0xFFFFC107))),
          const SizedBox(width: 10),
          Expanded(child: _statCard(Icons.class_, '10', lang.t('classes'), const Color(0xFF198754))),
        ]),
        const SizedBox(height: 20),
        _menuGrid(context, lang),
        const SizedBox(height: 24),
        Center(child: Text('© 2025 Ali Public Model School\nBasti Naho Wala, Nawan', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 11))),
      ])),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Container(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.4))),
      child: Column(children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
      ]));
  }

  Widget _menuGrid(BuildContext context, LanguageService lang) {
    final items = <_MI>[
      _MI(lang.t('classes'), Icons.class_, const Color(0xFF198754), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassesScreen()))),
      _MI(lang.t('students'), Icons.people, const Color(0xFF0D6EFD), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentsListScreen()))),
      _MI(lang.t('admission'), Icons.person_add, const Color(0xFF20C997), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddStudentScreen())).then((_) => _load())),
      _MI(lang.t('teachers'), Icons.person, const Color(0xFFFFC107), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeachersScreen()))),
      _MI(lang.t('attendance'), Icons.check_circle, const Color(0xFFDC3545), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()))),
      _MI(lang.t('result'), Icons.assignment, const Color(0xFF6F42C1), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultScreen()))),
      _MI(lang.t('timetable'), Icons.schedule, const Color(0xFFFD7E14), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimetableScreen()))),
      _MI(lang.t('announcements'), Icons.campaign, const Color(0xFF0DCAF0), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementsScreen()))),
      _MI(lang.t('sms'), Icons.message, const Color(0xFF198754), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SmsScreen()))),
      _MI(lang.t('backup'), Icons.backup, const Color(0xFF6C757D), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BackupScreen()))),
    ];
    return GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.85),
      itemCount: items.length,
      itemBuilder: (c, i) {
        final it = items[i];
        return InkWell(borderRadius: BorderRadius.circular(12), onTap: it.onTap, child: Column(children: [
          Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: it.color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)), child: Icon(it.icon, color: it.color, size: 26)),
          const SizedBox(height: 5),
          Text(it.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5)),
        ]));
      });
  }
}

class _MI {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _MI(this.title, this.icon, this.color, this.onTap);
}
