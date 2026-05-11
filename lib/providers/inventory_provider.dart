import 'package:flutter/material.dart';
import '../models/product.dart';
import '../repositories/inventory_repository.dart';

class InventoryProvider extends ChangeNotifier {
  // Dependencia inyectada
  final InventoryRepository _repository; 

  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  // Inyección por constructor
  InventoryProvider({required InventoryRepository repository}) : _repository = repository {
    loadInventory();
  }

  Future<void> loadInventory() async {
    _isLoading = true;
    notifyListeners();

    _products = await _repository.loadProducts();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _products.add(product);
    await _repository.saveProducts(_products); // Guarda en el JSON (SharedPreferences)
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    await _repository.saveProducts(_products);
    notifyListeners();
  }
}
