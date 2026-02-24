// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      brandId: json['brandId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      mrp: (json['mrp'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      hsnCode: json['hsnCode'] as String,
      gstRate: (json['gstRate'] as num).toDouble(),
      isTaxInclusive: json['isTaxInclusive'] as bool? ?? true,
      availableQty: (json['availableQty'] as num).toDouble(),
      uom: json['uom'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categoryId': instance.categoryId,
      'brandId': instance.brandId,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'mrp': instance.mrp,
      'sellingPrice': instance.sellingPrice,
      'hsnCode': instance.hsnCode,
      'gstRate': instance.gstRate,
      'isTaxInclusive': instance.isTaxInclusive,
      'availableQty': instance.availableQty,
      'uom': instance.uom,
      'isAvailable': instance.isAvailable,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
