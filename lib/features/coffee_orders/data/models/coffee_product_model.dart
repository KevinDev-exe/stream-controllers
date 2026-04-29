import '../../domain/entities/coffee_product.dart';

class CoffeeProductModel extends CoffeeProduct {
  const CoffeeProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
  });
}