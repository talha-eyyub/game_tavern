class Machine {
  final String id;
  final String name;
  final double price;
  final int durationInMinutes;
  bool isActive;

  Machine({
    required this.id,
    required this.name,
    required this.price,
    required this.durationInMinutes,
    this.isActive = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'durationInMinutes': durationInMinutes,
      'isActive': isActive,
    };
  }

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      durationInMinutes: json['durationInMinutes'],
      isActive: json['isActive'],
    );
  }
}
