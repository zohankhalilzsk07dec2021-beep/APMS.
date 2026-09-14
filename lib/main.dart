import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/language_service.dart';
import 'screens/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageService(),
      child: Consumer<LanguageService>(
        builder: (_, lang, __) => MaterialApp(
          title: 'Ali Public Model School',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
