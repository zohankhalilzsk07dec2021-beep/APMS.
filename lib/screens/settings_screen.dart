import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../services/language_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(lang.t('settings')), backgroundColor: const Color(0xFF198754)),
        body: ListView(children: [
          SwitchListTile(
            title: Text(lang.isUrdu ? 'اردو زبان' : 'Urdu Language'),
            subtitle: Text(lang.isUrdu ? 'اردو میں ایپ چلائیں' : 'Run in Urdu'),
            secondary: const Icon(Icons.language, color: Color(0xFF198754)),
            value: lang.isUrdu,
            onChanged: (_) => lang.toggle()),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock, color: Color(0xFF198754)),
            title: Text(lang.t('change_password')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showChangePassword(context, lang)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFF198754)),
            title: Text(lang.t('about')),
            subtitle: Text(lang.isUrdu
              ? 'ورژن 1.0.0\nعلی پبلک ماڈل اسکول'
              : 'Version 1.0.0\nAli Public Model School')),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(lang.t('logout'), style: const TextStyle(color: Colors.red)),
            onTap: () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false)),
          const SizedBox(height: 30),
          Center(child: Padding(padding: const EdgeInsets.all(20),
            child: Text('© 2025 Ali Public Model School\nBasti Naho Wala, Nawan',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 12)))),
        ]),
      ),
    );
  }

  void _showChangePassword(BuildContext context, LanguageService lang) {
    final oldC = TextEditingController();
    final newC = TextEditingController();

    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(lang.t('change_password')),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: oldC, obscureText: true,
          decoration: InputDecoration(labelText: lang.t('old_password'), border: const OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: newC, obscureText: true,
          decoration: InputDecoration(labelText: lang.t('new_password'), border: const OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(lang.t('cancel'))),
        ElevatedButton(onPressed: () async {
          final ok = await DatabaseService.changePassword(1, oldC.text, newC.text);
          if (!context.mounted) return;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(ok ? 'پاس ورڈ تبدیل ہو گیا' : 'غلط پرانا پاس ورڈ')));
        }, child: Text(lang.t('save'))),
      ]));
  }
}
