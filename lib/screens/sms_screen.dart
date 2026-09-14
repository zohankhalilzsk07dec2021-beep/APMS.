import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/student_service.dart';
import '../services/sms_service.dart';

class SmsScreen extends StatefulWidget {
  const SmsScreen({super.key});
  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  int classNumber = 1;
  List<Map<String, dynamic>> students = [];
  final _msg = TextEditingController();

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final r = await StudentService.byClass(classNumber);
    setState(() {
      students = r;
      _msg.text = SmsService.absentMessage('____');
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(lang.t('sms')), backgroundColor: const Color(0xFF198754)),
        body: Column(children: [
          Padding(padding: const EdgeInsets.all(10),
            child: DropdownButton<int>(value: classNumber,
              items: List.generate(10, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
              onChanged: (v) { setState(() => classNumber = v!); _load(); })),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(controller: _msg, maxLines: 3,
              decoration: const InputDecoration(labelText: 'پیغام', border: OutlineInputBorder()))),
          const SizedBox(height: 10),
          Expanded(child: students.isEmpty
            ? Center(child: Text(lang.t('no_data')))
            : ListView.builder(itemCount: students.length, itemBuilder: (c, i) {
                final s = students[i];
                return Card(margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: const Color(0xFF198754),
                      child: Text('${s['rollNumber']}', style: const TextStyle(color: Colors.white))),
                    title: Text(s['name'] ?? ''),
                    subtitle: Text(s['parentContact'] ?? '-'),
                    trailing: IconButton(icon: const Icon(Icons.send, color: Color(0xFF198754)),
                      onPressed: () async {
                        final phone = s['parentContact']?.toString() ?? '';
                        if (phone.isEmpty) return;
                        final msg = _msg.text.replaceAll('____', s['name'] ?? '');
                        await SmsService.send(phone, msg);
                      }),
                  ));
              })),
        ]),
      ),
    );
  }
}
