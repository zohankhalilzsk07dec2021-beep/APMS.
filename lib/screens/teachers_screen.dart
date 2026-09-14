import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/teacher_service.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});
  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  List<Map<String, dynamic>> data = [];
  bool loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => loading = true);
    final r = await TeacherService.all();
    if (mounted) setState(() { data = r; loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(lang.t('teachers')), backgroundColor: const Color(0xFF198754)),
        floatingActionButton: FloatingActionButton(backgroundColor: const Color(0xFF198754),
          onPressed: () async {
            await _showAddDialog(context, lang);
            _load();
          },
          child: const Icon(Icons.add, color: Colors.white)),
        body: loading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
            ? Center(child: Text(lang.t('no_data')))
            : ListView.builder(itemCount: data.length, itemBuilder: (c, i) {
                final t = data[i];
                return Card(margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Color(0xFF198754), child: Icon(Icons.person, color: Colors.white)),
                    title: Text(t['name'] ?? ''),
                    subtitle: Text('${lang.t('subject')}: ${t['subject'] ?? "-"}\n${lang.t('contact')}: ${t['contact'] ?? "-"}'),
                    isThreeLine: true,
                    trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await TeacherService.delete(t['id'] as int);
                        _load();
                      })));
              }),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, LanguageService lang) async {
    final nameC = TextEditingController();
    final cnicC = TextEditingController();
    final subC = TextEditingController();
    final conC = TextEditingController();
    final qualC = TextEditingController();

    await showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(lang.isUrdu ? 'نیا استاد' : 'New Teacher'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        _field(nameC, lang.t('student_name')),
        _field(cnicC, lang.t('cnic')),
        _field(subC, lang.t('subject')),
        _field(conC, lang.t('contact')),
        _field(qualC, lang.t('qualification')),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(lang.t('cancel'))),
        ElevatedButton(onPressed: () async {
          if (nameC.text.trim().isEmpty) return;
          await TeacherService.add(
            name: nameC.text.trim(), cnic: cnicC.text.trim(),
            subject: subC.text.trim(), contact: conC.text.trim(),
            qualification: qualC.text.trim(),
          );
          if (context.mounted) Navigator.pop(context);
        }, child: Text(lang.t('save'))),
      ]));
  }

  Widget _field(TextEditingController c, String label) {
    return Padding(padding: const EdgeInsets.only(bottom: 8),
      child: TextField(controller: c,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true)));
  }
}
