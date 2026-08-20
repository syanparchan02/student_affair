// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopItem _$ShopItemFromJson(Map<String, dynamic> json) => ShopItem(
  menuId: (json['menu_id'] as num).toInt(),
  itemName: json['item_name'] as String?,
  description: json['description'] as String?,
  itemPrice: ShopItem._toDouble(json['item_price']),
  quantity: (json['quantity'] as num).toInt(),
  isAvailable: (json['is_available'] as num).toInt(),
  categoryId: (json['category_id'] as num).toInt(),
  categoryName: json['category_name'] as String?,
  itemImage: json['item_image'] as String?,
);

Map<String, dynamic> _$ShopItemToJson(ShopItem instance) => <String, dynamic>{
  'menu_id': instance.menuId,
  'item_name': instance.itemName,
  'description': instance.description,
  'item_price': instance.itemPrice,
  'quantity': instance.quantity,
  'is_available': instance.isAvailable,
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
};

Shop _$ShopFromJson(Map<String, dynamic> json) => Shop(
  shopId: (json['shop_id'] as num).toInt(),
  shopName: json['shop_name'] as String?,
  shopPhone: json['shop_phone'] as String?,
  isOpen: (json['is_open'] as num).toInt(),
  userName: json['user_name'] as String?,
  userEmail: json['user_email'] as String?,
  categories: Shop._parseCategories(json['categories']),
);

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
  'shop_id': instance.shopId,
  'shop_name': instance.shopName,
  'shop_phone': instance.shopPhone,
  'is_open': instance.isOpen,
  'user_name': instance.userName,
  'user_email': instance.userEmail,
  'categories': instance.categories.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
};
