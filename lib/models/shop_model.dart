import 'package:json_annotation/json_annotation.dart';

part 'shop_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShopItem {
  @JsonKey(name: 'menu_id')
  final int menuId;
  
  @JsonKey(name: 'item_name')
  final String? itemName;
  
  @JsonKey(name: 'description')
  final String? description;
  
  @JsonKey(name: 'item_price', fromJson: _toDouble)
  final double itemPrice;
  
  @JsonKey(name: 'quantity')
  final int quantity;
  
  @JsonKey(name: 'is_available')
  final int isAvailable;
  
  @JsonKey(name: 'category_id')
  final int categoryId;
  
  @JsonKey(name: 'category_name')
  final String? categoryName;

  ShopItem({
    required this.menuId,
    this.itemName,
    this.description,
    required this.itemPrice,
    required this.quantity,
    required this.isAvailable,
    required this.categoryId,
    this.categoryName,
  });

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  factory ShopItem.fromJson(Map<String, dynamic> json) => _$ShopItemFromJson(json);
  Map<String, dynamic> toJson() => _$ShopItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Shop {
  @JsonKey(name: 'shop_id')
  final int shopId;
  
  @JsonKey(name: 'shop_name')
  final String? shopName;
  
  @JsonKey(name: 'shop_phone')
  final String? shopPhone;
  
  @JsonKey(name: 'is_open')
  final int isOpen;
  
  @JsonKey(name: 'user_name')
  final String? userName;
  
  @JsonKey(name: 'user_email')
  final String? userEmail;

  @JsonKey(fromJson: _parseCategories)
  final Map<String, List<ShopItem>> categories;

  Shop({
    required this.shopId,
    this.shopName,
    this.shopPhone,
    required this.isOpen,
    this.userName,
    this.userEmail,
    required this.categories,
  });

  static Map<String, List<ShopItem>> _parseCategories(dynamic json) {
    Map<String, List<ShopItem>> parsedCategories = {};
    if (json != null && json is Map) {
      (json as Map<String, dynamic>).forEach((categoryName, itemsList) {
        if (itemsList is List) {
          parsedCategories[categoryName] = itemsList
              .map((item) => ShopItem.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      });
    }
    return parsedCategories;
  }

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
  Map<String, dynamic> toJson() => _$ShopToJson(this);
}