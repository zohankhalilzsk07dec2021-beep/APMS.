import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/student_service.dart';
import '../services/sms_service.dart';

class StudentDetailScreen extends StatefulWidget {
  final int studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  Map<String, dynamic>? s;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final r = await StudentService.byId(widget.studentId);
    if (mounted) setState(() => s = r);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    if (s == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final photo = s!['photoPath'];

    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(lang.isUrdu ? 'تفصیل' : 'Details'),
          backgroundColor: const Color(0xFF198754),
          actions: [
            IconButton(icon: const Icon(Icons.delete),
              onPressed: () async {
                await StudentService.delete(widget.studentId);
                if (mounted) Navigator.pop(context);
              }),
          ]),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Center(child: CircleAvatar(radius: 55, backgroundColor: const Color(0xFF198754),
            backgroundImage: (photo != null && File(photo).existsSync()) ? FileImage(File(photo)) : null,
            child: (photo == null || !File(photo).existsSync()) ? Text('${s!['rollNumber']}', style: const TextStyle(fontSize: 34, color: Colors.white)) : null)),
          const SizedBox(height: 14),
          Center(child: Text(s!['name'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          const Divider(height: 30),
          _row(lang.t('admission_no'), '${s!['admissionNumber']}'),
          _row(lang.t('roll_no'), '${s!['rollNumber']}'),
          _row(lang.t('father_name'), '${s!['fatherName'] ?? "-"}'),
          _row(lang.t('mother_name'), '${s!['motherName'] ?? "-"}'),
          _row(lang.t('parent_contact'), '${s!['parentContact'] ?? "-"}'),
          _row(lang.t('address_lbl'), '${s!['address'] ?? "-"}'),
          const SizedBox(height: 20),
          ElevatedButton.icon(icon: const Icon(Icons.message), label: Text(lang.t('send_sms')),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF198754), padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: () async {
              final phone = s!['parentContact'];
              if (phone == null || phone.toString().isEmpty) return;
              await SmsService.send(phone.toString(), SmsService.absentMessage(s!['name']));
            }),
        ]),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        SizedBox(width: 130, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text(value)),
      ]));
  }
}
