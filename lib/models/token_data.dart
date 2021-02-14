import 'package:flutter/cupertino.dart';

@immutable
class TokenData {
  const TokenData({
    @required this.title,
    @required this.price,
    @required this.minPrice,
    @required this.maxPrice,
    @required this.diff,
  });

  final String title;
  final double price;
  final double minPrice;
  final double maxPrice;
  final double diff;

  @override
  String toString() {
    return 'TokenData{title: $title, price: $price, minPrice: $minPrice, maxPrice: $maxPrice, diff: $diff}';
  }

  TokenData copyWith({
    String title,
    double price,
    double minPrice,
    double maxPrice,
    double diff,
  }) {
    if ((title == null || identical(title, this.title)) &&
        (price == null || identical(price, this.price)) &&
        (minPrice == null || identical(minPrice, this.minPrice)) &&
        (maxPrice == null || identical(maxPrice, this.maxPrice)) &&
        (diff == null || identical(diff, this.diff))) {
      return this;
    }

    return TokenData(
      title: title ?? this.title,
      price: price ?? this.price,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      diff: diff ?? this.diff,
    );
  }
}
