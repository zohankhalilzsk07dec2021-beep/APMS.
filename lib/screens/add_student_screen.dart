import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/student_service.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});
  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _form = GlobalKey<FormState>();
  final name = TextEditingController();
  final father = TextEditingController();
  final mother = TextEditingController();
  final contact = TextEditingController();
  final address = TextEditingController();
  int classNumber = 1;
  String section = 'A';
  File? photo;

  Future<void> _pickPhoto() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70);
    if (img != null) setState(() => photo = File(img.path));
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    await StudentService.add(
      name: name.text.trim(), fatherName: father.text.trim(),
      motherName: mother.text.trim(), parentContact: contact.text.trim(),
      address: address.text.trim(), classNumber: classNumber,
      section: section, photoPath: photo?.path,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('طالب علم شامل ہو گیا')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Directionality(
      textDirection: lang.isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(lang.t('admission')), backgroundColor: const Color(0xFF198754)),
        body: Form(key: _form, child: ListView(padding: const EdgeInsets.all(16), children: [
          Center(child: GestureDetector(onTap: _pickPhoto,
            child: CircleAvatar(radius: 50, backgroundColor: Colors.grey[300],
              backgroundImage: photo != null ? FileImage(photo!) : null,
              child: photo == null ? const Icon(Icons.camera_alt, size: 40) : null))),
          const SizedBox(height: 16),
          _tf(name, lang.t('student_name')),
          _tf(father, lang.t('father_name')),
          _tf(mother, lang.t('mother_name')),
          _tf(contact, lang.t('parent_contact'), type: TextInputType.phone),
          _tf(address, lang.t('address_lbl'), maxLines: 2),
          DropdownButtonFormField<int>(value: classNumber,
            decoration: InputDecoration(labelText: lang.t('class'), border: const OutlineInputBorder()),
            items: List.generate(10, (i) => i + 1).map((n) => DropdownMenuItem(value: n, child: Text('Class $n'))).toList(),
            onChanged: (v) => setState(() => classNumber = v!)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(value: section,
            decoration: InputDecoration(labelText: lang.t('section'), border: const OutlineInputBorder()),
            items: ['A', 'B', 'C'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => section = v!)),
          const SizedBox(height: 20),
          ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: Text(lang.t('save')),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF198754), padding: const EdgeInsets.symmetric(vertical: 14))),
        ])),
      ),
    );
  }

  Widget _tf(TextEditingController c, String label, {TextInputType? type, int maxLines = 1}) {
    return Padding(padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(controller: c, keyboardType: type, maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null));
  }
}
