import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../services/language_service.dart';
import '../services/database_service.dart';
import '../services/student_service.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int classNumber = 1;
  List<Map<String, dynamic>> students = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final r = await StudentService.byClass(classNumber);
    setState(() => students = r);
  }

  Future<void> _generatePdf(Map<String, dynamic> s) async {
    final db = await DatabaseService.database;
    final results = await db.query('results', where: 'studentId = ?', whereArgs: [s['id']]);

    final doc = pw.Document();
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (ctx) => pw.Padding(
        padding: const pw.EdgeInsets.all(24),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Center(child: pw.Text('Ali Public Model School', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold))),
          pw.Center(child: pw.Text('Basti Naho Wala, Nawan', style: const pw.TextStyle(fontSize: 12))),
          pw.Divider(),
          pw.Text('Name: ${s['name']}'),
          pw.Text('Admission No: ${s['admissionNumber']}'),
          pw.Text('Roll No: ${s['rollNumber']}'),
          pw.SizedBox(height: 14),
          pw.TableHelper.fromTextArray(
            headers: ['Subject', 'Total', 'Obtained'],
            data: results.map((r) => [r['subject'].toString(), r['totalMarks'].toString(), r['obtainedMarks'].toString()]).toList(),
          ),
          pw.Spacer(),
          pw.Center(child: pw.Text('© 2025 Ali Public Model School', style: const pw.TextStyle(fontSize: 10))),
        ]),
      ),
    ));
    await Printing.layoutPdf(onLayout: (f) => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(lang.t('result')), backgroundColor: const Color(0xFF198754)),
        body: Column(children: [
          Padding(padding: const EdgeInsets.all(10),
            child: Row(children: [
              Text('${lang.t('class')}: '),
              DropdownButton<int>(value: classNumber,
                items: List.generate(10, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
                onChanged: (v) { setState(() => classNumber = v!); _load(); }),
            ])),
          Expanded(child: students.isEmpty
            ? Center(child: Text(lang.t('no_data')))
            : ListView.builder(itemCount: students.length, itemBuilder: (c, i) {
                final s = students[i];
                return Card(margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: const Color(0xFF198754),
                      child: Text('${s['rollNumber']}', style: const TextStyle(color: Colors.white))),
                    title: Text(s['name'] ?? ''),
                    trailing: IconButton(icon: const Icon(Icons.picture_as_pdf, color: Color(0xFF198754)),
                      onPressed: () => _generatePdf(s)),
                  ));
              })),
        ]),
      ),
    );
  }
}
