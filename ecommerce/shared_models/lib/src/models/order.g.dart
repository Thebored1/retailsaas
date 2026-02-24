// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      shippingAmount: (json['shippingAmount'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      grandTotal: (json['grandTotal'] as num).toDouble(),
      status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
          OrderStatus.pending,
      paymentStatus:
          $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
              PaymentStatus.pending,
      paymentMethod: json['paymentMethod'] as String?,
      paymentId: json['paymentId'] as String?,
      shippingAddress: json['shippingAddress'] as String?,
      shippingCity: json['shippingCity'] as String?,
      shippingPincode: json['shippingPincode'] as String?,
      shippingPhone: json['shippingPhone'] as String?,
      trackingNumber: json['trackingNumber'] as String?,
      shippedAt: json['shippedAt'] == null
          ? null
          : DateTime.parse(json['shippedAt'] as String),
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'orderDate': instance.orderDate.toIso8601String(),
      'items': instance.items,
      'subtotal': instance.subtotal,
      'taxAmount': instance.taxAmount,
      'shippingAmount': instance.shippingAmount,
      'discount': instance.discount,
      'grandTotal': instance.grandTotal,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'paymentMethod': instance.paymentMethod,
      'paymentId': instance.paymentId,
      'shippingAddress': instance.shippingAddress,
      'shippingCity': instance.shippingCity,
      'shippingPincode': instance.shippingPincode,
      'shippingPhone': instance.shippingPhone,
      'trackingNumber': instance.trackingNumber,
      'shippedAt': instance.shippedAt?.toIso8601String(),
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.processing: 'processing',
  OrderStatus.shipped: 'shipped',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.returned: 'returned',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};
