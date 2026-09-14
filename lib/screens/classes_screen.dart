import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/student_service.dart';
import 'students_list_screen.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  Color _c(int n) {
    const colors = [Color(0xFF198754), Color(0xFF0D6EFD), Color(0xFFDC3545), Color(0xFFFFC107), Color(0xFF6F42C1), Color(0xFF20C997), Color(0xFFFD7E14), Color(0xFF0DCAF0), Color(0xFFE83E8C), Color(0xFF6C757D)];
    return colors[(n - 1) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Scaffold(
      appBar: AppBar(title: Text('${lang.t('classes')} (1 - 10)'), backgroundColor: const Color(0xFF198754)),
      body: GridView.builder(padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.05),
        itemCount: 10,
        itemBuilder: (c, i) {
          final n = i + 1;
          return InkWell(borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StudentsListScreen(classNumber: n))),
            child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [_c(n), _c(n).withOpacity(0.7)]), borderRadius: BorderRadius.circular(16)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$n', style: const TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold)),
                Text(lang.isUrdu ? 'کلاس' : 'Class', style: const TextStyle(fontSize: 15, color: Colors.white)),
                const SizedBox(height: 6),
                FutureBuilder<int>(future: StudentService.countByClass(n),
                  builder: (c, s) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                    child: Text('${s.data ?? 0} ${lang.t('students')}', style: const TextStyle(color: Colors.white, fontSize: 11)))),
              ])));
        }),
    );
  }
}
