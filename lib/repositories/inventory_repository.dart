import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

abstract class InventoryRepository {
  Future<List<Product>> loadProducts();
  Future<void> saveProducts(List<Product> products);
}

class JsonInventoryRepository implements InventoryRepository {
  static const String _key = 'inventory_data';

  @override
  Future<List<Product>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(products.map((p) => p.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}
