class Product {
  final String id;
  final String name;
  final int quantity;

  Product({required this.id, required this.name, required this.quantity});

  Map<String, dynamic> toJson() => {
    'id': id, 
    'name': name, 
    'quantity': quantity
  };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
    );
  }
}
