import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/database_service.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});
  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  int classNumber = 1;
  List<Map<String, dynamic>> data = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final db = await DatabaseService.database;
    final r = await db.query('timetable', where: 'classNumber = ?', whereArgs: [classNumber], orderBy: 'periodNumber');
    setState(() => data = r);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(lang.t('timetable')), backgroundColor: const Color(0xFF198754)),
        body: Column(children: [
          Padding(padding: const EdgeInsets.all(10),
            child: DropdownButton<int>(value: classNumber,
              items: List.generate(10, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
              onChanged: (v) { setState(() => classNumber = v!); _load(); })),
          Expanded(child: data.isEmpty
            ? Center(child: Text(lang.isUrdu ? 'ابھی ٹائم ٹیبل شامل نہیں کیا گیا' : 'No timetable yet'))
            : ListView.builder(itemCount: data.length, itemBuilder: (c, i) {
                final t = data[i];
                return Card(margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: const Color(0xFF198754),
                      child: Text('${t['periodNumber']}', style: const TextStyle(color: Colors.white))),
                    title: Text(t['subject'] ?? ''),
                    subtitle: Text('${t['startTime'] ?? ""} - ${t['endTime'] ?? ""}'),
                  ));
              })),
        ]),
      ),
    );
  }
}
