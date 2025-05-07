class Category {
  final int id;
  final String nameTh;
  final int number;

  Category({
    required this.id,
    required this.nameTh,
    required this.number
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameTh: json['nameTh'],
      number: json['number'],
    );
  }
}