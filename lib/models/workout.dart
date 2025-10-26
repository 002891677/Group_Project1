class Workout {
  final int? id;
  final String name;
  final int sets;
  final int reps;
  final DateTime date;

  Workout({
    this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'sets': sets,
        'reps': reps,
        'date': _dateKey(date),
      };

  static Workout fromMap(Map<String, dynamic> m) => Workout(
        id: m['id'] as int?,
        name: m['name'] as String,
        sets: m['sets'] as int,
        reps: m['reps'] as int,
        date: DateTime.parse(m['date'] as String),
      );
}

String _dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
