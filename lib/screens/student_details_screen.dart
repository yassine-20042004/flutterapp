import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';
import 'student_form_screen.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student student;

  const StudentDetailsScreen({super.key, required this.student});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final _service = StudentService.instance;
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student = widget.student;
  }

  Future<void> _editStudent() async {
    // Navigation vers le même formulaire, mais en mode "Édition"
    final updatedStudent = await Navigator.push<Student>(
      context,
      MaterialPageRoute(builder: (_) => StudentFormScreen(student: _student)),
    );

    if (updatedStudent != null) {
      _service.update(updatedStudent);
      setState(() {
        _student = updatedStudent; // Met à jour l'affichage local
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_student.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editStudent,
            tooltip: 'Modifier',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              child: Text(
                _student.prenom.isNotEmpty
                    ? _student.prenom[0].toUpperCase()
                    : '?',
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoTile(Icons.badge, 'Identifiant', _student.id),
          _buildInfoTile(Icons.person, 'Nom complet', _student.fullName),
          _buildInfoTile(Icons.email, 'Email', _student.email),
          _buildInfoTile(Icons.school, 'Filière', _student.filiere),
          _buildInfoTile(
            Icons.grade,
            'Moyenne',
            '${_student.moyenne.toStringAsFixed(2)} / 20',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
