import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/language_service.dart';
import '../services/attendance_service.dart';
import '../services/sms_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  int classNumber = 1;
  final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<Map<String, dynamic>> list = [];
  bool loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => loading = true);
    final r = await AttendanceService.byDateClass(today, classNumber);
    if (mounted) setState(() { list = r; loading = false; });
  }

  Future<void> _mark(int id, String status) async {
    await AttendanceService.mark(studentId: id, date: today, status: status, verified: status == 'present' ? 1 : 0);
    _load();
  }

  Future<void> _smsAbsentees() async {
    for (var s in list) {
      if (s['status'] == 'absent') {
        final phone = s['parentContact']?.toString() ?? '';
        if (phone.isNotEmpty) {
          await SmsService.send(phone, SmsService.absentMessage(s['name']));
        }
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SMS بھیج دیے گئے')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(lang.t('attendance')), backgroundColor: const Color(0xFF198754),
          actions: [
            IconButton(icon: const Icon(Icons.message), onPressed: _smsAbsentees),
          ]),
        body: Column(children: [
          Padding(padding: const EdgeInsets.all(10),
            child: Row(children: [
              Text('${lang.t('class')}: '),
              DropdownButton<int>(value: classNumber,
                items: List.generate(10, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
                onChanged: (v) { setState(() => classNumber = v!); _load(); }),
              const Spacer(),
              Text(today, style: const TextStyle(fontWeight: FontWeight.bold)),
            ])),
          Expanded(child: loading
            ? const Center(child: CircularProgressIndicator())
            : list.isEmpty
              ? Center(child: Text(lang.t('no_data')))
              : ListView.builder(itemCount: list.length, itemBuilder: (c, i) {
                  final s = list[i];
                  final status = s['status'];
                  return Card(margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: const Color(0xFF198754),
                        child: Text('${s['rollNumber']}', style: const TextStyle(color: Colors.white))),
                      title: Text(s['name'] ?? ''),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        _chip(label: 'حاضر', color: Colors.green, selected: status == 'present', onTap: () => _mark(s['id'] as int, 'present')),
                        const SizedBox(width: 6),
                        _chip(label: 'غیر حاضر', color: Colors.red, selected: status == 'absent', onTap: () => _mark(s['id'] as int, 'absent')),
                      ]),
                    ));
                })),
        ]),
      ),
    );
  }

  Widget _chip({required String label, required Color color, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(onTap: onTap,
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: selected ? color : color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : color, fontSize: 12, fontWeight: FontWeight.bold))));
  }
}
