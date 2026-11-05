import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';
import '../widgets/student_card.dart';
import 'student_details_screen.dart';
import 'student_form_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final _service = StudentService.instance; // Utilisation du Singleton
  final _searchCtrl = TextEditingController();
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {
      _students = _service.search(_searchCtrl.text);
    });
  }

  Future<void> _addStudent() async {
    // Navigation vers le nouvel écran de formulaire
    final newStudent = await Navigator.push<Student>(
      context,
      MaterialPageRoute(builder: (_) => const StudentFormScreen()),
    );

    if (newStudent != null) {
      _service.add(newStudent);
      _refresh();
    }
  }

  Future<void> _deleteStudent(Student s) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: Text('Voulez-vous vraiment supprimer ${s.fullName} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _service.delete(s.id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des étudiants')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => _refresh(),
              decoration: const InputDecoration(
                hintText: 'Rechercher un étudiant...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _students.isEmpty
                ? const Center(child: Text('Aucun étudiant trouvé.'))
                : ListView.builder(
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final s = _students[index];
                      return Dismissible(
                        key: Key(s.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          await _deleteStudent(s);
                          return false; // On laisse _deleteStudent gérer la suppression
                        },
                        child: StudentCard(
                          student: s,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StudentDetailsScreen(student: s),
                              ),
                            );
                            _refresh(); // Rafraîchir au retour (au cas où on a modifié)
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStudent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
