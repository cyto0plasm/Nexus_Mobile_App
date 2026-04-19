class Shop {
  final int id;
  final String name;

  const Shop({
    required this.id,
    required this.name,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id:   json['id'] as int,
      name: json['name']?.toString() ?? '',
    );
  }
}