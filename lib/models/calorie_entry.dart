class CalorieEntry {
  final int? id;
  final String item;
  final int calories;
  final DateTime date;

  CalorieEntry({
    this.id,
    required this.item,
    required this.calories,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'item': item,
        'calories': calories,
        'date': _dateKey(date),
      };

  static CalorieEntry fromMap(Map<String, dynamic> m) => CalorieEntry(
        id: m['id'] as int?,
        item: m['item'] as String,
        calories: m['calories'] as int,
        date: DateTime.parse(m['date'] as String),
      );
}

String _dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
