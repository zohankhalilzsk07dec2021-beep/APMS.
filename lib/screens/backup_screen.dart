import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/language_service.dart';
import '../services/database_service.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(lang.t('backup')), backgroundColor: const Color(0xFF198754)),
        body: Padding(padding: const EdgeInsets.all(20),
          child: Column(children: [
            const Icon(Icons.backup, size: 80, color: Color(0xFF198754)),
            const SizedBox(height: 20),
            Text(lang.isUrdu
              ? 'اپنے اسکول کے تمام ڈیٹا کا بیک اپ لیں اور کسی بھی جگہ شیئر کریں۔'
              : 'Take a backup of all school data and share it anywhere.',
              textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 30),
            ElevatedButton.icon(icon: const Icon(Icons.download),
              label: Text(lang.isUrdu ? 'بیک اپ بنائیں' : 'Create Backup'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF198754), padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14)),
              onPressed: () async {
                final dbPath = await DatabaseService.getDbPath();
                final file = File(dbPath);
                if (await file.exists()) {
                  await Share.shareXFiles([XFile(dbPath)], text: 'APMS Backup');
                }
              }),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            Text('© 2025 Ali Public Model School\nBasti Naho Wala, Nawan',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ])),
      ),
    );
  }
}
