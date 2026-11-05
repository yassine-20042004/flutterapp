import '../models/student.dart';

class StudentService {
  // Singleton pour conserver les données en mémoire
  StudentService._privateConstructor();
  static final StudentService instance = StudentService._privateConstructor();

  final List<Student> _students = [];
  int _nextId = 1;

  List<Student> getAll() => List.unmodifiable(_students);

  List<Student> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return getAll();
    return _students
        .where(
          (s) =>
              s.nom.toLowerCase().contains(q) ||
              s.prenom.toLowerCase().contains(q),
        )
        .toList();
  }

  void add(Student student) {
    // On s'assure d'avoir un ID unique
    final newStudent = Student(
      id: (_nextId++).toString(),
      nom: student.nom,
      prenom: student.prenom,
      email: student.email,
      filiere: student.filiere,
      moyenne: student.moyenne,
    );
    _students.add(newStudent);
  }

  void update(Student updated) {
    final index = _students.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _students[index] = updated;
    }
  }

  void delete(String id) {
    _students.removeWhere((s) => s.id == id);
  }
}
