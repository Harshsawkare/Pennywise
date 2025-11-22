/// Category model representing a category with name and color
/// Follows clean architecture by keeping domain layer model simple
class CategoryModel {
  /// Category name
  final String name;

  /// Hex color code for the category
  final String hexCode;

  /// Constructor
  const CategoryModel({
    required this.name,
    required this.hexCode,
  });

  /// Creates CategoryModel from Firestore map
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] as String? ?? '',
      hexCode: map['hexCode'] as String? ?? '#000000',
    );
  }

  /// Converts CategoryModel to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hexCode': hexCode,
    };
  }

  /// Creates a copy of CategoryModel with updated fields
  CategoryModel copyWith({
    String? name,
    String? hexCode,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      hexCode: hexCode ?? this.hexCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel &&
        other.name == name &&
        other.hexCode == hexCode;
  }

  @override
  int get hashCode => name.hashCode ^ hexCode.hashCode;
}

