import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/inventory_provider.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios del provider
    final inventory = context.watch<InventoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Inventario - DI')),
      body: inventory.isLoading
          ? const Center(child: CircularProgressIndicator())
          : inventory.products.isEmpty
              ? const Center(child: Text('No hay productos.'))
              : ListView.builder(
                  itemCount: inventory.products.length,
                  itemBuilder: (context, index) {
                    final product = inventory.products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('Cantidad: ${product.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Llamamos al método delete usando read() ya que estamos en un callback
                          context.read<InventoryProvider>().deleteProduct(product.id);
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Añadir Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre del producto'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text.trim();
                final int quantity = int.tryParse(quantityController.text) ?? 0;
                
                if (name.isNotEmpty && quantity > 0) {
                  final newProduct = Product(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    quantity: quantity,
                  );
                  // Usamos read() para acceder al provider sin escuchar cambios
                  // Note que pasamos el context original (context) de la UI superior,
                  // o el de adentro. Provider funciona bien buscando en el árbol superior.
                  context.read<InventoryProvider>().addProduct(newProduct);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
