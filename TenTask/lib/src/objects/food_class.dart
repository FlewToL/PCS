import 'dart:convert';

class Food {
  final int? id;
  final String art;
  final String title;
  final String desc;
  final int weight;
  final String expDate;
  final double price;
  final double salePrice;
  final int count;
  final String brand;
  final double calories;
  final double fat;
  final double protein;
  final double carbohydrate;
  final String img;
  int inCart;

  Food({
    this.id,
    required this.art,
    required this.title,
    required this.desc,
    required this.weight,
    required this.expDate,
    required this.price,
    required this.salePrice,
    required this.count,
    required this.brand,
    required this.calories,
    required this.fat,
    required this.protein,
    required this.carbohydrate,
    required this.img,
    this.inCart = 0,
  });

  // Создание объекта Food из JSON
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      art: json['art'],
      title: json['title'],
      desc: json['desc'],
      weight: json['weight'],
      expDate: json['expDate'],
      price: (json['price'] as num).toDouble(),
      salePrice: (json['salePrice'] as num).toDouble(),
      count: json['count'],
      brand: json['brand'],
      calories: (json['calories'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbohydrate: (json['carbohydrate'] as num).toDouble(),
      img: json['img'],
      inCart: json['inCart'],
    );
  }

  // Преобразование объекта Food в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'art': art,
      'title': title,
      'desc': desc,
      'weight': weight,
      'expDate': expDate,
      'price': price,
      'salePrice': salePrice,
      'count': count,
      'brand': brand,
      'calories': calories,
      'fat': fat,
      'protein': protein,
      'carbohydrate': carbohydrate,
      'img': img,
      'inCart': inCart,
    };
  }

  Food copyWith({
    int? id,
    String? art,
    String? title,
    String? desc,
    int? weight,
    String? expDate,
    double? price,
    double? salePrice,
    int? count,
    String? brand,
    double? calories,
    double? fat,
    double? protein,
    double? carbohydrate,
    String? img,
    int? inCart,
  }) {
    return Food(
      id: id ?? this.id,
      art: art ?? this.art,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      weight: weight ?? this.weight,
      expDate: expDate ?? this.expDate,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      count: count ?? this.count,
      brand: brand ?? this.brand,
      calories: calories ?? this.calories,
      fat: fat ?? this.fat,
      protein: protein ?? this.protein,
      carbohydrate: carbohydrate ?? this.carbohydrate,
      img: img ?? this.img,
      inCart: inCart ?? this.inCart,
    );
  }

  void incrementCount() {
    inCart++;
  }

  void decrementCount() {
    if (inCart > 0) inCart--;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Food &&
        other.art == art &&
        other.title == title &&
        other.desc == desc &&
        other.weight == weight &&
        other.expDate == expDate &&
        other.price == price &&
        other.salePrice == salePrice &&
        other.count == count &&
        other.brand == brand &&
        other.calories == calories &&
        other.fat == fat &&
        other.protein == protein &&
        other.carbohydrate == carbohydrate &&
        other.img == img;
  }

  @override
  int get hashCode {
    return art.hashCode ^
        title.hashCode ^
        desc.hashCode ^
        weight.hashCode ^
        expDate.hashCode ^
        price.hashCode ^
        salePrice.hashCode ^
        count.hashCode ^
        brand.hashCode ^
        calories.hashCode ^
        fat.hashCode ^
        protein.hashCode ^
        carbohydrate.hashCode ^
        img.hashCode;
  }
}
