import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/student_service.dart';
import 'add_student_screen.dart';
import 'student_detail_screen.dart';

class StudentsListScreen extends StatefulWidget {
  final int? classNumber;
  const StudentsListScreen({super.key, this.classNumber});
  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filtered = [];
  bool loading = true;
  final _search = TextEditingController();

  @override
  void initState() { super.initState(); _load(); _search.addListener(_filter); }

  Future<void> _load() async {
    setState(() => loading = true);
    final r = widget.classNumber != null ? await StudentService.byClass(widget.classNumber!) : await StudentService.all();
    if (mounted) setState(() { data = r; filtered = r; loading = false; });
  }

  void _filter() {
    final q = _search.text.toLowerCase();
    setState(() {
      filtered = data.where((s) => (s['name'] ?? '').toString().toLowerCase().contains(q) || (s['admissionNumber'] ?? '').toString().toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.classNumber != null ? '${lang.t('class')} ${widget.classNumber}' : lang.t('students')), backgroundColor: const Color(0xFF198754)),
      floatingActionButton: FloatingActionButton(backgroundColor: const Color(0xFF198754),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddStudentScreen()));
          _load();
        },
        child: const Icon(Icons.add, color: Colors.white)),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(10),
          child: TextField(controller: _search,
            decoration: InputDecoration(hintText: lang.t('search'), prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), isDense: true))),
        Expanded(child: loading
          ? const Center(child: CircularProgressIndicator())
          : filtered.isEmpty
            ? Center(child: Text(lang.t('no_data')))
            : ListView.builder(itemCount: filtered.length, itemBuilder: (c, i) {
                final s = filtered[i];
                final photo = s['photoPath'];
                return Card(margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: const Color(0xFF198754),
                      backgroundImage: (photo != null && File(photo).existsSync()) ? FileImage(File(photo)) : null,
                      child: (photo == null || !File(photo).existsSync()) ? Text('${s['rollNumber']}', style: const TextStyle(color: Colors.white)) : null),
                    title: Text(s['name'] ?? ''),
                    subtitle: Text('${lang.t('admission_no')}: ${s['admissionNumber']}\n${lang.t('father_name')}: ${s['fatherName'] ?? ""}'),
                    isThreeLine: true,
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => StudentDetailScreen(studentId: s['id'] as int)));
                      _load();
                    }));
              })),
      ]),
    );
  }
}
