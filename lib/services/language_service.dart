import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  static bool _isUrdu = true;
  bool get isUrdu => _isUrdu;
  void toggle() { _isUrdu = !_isUrdu; notifyListeners(); }

  String t(String key) {
    final m = <String, Map<String, String>>{
      'school_name': {'ur': 'علی پبلک ماڈل اسکول', 'en': 'Ali Public Model School'},
      'address': {'ur': 'بستی ناہو والا، نواں', 'en': 'Basti Naho Wala, Nawan'},
      'login': {'ur': 'لاگ ان', 'en': 'Login'},
      'username': {'ur': 'صارف نام', 'en': 'Username'},
      'password': {'ur': 'پاس ورڈ', 'en': 'Password'},
      'dashboard': {'ur': 'ڈیش بورڈ', 'en': 'Dashboard'},
      'home': {'ur': 'ہوم', 'en': 'Home'},
      'students': {'ur': 'طلباء', 'en': 'Students'},
      'teachers': {'ur': 'اساتذہ', 'en': 'Teachers'},
      'classes': {'ur': 'کلاسز', 'en': 'Classes'},
      'attendance': {'ur': 'حاضری', 'en': 'Attendance'},
      'result': {'ur': 'نتیجہ', 'en': 'Result'},
      'timetable': {'ur': 'ٹائم ٹیبل', 'en': 'Timetable'},
      'admission': {'ur': 'داخلہ', 'en': 'Admission'},
      'sms': {'ur': 'پیغام', 'en': 'SMS'},
      'settings': {'ur': 'ترتیبات', 'en': 'Settings'},
      'backup': {'ur': 'بیک اپ', 'en': 'Backup'},
      'announcements': {'ur': 'اعلانات', 'en': 'Announcements'},
      'student_name': {'ur': 'طالب علم کا نام', 'en': 'Student Name'},
      'father_name': {'ur': 'والد کا نام', 'en': 'Father Name'},
      'mother_name': {'ur': 'والدہ کا نام', 'en': 'Mother Name'},
      'parent_contact': {'ur': 'والدین کا رابطہ', 'en': 'Parent Contact'},
      'address_lbl': {'ur': 'پتہ', 'en': 'Address'},
      'class': {'ur': 'کلاس', 'en': 'Class'},
      'section': {'ur': 'سیکشن', 'en': 'Section'},
      'roll_no': {'ur': 'رول نمبر', 'en': 'Roll No'},
      'admission_no': {'ur': 'داخلہ نمبر', 'en': 'Admission No'},
      'save': {'ur': 'محفوظ', 'en': 'Save'},
      'cancel': {'ur': 'منسوخ', 'en': 'Cancel'},
      'search': {'ur': 'تلاش', 'en': 'Search'},
      'present': {'ur': 'حاضر', 'en': 'Present'},
      'absent': {'ur': 'غیر حاضر', 'en': 'Absent'},
      'logout': {'ur': 'لاگ آؤٹ', 'en': 'Logout'},
      'change_password': {'ur': 'پاس ورڈ تبدیل', 'en': 'Change Password'},
      'no_data': {'ur': 'کوئی ڈیٹا نہیں', 'en': 'No data'},
      'cnic': {'ur': 'شناختی کارڈ', 'en': 'CNIC'},
      'subject': {'ur': 'مضمون', 'en': 'Subject'},
      'contact': {'ur': 'رابطہ', 'en': 'Contact'},
      'qualification': {'ur': 'تعلیم', 'en': 'Qualification'},
      'send_sms': {'ur': 'پیغام بھیجیں', 'en': 'Send SMS'},
      'about': {'ur': 'کے بارے میں', 'en': 'About'},
      'old_password': {'ur': 'پرانا پاس ورڈ', 'en': 'Old Password'},
      'new_password': {'ur': 'نیا پاس ورڈ', 'en': 'New Password'},
    };
    return m[key]?[isUrdu ? 'ur' : 'en'] ?? key;
  }
}
