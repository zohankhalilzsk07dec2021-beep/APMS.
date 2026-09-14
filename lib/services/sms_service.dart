import 'package:url_launcher/url_launcher.dart';

class SmsService {
  static Future<bool> send(String phone, String message) async {
    final uri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: {'body': message},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    return false;
  }

  static String absentMessage(String studentName) =>
      'محترم والدین، آپ کا بچہ $studentName آج علی پبلک ماڈل اسکول میں غیر حاضر تھا۔';
}
