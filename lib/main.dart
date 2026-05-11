import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/inventory_repository.dart';
import 'providers/inventory_provider.dart';
import 'screens/inventory_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // 1. Proveemos la dependencia base (El Repositorio JSON)
        Provider<InventoryRepository>(
          create: (_) => JsonInventoryRepository(),
        ),
        
        // 2. Proveemos el manejador de estado, INYECTÁNDOLE el repositorio
        ChangeNotifierProvider<InventoryProvider>(
          // context.read busca en el árbol el repositorio que creamos arriba
          create: (context) => InventoryProvider(
            repository: context.read<InventoryRepository>(), 
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Inventario',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const InventoryScreen(),
    );
  }
}
