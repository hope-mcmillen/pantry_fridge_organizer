class PantryItem {
  final String id;
  final String name;
  final String? imagePath;
  bool inFridge;

  PantryItem({
    required this.id,
    required this.name,
    this.imagePath,
    required this.inFridge,
  });

  // Converts the PantryItem into data that can eventually
  // be saved locally or to a database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'inFridge': inFridge,
    };
  }

  // Creates a PantryItem from saved data.
  factory PantryItem.fromMap(Map<String, dynamic> map) {
    return PantryItem(
      id: map['id'] as String,
      name: map['name'] as String,
      imagePath: map['imagePath'] as String?,
      inFridge: map['inFridge'] as bool,
    );
  }
}