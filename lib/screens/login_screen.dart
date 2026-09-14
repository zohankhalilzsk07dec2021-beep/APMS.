import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../services/language_service.dart';
import 'main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _u = TextEditingController(text: 'admin');
  final _p = TextEditingController(text: 'admin123');
  bool _loading = false;
  String? _err;

  Future<void> _login() async {
    setState(() { _loading = true; _err = null; });
    final user = await DatabaseService.login(_u.text.trim(), _p.text.trim());
    setState(() => _loading = false);
    if (user == null) { setState(() => _err = 'غلط صارف نام یا پاس ورڈ'); return; }
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainNavigation(userId: user['id'] as int)));
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F5132), Color(0xFF198754)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const CircleAvatar(radius: 40, backgroundColor: Color(0xFF198754), child: Icon(Icons.school, size: 45, color: Colors.white)),
                      const SizedBox(height: 12),
                      Text(lang.t('school_name'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(lang.t('address'), style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 20),
                      TextField(controller: _u, decoration: InputDecoration(labelText: lang.t('username'), prefixIcon: const Icon(Icons.person), border: const OutlineInputBorder())),
                      const SizedBox(height: 12),
                      TextField(controller: _p, obscureText: true, decoration: InputDecoration(labelText: lang.t('password'), prefixIcon: const Icon(Icons.lock), border: const OutlineInputBorder())),
                      const SizedBox(height: 16),
                      if (_err != null) Text(_err!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                      SizedBox(width: double.infinity, child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF198754), padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: _loading ? const CircularProgressIndicator(color: Colors.white) : Text(lang.t('login'), style: const TextStyle(fontSize: 18, color: Colors.white)),
                      )),
                      TextButton(onPressed: () => lang.toggle(), child: Text(lang.isUrdu ? 'Switch to English' : 'اردو میں تبدیل کریں')),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
