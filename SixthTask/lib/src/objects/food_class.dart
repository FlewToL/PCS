class Food {
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

  Food(
      {required this.title,
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
    return title.hashCode ^
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
