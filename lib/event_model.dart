class Event {
  String id;
  String name;
  String description;
  DateTime date;
  String location;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
  });

  // Convert Event object to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date,
      'location': location,
    };
  }

  // Create Event object from map
  Event.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        date = map['date'].toDate(),
        location = map['location'];
}
