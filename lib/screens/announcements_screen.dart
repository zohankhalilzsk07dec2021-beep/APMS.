import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/language_service.dart';
import '../services/database_service.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});
  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final db = await DatabaseService.database;
    final r = await db.query('announcements', orderBy: 'date DESC');
    setState(() => data = r);
  }

  Future<void> _add() async {
    final titleC = TextEditingController();
    final bodyC = TextEditingController();
    final lang = context.read<LanguageService>();
    await showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(lang.isUrdu ? 'نیا اعلان' : 'New Announcement'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: titleC,
          decoration: const InputDecoration(labelText: 'عنوان', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: bodyC, maxLines: 4,
          decoration: const InputDecoration(labelText: 'تفصیل', border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(lang.t('cancel'))),
        ElevatedButton(onPressed: () async {
          if (titleC.text.trim().isEmpty) return;
          final db = await DatabaseService.database;
          await db.insert('announcements', {
            'title': titleC.text.trim(),
            'body': bodyC.text.trim(),
            'date': DateTime.now().toIso8601String(),
          });
          if (mounted) Navigator.pop(context);
          _load();
        }, child: Text(lang.t('save'))),
      ]));
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(lang.t('announcements')), backgroundColor: const Color(0xFF198754)),
        floatingActionButton: FloatingActionButton(backgroundColor: const Color(0xFF198754),
          onPressed: _add, child: const Icon(Icons.add, color: Colors.white)),
        body: data.isEmpty
          ? Center(child: Text(lang.t('no_data')))
          : ListView.builder(itemCount: data.length, itemBuilder: (c, i) {
              final a = data[i];
              final date = DateTime.tryParse(a['date'] ?? '');
              return Card(margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.campaign, color: Color(0xFF198754)),
                  title: Text(a['title'] ?? ''),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a['body'] ?? ''),
                    if (date != null)
                      Text(DateFormat('dd-MM-yyyy').format(date), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ]),
                ));
            }),
      ),
    );
  }
}
