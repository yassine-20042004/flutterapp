import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/app_constants.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student; // Si null => Ajout, sinon => Modification

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomCtrl;
  late TextEditingController _prenomCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _moyenneCtrl;
  String? _selectedFiliere;

  @override
  void initState() {
    super.initState();
    // Si on modifie, on pré-remplit. Sinon, on laisse vide.
    _nomCtrl = TextEditingController(text: widget.student?.nom ?? '');
    _prenomCtrl = TextEditingController(text: widget.student?.prenom ?? '');
    _emailCtrl = TextEditingController(text: widget.student?.email ?? '');
    _moyenneCtrl = TextEditingController(
      text: widget.student?.moyenne.toString() ?? '',
    );
    _selectedFiliere = widget.student?.filiere;
  }

  @override
  void dispose() {
    // Flutter gère parfaitement la destruction ici, sans erreur !
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _moyenneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newStudent = Student(
        id: widget.student?.id ?? '', // L'ID sera généré par le service si vide
        nom: _nomCtrl.text.trim(),
        prenom: _prenomCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        filiere: _selectedFiliere!,
        moyenne: double.parse(_moyenneCtrl.text),
      );
      // On renvoie l'étudiant à l'écran précédent
      Navigator.pop(context, newStudent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.student == null ? 'Nouvel étudiant' : 'Modifier l\'étudiant',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomCtrl,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _prenomCtrl,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedFiliere,
              decoration: const InputDecoration(
                labelText: 'Filière',
                border: OutlineInputBorder(),
              ),
              items: AppConstants.filieres
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedFiliere = v),
              validator: (v) =>
                  v == null ? 'Veuillez choisir une filière' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _moyenneCtrl,
              decoration: const InputDecoration(
                labelText: 'Moyenne /20',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                final d = double.tryParse(v ?? '');
                if (d == null) return 'Veuillez entrer un nombre';
                if (d < 0 || d > 20)
                  return 'La moyenne doit être entre 0 et 20';
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Enregistrer', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
