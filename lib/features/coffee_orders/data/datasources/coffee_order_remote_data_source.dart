import '../models/coffee_product_model.dart';

class CoffeeOrderRemoteDataSource {
  Future<List<CoffeeProductModel>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      CoffeeProductModel(
        id: 1,
        name: 'Café americano',
        price: 4500,
        category: 'Bebidas calientes',
      ),
      CoffeeProductModel(
        id: 2,
        name: 'Capuchino',
        price: 6500,
        category: 'Bebidas calientes',
      ),
      CoffeeProductModel(
        id: 3,
        name: 'Latte',
        price: 7000,
        category: 'Bebidas calientes',
      ),
      CoffeeProductModel(
        id: 4,
        name: 'Mocaccino',
        price: 8000,
        category: 'Bebidas calientes',
      ),
      CoffeeProductModel(
        id: 5,
        name: 'Croissant',
        price: 5500,
        category: 'Panadería',
      ),
      CoffeeProductModel(
        id: 6,
        name: 'Torta de chocolate',
        price: 9000,
        category: 'Postres',
      ),
    ];
  }
}