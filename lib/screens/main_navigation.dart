import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import 'home_screen.dart';
import 'classes_screen.dart';
import 'students_list_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  final int userId;
  const MainNavigation({super.key, required this.userId});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late final List<Widget> _pages = [
    HomeScreen(userId: widget.userId),
    const ClassesScreen(),
    const StudentsListScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home, color: Color(0xFF198754)), label: lang.t('home')),
            NavigationDestination(icon: const Icon(Icons.class_outlined), selectedIcon: const Icon(Icons.class_, color: Color(0xFF198754)), label: lang.t('classes')),
            NavigationDestination(icon: const Icon(Icons.people_outline), selectedIcon: const Icon(Icons.people, color: Color(0xFF198754)), label: lang.t('students')),
            NavigationDestination(icon: const Icon(Icons.settings_outlined), selectedIcon: const Icon(Icons.settings, color: Color(0xFF198754)), label: lang.t('settings')),
          ],
        ),
      ),
    );
  }
}
