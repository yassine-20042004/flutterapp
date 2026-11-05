class Student {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String filiere;
  final double moyenne;

  const Student({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.filiere,
    required this.moyenne,
  });

  String get fullName => '$prenom $nom';

  Student copyWith({
    String? nom,
    String? prenom,
    String? email,
    String? filiere,
    double? moyenne,
  }) {
    return Student(
      id: id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      filiere: filiere ?? this.filiere,
      moyenne: moyenne ?? this.moyenne,
    );
  }
}
