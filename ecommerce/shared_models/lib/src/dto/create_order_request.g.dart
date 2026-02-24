// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemRequest _$OrderItemRequestFromJson(Map<String, dynamic> json) =>
    OrderItemRequest(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderItemRequestToJson(OrderItemRequest instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'price': instance.price,
    };

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingAddress: json['shippingAddress'] as String,
      shippingCity: json['shippingCity'] as String,
      shippingPincode: json['shippingPincode'] as String,
      shippingPhone: json['shippingPhone'] as String,
      couponCode: json['couponCode'] as String?,
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{
      'items': instance.items,
      'shippingAddress': instance.shippingAddress,
      'shippingCity': instance.shippingCity,
      'shippingPincode': instance.shippingPincode,
      'shippingPhone': instance.shippingPhone,
      'couponCode': instance.couponCode,
    };
