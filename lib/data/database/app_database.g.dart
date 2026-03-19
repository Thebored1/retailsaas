// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mrpMeta = const VerificationMeta('mrp');
  @override
  late final GeneratedColumn<double> mrp = GeneratedColumn<double>(
    'mrp',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _sellingPriceMeta = const VerificationMeta(
    'sellingPrice',
  );
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
    'selling_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _purchaseRateMeta = const VerificationMeta(
    'purchaseRate',
  );
  @override
  late final GeneratedColumn<double> purchaseRate = GeneratedColumn<double>(
    'purchase_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isTaxInclusiveMeta = const VerificationMeta(
    'isTaxInclusive',
  );
  @override
  late final GeneratedColumn<bool> isTaxInclusive = GeneratedColumn<bool>(
    'is_tax_inclusive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_tax_inclusive" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstRateMeta = const VerificationMeta(
    'gstRate',
  );
  @override
  late final GeneratedColumn<double> gstRate = GeneratedColumn<double>(
    'gst_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cessRateMeta = const VerificationMeta(
    'cessRate',
  );
  @override
  late final GeneratedColumn<double> cessRate = GeneratedColumn<double>(
    'cess_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isExemptMeta = const VerificationMeta(
    'isExempt',
  );
  @override
  late final GeneratedColumn<bool> isExempt = GeneratedColumn<bool>(
    'is_exempt',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_exempt" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isInfiniteStockMeta = const VerificationMeta(
    'isInfiniteStock',
  );
  @override
  late final GeneratedColumn<bool> isInfiniteStock = GeneratedColumn<bool>(
    'is_infinite_stock',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_infinite_stock" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _uomMeta = const VerificationMeta('uom');
  @override
  late final GeneratedColumn<String> uom = GeneratedColumn<String>(
    'uom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lowStockLimitMeta = const VerificationMeta(
    'lowStockLimit',
  );
  @override
  late final GeneratedColumn<double> lowStockLimit = GeneratedColumn<double>(
    'low_stock_limit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isLooseItemMeta = const VerificationMeta(
    'isLooseItem',
  );
  @override
  late final GeneratedColumn<bool> isLooseItem = GeneratedColumn<bool>(
    'is_loose_item',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_loose_item" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _batchTrackingMeta = const VerificationMeta(
    'batchTracking',
  );
  @override
  late final GeneratedColumn<bool> batchTracking = GeneratedColumn<bool>(
    'batch_tracking',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("batch_tracking" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _warrantyMonthsMeta = const VerificationMeta(
    'warrantyMonths',
  );
  @override
  late final GeneratedColumn<int> warrantyMonths = GeneratedColumn<int>(
    'warranty_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    categoryId,
    imageUrl,
    mrp,
    sellingPrice,
    purchaseRate,
    isTaxInclusive,
    hsnCode,
    gstRate,
    cessRate,
    isExempt,
    isInfiniteStock,
    uom,
    lowStockLimit,
    isLooseItem,
    batchTracking,
    warrantyMonths,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('mrp')) {
      context.handle(
        _mrpMeta,
        mrp.isAcceptableOrUnknown(data['mrp']!, _mrpMeta),
      );
    }
    if (data.containsKey('selling_price')) {
      context.handle(
        _sellingPriceMeta,
        sellingPrice.isAcceptableOrUnknown(
          data['selling_price']!,
          _sellingPriceMeta,
        ),
      );
    }
    if (data.containsKey('purchase_rate')) {
      context.handle(
        _purchaseRateMeta,
        purchaseRate.isAcceptableOrUnknown(
          data['purchase_rate']!,
          _purchaseRateMeta,
        ),
      );
    }
    if (data.containsKey('is_tax_inclusive')) {
      context.handle(
        _isTaxInclusiveMeta,
        isTaxInclusive.isAcceptableOrUnknown(
          data['is_tax_inclusive']!,
          _isTaxInclusiveMeta,
        ),
      );
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_hsnCodeMeta);
    }
    if (data.containsKey('gst_rate')) {
      context.handle(
        _gstRateMeta,
        gstRate.isAcceptableOrUnknown(data['gst_rate']!, _gstRateMeta),
      );
    } else if (isInserting) {
      context.missing(_gstRateMeta);
    }
    if (data.containsKey('cess_rate')) {
      context.handle(
        _cessRateMeta,
        cessRate.isAcceptableOrUnknown(data['cess_rate']!, _cessRateMeta),
      );
    }
    if (data.containsKey('is_exempt')) {
      context.handle(
        _isExemptMeta,
        isExempt.isAcceptableOrUnknown(data['is_exempt']!, _isExemptMeta),
      );
    }
    if (data.containsKey('is_infinite_stock')) {
      context.handle(
        _isInfiniteStockMeta,
        isInfiniteStock.isAcceptableOrUnknown(
          data['is_infinite_stock']!,
          _isInfiniteStockMeta,
        ),
      );
    }
    if (data.containsKey('uom')) {
      context.handle(
        _uomMeta,
        uom.isAcceptableOrUnknown(data['uom']!, _uomMeta),
      );
    } else if (isInserting) {
      context.missing(_uomMeta);
    }
    if (data.containsKey('low_stock_limit')) {
      context.handle(
        _lowStockLimitMeta,
        lowStockLimit.isAcceptableOrUnknown(
          data['low_stock_limit']!,
          _lowStockLimitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lowStockLimitMeta);
    }
    if (data.containsKey('is_loose_item')) {
      context.handle(
        _isLooseItemMeta,
        isLooseItem.isAcceptableOrUnknown(
          data['is_loose_item']!,
          _isLooseItemMeta,
        ),
      );
    }
    if (data.containsKey('batch_tracking')) {
      context.handle(
        _batchTrackingMeta,
        batchTracking.isAcceptableOrUnknown(
          data['batch_tracking']!,
          _batchTrackingMeta,
        ),
      );
    }
    if (data.containsKey('warranty_months')) {
      context.handle(
        _warrantyMonthsMeta,
        warrantyMonths.isAcceptableOrUnknown(
          data['warranty_months']!,
          _warrantyMonthsMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      mrp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mrp'],
      )!,
      sellingPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}selling_price'],
      )!,
      purchaseRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_rate'],
      )!,
      isTaxInclusive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_tax_inclusive'],
      )!,
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      )!,
      gstRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gst_rate'],
      )!,
      cessRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cess_rate'],
      )!,
      isExempt: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_exempt'],
      )!,
      isInfiniteStock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_infinite_stock'],
      ),
      uom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uom'],
      )!,
      lowStockLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}low_stock_limit'],
      )!,
      isLooseItem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_loose_item'],
      )!,
      batchTracking: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}batch_tracking'],
      )!,
      warrantyMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warranty_months'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String name;
  final String categoryId;
  final String? imageUrl;
  final double mrp;
  final double sellingPrice;
  final double purchaseRate;
  final bool isTaxInclusive;
  final String hsnCode;
  final double gstRate;
  final double cessRate;
  final bool isExempt;
  final bool? isInfiniteStock;
  final String uom;
  final double lowStockLimit;
  final bool isLooseItem;
  final bool batchTracking;
  final int warrantyMonths;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    this.imageUrl,
    required this.mrp,
    required this.sellingPrice,
    required this.purchaseRate,
    required this.isTaxInclusive,
    required this.hsnCode,
    required this.gstRate,
    required this.cessRate,
    required this.isExempt,
    this.isInfiniteStock,
    required this.uom,
    required this.lowStockLimit,
    required this.isLooseItem,
    required this.batchTracking,
    required this.warrantyMonths,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['mrp'] = Variable<double>(mrp);
    map['selling_price'] = Variable<double>(sellingPrice);
    map['purchase_rate'] = Variable<double>(purchaseRate);
    map['is_tax_inclusive'] = Variable<bool>(isTaxInclusive);
    map['hsn_code'] = Variable<String>(hsnCode);
    map['gst_rate'] = Variable<double>(gstRate);
    map['cess_rate'] = Variable<double>(cessRate);
    map['is_exempt'] = Variable<bool>(isExempt);
    if (!nullToAbsent || isInfiniteStock != null) {
      map['is_infinite_stock'] = Variable<bool>(isInfiniteStock);
    }
    map['uom'] = Variable<String>(uom);
    map['low_stock_limit'] = Variable<double>(lowStockLimit);
    map['is_loose_item'] = Variable<bool>(isLooseItem);
    map['batch_tracking'] = Variable<bool>(batchTracking);
    map['warranty_months'] = Variable<int>(warrantyMonths);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: Value(categoryId),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      mrp: Value(mrp),
      sellingPrice: Value(sellingPrice),
      purchaseRate: Value(purchaseRate),
      isTaxInclusive: Value(isTaxInclusive),
      hsnCode: Value(hsnCode),
      gstRate: Value(gstRate),
      cessRate: Value(cessRate),
      isExempt: Value(isExempt),
      isInfiniteStock: isInfiniteStock == null && nullToAbsent
          ? const Value.absent()
          : Value(isInfiniteStock),
      uom: Value(uom),
      lowStockLimit: Value(lowStockLimit),
      isLooseItem: Value(isLooseItem),
      batchTracking: Value(batchTracking),
      warrantyMonths: Value(warrantyMonths),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      mrp: serializer.fromJson<double>(json['mrp']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
      purchaseRate: serializer.fromJson<double>(json['purchaseRate']),
      isTaxInclusive: serializer.fromJson<bool>(json['isTaxInclusive']),
      hsnCode: serializer.fromJson<String>(json['hsnCode']),
      gstRate: serializer.fromJson<double>(json['gstRate']),
      cessRate: serializer.fromJson<double>(json['cessRate']),
      isExempt: serializer.fromJson<bool>(json['isExempt']),
      isInfiniteStock: serializer.fromJson<bool?>(json['isInfiniteStock']),
      uom: serializer.fromJson<String>(json['uom']),
      lowStockLimit: serializer.fromJson<double>(json['lowStockLimit']),
      isLooseItem: serializer.fromJson<bool>(json['isLooseItem']),
      batchTracking: serializer.fromJson<bool>(json['batchTracking']),
      warrantyMonths: serializer.fromJson<int>(json['warrantyMonths']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<String>(categoryId),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'mrp': serializer.toJson<double>(mrp),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
      'purchaseRate': serializer.toJson<double>(purchaseRate),
      'isTaxInclusive': serializer.toJson<bool>(isTaxInclusive),
      'hsnCode': serializer.toJson<String>(hsnCode),
      'gstRate': serializer.toJson<double>(gstRate),
      'cessRate': serializer.toJson<double>(cessRate),
      'isExempt': serializer.toJson<bool>(isExempt),
      'isInfiniteStock': serializer.toJson<bool?>(isInfiniteStock),
      'uom': serializer.toJson<String>(uom),
      'lowStockLimit': serializer.toJson<double>(lowStockLimit),
      'isLooseItem': serializer.toJson<bool>(isLooseItem),
      'batchTracking': serializer.toJson<bool>(batchTracking),
      'warrantyMonths': serializer.toJson<int>(warrantyMonths),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? categoryId,
    Value<String?> imageUrl = const Value.absent(),
    double? mrp,
    double? sellingPrice,
    double? purchaseRate,
    bool? isTaxInclusive,
    String? hsnCode,
    double? gstRate,
    double? cessRate,
    bool? isExempt,
    Value<bool?> isInfiniteStock = const Value.absent(),
    String? uom,
    double? lowStockLimit,
    bool? isLooseItem,
    bool? batchTracking,
    int? warrantyMonths,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    categoryId: categoryId ?? this.categoryId,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    mrp: mrp ?? this.mrp,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    purchaseRate: purchaseRate ?? this.purchaseRate,
    isTaxInclusive: isTaxInclusive ?? this.isTaxInclusive,
    hsnCode: hsnCode ?? this.hsnCode,
    gstRate: gstRate ?? this.gstRate,
    cessRate: cessRate ?? this.cessRate,
    isExempt: isExempt ?? this.isExempt,
    isInfiniteStock: isInfiniteStock.present
        ? isInfiniteStock.value
        : this.isInfiniteStock,
    uom: uom ?? this.uom,
    lowStockLimit: lowStockLimit ?? this.lowStockLimit,
    isLooseItem: isLooseItem ?? this.isLooseItem,
    batchTracking: batchTracking ?? this.batchTracking,
    warrantyMonths: warrantyMonths ?? this.warrantyMonths,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      mrp: data.mrp.present ? data.mrp.value : this.mrp,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      purchaseRate: data.purchaseRate.present
          ? data.purchaseRate.value
          : this.purchaseRate,
      isTaxInclusive: data.isTaxInclusive.present
          ? data.isTaxInclusive.value
          : this.isTaxInclusive,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      gstRate: data.gstRate.present ? data.gstRate.value : this.gstRate,
      cessRate: data.cessRate.present ? data.cessRate.value : this.cessRate,
      isExempt: data.isExempt.present ? data.isExempt.value : this.isExempt,
      isInfiniteStock: data.isInfiniteStock.present
          ? data.isInfiniteStock.value
          : this.isInfiniteStock,
      uom: data.uom.present ? data.uom.value : this.uom,
      lowStockLimit: data.lowStockLimit.present
          ? data.lowStockLimit.value
          : this.lowStockLimit,
      isLooseItem: data.isLooseItem.present
          ? data.isLooseItem.value
          : this.isLooseItem,
      batchTracking: data.batchTracking.present
          ? data.batchTracking.value
          : this.batchTracking,
      warrantyMonths: data.warrantyMonths.present
          ? data.warrantyMonths.value
          : this.warrantyMonths,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('mrp: $mrp, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('purchaseRate: $purchaseRate, ')
          ..write('isTaxInclusive: $isTaxInclusive, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('gstRate: $gstRate, ')
          ..write('cessRate: $cessRate, ')
          ..write('isExempt: $isExempt, ')
          ..write('isInfiniteStock: $isInfiniteStock, ')
          ..write('uom: $uom, ')
          ..write('lowStockLimit: $lowStockLimit, ')
          ..write('isLooseItem: $isLooseItem, ')
          ..write('batchTracking: $batchTracking, ')
          ..write('warrantyMonths: $warrantyMonths, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    categoryId,
    imageUrl,
    mrp,
    sellingPrice,
    purchaseRate,
    isTaxInclusive,
    hsnCode,
    gstRate,
    cessRate,
    isExempt,
    isInfiniteStock,
    uom,
    lowStockLimit,
    isLooseItem,
    batchTracking,
    warrantyMonths,
    isActive,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.imageUrl == this.imageUrl &&
          other.mrp == this.mrp &&
          other.sellingPrice == this.sellingPrice &&
          other.purchaseRate == this.purchaseRate &&
          other.isTaxInclusive == this.isTaxInclusive &&
          other.hsnCode == this.hsnCode &&
          other.gstRate == this.gstRate &&
          other.cessRate == this.cessRate &&
          other.isExempt == this.isExempt &&
          other.isInfiniteStock == this.isInfiniteStock &&
          other.uom == this.uom &&
          other.lowStockLimit == this.lowStockLimit &&
          other.isLooseItem == this.isLooseItem &&
          other.batchTracking == this.batchTracking &&
          other.warrantyMonths == this.warrantyMonths &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> categoryId;
  final Value<String?> imageUrl;
  final Value<double> mrp;
  final Value<double> sellingPrice;
  final Value<double> purchaseRate;
  final Value<bool> isTaxInclusive;
  final Value<String> hsnCode;
  final Value<double> gstRate;
  final Value<double> cessRate;
  final Value<bool> isExempt;
  final Value<bool?> isInfiniteStock;
  final Value<String> uom;
  final Value<double> lowStockLimit;
  final Value<bool> isLooseItem;
  final Value<bool> batchTracking;
  final Value<int> warrantyMonths;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.mrp = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.purchaseRate = const Value.absent(),
    this.isTaxInclusive = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.gstRate = const Value.absent(),
    this.cessRate = const Value.absent(),
    this.isExempt = const Value.absent(),
    this.isInfiniteStock = const Value.absent(),
    this.uom = const Value.absent(),
    this.lowStockLimit = const Value.absent(),
    this.isLooseItem = const Value.absent(),
    this.batchTracking = const Value.absent(),
    this.warrantyMonths = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    required String categoryId,
    this.imageUrl = const Value.absent(),
    this.mrp = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.purchaseRate = const Value.absent(),
    this.isTaxInclusive = const Value.absent(),
    required String hsnCode,
    required double gstRate,
    this.cessRate = const Value.absent(),
    this.isExempt = const Value.absent(),
    this.isInfiniteStock = const Value.absent(),
    required String uom,
    required double lowStockLimit,
    this.isLooseItem = const Value.absent(),
    this.batchTracking = const Value.absent(),
    this.warrantyMonths = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       categoryId = Value(categoryId),
       hsnCode = Value(hsnCode),
       gstRate = Value(gstRate),
       uom = Value(uom),
       lowStockLimit = Value(lowStockLimit),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? categoryId,
    Expression<String>? imageUrl,
    Expression<double>? mrp,
    Expression<double>? sellingPrice,
    Expression<double>? purchaseRate,
    Expression<bool>? isTaxInclusive,
    Expression<String>? hsnCode,
    Expression<double>? gstRate,
    Expression<double>? cessRate,
    Expression<bool>? isExempt,
    Expression<bool>? isInfiniteStock,
    Expression<String>? uom,
    Expression<double>? lowStockLimit,
    Expression<bool>? isLooseItem,
    Expression<bool>? batchTracking,
    Expression<int>? warrantyMonths,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (imageUrl != null) 'image_url': imageUrl,
      if (mrp != null) 'mrp': mrp,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (purchaseRate != null) 'purchase_rate': purchaseRate,
      if (isTaxInclusive != null) 'is_tax_inclusive': isTaxInclusive,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (gstRate != null) 'gst_rate': gstRate,
      if (cessRate != null) 'cess_rate': cessRate,
      if (isExempt != null) 'is_exempt': isExempt,
      if (isInfiniteStock != null) 'is_infinite_stock': isInfiniteStock,
      if (uom != null) 'uom': uom,
      if (lowStockLimit != null) 'low_stock_limit': lowStockLimit,
      if (isLooseItem != null) 'is_loose_item': isLooseItem,
      if (batchTracking != null) 'batch_tracking': batchTracking,
      if (warrantyMonths != null) 'warranty_months': warrantyMonths,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? categoryId,
    Value<String?>? imageUrl,
    Value<double>? mrp,
    Value<double>? sellingPrice,
    Value<double>? purchaseRate,
    Value<bool>? isTaxInclusive,
    Value<String>? hsnCode,
    Value<double>? gstRate,
    Value<double>? cessRate,
    Value<bool>? isExempt,
    Value<bool?>? isInfiniteStock,
    Value<String>? uom,
    Value<double>? lowStockLimit,
    Value<bool>? isLooseItem,
    Value<bool>? batchTracking,
    Value<int>? warrantyMonths,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      mrp: mrp ?? this.mrp,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      purchaseRate: purchaseRate ?? this.purchaseRate,
      isTaxInclusive: isTaxInclusive ?? this.isTaxInclusive,
      hsnCode: hsnCode ?? this.hsnCode,
      gstRate: gstRate ?? this.gstRate,
      cessRate: cessRate ?? this.cessRate,
      isExempt: isExempt ?? this.isExempt,
      isInfiniteStock: isInfiniteStock ?? this.isInfiniteStock,
      uom: uom ?? this.uom,
      lowStockLimit: lowStockLimit ?? this.lowStockLimit,
      isLooseItem: isLooseItem ?? this.isLooseItem,
      batchTracking: batchTracking ?? this.batchTracking,
      warrantyMonths: warrantyMonths ?? this.warrantyMonths,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (mrp.present) {
      map['mrp'] = Variable<double>(mrp.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    if (purchaseRate.present) {
      map['purchase_rate'] = Variable<double>(purchaseRate.value);
    }
    if (isTaxInclusive.present) {
      map['is_tax_inclusive'] = Variable<bool>(isTaxInclusive.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (gstRate.present) {
      map['gst_rate'] = Variable<double>(gstRate.value);
    }
    if (cessRate.present) {
      map['cess_rate'] = Variable<double>(cessRate.value);
    }
    if (isExempt.present) {
      map['is_exempt'] = Variable<bool>(isExempt.value);
    }
    if (isInfiniteStock.present) {
      map['is_infinite_stock'] = Variable<bool>(isInfiniteStock.value);
    }
    if (uom.present) {
      map['uom'] = Variable<String>(uom.value);
    }
    if (lowStockLimit.present) {
      map['low_stock_limit'] = Variable<double>(lowStockLimit.value);
    }
    if (isLooseItem.present) {
      map['is_loose_item'] = Variable<bool>(isLooseItem.value);
    }
    if (batchTracking.present) {
      map['batch_tracking'] = Variable<bool>(batchTracking.value);
    }
    if (warrantyMonths.present) {
      map['warranty_months'] = Variable<int>(warrantyMonths.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('mrp: $mrp, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('purchaseRate: $purchaseRate, ')
          ..write('isTaxInclusive: $isTaxInclusive, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('gstRate: $gstRate, ')
          ..write('cessRate: $cessRate, ')
          ..write('isExempt: $isExempt, ')
          ..write('isInfiniteStock: $isInfiniteStock, ')
          ..write('uom: $uom, ')
          ..write('lowStockLimit: $lowStockLimit, ')
          ..write('isLooseItem: $isLooseItem, ')
          ..write('batchTracking: $batchTracking, ')
          ..write('warrantyMonths: $warrantyMonths, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VendorsTable extends Vendors with TableInfo<$VendorsTable, Vendor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VendorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactMeta = const VerificationMeta(
    'contact',
  );
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
    'contact',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
    'gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta(
    'stateCode',
  );
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    contact,
    email,
    gstin,
    stateCode,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vendors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vendor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('contact')) {
      context.handle(
        _contactMeta,
        contact.isAcceptableOrUnknown(data['contact']!, _contactMeta),
      );
    } else if (isInserting) {
      context.missing(_contactMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('gstin')) {
      context.handle(
        _gstinMeta,
        gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta),
      );
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vendor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vendor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      contact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      gstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gstin'],
      ),
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $VendorsTable createAlias(String alias) {
    return $VendorsTable(attachedDatabase, alias);
  }
}

class Vendor extends DataClass implements Insertable<Vendor> {
  final String id;
  final String name;
  final String address;
  final String contact;
  final String? email;
  final String? gstin;
  final String? stateCode;
  final bool isActive;
  const Vendor({
    required this.id,
    required this.name,
    required this.address,
    required this.contact,
    this.email,
    this.gstin,
    this.stateCode,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['contact'] = Variable<String>(contact);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || stateCode != null) {
      map['state_code'] = Variable<String>(stateCode);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  VendorsCompanion toCompanion(bool nullToAbsent) {
    return VendorsCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      contact: Value(contact),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      gstin: gstin == null && nullToAbsent
          ? const Value.absent()
          : Value(gstin),
      stateCode: stateCode == null && nullToAbsent
          ? const Value.absent()
          : Value(stateCode),
      isActive: Value(isActive),
    );
  }

  factory Vendor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vendor(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      contact: serializer.fromJson<String>(json['contact']),
      email: serializer.fromJson<String?>(json['email']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      stateCode: serializer.fromJson<String?>(json['stateCode']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'contact': serializer.toJson<String>(contact),
      'email': serializer.toJson<String?>(email),
      'gstin': serializer.toJson<String?>(gstin),
      'stateCode': serializer.toJson<String?>(stateCode),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Vendor copyWith({
    String? id,
    String? name,
    String? address,
    String? contact,
    Value<String?> email = const Value.absent(),
    Value<String?> gstin = const Value.absent(),
    Value<String?> stateCode = const Value.absent(),
    bool? isActive,
  }) => Vendor(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address ?? this.address,
    contact: contact ?? this.contact,
    email: email.present ? email.value : this.email,
    gstin: gstin.present ? gstin.value : this.gstin,
    stateCode: stateCode.present ? stateCode.value : this.stateCode,
    isActive: isActive ?? this.isActive,
  );
  Vendor copyWithCompanion(VendorsCompanion data) {
    return Vendor(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      contact: data.contact.present ? data.contact.value : this.contact,
      email: data.email.present ? data.email.value : this.email,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vendor(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('contact: $contact, ')
          ..write('email: $email, ')
          ..write('gstin: $gstin, ')
          ..write('stateCode: $stateCode, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    address,
    contact,
    email,
    gstin,
    stateCode,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vendor &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.contact == this.contact &&
          other.email == this.email &&
          other.gstin == this.gstin &&
          other.stateCode == this.stateCode &&
          other.isActive == this.isActive);
}

class VendorsCompanion extends UpdateCompanion<Vendor> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> address;
  final Value<String> contact;
  final Value<String?> email;
  final Value<String?> gstin;
  final Value<String?> stateCode;
  final Value<bool> isActive;
  final Value<int> rowid;
  const VendorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.contact = const Value.absent(),
    this.email = const Value.absent(),
    this.gstin = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VendorsCompanion.insert({
    required String id,
    required String name,
    required String address,
    required String contact,
    this.email = const Value.absent(),
    this.gstin = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       address = Value(address),
       contact = Value(contact);
  static Insertable<Vendor> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? contact,
    Expression<String>? email,
    Expression<String>? gstin,
    Expression<String>? stateCode,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (contact != null) 'contact': contact,
      if (email != null) 'email': email,
      if (gstin != null) 'gstin': gstin,
      if (stateCode != null) 'state_code': stateCode,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VendorsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? address,
    Value<String>? contact,
    Value<String?>? email,
    Value<String?>? gstin,
    Value<String?>? stateCode,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return VendorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      gstin: gstin ?? this.gstin,
      stateCode: stateCode ?? this.stateCode,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VendorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('contact: $contact, ')
          ..write('email: $email, ')
          ..write('gstin: $gstin, ')
          ..write('stateCode: $stateCode, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  const Category({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(id: Value(id), name: Value(name));
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Category copyWith({String? id, String? name}) =>
      Category(id: id ?? this.id, name: name ?? this.name);
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category && other.id == this.id && other.name == this.name);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrandsTable extends Brands with TableInfo<$BrandsTable, Brand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brands';
  @override
  VerificationContext validateIntegrity(
    Insertable<Brand> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Brand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Brand(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $BrandsTable createAlias(String alias) {
    return $BrandsTable(attachedDatabase, alias);
  }
}

class Brand extends DataClass implements Insertable<Brand> {
  final String id;
  final String name;
  const Brand({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  BrandsCompanion toCompanion(bool nullToAbsent) {
    return BrandsCompanion(id: Value(id), name: Value(name));
  }

  factory Brand.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Brand(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Brand copyWith({String? id, String? name}) =>
      Brand(id: id ?? this.id, name: name ?? this.name);
  Brand copyWithCompanion(BrandsCompanion data) {
    return Brand(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Brand(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Brand && other.id == this.id && other.name == this.name);
}

class BrandsCompanion extends UpdateCompanion<Brand> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const BrandsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrandsCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Brand> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrandsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return BrandsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrandsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseOrdersTable extends PurchaseOrders
    with TableInfo<$PurchaseOrdersTable, PurchaseOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poNumberMeta = const VerificationMeta(
    'poNumber',
  );
  @override
  late final GeneratedColumn<String> poNumber = GeneratedColumn<String>(
    'po_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<String> vendorId = GeneratedColumn<String>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedDeliveryDateMeta =
      const VerificationMeta('expectedDeliveryDate');
  @override
  late final GeneratedColumn<DateTime> expectedDeliveryDate =
      GeneratedColumn<DateTime>(
        'expected_delivery_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Draft'),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grnIdMeta = const VerificationMeta('grnId');
  @override
  late final GeneratedColumn<String> grnId = GeneratedColumn<String>(
    'grn_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grnNumberMeta = const VerificationMeta(
    'grnNumber',
  );
  @override
  late final GeneratedColumn<String> grnNumber = GeneratedColumn<String>(
    'grn_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _challanNumberMeta = const VerificationMeta(
    'challanNumber',
  );
  @override
  late final GeneratedColumn<String> challanNumber = GeneratedColumn<String>(
    'challan_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    poNumber,
    vendorId,
    date,
    expectedDeliveryDate,
    status,
    totalAmount,
    grnId,
    grnNumber,
    challanNumber,
    userId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseOrder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('po_number')) {
      context.handle(
        _poNumberMeta,
        poNumber.isAcceptableOrUnknown(data['po_number']!, _poNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_poNumberMeta);
    }
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('expected_delivery_date')) {
      context.handle(
        _expectedDeliveryDateMeta,
        expectedDeliveryDate.isAcceptableOrUnknown(
          data['expected_delivery_date']!,
          _expectedDeliveryDateMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('grn_id')) {
      context.handle(
        _grnIdMeta,
        grnId.isAcceptableOrUnknown(data['grn_id']!, _grnIdMeta),
      );
    }
    if (data.containsKey('grn_number')) {
      context.handle(
        _grnNumberMeta,
        grnNumber.isAcceptableOrUnknown(data['grn_number']!, _grnNumberMeta),
      );
    }
    if (data.containsKey('challan_number')) {
      context.handle(
        _challanNumberMeta,
        challanNumber.isAcceptableOrUnknown(
          data['challan_number']!,
          _challanNumberMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseOrder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      poNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}po_number'],
      )!,
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      expectedDeliveryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expected_delivery_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      grnId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grn_id'],
      ),
      grnNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grn_number'],
      ),
      challanNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challan_number'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PurchaseOrdersTable createAlias(String alias) {
    return $PurchaseOrdersTable(attachedDatabase, alias);
  }
}

class PurchaseOrder extends DataClass implements Insertable<PurchaseOrder> {
  final String id;
  final String poNumber;
  final String vendorId;
  final DateTime date;
  final DateTime? expectedDeliveryDate;
  final String status;
  final double totalAmount;
  final String? grnId;
  final String? grnNumber;
  final String? challanNumber;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PurchaseOrder({
    required this.id,
    required this.poNumber,
    required this.vendorId,
    required this.date,
    this.expectedDeliveryDate,
    required this.status,
    required this.totalAmount,
    this.grnId,
    this.grnNumber,
    this.challanNumber,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['po_number'] = Variable<String>(poNumber);
    map['vendor_id'] = Variable<String>(vendorId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || expectedDeliveryDate != null) {
      map['expected_delivery_date'] = Variable<DateTime>(expectedDeliveryDate);
    }
    map['status'] = Variable<String>(status);
    map['total_amount'] = Variable<double>(totalAmount);
    if (!nullToAbsent || grnId != null) {
      map['grn_id'] = Variable<String>(grnId);
    }
    if (!nullToAbsent || grnNumber != null) {
      map['grn_number'] = Variable<String>(grnNumber);
    }
    if (!nullToAbsent || challanNumber != null) {
      map['challan_number'] = Variable<String>(challanNumber);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PurchaseOrdersCompanion toCompanion(bool nullToAbsent) {
    return PurchaseOrdersCompanion(
      id: Value(id),
      poNumber: Value(poNumber),
      vendorId: Value(vendorId),
      date: Value(date),
      expectedDeliveryDate: expectedDeliveryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedDeliveryDate),
      status: Value(status),
      totalAmount: Value(totalAmount),
      grnId: grnId == null && nullToAbsent
          ? const Value.absent()
          : Value(grnId),
      grnNumber: grnNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(grnNumber),
      challanNumber: challanNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(challanNumber),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PurchaseOrder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseOrder(
      id: serializer.fromJson<String>(json['id']),
      poNumber: serializer.fromJson<String>(json['poNumber']),
      vendorId: serializer.fromJson<String>(json['vendorId']),
      date: serializer.fromJson<DateTime>(json['date']),
      expectedDeliveryDate: serializer.fromJson<DateTime?>(
        json['expectedDeliveryDate'],
      ),
      status: serializer.fromJson<String>(json['status']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      grnId: serializer.fromJson<String?>(json['grnId']),
      grnNumber: serializer.fromJson<String?>(json['grnNumber']),
      challanNumber: serializer.fromJson<String?>(json['challanNumber']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'poNumber': serializer.toJson<String>(poNumber),
      'vendorId': serializer.toJson<String>(vendorId),
      'date': serializer.toJson<DateTime>(date),
      'expectedDeliveryDate': serializer.toJson<DateTime?>(
        expectedDeliveryDate,
      ),
      'status': serializer.toJson<String>(status),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'grnId': serializer.toJson<String?>(grnId),
      'grnNumber': serializer.toJson<String?>(grnNumber),
      'challanNumber': serializer.toJson<String?>(challanNumber),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PurchaseOrder copyWith({
    String? id,
    String? poNumber,
    String? vendorId,
    DateTime? date,
    Value<DateTime?> expectedDeliveryDate = const Value.absent(),
    String? status,
    double? totalAmount,
    Value<String?> grnId = const Value.absent(),
    Value<String?> grnNumber = const Value.absent(),
    Value<String?> challanNumber = const Value.absent(),
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PurchaseOrder(
    id: id ?? this.id,
    poNumber: poNumber ?? this.poNumber,
    vendorId: vendorId ?? this.vendorId,
    date: date ?? this.date,
    expectedDeliveryDate: expectedDeliveryDate.present
        ? expectedDeliveryDate.value
        : this.expectedDeliveryDate,
    status: status ?? this.status,
    totalAmount: totalAmount ?? this.totalAmount,
    grnId: grnId.present ? grnId.value : this.grnId,
    grnNumber: grnNumber.present ? grnNumber.value : this.grnNumber,
    challanNumber: challanNumber.present
        ? challanNumber.value
        : this.challanNumber,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PurchaseOrder copyWithCompanion(PurchaseOrdersCompanion data) {
    return PurchaseOrder(
      id: data.id.present ? data.id.value : this.id,
      poNumber: data.poNumber.present ? data.poNumber.value : this.poNumber,
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      date: data.date.present ? data.date.value : this.date,
      expectedDeliveryDate: data.expectedDeliveryDate.present
          ? data.expectedDeliveryDate.value
          : this.expectedDeliveryDate,
      status: data.status.present ? data.status.value : this.status,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      grnId: data.grnId.present ? data.grnId.value : this.grnId,
      grnNumber: data.grnNumber.present ? data.grnNumber.value : this.grnNumber,
      challanNumber: data.challanNumber.present
          ? data.challanNumber.value
          : this.challanNumber,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrder(')
          ..write('id: $id, ')
          ..write('poNumber: $poNumber, ')
          ..write('vendorId: $vendorId, ')
          ..write('date: $date, ')
          ..write('expectedDeliveryDate: $expectedDeliveryDate, ')
          ..write('status: $status, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('grnId: $grnId, ')
          ..write('grnNumber: $grnNumber, ')
          ..write('challanNumber: $challanNumber, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    poNumber,
    vendorId,
    date,
    expectedDeliveryDate,
    status,
    totalAmount,
    grnId,
    grnNumber,
    challanNumber,
    userId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseOrder &&
          other.id == this.id &&
          other.poNumber == this.poNumber &&
          other.vendorId == this.vendorId &&
          other.date == this.date &&
          other.expectedDeliveryDate == this.expectedDeliveryDate &&
          other.status == this.status &&
          other.totalAmount == this.totalAmount &&
          other.grnId == this.grnId &&
          other.grnNumber == this.grnNumber &&
          other.challanNumber == this.challanNumber &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PurchaseOrdersCompanion extends UpdateCompanion<PurchaseOrder> {
  final Value<String> id;
  final Value<String> poNumber;
  final Value<String> vendorId;
  final Value<DateTime> date;
  final Value<DateTime?> expectedDeliveryDate;
  final Value<String> status;
  final Value<double> totalAmount;
  final Value<String?> grnId;
  final Value<String?> grnNumber;
  final Value<String?> challanNumber;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PurchaseOrdersCompanion({
    this.id = const Value.absent(),
    this.poNumber = const Value.absent(),
    this.vendorId = const Value.absent(),
    this.date = const Value.absent(),
    this.expectedDeliveryDate = const Value.absent(),
    this.status = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.grnId = const Value.absent(),
    this.grnNumber = const Value.absent(),
    this.challanNumber = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseOrdersCompanion.insert({
    required String id,
    required String poNumber,
    required String vendorId,
    required DateTime date,
    this.expectedDeliveryDate = const Value.absent(),
    this.status = const Value.absent(),
    required double totalAmount,
    this.grnId = const Value.absent(),
    this.grnNumber = const Value.absent(),
    this.challanNumber = const Value.absent(),
    this.userId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       poNumber = Value(poNumber),
       vendorId = Value(vendorId),
       date = Value(date),
       totalAmount = Value(totalAmount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PurchaseOrder> custom({
    Expression<String>? id,
    Expression<String>? poNumber,
    Expression<String>? vendorId,
    Expression<DateTime>? date,
    Expression<DateTime>? expectedDeliveryDate,
    Expression<String>? status,
    Expression<double>? totalAmount,
    Expression<String>? grnId,
    Expression<String>? grnNumber,
    Expression<String>? challanNumber,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (poNumber != null) 'po_number': poNumber,
      if (vendorId != null) 'vendor_id': vendorId,
      if (date != null) 'date': date,
      if (expectedDeliveryDate != null)
        'expected_delivery_date': expectedDeliveryDate,
      if (status != null) 'status': status,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (grnId != null) 'grn_id': grnId,
      if (grnNumber != null) 'grn_number': grnNumber,
      if (challanNumber != null) 'challan_number': challanNumber,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseOrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? poNumber,
    Value<String>? vendorId,
    Value<DateTime>? date,
    Value<DateTime?>? expectedDeliveryDate,
    Value<String>? status,
    Value<double>? totalAmount,
    Value<String?>? grnId,
    Value<String?>? grnNumber,
    Value<String?>? challanNumber,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PurchaseOrdersCompanion(
      id: id ?? this.id,
      poNumber: poNumber ?? this.poNumber,
      vendorId: vendorId ?? this.vendorId,
      date: date ?? this.date,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      grnId: grnId ?? this.grnId,
      grnNumber: grnNumber ?? this.grnNumber,
      challanNumber: challanNumber ?? this.challanNumber,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (poNumber.present) {
      map['po_number'] = Variable<String>(poNumber.value);
    }
    if (vendorId.present) {
      map['vendor_id'] = Variable<String>(vendorId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (expectedDeliveryDate.present) {
      map['expected_delivery_date'] = Variable<DateTime>(
        expectedDeliveryDate.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (grnId.present) {
      map['grn_id'] = Variable<String>(grnId.value);
    }
    if (grnNumber.present) {
      map['grn_number'] = Variable<String>(grnNumber.value);
    }
    if (challanNumber.present) {
      map['challan_number'] = Variable<String>(challanNumber.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrdersCompanion(')
          ..write('id: $id, ')
          ..write('poNumber: $poNumber, ')
          ..write('vendorId: $vendorId, ')
          ..write('date: $date, ')
          ..write('expectedDeliveryDate: $expectedDeliveryDate, ')
          ..write('status: $status, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('grnId: $grnId, ')
          ..write('grnNumber: $grnNumber, ')
          ..write('challanNumber: $challanNumber, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseOrderItemsTable extends PurchaseOrderItems
    with TableInfo<$PurchaseOrderItemsTable, PurchaseOrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseOrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _poIdMeta = const VerificationMeta('poId');
  @override
  late final GeneratedColumn<String> poId = GeneratedColumn<String>(
    'po_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cessRateMeta = const VerificationMeta(
    'cessRate',
  );
  @override
  late final GeneratedColumn<double> cessRate = GeneratedColumn<double>(
    'cess_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uomMeta = const VerificationMeta('uom');
  @override
  late final GeneratedColumn<String> uom = GeneratedColumn<String>(
    'uom',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conversionFactorMeta = const VerificationMeta(
    'conversionFactor',
  );
  @override
  late final GeneratedColumn<double> conversionFactor = GeneratedColumn<double>(
    'conversion_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _receivedQuantityMeta = const VerificationMeta(
    'receivedQuantity',
  );
  @override
  late final GeneratedColumn<int> receivedQuantity = GeneratedColumn<int>(
    'received_quantity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    poId,
    productId,
    quantity,
    unitPrice,
    productName,
    hsnCode,
    taxRate,
    cessRate,
    uom,
    conversionFactor,
    receivedQuantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseOrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('po_id')) {
      context.handle(
        _poIdMeta,
        poId.isAcceptableOrUnknown(data['po_id']!, _poIdMeta),
      );
    } else if (isInserting) {
      context.missing(_poIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    } else if (isInserting) {
      context.missing(_taxRateMeta);
    }
    if (data.containsKey('cess_rate')) {
      context.handle(
        _cessRateMeta,
        cessRate.isAcceptableOrUnknown(data['cess_rate']!, _cessRateMeta),
      );
    } else if (isInserting) {
      context.missing(_cessRateMeta);
    }
    if (data.containsKey('uom')) {
      context.handle(
        _uomMeta,
        uom.isAcceptableOrUnknown(data['uom']!, _uomMeta),
      );
    }
    if (data.containsKey('conversion_factor')) {
      context.handle(
        _conversionFactorMeta,
        conversionFactor.isAcceptableOrUnknown(
          data['conversion_factor']!,
          _conversionFactorMeta,
        ),
      );
    }
    if (data.containsKey('received_quantity')) {
      context.handle(
        _receivedQuantityMeta,
        receivedQuantity.isAcceptableOrUnknown(
          data['received_quantity']!,
          _receivedQuantityMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseOrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseOrderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      poId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}po_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      ),
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      cessRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cess_rate'],
      )!,
      uom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uom'],
      ),
      conversionFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}conversion_factor'],
      )!,
      receivedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}received_quantity'],
      ),
    );
  }

  @override
  $PurchaseOrderItemsTable createAlias(String alias) {
    return $PurchaseOrderItemsTable(attachedDatabase, alias);
  }
}

class PurchaseOrderItem extends DataClass
    implements Insertable<PurchaseOrderItem> {
  final int id;
  final String poId;
  final String productId;
  final int quantity;
  final double unitPrice;
  final String productName;
  final String? hsnCode;
  final double taxRate;
  final double cessRate;
  final String? uom;
  final double conversionFactor;
  final int? receivedQuantity;
  const PurchaseOrderItem({
    required this.id,
    required this.poId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.productName,
    this.hsnCode,
    required this.taxRate,
    required this.cessRate,
    this.uom,
    required this.conversionFactor,
    this.receivedQuantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['po_id'] = Variable<String>(poId);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    map['tax_rate'] = Variable<double>(taxRate);
    map['cess_rate'] = Variable<double>(cessRate);
    if (!nullToAbsent || uom != null) {
      map['uom'] = Variable<String>(uom);
    }
    map['conversion_factor'] = Variable<double>(conversionFactor);
    if (!nullToAbsent || receivedQuantity != null) {
      map['received_quantity'] = Variable<int>(receivedQuantity);
    }
    return map;
  }

  PurchaseOrderItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseOrderItemsCompanion(
      id: Value(id),
      poId: Value(poId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      productName: Value(productName),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      taxRate: Value(taxRate),
      cessRate: Value(cessRate),
      uom: uom == null && nullToAbsent ? const Value.absent() : Value(uom),
      conversionFactor: Value(conversionFactor),
      receivedQuantity: receivedQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(receivedQuantity),
    );
  }

  factory PurchaseOrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseOrderItem(
      id: serializer.fromJson<int>(json['id']),
      poId: serializer.fromJson<String>(json['poId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      productName: serializer.fromJson<String>(json['productName']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      cessRate: serializer.fromJson<double>(json['cessRate']),
      uom: serializer.fromJson<String?>(json['uom']),
      conversionFactor: serializer.fromJson<double>(json['conversionFactor']),
      receivedQuantity: serializer.fromJson<int?>(json['receivedQuantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'poId': serializer.toJson<String>(poId),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'productName': serializer.toJson<String>(productName),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'taxRate': serializer.toJson<double>(taxRate),
      'cessRate': serializer.toJson<double>(cessRate),
      'uom': serializer.toJson<String?>(uom),
      'conversionFactor': serializer.toJson<double>(conversionFactor),
      'receivedQuantity': serializer.toJson<int?>(receivedQuantity),
    };
  }

  PurchaseOrderItem copyWith({
    int? id,
    String? poId,
    String? productId,
    int? quantity,
    double? unitPrice,
    String? productName,
    Value<String?> hsnCode = const Value.absent(),
    double? taxRate,
    double? cessRate,
    Value<String?> uom = const Value.absent(),
    double? conversionFactor,
    Value<int?> receivedQuantity = const Value.absent(),
  }) => PurchaseOrderItem(
    id: id ?? this.id,
    poId: poId ?? this.poId,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    productName: productName ?? this.productName,
    hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
    taxRate: taxRate ?? this.taxRate,
    cessRate: cessRate ?? this.cessRate,
    uom: uom.present ? uom.value : this.uom,
    conversionFactor: conversionFactor ?? this.conversionFactor,
    receivedQuantity: receivedQuantity.present
        ? receivedQuantity.value
        : this.receivedQuantity,
  );
  PurchaseOrderItem copyWithCompanion(PurchaseOrderItemsCompanion data) {
    return PurchaseOrderItem(
      id: data.id.present ? data.id.value : this.id,
      poId: data.poId.present ? data.poId.value : this.poId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      cessRate: data.cessRate.present ? data.cessRate.value : this.cessRate,
      uom: data.uom.present ? data.uom.value : this.uom,
      conversionFactor: data.conversionFactor.present
          ? data.conversionFactor.value
          : this.conversionFactor,
      receivedQuantity: data.receivedQuantity.present
          ? data.receivedQuantity.value
          : this.receivedQuantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrderItem(')
          ..write('id: $id, ')
          ..write('poId: $poId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('productName: $productName, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('taxRate: $taxRate, ')
          ..write('cessRate: $cessRate, ')
          ..write('uom: $uom, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('receivedQuantity: $receivedQuantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    poId,
    productId,
    quantity,
    unitPrice,
    productName,
    hsnCode,
    taxRate,
    cessRate,
    uom,
    conversionFactor,
    receivedQuantity,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseOrderItem &&
          other.id == this.id &&
          other.poId == this.poId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.productName == this.productName &&
          other.hsnCode == this.hsnCode &&
          other.taxRate == this.taxRate &&
          other.cessRate == this.cessRate &&
          other.uom == this.uom &&
          other.conversionFactor == this.conversionFactor &&
          other.receivedQuantity == this.receivedQuantity);
}

class PurchaseOrderItemsCompanion extends UpdateCompanion<PurchaseOrderItem> {
  final Value<int> id;
  final Value<String> poId;
  final Value<String> productId;
  final Value<int> quantity;
  final Value<double> unitPrice;
  final Value<String> productName;
  final Value<String?> hsnCode;
  final Value<double> taxRate;
  final Value<double> cessRate;
  final Value<String?> uom;
  final Value<double> conversionFactor;
  final Value<int?> receivedQuantity;
  const PurchaseOrderItemsCompanion({
    this.id = const Value.absent(),
    this.poId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.productName = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.cessRate = const Value.absent(),
    this.uom = const Value.absent(),
    this.conversionFactor = const Value.absent(),
    this.receivedQuantity = const Value.absent(),
  });
  PurchaseOrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required String poId,
    required String productId,
    required int quantity,
    required double unitPrice,
    required String productName,
    this.hsnCode = const Value.absent(),
    required double taxRate,
    required double cessRate,
    this.uom = const Value.absent(),
    this.conversionFactor = const Value.absent(),
    this.receivedQuantity = const Value.absent(),
  }) : poId = Value(poId),
       productId = Value(productId),
       quantity = Value(quantity),
       unitPrice = Value(unitPrice),
       productName = Value(productName),
       taxRate = Value(taxRate),
       cessRate = Value(cessRate);
  static Insertable<PurchaseOrderItem> custom({
    Expression<int>? id,
    Expression<String>? poId,
    Expression<String>? productId,
    Expression<int>? quantity,
    Expression<double>? unitPrice,
    Expression<String>? productName,
    Expression<String>? hsnCode,
    Expression<double>? taxRate,
    Expression<double>? cessRate,
    Expression<String>? uom,
    Expression<double>? conversionFactor,
    Expression<int>? receivedQuantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (poId != null) 'po_id': poId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (productName != null) 'product_name': productName,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (taxRate != null) 'tax_rate': taxRate,
      if (cessRate != null) 'cess_rate': cessRate,
      if (uom != null) 'uom': uom,
      if (conversionFactor != null) 'conversion_factor': conversionFactor,
      if (receivedQuantity != null) 'received_quantity': receivedQuantity,
    });
  }

  PurchaseOrderItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? poId,
    Value<String>? productId,
    Value<int>? quantity,
    Value<double>? unitPrice,
    Value<String>? productName,
    Value<String?>? hsnCode,
    Value<double>? taxRate,
    Value<double>? cessRate,
    Value<String?>? uom,
    Value<double>? conversionFactor,
    Value<int?>? receivedQuantity,
  }) {
    return PurchaseOrderItemsCompanion(
      id: id ?? this.id,
      poId: poId ?? this.poId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      productName: productName ?? this.productName,
      hsnCode: hsnCode ?? this.hsnCode,
      taxRate: taxRate ?? this.taxRate,
      cessRate: cessRate ?? this.cessRate,
      uom: uom ?? this.uom,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      receivedQuantity: receivedQuantity ?? this.receivedQuantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (poId.present) {
      map['po_id'] = Variable<String>(poId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (cessRate.present) {
      map['cess_rate'] = Variable<double>(cessRate.value);
    }
    if (uom.present) {
      map['uom'] = Variable<String>(uom.value);
    }
    if (conversionFactor.present) {
      map['conversion_factor'] = Variable<double>(conversionFactor.value);
    }
    if (receivedQuantity.present) {
      map['received_quantity'] = Variable<int>(receivedQuantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('poId: $poId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('productName: $productName, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('taxRate: $taxRate, ')
          ..write('cessRate: $cessRate, ')
          ..write('uom: $uom, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('receivedQuantity: $receivedQuantity')
          ..write(')'))
        .toString();
  }
}

class $DebitNotesTable extends DebitNotes
    with TableInfo<$DebitNotesTable, DebitNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebitNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<String> vendorId = GeneratedColumn<String>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poIdMeta = const VerificationMeta('poId');
  @override
  late final GeneratedColumn<String> poId = GeneratedColumn<String>(
    'po_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vendorId,
    poId,
    date,
    amount,
    reason,
    notes,
    status,
    userId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debit_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebitNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('po_id')) {
      context.handle(
        _poIdMeta,
        poId.isAcceptableOrUnknown(data['po_id']!, _poIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebitNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebitNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_id'],
      )!,
      poId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}po_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
    );
  }

  @override
  $DebitNotesTable createAlias(String alias) {
    return $DebitNotesTable(attachedDatabase, alias);
  }
}

class DebitNote extends DataClass implements Insertable<DebitNote> {
  final String id;
  final String vendorId;
  final String? poId;
  final DateTime date;
  final double amount;
  final String reason;
  final String? notes;
  final String status;
  final String? userId;
  const DebitNote({
    required this.id,
    required this.vendorId,
    this.poId,
    required this.date,
    required this.amount,
    required this.reason,
    this.notes,
    required this.status,
    this.userId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vendor_id'] = Variable<String>(vendorId);
    if (!nullToAbsent || poId != null) {
      map['po_id'] = Variable<String>(poId);
    }
    map['date'] = Variable<DateTime>(date);
    map['amount'] = Variable<double>(amount);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  DebitNotesCompanion toCompanion(bool nullToAbsent) {
    return DebitNotesCompanion(
      id: Value(id),
      vendorId: Value(vendorId),
      poId: poId == null && nullToAbsent ? const Value.absent() : Value(poId),
      date: Value(date),
      amount: Value(amount),
      reason: Value(reason),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
    );
  }

  factory DebitNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebitNote(
      id: serializer.fromJson<String>(json['id']),
      vendorId: serializer.fromJson<String>(json['vendorId']),
      poId: serializer.fromJson<String?>(json['poId']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<double>(json['amount']),
      reason: serializer.fromJson<String>(json['reason']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vendorId': serializer.toJson<String>(vendorId),
      'poId': serializer.toJson<String?>(poId),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<double>(amount),
      'reason': serializer.toJson<String>(reason),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  DebitNote copyWith({
    String? id,
    String? vendorId,
    Value<String?> poId = const Value.absent(),
    DateTime? date,
    double? amount,
    String? reason,
    Value<String?> notes = const Value.absent(),
    String? status,
    Value<String?> userId = const Value.absent(),
  }) => DebitNote(
    id: id ?? this.id,
    vendorId: vendorId ?? this.vendorId,
    poId: poId.present ? poId.value : this.poId,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    reason: reason ?? this.reason,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
    userId: userId.present ? userId.value : this.userId,
  );
  DebitNote copyWithCompanion(DebitNotesCompanion data) {
    return DebitNote(
      id: data.id.present ? data.id.value : this.id,
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      poId: data.poId.present ? data.poId.value : this.poId,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      reason: data.reason.present ? data.reason.value : this.reason,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebitNote(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('poId: $poId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vendorId,
    poId,
    date,
    amount,
    reason,
    notes,
    status,
    userId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebitNote &&
          other.id == this.id &&
          other.vendorId == this.vendorId &&
          other.poId == this.poId &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.reason == this.reason &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.userId == this.userId);
}

class DebitNotesCompanion extends UpdateCompanion<DebitNote> {
  final Value<String> id;
  final Value<String> vendorId;
  final Value<String?> poId;
  final Value<DateTime> date;
  final Value<double> amount;
  final Value<String> reason;
  final Value<String?> notes;
  final Value<String> status;
  final Value<String?> userId;
  final Value<int> rowid;
  const DebitNotesCompanion({
    this.id = const Value.absent(),
    this.vendorId = const Value.absent(),
    this.poId = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.reason = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DebitNotesCompanion.insert({
    required String id,
    required String vendorId,
    this.poId = const Value.absent(),
    required DateTime date,
    required double amount,
    required String reason,
    this.notes = const Value.absent(),
    required String status,
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vendorId = Value(vendorId),
       date = Value(date),
       amount = Value(amount),
       reason = Value(reason),
       status = Value(status);
  static Insertable<DebitNote> custom({
    Expression<String>? id,
    Expression<String>? vendorId,
    Expression<String>? poId,
    Expression<DateTime>? date,
    Expression<double>? amount,
    Expression<String>? reason,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vendorId != null) 'vendor_id': vendorId,
      if (poId != null) 'po_id': poId,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (reason != null) 'reason': reason,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DebitNotesCompanion copyWith({
    Value<String>? id,
    Value<String>? vendorId,
    Value<String?>? poId,
    Value<DateTime>? date,
    Value<double>? amount,
    Value<String>? reason,
    Value<String?>? notes,
    Value<String>? status,
    Value<String?>? userId,
    Value<int>? rowid,
  }) {
    return DebitNotesCompanion(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      poId: poId ?? this.poId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vendorId.present) {
      map['vendor_id'] = Variable<String>(vendorId.value);
    }
    if (poId.present) {
      map['po_id'] = Variable<String>(poId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebitNotesCompanion(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('poId: $poId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DebitNoteItemsTable extends DebitNoteItems
    with TableInfo<$DebitNoteItemsTable, DebitNoteItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebitNoteItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dnIdMeta = const VerificationMeta('dnId');
  @override
  late final GeneratedColumn<String> dnId = GeneratedColumn<String>(
    'dn_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderedQtyMeta = const VerificationMeta(
    'orderedQty',
  );
  @override
  late final GeneratedColumn<int> orderedQty = GeneratedColumn<int>(
    'ordered_qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rejectedQtyMeta = const VerificationMeta(
    'rejectedQty',
  );
  @override
  late final GeneratedColumn<int> rejectedQty = GeneratedColumn<int>(
    'rejected_qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dnId,
    productId,
    productName,
    orderedQty,
    rejectedQty,
    reason,
    rate,
    taxRate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debit_note_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebitNoteItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dn_id')) {
      context.handle(
        _dnIdMeta,
        dnId.isAcceptableOrUnknown(data['dn_id']!, _dnIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dnIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('ordered_qty')) {
      context.handle(
        _orderedQtyMeta,
        orderedQty.isAcceptableOrUnknown(data['ordered_qty']!, _orderedQtyMeta),
      );
    } else if (isInserting) {
      context.missing(_orderedQtyMeta);
    }
    if (data.containsKey('rejected_qty')) {
      context.handle(
        _rejectedQtyMeta,
        rejectedQty.isAcceptableOrUnknown(
          data['rejected_qty']!,
          _rejectedQtyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rejectedQtyMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    } else if (isInserting) {
      context.missing(_taxRateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebitNoteItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebitNoteItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dnId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dn_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      orderedQty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordered_qty'],
      )!,
      rejectedQty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rejected_qty'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
    );
  }

  @override
  $DebitNoteItemsTable createAlias(String alias) {
    return $DebitNoteItemsTable(attachedDatabase, alias);
  }
}

class DebitNoteItem extends DataClass implements Insertable<DebitNoteItem> {
  final int id;
  final String dnId;
  final String productId;
  final String productName;
  final int orderedQty;
  final int rejectedQty;
  final String reason;
  final double rate;
  final double taxRate;
  const DebitNoteItem({
    required this.id,
    required this.dnId,
    required this.productId,
    required this.productName,
    required this.orderedQty,
    required this.rejectedQty,
    required this.reason,
    required this.rate,
    required this.taxRate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dn_id'] = Variable<String>(dnId);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    map['ordered_qty'] = Variable<int>(orderedQty);
    map['rejected_qty'] = Variable<int>(rejectedQty);
    map['reason'] = Variable<String>(reason);
    map['rate'] = Variable<double>(rate);
    map['tax_rate'] = Variable<double>(taxRate);
    return map;
  }

  DebitNoteItemsCompanion toCompanion(bool nullToAbsent) {
    return DebitNoteItemsCompanion(
      id: Value(id),
      dnId: Value(dnId),
      productId: Value(productId),
      productName: Value(productName),
      orderedQty: Value(orderedQty),
      rejectedQty: Value(rejectedQty),
      reason: Value(reason),
      rate: Value(rate),
      taxRate: Value(taxRate),
    );
  }

  factory DebitNoteItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebitNoteItem(
      id: serializer.fromJson<int>(json['id']),
      dnId: serializer.fromJson<String>(json['dnId']),
      productId: serializer.fromJson<String>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      orderedQty: serializer.fromJson<int>(json['orderedQty']),
      rejectedQty: serializer.fromJson<int>(json['rejectedQty']),
      reason: serializer.fromJson<String>(json['reason']),
      rate: serializer.fromJson<double>(json['rate']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dnId': serializer.toJson<String>(dnId),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'orderedQty': serializer.toJson<int>(orderedQty),
      'rejectedQty': serializer.toJson<int>(rejectedQty),
      'reason': serializer.toJson<String>(reason),
      'rate': serializer.toJson<double>(rate),
      'taxRate': serializer.toJson<double>(taxRate),
    };
  }

  DebitNoteItem copyWith({
    int? id,
    String? dnId,
    String? productId,
    String? productName,
    int? orderedQty,
    int? rejectedQty,
    String? reason,
    double? rate,
    double? taxRate,
  }) => DebitNoteItem(
    id: id ?? this.id,
    dnId: dnId ?? this.dnId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    orderedQty: orderedQty ?? this.orderedQty,
    rejectedQty: rejectedQty ?? this.rejectedQty,
    reason: reason ?? this.reason,
    rate: rate ?? this.rate,
    taxRate: taxRate ?? this.taxRate,
  );
  DebitNoteItem copyWithCompanion(DebitNoteItemsCompanion data) {
    return DebitNoteItem(
      id: data.id.present ? data.id.value : this.id,
      dnId: data.dnId.present ? data.dnId.value : this.dnId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      orderedQty: data.orderedQty.present
          ? data.orderedQty.value
          : this.orderedQty,
      rejectedQty: data.rejectedQty.present
          ? data.rejectedQty.value
          : this.rejectedQty,
      reason: data.reason.present ? data.reason.value : this.reason,
      rate: data.rate.present ? data.rate.value : this.rate,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebitNoteItem(')
          ..write('id: $id, ')
          ..write('dnId: $dnId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('orderedQty: $orderedQty, ')
          ..write('rejectedQty: $rejectedQty, ')
          ..write('reason: $reason, ')
          ..write('rate: $rate, ')
          ..write('taxRate: $taxRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dnId,
    productId,
    productName,
    orderedQty,
    rejectedQty,
    reason,
    rate,
    taxRate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebitNoteItem &&
          other.id == this.id &&
          other.dnId == this.dnId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.orderedQty == this.orderedQty &&
          other.rejectedQty == this.rejectedQty &&
          other.reason == this.reason &&
          other.rate == this.rate &&
          other.taxRate == this.taxRate);
}

class DebitNoteItemsCompanion extends UpdateCompanion<DebitNoteItem> {
  final Value<int> id;
  final Value<String> dnId;
  final Value<String> productId;
  final Value<String> productName;
  final Value<int> orderedQty;
  final Value<int> rejectedQty;
  final Value<String> reason;
  final Value<double> rate;
  final Value<double> taxRate;
  const DebitNoteItemsCompanion({
    this.id = const Value.absent(),
    this.dnId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.orderedQty = const Value.absent(),
    this.rejectedQty = const Value.absent(),
    this.reason = const Value.absent(),
    this.rate = const Value.absent(),
    this.taxRate = const Value.absent(),
  });
  DebitNoteItemsCompanion.insert({
    this.id = const Value.absent(),
    required String dnId,
    required String productId,
    required String productName,
    required int orderedQty,
    required int rejectedQty,
    required String reason,
    required double rate,
    required double taxRate,
  }) : dnId = Value(dnId),
       productId = Value(productId),
       productName = Value(productName),
       orderedQty = Value(orderedQty),
       rejectedQty = Value(rejectedQty),
       reason = Value(reason),
       rate = Value(rate),
       taxRate = Value(taxRate);
  static Insertable<DebitNoteItem> custom({
    Expression<int>? id,
    Expression<String>? dnId,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<int>? orderedQty,
    Expression<int>? rejectedQty,
    Expression<String>? reason,
    Expression<double>? rate,
    Expression<double>? taxRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dnId != null) 'dn_id': dnId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (orderedQty != null) 'ordered_qty': orderedQty,
      if (rejectedQty != null) 'rejected_qty': rejectedQty,
      if (reason != null) 'reason': reason,
      if (rate != null) 'rate': rate,
      if (taxRate != null) 'tax_rate': taxRate,
    });
  }

  DebitNoteItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? dnId,
    Value<String>? productId,
    Value<String>? productName,
    Value<int>? orderedQty,
    Value<int>? rejectedQty,
    Value<String>? reason,
    Value<double>? rate,
    Value<double>? taxRate,
  }) {
    return DebitNoteItemsCompanion(
      id: id ?? this.id,
      dnId: dnId ?? this.dnId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      orderedQty: orderedQty ?? this.orderedQty,
      rejectedQty: rejectedQty ?? this.rejectedQty,
      reason: reason ?? this.reason,
      rate: rate ?? this.rate,
      taxRate: taxRate ?? this.taxRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dnId.present) {
      map['dn_id'] = Variable<String>(dnId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (orderedQty.present) {
      map['ordered_qty'] = Variable<int>(orderedQty.value);
    }
    if (rejectedQty.present) {
      map['rejected_qty'] = Variable<int>(rejectedQty.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebitNoteItemsCompanion(')
          ..write('id: $id, ')
          ..write('dnId: $dnId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('orderedQty: $orderedQty, ')
          ..write('rejectedQty: $rejectedQty, ')
          ..write('reason: $reason, ')
          ..write('rate: $rate, ')
          ..write('taxRate: $taxRate')
          ..write(')'))
        .toString();
  }
}

class $GoodsReceiptsTable extends GoodsReceipts
    with TableInfo<$GoodsReceiptsTable, GoodsReceipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoodsReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poIdMeta = const VerificationMeta('poId');
  @override
  late final GeneratedColumn<String> poId = GeneratedColumn<String>(
    'po_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grnNumberMeta = const VerificationMeta(
    'grnNumber',
  );
  @override
  late final GeneratedColumn<String> grnNumber = GeneratedColumn<String>(
    'grn_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _challanNumberMeta = const VerificationMeta(
    'challanNumber',
  );
  @override
  late final GeneratedColumn<String> challanNumber = GeneratedColumn<String>(
    'challan_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grnDateMeta = const VerificationMeta(
    'grnDate',
  );
  @override
  late final GeneratedColumn<DateTime> grnDate = GeneratedColumn<DateTime>(
    'grn_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    poId,
    grnNumber,
    challanNumber,
    userId,
    grnDate,
    paidAmount,
    totalAmount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goods_receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoodsReceipt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('po_id')) {
      context.handle(
        _poIdMeta,
        poId.isAcceptableOrUnknown(data['po_id']!, _poIdMeta),
      );
    } else if (isInserting) {
      context.missing(_poIdMeta);
    }
    if (data.containsKey('grn_number')) {
      context.handle(
        _grnNumberMeta,
        grnNumber.isAcceptableOrUnknown(data['grn_number']!, _grnNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_grnNumberMeta);
    }
    if (data.containsKey('challan_number')) {
      context.handle(
        _challanNumberMeta,
        challanNumber.isAcceptableOrUnknown(
          data['challan_number']!,
          _challanNumberMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('grn_date')) {
      context.handle(
        _grnDateMeta,
        grnDate.isAcceptableOrUnknown(data['grn_date']!, _grnDateMeta),
      );
    } else if (isInserting) {
      context.missing(_grnDateMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoodsReceipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoodsReceipt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      poId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}po_id'],
      )!,
      grnNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grn_number'],
      )!,
      challanNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challan_number'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      grnDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}grn_date'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paid_amount'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GoodsReceiptsTable createAlias(String alias) {
    return $GoodsReceiptsTable(attachedDatabase, alias);
  }
}

class GoodsReceipt extends DataClass implements Insertable<GoodsReceipt> {
  final String id;
  final String poId;
  final String grnNumber;
  final String? challanNumber;
  final String? userId;
  final DateTime grnDate;
  final double paidAmount;
  final double totalAmount;
  final DateTime createdAt;
  const GoodsReceipt({
    required this.id,
    required this.poId,
    required this.grnNumber,
    this.challanNumber,
    this.userId,
    required this.grnDate,
    required this.paidAmount,
    required this.totalAmount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['po_id'] = Variable<String>(poId);
    map['grn_number'] = Variable<String>(grnNumber);
    if (!nullToAbsent || challanNumber != null) {
      map['challan_number'] = Variable<String>(challanNumber);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['grn_date'] = Variable<DateTime>(grnDate);
    map['paid_amount'] = Variable<double>(paidAmount);
    map['total_amount'] = Variable<double>(totalAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoodsReceiptsCompanion toCompanion(bool nullToAbsent) {
    return GoodsReceiptsCompanion(
      id: Value(id),
      poId: Value(poId),
      grnNumber: Value(grnNumber),
      challanNumber: challanNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(challanNumber),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      grnDate: Value(grnDate),
      paidAmount: Value(paidAmount),
      totalAmount: Value(totalAmount),
      createdAt: Value(createdAt),
    );
  }

  factory GoodsReceipt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoodsReceipt(
      id: serializer.fromJson<String>(json['id']),
      poId: serializer.fromJson<String>(json['poId']),
      grnNumber: serializer.fromJson<String>(json['grnNumber']),
      challanNumber: serializer.fromJson<String?>(json['challanNumber']),
      userId: serializer.fromJson<String?>(json['userId']),
      grnDate: serializer.fromJson<DateTime>(json['grnDate']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'poId': serializer.toJson<String>(poId),
      'grnNumber': serializer.toJson<String>(grnNumber),
      'challanNumber': serializer.toJson<String?>(challanNumber),
      'userId': serializer.toJson<String?>(userId),
      'grnDate': serializer.toJson<DateTime>(grnDate),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GoodsReceipt copyWith({
    String? id,
    String? poId,
    String? grnNumber,
    Value<String?> challanNumber = const Value.absent(),
    Value<String?> userId = const Value.absent(),
    DateTime? grnDate,
    double? paidAmount,
    double? totalAmount,
    DateTime? createdAt,
  }) => GoodsReceipt(
    id: id ?? this.id,
    poId: poId ?? this.poId,
    grnNumber: grnNumber ?? this.grnNumber,
    challanNumber: challanNumber.present
        ? challanNumber.value
        : this.challanNumber,
    userId: userId.present ? userId.value : this.userId,
    grnDate: grnDate ?? this.grnDate,
    paidAmount: paidAmount ?? this.paidAmount,
    totalAmount: totalAmount ?? this.totalAmount,
    createdAt: createdAt ?? this.createdAt,
  );
  GoodsReceipt copyWithCompanion(GoodsReceiptsCompanion data) {
    return GoodsReceipt(
      id: data.id.present ? data.id.value : this.id,
      poId: data.poId.present ? data.poId.value : this.poId,
      grnNumber: data.grnNumber.present ? data.grnNumber.value : this.grnNumber,
      challanNumber: data.challanNumber.present
          ? data.challanNumber.value
          : this.challanNumber,
      userId: data.userId.present ? data.userId.value : this.userId,
      grnDate: data.grnDate.present ? data.grnDate.value : this.grnDate,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoodsReceipt(')
          ..write('id: $id, ')
          ..write('poId: $poId, ')
          ..write('grnNumber: $grnNumber, ')
          ..write('challanNumber: $challanNumber, ')
          ..write('userId: $userId, ')
          ..write('grnDate: $grnDate, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    poId,
    grnNumber,
    challanNumber,
    userId,
    grnDate,
    paidAmount,
    totalAmount,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsReceipt &&
          other.id == this.id &&
          other.poId == this.poId &&
          other.grnNumber == this.grnNumber &&
          other.challanNumber == this.challanNumber &&
          other.userId == this.userId &&
          other.grnDate == this.grnDate &&
          other.paidAmount == this.paidAmount &&
          other.totalAmount == this.totalAmount &&
          other.createdAt == this.createdAt);
}

class GoodsReceiptsCompanion extends UpdateCompanion<GoodsReceipt> {
  final Value<String> id;
  final Value<String> poId;
  final Value<String> grnNumber;
  final Value<String?> challanNumber;
  final Value<String?> userId;
  final Value<DateTime> grnDate;
  final Value<double> paidAmount;
  final Value<double> totalAmount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GoodsReceiptsCompanion({
    this.id = const Value.absent(),
    this.poId = const Value.absent(),
    this.grnNumber = const Value.absent(),
    this.challanNumber = const Value.absent(),
    this.userId = const Value.absent(),
    this.grnDate = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoodsReceiptsCompanion.insert({
    required String id,
    required String poId,
    required String grnNumber,
    this.challanNumber = const Value.absent(),
    this.userId = const Value.absent(),
    required DateTime grnDate,
    this.paidAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       poId = Value(poId),
       grnNumber = Value(grnNumber),
       grnDate = Value(grnDate);
  static Insertable<GoodsReceipt> custom({
    Expression<String>? id,
    Expression<String>? poId,
    Expression<String>? grnNumber,
    Expression<String>? challanNumber,
    Expression<String>? userId,
    Expression<DateTime>? grnDate,
    Expression<double>? paidAmount,
    Expression<double>? totalAmount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (poId != null) 'po_id': poId,
      if (grnNumber != null) 'grn_number': grnNumber,
      if (challanNumber != null) 'challan_number': challanNumber,
      if (userId != null) 'user_id': userId,
      if (grnDate != null) 'grn_date': grnDate,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoodsReceiptsCompanion copyWith({
    Value<String>? id,
    Value<String>? poId,
    Value<String>? grnNumber,
    Value<String?>? challanNumber,
    Value<String?>? userId,
    Value<DateTime>? grnDate,
    Value<double>? paidAmount,
    Value<double>? totalAmount,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GoodsReceiptsCompanion(
      id: id ?? this.id,
      poId: poId ?? this.poId,
      grnNumber: grnNumber ?? this.grnNumber,
      challanNumber: challanNumber ?? this.challanNumber,
      userId: userId ?? this.userId,
      grnDate: grnDate ?? this.grnDate,
      paidAmount: paidAmount ?? this.paidAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (poId.present) {
      map['po_id'] = Variable<String>(poId.value);
    }
    if (grnNumber.present) {
      map['grn_number'] = Variable<String>(grnNumber.value);
    }
    if (challanNumber.present) {
      map['challan_number'] = Variable<String>(challanNumber.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (grnDate.present) {
      map['grn_date'] = Variable<DateTime>(grnDate.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoodsReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('poId: $poId, ')
          ..write('grnNumber: $grnNumber, ')
          ..write('challanNumber: $challanNumber, ')
          ..write('userId: $userId, ')
          ..write('grnDate: $grnDate, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoodsReceiptItemsTable extends GoodsReceiptItems
    with TableInfo<$GoodsReceiptItemsTable, GoodsReceiptItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoodsReceiptItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grnIdMeta = const VerificationMeta('grnId');
  @override
  late final GeneratedColumn<String> grnId = GeneratedColumn<String>(
    'grn_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderedQtyMeta = const VerificationMeta(
    'orderedQty',
  );
  @override
  late final GeneratedColumn<double> orderedQty = GeneratedColumn<double>(
    'ordered_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedQtyMeta = const VerificationMeta(
    'receivedQty',
  );
  @override
  late final GeneratedColumn<double> receivedQty = GeneratedColumn<double>(
    'received_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rejectedQtyMeta = const VerificationMeta(
    'rejectedQty',
  );
  @override
  late final GeneratedColumn<double> rejectedQty = GeneratedColumn<double>(
    'rejected_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acceptedQtyMeta = const VerificationMeta(
    'acceptedQty',
  );
  @override
  late final GeneratedColumn<double> acceptedQty = GeneratedColumn<double>(
    'accepted_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _uomMeta = const VerificationMeta('uom');
  @override
  late final GeneratedColumn<String> uom = GeneratedColumn<String>(
    'uom',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conversionFactorMeta = const VerificationMeta(
    'conversionFactor',
  );
  @override
  late final GeneratedColumn<double> conversionFactor = GeneratedColumn<double>(
    'conversion_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    grnId,
    productId,
    productName,
    hsnCode,
    orderedQty,
    receivedQty,
    rejectedQty,
    acceptedQty,
    rate,
    taxRate,
    uom,
    conversionFactor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goods_receipt_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoodsReceiptItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('grn_id')) {
      context.handle(
        _grnIdMeta,
        grnId.isAcceptableOrUnknown(data['grn_id']!, _grnIdMeta),
      );
    } else if (isInserting) {
      context.missing(_grnIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    }
    if (data.containsKey('ordered_qty')) {
      context.handle(
        _orderedQtyMeta,
        orderedQty.isAcceptableOrUnknown(data['ordered_qty']!, _orderedQtyMeta),
      );
    } else if (isInserting) {
      context.missing(_orderedQtyMeta);
    }
    if (data.containsKey('received_qty')) {
      context.handle(
        _receivedQtyMeta,
        receivedQty.isAcceptableOrUnknown(
          data['received_qty']!,
          _receivedQtyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receivedQtyMeta);
    }
    if (data.containsKey('rejected_qty')) {
      context.handle(
        _rejectedQtyMeta,
        rejectedQty.isAcceptableOrUnknown(
          data['rejected_qty']!,
          _rejectedQtyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rejectedQtyMeta);
    }
    if (data.containsKey('accepted_qty')) {
      context.handle(
        _acceptedQtyMeta,
        acceptedQty.isAcceptableOrUnknown(
          data['accepted_qty']!,
          _acceptedQtyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_acceptedQtyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('uom')) {
      context.handle(
        _uomMeta,
        uom.isAcceptableOrUnknown(data['uom']!, _uomMeta),
      );
    }
    if (data.containsKey('conversion_factor')) {
      context.handle(
        _conversionFactorMeta,
        conversionFactor.isAcceptableOrUnknown(
          data['conversion_factor']!,
          _conversionFactorMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoodsReceiptItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoodsReceiptItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      grnId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grn_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      ),
      orderedQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ordered_qty'],
      )!,
      receivedQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}received_qty'],
      )!,
      rejectedQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rejected_qty'],
      )!,
      acceptedQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accepted_qty'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      uom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uom'],
      ),
      conversionFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}conversion_factor'],
      )!,
    );
  }

  @override
  $GoodsReceiptItemsTable createAlias(String alias) {
    return $GoodsReceiptItemsTable(attachedDatabase, alias);
  }
}

class GoodsReceiptItem extends DataClass
    implements Insertable<GoodsReceiptItem> {
  final String id;
  final String grnId;
  final String productId;
  final String productName;
  final String? hsnCode;
  final double orderedQty;
  final double receivedQty;
  final double rejectedQty;
  final double acceptedQty;
  final double rate;
  final double taxRate;
  final String? uom;
  final double conversionFactor;
  const GoodsReceiptItem({
    required this.id,
    required this.grnId,
    required this.productId,
    required this.productName,
    this.hsnCode,
    required this.orderedQty,
    required this.receivedQty,
    required this.rejectedQty,
    required this.acceptedQty,
    required this.rate,
    required this.taxRate,
    this.uom,
    required this.conversionFactor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['grn_id'] = Variable<String>(grnId);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    map['ordered_qty'] = Variable<double>(orderedQty);
    map['received_qty'] = Variable<double>(receivedQty);
    map['rejected_qty'] = Variable<double>(rejectedQty);
    map['accepted_qty'] = Variable<double>(acceptedQty);
    map['rate'] = Variable<double>(rate);
    map['tax_rate'] = Variable<double>(taxRate);
    if (!nullToAbsent || uom != null) {
      map['uom'] = Variable<String>(uom);
    }
    map['conversion_factor'] = Variable<double>(conversionFactor);
    return map;
  }

  GoodsReceiptItemsCompanion toCompanion(bool nullToAbsent) {
    return GoodsReceiptItemsCompanion(
      id: Value(id),
      grnId: Value(grnId),
      productId: Value(productId),
      productName: Value(productName),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      orderedQty: Value(orderedQty),
      receivedQty: Value(receivedQty),
      rejectedQty: Value(rejectedQty),
      acceptedQty: Value(acceptedQty),
      rate: Value(rate),
      taxRate: Value(taxRate),
      uom: uom == null && nullToAbsent ? const Value.absent() : Value(uom),
      conversionFactor: Value(conversionFactor),
    );
  }

  factory GoodsReceiptItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoodsReceiptItem(
      id: serializer.fromJson<String>(json['id']),
      grnId: serializer.fromJson<String>(json['grnId']),
      productId: serializer.fromJson<String>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      orderedQty: serializer.fromJson<double>(json['orderedQty']),
      receivedQty: serializer.fromJson<double>(json['receivedQty']),
      rejectedQty: serializer.fromJson<double>(json['rejectedQty']),
      acceptedQty: serializer.fromJson<double>(json['acceptedQty']),
      rate: serializer.fromJson<double>(json['rate']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      uom: serializer.fromJson<String?>(json['uom']),
      conversionFactor: serializer.fromJson<double>(json['conversionFactor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'grnId': serializer.toJson<String>(grnId),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'orderedQty': serializer.toJson<double>(orderedQty),
      'receivedQty': serializer.toJson<double>(receivedQty),
      'rejectedQty': serializer.toJson<double>(rejectedQty),
      'acceptedQty': serializer.toJson<double>(acceptedQty),
      'rate': serializer.toJson<double>(rate),
      'taxRate': serializer.toJson<double>(taxRate),
      'uom': serializer.toJson<String?>(uom),
      'conversionFactor': serializer.toJson<double>(conversionFactor),
    };
  }

  GoodsReceiptItem copyWith({
    String? id,
    String? grnId,
    String? productId,
    String? productName,
    Value<String?> hsnCode = const Value.absent(),
    double? orderedQty,
    double? receivedQty,
    double? rejectedQty,
    double? acceptedQty,
    double? rate,
    double? taxRate,
    Value<String?> uom = const Value.absent(),
    double? conversionFactor,
  }) => GoodsReceiptItem(
    id: id ?? this.id,
    grnId: grnId ?? this.grnId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
    orderedQty: orderedQty ?? this.orderedQty,
    receivedQty: receivedQty ?? this.receivedQty,
    rejectedQty: rejectedQty ?? this.rejectedQty,
    acceptedQty: acceptedQty ?? this.acceptedQty,
    rate: rate ?? this.rate,
    taxRate: taxRate ?? this.taxRate,
    uom: uom.present ? uom.value : this.uom,
    conversionFactor: conversionFactor ?? this.conversionFactor,
  );
  GoodsReceiptItem copyWithCompanion(GoodsReceiptItemsCompanion data) {
    return GoodsReceiptItem(
      id: data.id.present ? data.id.value : this.id,
      grnId: data.grnId.present ? data.grnId.value : this.grnId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      orderedQty: data.orderedQty.present
          ? data.orderedQty.value
          : this.orderedQty,
      receivedQty: data.receivedQty.present
          ? data.receivedQty.value
          : this.receivedQty,
      rejectedQty: data.rejectedQty.present
          ? data.rejectedQty.value
          : this.rejectedQty,
      acceptedQty: data.acceptedQty.present
          ? data.acceptedQty.value
          : this.acceptedQty,
      rate: data.rate.present ? data.rate.value : this.rate,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      uom: data.uom.present ? data.uom.value : this.uom,
      conversionFactor: data.conversionFactor.present
          ? data.conversionFactor.value
          : this.conversionFactor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoodsReceiptItem(')
          ..write('id: $id, ')
          ..write('grnId: $grnId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('orderedQty: $orderedQty, ')
          ..write('receivedQty: $receivedQty, ')
          ..write('rejectedQty: $rejectedQty, ')
          ..write('acceptedQty: $acceptedQty, ')
          ..write('rate: $rate, ')
          ..write('taxRate: $taxRate, ')
          ..write('uom: $uom, ')
          ..write('conversionFactor: $conversionFactor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    grnId,
    productId,
    productName,
    hsnCode,
    orderedQty,
    receivedQty,
    rejectedQty,
    acceptedQty,
    rate,
    taxRate,
    uom,
    conversionFactor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsReceiptItem &&
          other.id == this.id &&
          other.grnId == this.grnId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.hsnCode == this.hsnCode &&
          other.orderedQty == this.orderedQty &&
          other.receivedQty == this.receivedQty &&
          other.rejectedQty == this.rejectedQty &&
          other.acceptedQty == this.acceptedQty &&
          other.rate == this.rate &&
          other.taxRate == this.taxRate &&
          other.uom == this.uom &&
          other.conversionFactor == this.conversionFactor);
}

class GoodsReceiptItemsCompanion extends UpdateCompanion<GoodsReceiptItem> {
  final Value<String> id;
  final Value<String> grnId;
  final Value<String> productId;
  final Value<String> productName;
  final Value<String?> hsnCode;
  final Value<double> orderedQty;
  final Value<double> receivedQty;
  final Value<double> rejectedQty;
  final Value<double> acceptedQty;
  final Value<double> rate;
  final Value<double> taxRate;
  final Value<String?> uom;
  final Value<double> conversionFactor;
  final Value<int> rowid;
  const GoodsReceiptItemsCompanion({
    this.id = const Value.absent(),
    this.grnId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.orderedQty = const Value.absent(),
    this.receivedQty = const Value.absent(),
    this.rejectedQty = const Value.absent(),
    this.acceptedQty = const Value.absent(),
    this.rate = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.uom = const Value.absent(),
    this.conversionFactor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoodsReceiptItemsCompanion.insert({
    required String id,
    required String grnId,
    required String productId,
    required String productName,
    this.hsnCode = const Value.absent(),
    required double orderedQty,
    required double receivedQty,
    required double rejectedQty,
    required double acceptedQty,
    required double rate,
    this.taxRate = const Value.absent(),
    this.uom = const Value.absent(),
    this.conversionFactor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       grnId = Value(grnId),
       productId = Value(productId),
       productName = Value(productName),
       orderedQty = Value(orderedQty),
       receivedQty = Value(receivedQty),
       rejectedQty = Value(rejectedQty),
       acceptedQty = Value(acceptedQty),
       rate = Value(rate);
  static Insertable<GoodsReceiptItem> custom({
    Expression<String>? id,
    Expression<String>? grnId,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<String>? hsnCode,
    Expression<double>? orderedQty,
    Expression<double>? receivedQty,
    Expression<double>? rejectedQty,
    Expression<double>? acceptedQty,
    Expression<double>? rate,
    Expression<double>? taxRate,
    Expression<String>? uom,
    Expression<double>? conversionFactor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (grnId != null) 'grn_id': grnId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (orderedQty != null) 'ordered_qty': orderedQty,
      if (receivedQty != null) 'received_qty': receivedQty,
      if (rejectedQty != null) 'rejected_qty': rejectedQty,
      if (acceptedQty != null) 'accepted_qty': acceptedQty,
      if (rate != null) 'rate': rate,
      if (taxRate != null) 'tax_rate': taxRate,
      if (uom != null) 'uom': uom,
      if (conversionFactor != null) 'conversion_factor': conversionFactor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoodsReceiptItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? grnId,
    Value<String>? productId,
    Value<String>? productName,
    Value<String?>? hsnCode,
    Value<double>? orderedQty,
    Value<double>? receivedQty,
    Value<double>? rejectedQty,
    Value<double>? acceptedQty,
    Value<double>? rate,
    Value<double>? taxRate,
    Value<String?>? uom,
    Value<double>? conversionFactor,
    Value<int>? rowid,
  }) {
    return GoodsReceiptItemsCompanion(
      id: id ?? this.id,
      grnId: grnId ?? this.grnId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      hsnCode: hsnCode ?? this.hsnCode,
      orderedQty: orderedQty ?? this.orderedQty,
      receivedQty: receivedQty ?? this.receivedQty,
      rejectedQty: rejectedQty ?? this.rejectedQty,
      acceptedQty: acceptedQty ?? this.acceptedQty,
      rate: rate ?? this.rate,
      taxRate: taxRate ?? this.taxRate,
      uom: uom ?? this.uom,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (grnId.present) {
      map['grn_id'] = Variable<String>(grnId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (orderedQty.present) {
      map['ordered_qty'] = Variable<double>(orderedQty.value);
    }
    if (receivedQty.present) {
      map['received_qty'] = Variable<double>(receivedQty.value);
    }
    if (rejectedQty.present) {
      map['rejected_qty'] = Variable<double>(rejectedQty.value);
    }
    if (acceptedQty.present) {
      map['accepted_qty'] = Variable<double>(acceptedQty.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (uom.present) {
      map['uom'] = Variable<String>(uom.value);
    }
    if (conversionFactor.present) {
      map['conversion_factor'] = Variable<double>(conversionFactor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoodsReceiptItemsCompanion(')
          ..write('id: $id, ')
          ..write('grnId: $grnId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('orderedQty: $orderedQty, ')
          ..write('receivedQty: $receivedQty, ')
          ..write('rejectedQty: $rejectedQty, ')
          ..write('acceptedQty: $acceptedQty, ')
          ..write('rate: $rate, ')
          ..write('taxRate: $taxRate, ')
          ..write('uom: $uom, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductBatchesTable extends ProductBatches
    with TableInfo<$ProductBatchesTable, ProductBatch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mrpMeta = const VerificationMeta('mrp');
  @override
  late final GeneratedColumn<double> mrp = GeneratedColumn<double>(
    'mrp',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sellingPriceMeta = const VerificationMeta(
    'sellingPrice',
  );
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
    'selling_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseRateMeta = const VerificationMeta(
    'purchaseRate',
  );
  @override
  late final GeneratedColumn<double> purchaseRate = GeneratedColumn<double>(
    'purchase_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockQtyMeta = const VerificationMeta(
    'stockQty',
  );
  @override
  late final GeneratedColumn<double> stockQty = GeneratedColumn<double>(
    'stock_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _batchNumberMeta = const VerificationMeta(
    'batchNumber',
  );
  @override
  late final GeneratedColumn<String> batchNumber = GeneratedColumn<String>(
    'batch_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDamagedMeta = const VerificationMeta(
    'isDamaged',
  );
  @override
  late final GeneratedColumn<bool> isDamaged = GeneratedColumn<bool>(
    'is_damaged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_damaged" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    mrp,
    sellingPrice,
    purchaseRate,
    stockQty,
    batchNumber,
    expiryDate,
    isDamaged,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductBatch> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('mrp')) {
      context.handle(
        _mrpMeta,
        mrp.isAcceptableOrUnknown(data['mrp']!, _mrpMeta),
      );
    } else if (isInserting) {
      context.missing(_mrpMeta);
    }
    if (data.containsKey('selling_price')) {
      context.handle(
        _sellingPriceMeta,
        sellingPrice.isAcceptableOrUnknown(
          data['selling_price']!,
          _sellingPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sellingPriceMeta);
    }
    if (data.containsKey('purchase_rate')) {
      context.handle(
        _purchaseRateMeta,
        purchaseRate.isAcceptableOrUnknown(
          data['purchase_rate']!,
          _purchaseRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseRateMeta);
    }
    if (data.containsKey('stock_qty')) {
      context.handle(
        _stockQtyMeta,
        stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta),
      );
    }
    if (data.containsKey('batch_number')) {
      context.handle(
        _batchNumberMeta,
        batchNumber.isAcceptableOrUnknown(
          data['batch_number']!,
          _batchNumberMeta,
        ),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('is_damaged')) {
      context.handle(
        _isDamagedMeta,
        isDamaged.isAcceptableOrUnknown(data['is_damaged']!, _isDamagedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductBatch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductBatch(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      mrp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mrp'],
      )!,
      sellingPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}selling_price'],
      )!,
      purchaseRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_rate'],
      )!,
      stockQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock_qty'],
      )!,
      batchNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_number'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      ),
      isDamaged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_damaged'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ProductBatchesTable createAlias(String alias) {
    return $ProductBatchesTable(attachedDatabase, alias);
  }
}

class ProductBatch extends DataClass implements Insertable<ProductBatch> {
  final String id;
  final String productId;
  final double mrp;
  final double sellingPrice;
  final double purchaseRate;
  final double stockQty;
  final String? batchNumber;
  final DateTime? expiryDate;
  final bool isDamaged;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const ProductBatch({
    required this.id,
    required this.productId,
    required this.mrp,
    required this.sellingPrice,
    required this.purchaseRate,
    required this.stockQty,
    this.batchNumber,
    this.expiryDate,
    required this.isDamaged,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['mrp'] = Variable<double>(mrp);
    map['selling_price'] = Variable<double>(sellingPrice);
    map['purchase_rate'] = Variable<double>(purchaseRate);
    map['stock_qty'] = Variable<double>(stockQty);
    if (!nullToAbsent || batchNumber != null) {
      map['batch_number'] = Variable<String>(batchNumber);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    map['is_damaged'] = Variable<bool>(isDamaged);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ProductBatchesCompanion toCompanion(bool nullToAbsent) {
    return ProductBatchesCompanion(
      id: Value(id),
      productId: Value(productId),
      mrp: Value(mrp),
      sellingPrice: Value(sellingPrice),
      purchaseRate: Value(purchaseRate),
      stockQty: Value(stockQty),
      batchNumber: batchNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(batchNumber),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      isDamaged: Value(isDamaged),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ProductBatch.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductBatch(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      mrp: serializer.fromJson<double>(json['mrp']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
      purchaseRate: serializer.fromJson<double>(json['purchaseRate']),
      stockQty: serializer.fromJson<double>(json['stockQty']),
      batchNumber: serializer.fromJson<String?>(json['batchNumber']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      isDamaged: serializer.fromJson<bool>(json['isDamaged']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'mrp': serializer.toJson<double>(mrp),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
      'purchaseRate': serializer.toJson<double>(purchaseRate),
      'stockQty': serializer.toJson<double>(stockQty),
      'batchNumber': serializer.toJson<String?>(batchNumber),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'isDamaged': serializer.toJson<bool>(isDamaged),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ProductBatch copyWith({
    String? id,
    String? productId,
    double? mrp,
    double? sellingPrice,
    double? purchaseRate,
    double? stockQty,
    Value<String?> batchNumber = const Value.absent(),
    Value<DateTime?> expiryDate = const Value.absent(),
    bool? isDamaged,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => ProductBatch(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    mrp: mrp ?? this.mrp,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    purchaseRate: purchaseRate ?? this.purchaseRate,
    stockQty: stockQty ?? this.stockQty,
    batchNumber: batchNumber.present ? batchNumber.value : this.batchNumber,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    isDamaged: isDamaged ?? this.isDamaged,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ProductBatch copyWithCompanion(ProductBatchesCompanion data) {
    return ProductBatch(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      mrp: data.mrp.present ? data.mrp.value : this.mrp,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      purchaseRate: data.purchaseRate.present
          ? data.purchaseRate.value
          : this.purchaseRate,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      batchNumber: data.batchNumber.present
          ? data.batchNumber.value
          : this.batchNumber,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      isDamaged: data.isDamaged.present ? data.isDamaged.value : this.isDamaged,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductBatch(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('mrp: $mrp, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('purchaseRate: $purchaseRate, ')
          ..write('stockQty: $stockQty, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('isDamaged: $isDamaged, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    mrp,
    sellingPrice,
    purchaseRate,
    stockQty,
    batchNumber,
    expiryDate,
    isDamaged,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductBatch &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.mrp == this.mrp &&
          other.sellingPrice == this.sellingPrice &&
          other.purchaseRate == this.purchaseRate &&
          other.stockQty == this.stockQty &&
          other.batchNumber == this.batchNumber &&
          other.expiryDate == this.expiryDate &&
          other.isDamaged == this.isDamaged &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductBatchesCompanion extends UpdateCompanion<ProductBatch> {
  final Value<String> id;
  final Value<String> productId;
  final Value<double> mrp;
  final Value<double> sellingPrice;
  final Value<double> purchaseRate;
  final Value<double> stockQty;
  final Value<String?> batchNumber;
  final Value<DateTime?> expiryDate;
  final Value<bool> isDamaged;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ProductBatchesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.mrp = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.purchaseRate = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.isDamaged = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductBatchesCompanion.insert({
    required String id,
    required String productId,
    required double mrp,
    required double sellingPrice,
    required double purchaseRate,
    this.stockQty = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.isDamaged = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       mrp = Value(mrp),
       sellingPrice = Value(sellingPrice),
       purchaseRate = Value(purchaseRate),
       createdAt = Value(createdAt);
  static Insertable<ProductBatch> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<double>? mrp,
    Expression<double>? sellingPrice,
    Expression<double>? purchaseRate,
    Expression<double>? stockQty,
    Expression<String>? batchNumber,
    Expression<DateTime>? expiryDate,
    Expression<bool>? isDamaged,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (mrp != null) 'mrp': mrp,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (purchaseRate != null) 'purchase_rate': purchaseRate,
      if (stockQty != null) 'stock_qty': stockQty,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (isDamaged != null) 'is_damaged': isDamaged,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductBatchesCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<double>? mrp,
    Value<double>? sellingPrice,
    Value<double>? purchaseRate,
    Value<double>? stockQty,
    Value<String?>? batchNumber,
    Value<DateTime?>? expiryDate,
    Value<bool>? isDamaged,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductBatchesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      mrp: mrp ?? this.mrp,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      purchaseRate: purchaseRate ?? this.purchaseRate,
      stockQty: stockQty ?? this.stockQty,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      isDamaged: isDamaged ?? this.isDamaged,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (mrp.present) {
      map['mrp'] = Variable<double>(mrp.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    if (purchaseRate.present) {
      map['purchase_rate'] = Variable<double>(purchaseRate.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<double>(stockQty.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<String>(batchNumber.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (isDamaged.present) {
      map['is_damaged'] = Variable<bool>(isDamaged.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductBatchesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('mrp: $mrp, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('purchaseRate: $purchaseRate, ')
          ..write('stockQty: $stockQty, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('isDamaged: $isDamaged, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductTransactionsTable extends ProductTransactions
    with TableInfo<$ProductTransactionsTable, ProductTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product_batches (id)',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    type,
    quantity,
    price,
    totalAmount,
    date,
    orderId,
    location,
    batchId,
    userId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ProductTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_id'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
    );
  }

  @override
  $ProductTransactionsTable createAlias(String alias) {
    return $ProductTransactionsTable(attachedDatabase, alias);
  }
}

class ProductTransaction extends DataClass
    implements Insertable<ProductTransaction> {
  final String id;
  final String productId;
  final String type;
  final double quantity;
  final double price;
  final double totalAmount;
  final DateTime date;
  final String? orderId;
  final String? location;
  final String? batchId;
  final String? userId;
  const ProductTransaction({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.price,
    required this.totalAmount,
    required this.date,
    this.orderId,
    this.location,
    this.batchId,
    this.userId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['type'] = Variable<String>(type);
    map['quantity'] = Variable<double>(quantity);
    map['price'] = Variable<double>(price);
    map['total_amount'] = Variable<double>(totalAmount);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || orderId != null) {
      map['order_id'] = Variable<String>(orderId);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<String>(batchId);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  ProductTransactionsCompanion toCompanion(bool nullToAbsent) {
    return ProductTransactionsCompanion(
      id: Value(id),
      productId: Value(productId),
      type: Value(type),
      quantity: Value(quantity),
      price: Value(price),
      totalAmount: Value(totalAmount),
      date: Value(date),
      orderId: orderId == null && nullToAbsent
          ? const Value.absent()
          : Value(orderId),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
    );
  }

  factory ProductTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductTransaction(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      type: serializer.fromJson<String>(json['type']),
      quantity: serializer.fromJson<double>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      date: serializer.fromJson<DateTime>(json['date']),
      orderId: serializer.fromJson<String?>(json['orderId']),
      location: serializer.fromJson<String?>(json['location']),
      batchId: serializer.fromJson<String?>(json['batchId']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'type': serializer.toJson<String>(type),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double>(price),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'date': serializer.toJson<DateTime>(date),
      'orderId': serializer.toJson<String?>(orderId),
      'location': serializer.toJson<String?>(location),
      'batchId': serializer.toJson<String?>(batchId),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  ProductTransaction copyWith({
    String? id,
    String? productId,
    String? type,
    double? quantity,
    double? price,
    double? totalAmount,
    DateTime? date,
    Value<String?> orderId = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> batchId = const Value.absent(),
    Value<String?> userId = const Value.absent(),
  }) => ProductTransaction(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    type: type ?? this.type,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    totalAmount: totalAmount ?? this.totalAmount,
    date: date ?? this.date,
    orderId: orderId.present ? orderId.value : this.orderId,
    location: location.present ? location.value : this.location,
    batchId: batchId.present ? batchId.value : this.batchId,
    userId: userId.present ? userId.value : this.userId,
  );
  ProductTransaction copyWithCompanion(ProductTransactionsCompanion data) {
    return ProductTransaction(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      type: data.type.present ? data.type.value : this.type,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      date: data.date.present ? data.date.value : this.date,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      location: data.location.present ? data.location.value : this.location,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductTransaction(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('date: $date, ')
          ..write('orderId: $orderId, ')
          ..write('location: $location, ')
          ..write('batchId: $batchId, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    type,
    quantity,
    price,
    totalAmount,
    date,
    orderId,
    location,
    batchId,
    userId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductTransaction &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.type == this.type &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.totalAmount == this.totalAmount &&
          other.date == this.date &&
          other.orderId == this.orderId &&
          other.location == this.location &&
          other.batchId == this.batchId &&
          other.userId == this.userId);
}

class ProductTransactionsCompanion extends UpdateCompanion<ProductTransaction> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> type;
  final Value<double> quantity;
  final Value<double> price;
  final Value<double> totalAmount;
  final Value<DateTime> date;
  final Value<String?> orderId;
  final Value<String?> location;
  final Value<String?> batchId;
  final Value<String?> userId;
  final Value<int> rowid;
  const ProductTransactionsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.type = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.date = const Value.absent(),
    this.orderId = const Value.absent(),
    this.location = const Value.absent(),
    this.batchId = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String productId,
    required String type,
    required double quantity,
    required double price,
    required double totalAmount,
    required DateTime date,
    this.orderId = const Value.absent(),
    this.location = const Value.absent(),
    this.batchId = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : productId = Value(productId),
       type = Value(type),
       quantity = Value(quantity),
       price = Value(price),
       totalAmount = Value(totalAmount),
       date = Value(date);
  static Insertable<ProductTransaction> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? type,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<double>? totalAmount,
    Expression<DateTime>? date,
    Expression<String>? orderId,
    Expression<String>? location,
    Expression<String>? batchId,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (type != null) 'type': type,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (date != null) 'date': date,
      if (orderId != null) 'order_id': orderId,
      if (location != null) 'location': location,
      if (batchId != null) 'batch_id': batchId,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? type,
    Value<double>? quantity,
    Value<double>? price,
    Value<double>? totalAmount,
    Value<DateTime>? date,
    Value<String?>? orderId,
    Value<String?>? location,
    Value<String?>? batchId,
    Value<String?>? userId,
    Value<int>? rowid,
  }) {
    return ProductTransactionsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalAmount: totalAmount ?? this.totalAmount,
      date: date ?? this.date,
      orderId: orderId ?? this.orderId,
      location: location ?? this.location,
      batchId: batchId ?? this.batchId,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('date: $date, ')
          ..write('orderId: $orderId, ')
          ..write('location: $location, ')
          ..write('batchId: $batchId, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesBillsTable extends SalesBills
    with TableInfo<$SalesBillsTable, SalesBill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesBillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grandTotalMeta = const VerificationMeta(
    'grandTotal',
  );
  @override
  late final GeneratedColumn<double> grandTotal = GeneratedColumn<double>(
    'grand_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentStatusMeta = const VerificationMeta(
    'paymentStatus',
  );
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    customerName,
    customerId,
    grandTotal,
    paymentStatus,
    userId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales_bills';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalesBill> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('grand_total')) {
      context.handle(
        _grandTotalMeta,
        grandTotal.isAcceptableOrUnknown(data['grand_total']!, _grandTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_grandTotalMeta);
    }
    if (data.containsKey('payment_status')) {
      context.handle(
        _paymentStatusMeta,
        paymentStatus.isAcceptableOrUnknown(
          data['payment_status']!,
          _paymentStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentStatusMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalesBill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalesBill(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      grandTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grand_total'],
      )!,
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
    );
  }

  @override
  $SalesBillsTable createAlias(String alias) {
    return $SalesBillsTable(attachedDatabase, alias);
  }
}

class SalesBill extends DataClass implements Insertable<SalesBill> {
  final String id;
  final DateTime date;
  final String? customerName;
  final String? customerId;
  final double grandTotal;
  final String paymentStatus;
  final String? userId;
  const SalesBill({
    required this.id,
    required this.date,
    this.customerName,
    this.customerId,
    required this.grandTotal,
    required this.paymentStatus,
    this.userId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['grand_total'] = Variable<double>(grandTotal);
    map['payment_status'] = Variable<String>(paymentStatus);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  SalesBillsCompanion toCompanion(bool nullToAbsent) {
    return SalesBillsCompanion(
      id: Value(id),
      date: Value(date),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      grandTotal: Value(grandTotal),
      paymentStatus: Value(paymentStatus),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
    );
  }

  factory SalesBill.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalesBill(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      grandTotal: serializer.fromJson<double>(json['grandTotal']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'customerName': serializer.toJson<String?>(customerName),
      'customerId': serializer.toJson<String?>(customerId),
      'grandTotal': serializer.toJson<double>(grandTotal),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  SalesBill copyWith({
    String? id,
    DateTime? date,
    Value<String?> customerName = const Value.absent(),
    Value<String?> customerId = const Value.absent(),
    double? grandTotal,
    String? paymentStatus,
    Value<String?> userId = const Value.absent(),
  }) => SalesBill(
    id: id ?? this.id,
    date: date ?? this.date,
    customerName: customerName.present ? customerName.value : this.customerName,
    customerId: customerId.present ? customerId.value : this.customerId,
    grandTotal: grandTotal ?? this.grandTotal,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    userId: userId.present ? userId.value : this.userId,
  );
  SalesBill copyWithCompanion(SalesBillsCompanion data) {
    return SalesBill(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      grandTotal: data.grandTotal.present
          ? data.grandTotal.value
          : this.grandTotal,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalesBill(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('customerName: $customerName, ')
          ..write('customerId: $customerId, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    customerName,
    customerId,
    grandTotal,
    paymentStatus,
    userId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesBill &&
          other.id == this.id &&
          other.date == this.date &&
          other.customerName == this.customerName &&
          other.customerId == this.customerId &&
          other.grandTotal == this.grandTotal &&
          other.paymentStatus == this.paymentStatus &&
          other.userId == this.userId);
}

class SalesBillsCompanion extends UpdateCompanion<SalesBill> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String?> customerName;
  final Value<String?> customerId;
  final Value<double> grandTotal;
  final Value<String> paymentStatus;
  final Value<String?> userId;
  final Value<int> rowid;
  const SalesBillsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerId = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesBillsCompanion.insert({
    required String id,
    required DateTime date,
    this.customerName = const Value.absent(),
    this.customerId = const Value.absent(),
    required double grandTotal,
    required String paymentStatus,
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       grandTotal = Value(grandTotal),
       paymentStatus = Value(paymentStatus);
  static Insertable<SalesBill> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? customerName,
    Expression<String>? customerId,
    Expression<double>? grandTotal,
    Expression<String>? paymentStatus,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (customerName != null) 'customer_name': customerName,
      if (customerId != null) 'customer_id': customerId,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesBillsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String?>? customerName,
    Value<String?>? customerId,
    Value<double>? grandTotal,
    Value<String>? paymentStatus,
    Value<String?>? userId,
    Value<int>? rowid,
  }) {
    return SalesBillsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      customerName: customerName ?? this.customerName,
      customerId: customerId ?? this.customerId,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<double>(grandTotal.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesBillsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('customerName: $customerName, ')
          ..write('customerId: $customerId, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillItemsTable extends BillItems
    with TableInfo<$BillItemsTable, BillItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<String> billId = GeneratedColumn<String>(
    'bill_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _cessRateMeta = const VerificationMeta(
    'cessRate',
  );
  @override
  late final GeneratedColumn<double> cessRate = GeneratedColumn<double>(
    'cess_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _taxAmountMeta = const VerificationMeta(
    'taxAmount',
  );
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
    'tax_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warrantyEndDateMeta = const VerificationMeta(
    'warrantyEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> warrantyEndDate =
      GeneratedColumn<DateTime>(
        'warranty_end_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    billId,
    productId,
    productName,
    hsnCode,
    quantity,
    unitPrice,
    taxRate,
    cessRate,
    taxAmount,
    totalAmount,
    warrantyEndDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bill_id')) {
      context.handle(
        _billIdMeta,
        billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta),
      );
    } else if (isInserting) {
      context.missing(_billIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    }
    if (data.containsKey('cess_rate')) {
      context.handle(
        _cessRateMeta,
        cessRate.isAcceptableOrUnknown(data['cess_rate']!, _cessRateMeta),
      );
    }
    if (data.containsKey('tax_amount')) {
      context.handle(
        _taxAmountMeta,
        taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_taxAmountMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('warranty_end_date')) {
      context.handle(
        _warrantyEndDateMeta,
        warrantyEndDate.isAcceptableOrUnknown(
          data['warranty_end_date']!,
          _warrantyEndDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      billId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bill_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      cessRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cess_rate'],
      )!,
      taxAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_amount'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      warrantyEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}warranty_end_date'],
      ),
    );
  }

  @override
  $BillItemsTable createAlias(String alias) {
    return $BillItemsTable(attachedDatabase, alias);
  }
}

class BillItem extends DataClass implements Insertable<BillItem> {
  final String id;
  final String billId;
  final String productId;
  final String productName;
  final String? hsnCode;
  final double quantity;
  final double unitPrice;
  final double taxRate;
  final double cessRate;
  final double taxAmount;
  final double totalAmount;
  final DateTime? warrantyEndDate;
  const BillItem({
    required this.id,
    required this.billId,
    required this.productId,
    required this.productName,
    this.hsnCode,
    required this.quantity,
    required this.unitPrice,
    required this.taxRate,
    required this.cessRate,
    required this.taxAmount,
    required this.totalAmount,
    this.warrantyEndDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bill_id'] = Variable<String>(billId);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    map['quantity'] = Variable<double>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['tax_rate'] = Variable<double>(taxRate);
    map['cess_rate'] = Variable<double>(cessRate);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['total_amount'] = Variable<double>(totalAmount);
    if (!nullToAbsent || warrantyEndDate != null) {
      map['warranty_end_date'] = Variable<DateTime>(warrantyEndDate);
    }
    return map;
  }

  BillItemsCompanion toCompanion(bool nullToAbsent) {
    return BillItemsCompanion(
      id: Value(id),
      billId: Value(billId),
      productId: Value(productId),
      productName: Value(productName),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      taxRate: Value(taxRate),
      cessRate: Value(cessRate),
      taxAmount: Value(taxAmount),
      totalAmount: Value(totalAmount),
      warrantyEndDate: warrantyEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(warrantyEndDate),
    );
  }

  factory BillItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillItem(
      id: serializer.fromJson<String>(json['id']),
      billId: serializer.fromJson<String>(json['billId']),
      productId: serializer.fromJson<String>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      cessRate: serializer.fromJson<double>(json['cessRate']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      warrantyEndDate: serializer.fromJson<DateTime?>(json['warrantyEndDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'billId': serializer.toJson<String>(billId),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'taxRate': serializer.toJson<double>(taxRate),
      'cessRate': serializer.toJson<double>(cessRate),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'warrantyEndDate': serializer.toJson<DateTime?>(warrantyEndDate),
    };
  }

  BillItem copyWith({
    String? id,
    String? billId,
    String? productId,
    String? productName,
    Value<String?> hsnCode = const Value.absent(),
    double? quantity,
    double? unitPrice,
    double? taxRate,
    double? cessRate,
    double? taxAmount,
    double? totalAmount,
    Value<DateTime?> warrantyEndDate = const Value.absent(),
  }) => BillItem(
    id: id ?? this.id,
    billId: billId ?? this.billId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    taxRate: taxRate ?? this.taxRate,
    cessRate: cessRate ?? this.cessRate,
    taxAmount: taxAmount ?? this.taxAmount,
    totalAmount: totalAmount ?? this.totalAmount,
    warrantyEndDate: warrantyEndDate.present
        ? warrantyEndDate.value
        : this.warrantyEndDate,
  );
  BillItem copyWithCompanion(BillItemsCompanion data) {
    return BillItem(
      id: data.id.present ? data.id.value : this.id,
      billId: data.billId.present ? data.billId.value : this.billId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      cessRate: data.cessRate.present ? data.cessRate.value : this.cessRate,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      warrantyEndDate: data.warrantyEndDate.present
          ? data.warrantyEndDate.value
          : this.warrantyEndDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillItem(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('taxRate: $taxRate, ')
          ..write('cessRate: $cessRate, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('warrantyEndDate: $warrantyEndDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    billId,
    productId,
    productName,
    hsnCode,
    quantity,
    unitPrice,
    taxRate,
    cessRate,
    taxAmount,
    totalAmount,
    warrantyEndDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillItem &&
          other.id == this.id &&
          other.billId == this.billId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.hsnCode == this.hsnCode &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.taxRate == this.taxRate &&
          other.cessRate == this.cessRate &&
          other.taxAmount == this.taxAmount &&
          other.totalAmount == this.totalAmount &&
          other.warrantyEndDate == this.warrantyEndDate);
}

class BillItemsCompanion extends UpdateCompanion<BillItem> {
  final Value<String> id;
  final Value<String> billId;
  final Value<String> productId;
  final Value<String> productName;
  final Value<String?> hsnCode;
  final Value<double> quantity;
  final Value<double> unitPrice;
  final Value<double> taxRate;
  final Value<double> cessRate;
  final Value<double> taxAmount;
  final Value<double> totalAmount;
  final Value<DateTime?> warrantyEndDate;
  final Value<int> rowid;
  const BillItemsCompanion({
    this.id = const Value.absent(),
    this.billId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.cessRate = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.warrantyEndDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillItemsCompanion.insert({
    required String id,
    required String billId,
    required String productId,
    required String productName,
    this.hsnCode = const Value.absent(),
    required double quantity,
    required double unitPrice,
    this.taxRate = const Value.absent(),
    this.cessRate = const Value.absent(),
    required double taxAmount,
    required double totalAmount,
    this.warrantyEndDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       billId = Value(billId),
       productId = Value(productId),
       productName = Value(productName),
       quantity = Value(quantity),
       unitPrice = Value(unitPrice),
       taxAmount = Value(taxAmount),
       totalAmount = Value(totalAmount);
  static Insertable<BillItem> custom({
    Expression<String>? id,
    Expression<String>? billId,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<String>? hsnCode,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? taxRate,
    Expression<double>? cessRate,
    Expression<double>? taxAmount,
    Expression<double>? totalAmount,
    Expression<DateTime>? warrantyEndDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billId != null) 'bill_id': billId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (taxRate != null) 'tax_rate': taxRate,
      if (cessRate != null) 'cess_rate': cessRate,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (warrantyEndDate != null) 'warranty_end_date': warrantyEndDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? billId,
    Value<String>? productId,
    Value<String>? productName,
    Value<String?>? hsnCode,
    Value<double>? quantity,
    Value<double>? unitPrice,
    Value<double>? taxRate,
    Value<double>? cessRate,
    Value<double>? taxAmount,
    Value<double>? totalAmount,
    Value<DateTime?>? warrantyEndDate,
    Value<int>? rowid,
  }) {
    return BillItemsCompanion(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      hsnCode: hsnCode ?? this.hsnCode,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      taxRate: taxRate ?? this.taxRate,
      cessRate: cessRate ?? this.cessRate,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      warrantyEndDate: warrantyEndDate ?? this.warrantyEndDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<String>(billId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (cessRate.present) {
      map['cess_rate'] = Variable<double>(cessRate.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (warrantyEndDate.present) {
      map['warranty_end_date'] = Variable<DateTime>(warrantyEndDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillItemsCompanion(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('taxRate: $taxRate, ')
          ..write('cessRate: $cessRate, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('warrantyEndDate: $warrantyEndDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillPaymentsTable extends BillPayments
    with TableInfo<$BillPaymentsTable, BillPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<String> billId = GeneratedColumn<String>(
    'bill_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sales_bills (id)',
    ),
  );
  static const VerificationMeta _paymentModeMeta = const VerificationMeta(
    'paymentMode',
  );
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
    'payment_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceNoMeta = const VerificationMeta(
    'referenceNo',
  );
  @override
  late final GeneratedColumn<String> referenceNo = GeneratedColumn<String>(
    'reference_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    billId,
    paymentMode,
    amount,
    referenceNo,
    userId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bill_id')) {
      context.handle(
        _billIdMeta,
        billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta),
      );
    } else if (isInserting) {
      context.missing(_billIdMeta);
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
        _paymentModeMeta,
        paymentMode.isAcceptableOrUnknown(
          data['payment_mode']!,
          _paymentModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentModeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reference_no')) {
      context.handle(
        _referenceNoMeta,
        referenceNo.isAcceptableOrUnknown(
          data['reference_no']!,
          _referenceNoMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      billId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bill_id'],
      )!,
      paymentMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_mode'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      referenceNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_no'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
    );
  }

  @override
  $BillPaymentsTable createAlias(String alias) {
    return $BillPaymentsTable(attachedDatabase, alias);
  }
}

class BillPayment extends DataClass implements Insertable<BillPayment> {
  final String id;
  final String billId;
  final String paymentMode;
  final double amount;
  final String? referenceNo;
  final String? userId;
  const BillPayment({
    required this.id,
    required this.billId,
    required this.paymentMode,
    required this.amount,
    this.referenceNo,
    this.userId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bill_id'] = Variable<String>(billId);
    map['payment_mode'] = Variable<String>(paymentMode);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || referenceNo != null) {
      map['reference_no'] = Variable<String>(referenceNo);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  BillPaymentsCompanion toCompanion(bool nullToAbsent) {
    return BillPaymentsCompanion(
      id: Value(id),
      billId: Value(billId),
      paymentMode: Value(paymentMode),
      amount: Value(amount),
      referenceNo: referenceNo == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceNo),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
    );
  }

  factory BillPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillPayment(
      id: serializer.fromJson<String>(json['id']),
      billId: serializer.fromJson<String>(json['billId']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      amount: serializer.fromJson<double>(json['amount']),
      referenceNo: serializer.fromJson<String?>(json['referenceNo']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'billId': serializer.toJson<String>(billId),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'amount': serializer.toJson<double>(amount),
      'referenceNo': serializer.toJson<String?>(referenceNo),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  BillPayment copyWith({
    String? id,
    String? billId,
    String? paymentMode,
    double? amount,
    Value<String?> referenceNo = const Value.absent(),
    Value<String?> userId = const Value.absent(),
  }) => BillPayment(
    id: id ?? this.id,
    billId: billId ?? this.billId,
    paymentMode: paymentMode ?? this.paymentMode,
    amount: amount ?? this.amount,
    referenceNo: referenceNo.present ? referenceNo.value : this.referenceNo,
    userId: userId.present ? userId.value : this.userId,
  );
  BillPayment copyWithCompanion(BillPaymentsCompanion data) {
    return BillPayment(
      id: data.id.present ? data.id.value : this.id,
      billId: data.billId.present ? data.billId.value : this.billId,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      amount: data.amount.present ? data.amount.value : this.amount,
      referenceNo: data.referenceNo.present
          ? data.referenceNo.value
          : this.referenceNo,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillPayment(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('amount: $amount, ')
          ..write('referenceNo: $referenceNo, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, billId, paymentMode, amount, referenceNo, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillPayment &&
          other.id == this.id &&
          other.billId == this.billId &&
          other.paymentMode == this.paymentMode &&
          other.amount == this.amount &&
          other.referenceNo == this.referenceNo &&
          other.userId == this.userId);
}

class BillPaymentsCompanion extends UpdateCompanion<BillPayment> {
  final Value<String> id;
  final Value<String> billId;
  final Value<String> paymentMode;
  final Value<double> amount;
  final Value<String?> referenceNo;
  final Value<String?> userId;
  final Value<int> rowid;
  const BillPaymentsCompanion({
    this.id = const Value.absent(),
    this.billId = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.amount = const Value.absent(),
    this.referenceNo = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillPaymentsCompanion.insert({
    required String id,
    required String billId,
    required String paymentMode,
    required double amount,
    this.referenceNo = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       billId = Value(billId),
       paymentMode = Value(paymentMode),
       amount = Value(amount);
  static Insertable<BillPayment> custom({
    Expression<String>? id,
    Expression<String>? billId,
    Expression<String>? paymentMode,
    Expression<double>? amount,
    Expression<String>? referenceNo,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billId != null) 'bill_id': billId,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (amount != null) 'amount': amount,
      if (referenceNo != null) 'reference_no': referenceNo,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillPaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? billId,
    Value<String>? paymentMode,
    Value<double>? amount,
    Value<String?>? referenceNo,
    Value<String?>? userId,
    Value<int>? rowid,
  }) {
    return BillPaymentsCompanion(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      paymentMode: paymentMode ?? this.paymentMode,
      amount: amount ?? this.amount,
      referenceNo: referenceNo ?? this.referenceNo,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<String>(billId.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (referenceNo.present) {
      map['reference_no'] = Variable<String>(referenceNo.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('amount: $amount, ')
          ..write('referenceNo: $referenceNo, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GeneralLedgerTable extends GeneralLedger
    with TableInfo<$GeneralLedgerTable, GeneralLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeneralLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<double> debit = GeneratedColumn<double>(
    'debit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _creditMeta = const VerificationMeta('credit');
  @override
  late final GeneratedColumn<double> credit = GeneratedColumn<double>(
    'credit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceTableMeta = const VerificationMeta(
    'referenceTable',
  );
  @override
  late final GeneratedColumn<String> referenceTable = GeneratedColumn<String>(
    'reference_table',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    type,
    description,
    debit,
    credit,
    referenceId,
    referenceTable,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'general_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<GeneralLedgerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('debit')) {
      context.handle(
        _debitMeta,
        debit.isAcceptableOrUnknown(data['debit']!, _debitMeta),
      );
    }
    if (data.containsKey('credit')) {
      context.handle(
        _creditMeta,
        credit.isAcceptableOrUnknown(data['credit']!, _creditMeta),
      );
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    }
    if (data.containsKey('reference_table')) {
      context.handle(
        _referenceTableMeta,
        referenceTable.isAcceptableOrUnknown(
          data['reference_table']!,
          _referenceTableMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GeneralLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeneralLedgerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      debit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}debit'],
      )!,
      credit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit'],
      )!,
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      ),
      referenceTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_table'],
      ),
    );
  }

  @override
  $GeneralLedgerTable createAlias(String alias) {
    return $GeneralLedgerTable(attachedDatabase, alias);
  }
}

class GeneralLedgerData extends DataClass
    implements Insertable<GeneralLedgerData> {
  final String id;
  final DateTime date;
  final String type;
  final String description;
  final double debit;
  final double credit;
  final String? referenceId;
  final String? referenceTable;
  const GeneralLedgerData({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.debit,
    required this.credit,
    this.referenceId,
    this.referenceTable,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['description'] = Variable<String>(description);
    map['debit'] = Variable<double>(debit);
    map['credit'] = Variable<double>(credit);
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<String>(referenceId);
    }
    if (!nullToAbsent || referenceTable != null) {
      map['reference_table'] = Variable<String>(referenceTable);
    }
    return map;
  }

  GeneralLedgerCompanion toCompanion(bool nullToAbsent) {
    return GeneralLedgerCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      description: Value(description),
      debit: Value(debit),
      credit: Value(credit),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      referenceTable: referenceTable == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceTable),
    );
  }

  factory GeneralLedgerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeneralLedgerData(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String>(json['description']),
      debit: serializer.fromJson<double>(json['debit']),
      credit: serializer.fromJson<double>(json['credit']),
      referenceId: serializer.fromJson<String?>(json['referenceId']),
      referenceTable: serializer.fromJson<String?>(json['referenceTable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String>(description),
      'debit': serializer.toJson<double>(debit),
      'credit': serializer.toJson<double>(credit),
      'referenceId': serializer.toJson<String?>(referenceId),
      'referenceTable': serializer.toJson<String?>(referenceTable),
    };
  }

  GeneralLedgerData copyWith({
    String? id,
    DateTime? date,
    String? type,
    String? description,
    double? debit,
    double? credit,
    Value<String?> referenceId = const Value.absent(),
    Value<String?> referenceTable = const Value.absent(),
  }) => GeneralLedgerData(
    id: id ?? this.id,
    date: date ?? this.date,
    type: type ?? this.type,
    description: description ?? this.description,
    debit: debit ?? this.debit,
    credit: credit ?? this.credit,
    referenceId: referenceId.present ? referenceId.value : this.referenceId,
    referenceTable: referenceTable.present
        ? referenceTable.value
        : this.referenceTable,
  );
  GeneralLedgerData copyWithCompanion(GeneralLedgerCompanion data) {
    return GeneralLedgerData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
      debit: data.debit.present ? data.debit.value : this.debit,
      credit: data.credit.present ? data.credit.value : this.credit,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      referenceTable: data.referenceTable.present
          ? data.referenceTable.value
          : this.referenceTable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeneralLedgerData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('referenceId: $referenceId, ')
          ..write('referenceTable: $referenceTable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    type,
    description,
    debit,
    credit,
    referenceId,
    referenceTable,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeneralLedgerData &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.description == this.description &&
          other.debit == this.debit &&
          other.credit == this.credit &&
          other.referenceId == this.referenceId &&
          other.referenceTable == this.referenceTable);
}

class GeneralLedgerCompanion extends UpdateCompanion<GeneralLedgerData> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<String> description;
  final Value<double> debit;
  final Value<double> credit;
  final Value<String?> referenceId;
  final Value<String?> referenceTable;
  final Value<int> rowid;
  const GeneralLedgerCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.referenceTable = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GeneralLedgerCompanion.insert({
    required String id,
    required DateTime date,
    required String type,
    required String description,
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.referenceTable = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       type = Value(type),
       description = Value(description);
  static Insertable<GeneralLedgerData> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<String>? description,
    Expression<double>? debit,
    Expression<double>? credit,
    Expression<String>? referenceId,
    Expression<String>? referenceTable,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
      if (referenceId != null) 'reference_id': referenceId,
      if (referenceTable != null) 'reference_table': referenceTable,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GeneralLedgerCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? type,
    Value<String>? description,
    Value<double>? debit,
    Value<double>? credit,
    Value<String?>? referenceId,
    Value<String?>? referenceTable,
    Value<int>? rowid,
  }) {
    return GeneralLedgerCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      referenceId: referenceId ?? this.referenceId,
      referenceTable: referenceTable ?? this.referenceTable,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (debit.present) {
      map['debit'] = Variable<double>(debit.value);
    }
    if (credit.present) {
      map['credit'] = Variable<double>(credit.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (referenceTable.present) {
      map['reference_table'] = Variable<String>(referenceTable.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeneralLedgerCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('referenceId: $referenceId, ')
          ..write('referenceTable: $referenceTable, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VendorPaymentsTable extends VendorPayments
    with TableInfo<$VendorPaymentsTable, VendorPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VendorPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<String> vendorId = GeneratedColumn<String>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Cash'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vendorId,
    amount,
    date,
    mode,
    notes,
    reference,
    userId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vendor_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<VendorPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VendorPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VendorPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
    );
  }

  @override
  $VendorPaymentsTable createAlias(String alias) {
    return $VendorPaymentsTable(attachedDatabase, alias);
  }
}

class VendorPayment extends DataClass implements Insertable<VendorPayment> {
  final String id;
  final String vendorId;
  final double amount;
  final DateTime date;
  final String mode;
  final String? notes;
  final String? reference;
  final String? userId;
  const VendorPayment({
    required this.id,
    required this.vendorId,
    required this.amount,
    required this.date,
    required this.mode,
    this.notes,
    this.reference,
    this.userId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vendor_id'] = Variable<String>(vendorId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  VendorPaymentsCompanion toCompanion(bool nullToAbsent) {
    return VendorPaymentsCompanion(
      id: Value(id),
      vendorId: Value(vendorId),
      amount: Value(amount),
      date: Value(date),
      mode: Value(mode),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
    );
  }

  factory VendorPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VendorPayment(
      id: serializer.fromJson<String>(json['id']),
      vendorId: serializer.fromJson<String>(json['vendorId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      mode: serializer.fromJson<String>(json['mode']),
      notes: serializer.fromJson<String?>(json['notes']),
      reference: serializer.fromJson<String?>(json['reference']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vendorId': serializer.toJson<String>(vendorId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'mode': serializer.toJson<String>(mode),
      'notes': serializer.toJson<String?>(notes),
      'reference': serializer.toJson<String?>(reference),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  VendorPayment copyWith({
    String? id,
    String? vendorId,
    double? amount,
    DateTime? date,
    String? mode,
    Value<String?> notes = const Value.absent(),
    Value<String?> reference = const Value.absent(),
    Value<String?> userId = const Value.absent(),
  }) => VendorPayment(
    id: id ?? this.id,
    vendorId: vendorId ?? this.vendorId,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    mode: mode ?? this.mode,
    notes: notes.present ? notes.value : this.notes,
    reference: reference.present ? reference.value : this.reference,
    userId: userId.present ? userId.value : this.userId,
  );
  VendorPayment copyWithCompanion(VendorPaymentsCompanion data) {
    return VendorPayment(
      id: data.id.present ? data.id.value : this.id,
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      mode: data.mode.present ? data.mode.value : this.mode,
      notes: data.notes.present ? data.notes.value : this.notes,
      reference: data.reference.present ? data.reference.value : this.reference,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VendorPayment(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('mode: $mode, ')
          ..write('notes: $notes, ')
          ..write('reference: $reference, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vendorId, amount, date, mode, notes, reference, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VendorPayment &&
          other.id == this.id &&
          other.vendorId == this.vendorId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.mode == this.mode &&
          other.notes == this.notes &&
          other.reference == this.reference &&
          other.userId == this.userId);
}

class VendorPaymentsCompanion extends UpdateCompanion<VendorPayment> {
  final Value<String> id;
  final Value<String> vendorId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> mode;
  final Value<String?> notes;
  final Value<String?> reference;
  final Value<String?> userId;
  final Value<int> rowid;
  const VendorPaymentsCompanion({
    this.id = const Value.absent(),
    this.vendorId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.mode = const Value.absent(),
    this.notes = const Value.absent(),
    this.reference = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VendorPaymentsCompanion.insert({
    required String id,
    required String vendorId,
    required double amount,
    required DateTime date,
    this.mode = const Value.absent(),
    this.notes = const Value.absent(),
    this.reference = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vendorId = Value(vendorId),
       amount = Value(amount),
       date = Value(date);
  static Insertable<VendorPayment> custom({
    Expression<String>? id,
    Expression<String>? vendorId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? mode,
    Expression<String>? notes,
    Expression<String>? reference,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vendorId != null) 'vendor_id': vendorId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (mode != null) 'mode': mode,
      if (notes != null) 'notes': notes,
      if (reference != null) 'reference': reference,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VendorPaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? vendorId,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String>? mode,
    Value<String?>? notes,
    Value<String?>? reference,
    Value<String?>? userId,
    Value<int>? rowid,
  }) {
    return VendorPaymentsCompanion(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      mode: mode ?? this.mode,
      notes: notes ?? this.notes,
      reference: reference ?? this.reference,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vendorId.present) {
      map['vendor_id'] = Variable<String>(vendorId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VendorPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('vendorId: $vendorId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('mode: $mode, ')
          ..write('notes: $notes, ')
          ..write('reference: $reference, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentAllocationsTable extends PaymentAllocations
    with TableInfo<$PaymentAllocationsTable, PaymentAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentIdMeta = const VerificationMeta(
    'paymentId',
  );
  @override
  late final GeneratedColumn<String> paymentId = GeneratedColumn<String>(
    'payment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grnIdMeta = const VerificationMeta('grnId');
  @override
  late final GeneratedColumn<String> grnId = GeneratedColumn<String>(
    'grn_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allocatedAmountMeta = const VerificationMeta(
    'allocatedAmount',
  );
  @override
  late final GeneratedColumn<double> allocatedAmount = GeneratedColumn<double>(
    'allocated_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    paymentId,
    grnId,
    allocatedAmount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentAllocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payment_id')) {
      context.handle(
        _paymentIdMeta,
        paymentId.isAcceptableOrUnknown(data['payment_id']!, _paymentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_paymentIdMeta);
    }
    if (data.containsKey('grn_id')) {
      context.handle(
        _grnIdMeta,
        grnId.isAcceptableOrUnknown(data['grn_id']!, _grnIdMeta),
      );
    } else if (isInserting) {
      context.missing(_grnIdMeta);
    }
    if (data.containsKey('allocated_amount')) {
      context.handle(
        _allocatedAmountMeta,
        allocatedAmount.isAcceptableOrUnknown(
          data['allocated_amount']!,
          _allocatedAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allocatedAmountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentAllocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      paymentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_id'],
      )!,
      grnId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grn_id'],
      )!,
      allocatedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}allocated_amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentAllocationsTable createAlias(String alias) {
    return $PaymentAllocationsTable(attachedDatabase, alias);
  }
}

class PaymentAllocation extends DataClass
    implements Insertable<PaymentAllocation> {
  final String id;
  final String paymentId;
  final String grnId;
  final double allocatedAmount;
  final DateTime createdAt;
  const PaymentAllocation({
    required this.id,
    required this.paymentId,
    required this.grnId,
    required this.allocatedAmount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payment_id'] = Variable<String>(paymentId);
    map['grn_id'] = Variable<String>(grnId);
    map['allocated_amount'] = Variable<double>(allocatedAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentAllocationsCompanion toCompanion(bool nullToAbsent) {
    return PaymentAllocationsCompanion(
      id: Value(id),
      paymentId: Value(paymentId),
      grnId: Value(grnId),
      allocatedAmount: Value(allocatedAmount),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentAllocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentAllocation(
      id: serializer.fromJson<String>(json['id']),
      paymentId: serializer.fromJson<String>(json['paymentId']),
      grnId: serializer.fromJson<String>(json['grnId']),
      allocatedAmount: serializer.fromJson<double>(json['allocatedAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'paymentId': serializer.toJson<String>(paymentId),
      'grnId': serializer.toJson<String>(grnId),
      'allocatedAmount': serializer.toJson<double>(allocatedAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentAllocation copyWith({
    String? id,
    String? paymentId,
    String? grnId,
    double? allocatedAmount,
    DateTime? createdAt,
  }) => PaymentAllocation(
    id: id ?? this.id,
    paymentId: paymentId ?? this.paymentId,
    grnId: grnId ?? this.grnId,
    allocatedAmount: allocatedAmount ?? this.allocatedAmount,
    createdAt: createdAt ?? this.createdAt,
  );
  PaymentAllocation copyWithCompanion(PaymentAllocationsCompanion data) {
    return PaymentAllocation(
      id: data.id.present ? data.id.value : this.id,
      paymentId: data.paymentId.present ? data.paymentId.value : this.paymentId,
      grnId: data.grnId.present ? data.grnId.value : this.grnId,
      allocatedAmount: data.allocatedAmount.present
          ? data.allocatedAmount.value
          : this.allocatedAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocation(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('grnId: $grnId, ')
          ..write('allocatedAmount: $allocatedAmount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, paymentId, grnId, allocatedAmount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentAllocation &&
          other.id == this.id &&
          other.paymentId == this.paymentId &&
          other.grnId == this.grnId &&
          other.allocatedAmount == this.allocatedAmount &&
          other.createdAt == this.createdAt);
}

class PaymentAllocationsCompanion extends UpdateCompanion<PaymentAllocation> {
  final Value<String> id;
  final Value<String> paymentId;
  final Value<String> grnId;
  final Value<double> allocatedAmount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PaymentAllocationsCompanion({
    this.id = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.grnId = const Value.absent(),
    this.allocatedAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentAllocationsCompanion.insert({
    required String id,
    required String paymentId,
    required String grnId,
    required double allocatedAmount,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       paymentId = Value(paymentId),
       grnId = Value(grnId),
       allocatedAmount = Value(allocatedAmount),
       createdAt = Value(createdAt);
  static Insertable<PaymentAllocation> custom({
    Expression<String>? id,
    Expression<String>? paymentId,
    Expression<String>? grnId,
    Expression<double>? allocatedAmount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentId != null) 'payment_id': paymentId,
      if (grnId != null) 'grn_id': grnId,
      if (allocatedAmount != null) 'allocated_amount': allocatedAmount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentAllocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? paymentId,
    Value<String>? grnId,
    Value<double>? allocatedAmount,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PaymentAllocationsCompanion(
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      grnId: grnId ?? this.grnId,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (paymentId.present) {
      map['payment_id'] = Variable<String>(paymentId.value);
    }
    if (grnId.present) {
      map['grn_id'] = Variable<String>(grnId.value);
    }
    if (allocatedAmount.present) {
      map['allocated_amount'] = Variable<double>(allocatedAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('grnId: $grnId, ')
          ..write('allocatedAmount: $allocatedAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductUomsTable extends ProductUoms
    with TableInfo<$ProductUomsTable, ProductUom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductUomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uomNameMeta = const VerificationMeta(
    'uomName',
  );
  @override
  late final GeneratedColumn<String> uomName = GeneratedColumn<String>(
    'uom_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversionFactorMeta = const VerificationMeta(
    'conversionFactor',
  );
  @override
  late final GeneratedColumn<double> conversionFactor = GeneratedColumn<double>(
    'conversion_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBaseMeta = const VerificationMeta('isBase');
  @override
  late final GeneratedColumn<bool> isBase = GeneratedColumn<bool>(
    'is_base',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_base" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    uomName,
    conversionFactor,
    isBase,
    barcode,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_uoms';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductUom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('uom_name')) {
      context.handle(
        _uomNameMeta,
        uomName.isAcceptableOrUnknown(data['uom_name']!, _uomNameMeta),
      );
    } else if (isInserting) {
      context.missing(_uomNameMeta);
    }
    if (data.containsKey('conversion_factor')) {
      context.handle(
        _conversionFactorMeta,
        conversionFactor.isAcceptableOrUnknown(
          data['conversion_factor']!,
          _conversionFactorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversionFactorMeta);
    }
    if (data.containsKey('is_base')) {
      context.handle(
        _isBaseMeta,
        isBase.isAcceptableOrUnknown(data['is_base']!, _isBaseMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductUom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductUom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      uomName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uom_name'],
      )!,
      conversionFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}conversion_factor'],
      )!,
      isBase: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_base'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductUomsTable createAlias(String alias) {
    return $ProductUomsTable(attachedDatabase, alias);
  }
}

class ProductUom extends DataClass implements Insertable<ProductUom> {
  final int id;
  final String productId;
  final String uomName;
  final double conversionFactor;
  final bool isBase;
  final String? barcode;
  final DateTime createdAt;
  const ProductUom({
    required this.id,
    required this.productId,
    required this.uomName,
    required this.conversionFactor,
    required this.isBase,
    this.barcode,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<String>(productId);
    map['uom_name'] = Variable<String>(uomName);
    map['conversion_factor'] = Variable<double>(conversionFactor);
    map['is_base'] = Variable<bool>(isBase);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductUomsCompanion toCompanion(bool nullToAbsent) {
    return ProductUomsCompanion(
      id: Value(id),
      productId: Value(productId),
      uomName: Value(uomName),
      conversionFactor: Value(conversionFactor),
      isBase: Value(isBase),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      createdAt: Value(createdAt),
    );
  }

  factory ProductUom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductUom(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      uomName: serializer.fromJson<String>(json['uomName']),
      conversionFactor: serializer.fromJson<double>(json['conversionFactor']),
      isBase: serializer.fromJson<bool>(json['isBase']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<String>(productId),
      'uomName': serializer.toJson<String>(uomName),
      'conversionFactor': serializer.toJson<double>(conversionFactor),
      'isBase': serializer.toJson<bool>(isBase),
      'barcode': serializer.toJson<String?>(barcode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProductUom copyWith({
    int? id,
    String? productId,
    String? uomName,
    double? conversionFactor,
    bool? isBase,
    Value<String?> barcode = const Value.absent(),
    DateTime? createdAt,
  }) => ProductUom(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    uomName: uomName ?? this.uomName,
    conversionFactor: conversionFactor ?? this.conversionFactor,
    isBase: isBase ?? this.isBase,
    barcode: barcode.present ? barcode.value : this.barcode,
    createdAt: createdAt ?? this.createdAt,
  );
  ProductUom copyWithCompanion(ProductUomsCompanion data) {
    return ProductUom(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      uomName: data.uomName.present ? data.uomName.value : this.uomName,
      conversionFactor: data.conversionFactor.present
          ? data.conversionFactor.value
          : this.conversionFactor,
      isBase: data.isBase.present ? data.isBase.value : this.isBase,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductUom(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('uomName: $uomName, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('isBase: $isBase, ')
          ..write('barcode: $barcode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    uomName,
    conversionFactor,
    isBase,
    barcode,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductUom &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.uomName == this.uomName &&
          other.conversionFactor == this.conversionFactor &&
          other.isBase == this.isBase &&
          other.barcode == this.barcode &&
          other.createdAt == this.createdAt);
}

class ProductUomsCompanion extends UpdateCompanion<ProductUom> {
  final Value<int> id;
  final Value<String> productId;
  final Value<String> uomName;
  final Value<double> conversionFactor;
  final Value<bool> isBase;
  final Value<String?> barcode;
  final Value<DateTime> createdAt;
  const ProductUomsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.uomName = const Value.absent(),
    this.conversionFactor = const Value.absent(),
    this.isBase = const Value.absent(),
    this.barcode = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProductUomsCompanion.insert({
    this.id = const Value.absent(),
    required String productId,
    required String uomName,
    required double conversionFactor,
    this.isBase = const Value.absent(),
    this.barcode = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : productId = Value(productId),
       uomName = Value(uomName),
       conversionFactor = Value(conversionFactor);
  static Insertable<ProductUom> custom({
    Expression<int>? id,
    Expression<String>? productId,
    Expression<String>? uomName,
    Expression<double>? conversionFactor,
    Expression<bool>? isBase,
    Expression<String>? barcode,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (uomName != null) 'uom_name': uomName,
      if (conversionFactor != null) 'conversion_factor': conversionFactor,
      if (isBase != null) 'is_base': isBase,
      if (barcode != null) 'barcode': barcode,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProductUomsCompanion copyWith({
    Value<int>? id,
    Value<String>? productId,
    Value<String>? uomName,
    Value<double>? conversionFactor,
    Value<bool>? isBase,
    Value<String?>? barcode,
    Value<DateTime>? createdAt,
  }) {
    return ProductUomsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      uomName: uomName ?? this.uomName,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      isBase: isBase ?? this.isBase,
      barcode: barcode ?? this.barcode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (uomName.present) {
      map['uom_name'] = Variable<String>(uomName.value);
    }
    if (conversionFactor.present) {
      map['conversion_factor'] = Variable<double>(conversionFactor.value);
    }
    if (isBase.present) {
      map['is_base'] = Variable<bool>(isBase.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductUomsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('uomName: $uomName, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('isBase: $isBase, ')
          ..write('barcode: $barcode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinMeta = const VerificationMeta('pin');
  @override
  late final GeneratedColumn<String> pin = GeneratedColumn<String>(
    'pin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    username,
    password,
    role,
    pin,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('pin')) {
      context.handle(
        _pinMeta,
        pin.isAcceptableOrUnknown(data['pin']!, _pinMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      pin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String username;
  final String password;
  final String role;
  final String? pin;
  final bool isActive;
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.role,
    this.pin,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || pin != null) {
      map['pin'] = Variable<String>(pin);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      username: Value(username),
      password: Value(password),
      role: Value(role),
      pin: pin == null && nullToAbsent ? const Value.absent() : Value(pin),
      isActive: Value(isActive),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      role: serializer.fromJson<String>(json['role']),
      pin: serializer.fromJson<String?>(json['pin']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
      'pin': serializer.toJson<String?>(pin),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? username,
    String? password,
    String? role,
    Value<String?> pin = const Value.absent(),
    bool? isActive,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    username: username ?? this.username,
    password: password ?? this.password,
    role: role ?? this.role,
    pin: pin.present ? pin.value : this.pin,
    isActive: isActive ?? this.isActive,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      role: data.role.present ? data.role.value : this.role,
      pin: data.pin.present ? data.pin.value : this.pin,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('pin: $pin, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, username, password, role, pin, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.username == this.username &&
          other.password == this.password &&
          other.role == this.role &&
          other.pin == this.pin &&
          other.isActive == this.isActive);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> username;
  final Value<String> password;
  final Value<String> role;
  final Value<String?> pin;
  final Value<bool> isActive;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.pin = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required String username,
    required String password,
    required String role,
    this.pin = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       username = Value(username),
       password = Value(password),
       role = Value(role);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? role,
    Expression<String>? pin,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (pin != null) 'pin': pin,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? username,
    Value<String>? password,
    Value<String>? role,
    Value<String?>? pin,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      pin: pin ?? this.pin,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pin.present) {
      map['pin'] = Variable<String>(pin.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('pin: $pin, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    action,
    entityType,
    recordId,
    details,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      ),
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      ),
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final String id;
  final String? userId;
  final String action;
  final String? entityType;
  final String? recordId;
  final String? details;
  final DateTime timestamp;
  const AuditLog({
    required this.id,
    this.userId,
    required this.action,
    this.entityType,
    this.recordId,
    this.details,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(entityType);
    }
    if (!nullToAbsent || recordId != null) {
      map['record_id'] = Variable<String>(recordId);
    }
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      action: Value(action),
      entityType: entityType == null && nullToAbsent
          ? const Value.absent()
          : Value(entityType),
      recordId: recordId == null && nullToAbsent
          ? const Value.absent()
          : Value(recordId),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      timestamp: Value(timestamp),
    );
  }

  factory AuditLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String?>(json['entityType']),
      recordId: serializer.fromJson<String?>(json['recordId']),
      details: serializer.fromJson<String?>(json['details']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String?>(entityType),
      'recordId': serializer.toJson<String?>(recordId),
      'details': serializer.toJson<String?>(details),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  AuditLog copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    String? action,
    Value<String?> entityType = const Value.absent(),
    Value<String?> recordId = const Value.absent(),
    Value<String?> details = const Value.absent(),
    DateTime? timestamp,
  }) => AuditLog(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    action: action ?? this.action,
    entityType: entityType.present ? entityType.value : this.entityType,
    recordId: recordId.present ? recordId.value : this.recordId,
    details: details.present ? details.value : this.details,
    timestamp: timestamp ?? this.timestamp,
  );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      details: data.details.present ? data.details.value : this.details,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('recordId: $recordId, ')
          ..write('details: $details, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, action, entityType, recordId, details, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.recordId == this.recordId &&
          other.details == this.details &&
          other.timestamp == this.timestamp);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String> action;
  final Value<String?> entityType;
  final Value<String?> recordId;
  final Value<String?> details;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.recordId = const Value.absent(),
    this.details = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String action,
    this.entityType = const Value.absent(),
    this.recordId = const Value.absent(),
    this.details = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       action = Value(action);
  static Insertable<AuditLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<String>? recordId,
    Expression<String>? details,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (recordId != null) 'record_id': recordId,
      if (details != null) 'details': details,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String>? action,
    Value<String?>? entityType,
    Value<String?>? recordId,
    Value<String?>? details,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      recordId: recordId ?? this.recordId,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('recordId: $recordId, ')
          ..write('details: $details, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subTypeMeta = const VerificationMeta(
    'subType',
  );
  @override
  late final GeneratedColumn<String> subType = GeneratedColumn<String>(
    'sub_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _currentBalanceMeta = const VerificationMeta(
    'currentBalance',
  );
  @override
  late final GeneratedColumn<double> currentBalance = GeneratedColumn<double>(
    'current_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _assignedUserIdMeta = const VerificationMeta(
    'assignedUserId',
  );
  @override
  late final GeneratedColumn<String> assignedUserId = GeneratedColumn<String>(
    'assigned_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    type,
    subType,
    parentId,
    currency,
    currentBalance,
    assignedUserId,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('sub_type')) {
      context.handle(
        _subTypeMeta,
        subType.isAcceptableOrUnknown(data['sub_type']!, _subTypeMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('current_balance')) {
      context.handle(
        _currentBalanceMeta,
        currentBalance.isAcceptableOrUnknown(
          data['current_balance']!,
          _currentBalanceMeta,
        ),
      );
    }
    if (data.containsKey('assigned_user_id')) {
      context.handle(
        _assignedUserIdMeta,
        assignedUserId.isAcceptableOrUnknown(
          data['assigned_user_id']!,
          _assignedUserIdMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      subType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_type'],
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      currentBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_balance'],
      )!,
      assignedUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assigned_user_id'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String? code;
  final String name;
  final String type;
  final String? subType;
  final String? parentId;
  final String currency;
  final double currentBalance;
  final String? assignedUserId;
  final bool isArchived;
  const Account({
    required this.id,
    this.code,
    required this.name,
    required this.type,
    this.subType,
    this.parentId,
    required this.currency,
    required this.currentBalance,
    this.assignedUserId,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || subType != null) {
      map['sub_type'] = Variable<String>(subType);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['currency'] = Variable<String>(currency);
    map['current_balance'] = Variable<double>(currentBalance);
    if (!nullToAbsent || assignedUserId != null) {
      map['assigned_user_id'] = Variable<String>(assignedUserId);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      name: Value(name),
      type: Value(type),
      subType: subType == null && nullToAbsent
          ? const Value.absent()
          : Value(subType),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      currency: Value(currency),
      currentBalance: Value(currentBalance),
      assignedUserId: assignedUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedUserId),
      isArchived: Value(isArchived),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String?>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      subType: serializer.fromJson<String?>(json['subType']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      currency: serializer.fromJson<String>(json['currency']),
      currentBalance: serializer.fromJson<double>(json['currentBalance']),
      assignedUserId: serializer.fromJson<String?>(json['assignedUserId']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String?>(code),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'subType': serializer.toJson<String?>(subType),
      'parentId': serializer.toJson<String?>(parentId),
      'currency': serializer.toJson<String>(currency),
      'currentBalance': serializer.toJson<double>(currentBalance),
      'assignedUserId': serializer.toJson<String?>(assignedUserId),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  Account copyWith({
    String? id,
    Value<String?> code = const Value.absent(),
    String? name,
    String? type,
    Value<String?> subType = const Value.absent(),
    Value<String?> parentId = const Value.absent(),
    String? currency,
    double? currentBalance,
    Value<String?> assignedUserId = const Value.absent(),
    bool? isArchived,
  }) => Account(
    id: id ?? this.id,
    code: code.present ? code.value : this.code,
    name: name ?? this.name,
    type: type ?? this.type,
    subType: subType.present ? subType.value : this.subType,
    parentId: parentId.present ? parentId.value : this.parentId,
    currency: currency ?? this.currency,
    currentBalance: currentBalance ?? this.currentBalance,
    assignedUserId: assignedUserId.present
        ? assignedUserId.value
        : this.assignedUserId,
    isArchived: isArchived ?? this.isArchived,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      subType: data.subType.present ? data.subType.value : this.subType,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      currency: data.currency.present ? data.currency.value : this.currency,
      currentBalance: data.currentBalance.present
          ? data.currentBalance.value
          : this.currentBalance,
      assignedUserId: data.assignedUserId.present
          ? data.assignedUserId.value
          : this.assignedUserId,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('subType: $subType, ')
          ..write('parentId: $parentId, ')
          ..write('currency: $currency, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('assignedUserId: $assignedUserId, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    type,
    subType,
    parentId,
    currency,
    currentBalance,
    assignedUserId,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.type == this.type &&
          other.subType == this.subType &&
          other.parentId == this.parentId &&
          other.currency == this.currency &&
          other.currentBalance == this.currentBalance &&
          other.assignedUserId == this.assignedUserId &&
          other.isArchived == this.isArchived);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String?> code;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> subType;
  final Value<String?> parentId;
  final Value<String> currency;
  final Value<double> currentBalance;
  final Value<String?> assignedUserId;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.subType = const Value.absent(),
    this.parentId = const Value.absent(),
    this.currency = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.assignedUserId = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    this.code = const Value.absent(),
    required String name,
    required String type,
    this.subType = const Value.absent(),
    this.parentId = const Value.absent(),
    this.currency = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.assignedUserId = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? subType,
    Expression<String>? parentId,
    Expression<String>? currency,
    Expression<double>? currentBalance,
    Expression<String>? assignedUserId,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (subType != null) 'sub_type': subType,
      if (parentId != null) 'parent_id': parentId,
      if (currency != null) 'currency': currency,
      if (currentBalance != null) 'current_balance': currentBalance,
      if (assignedUserId != null) 'assigned_user_id': assignedUserId,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String?>? code,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? subType,
    Value<String?>? parentId,
    Value<String>? currency,
    Value<double>? currentBalance,
    Value<String?>? assignedUserId,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      parentId: parentId ?? this.parentId,
      currency: currency ?? this.currency,
      currentBalance: currentBalance ?? this.currentBalance,
      assignedUserId: assignedUserId ?? this.assignedUserId,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (subType.present) {
      map['sub_type'] = Variable<String>(subType.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (currentBalance.present) {
      map['current_balance'] = Variable<double>(currentBalance.value);
    }
    if (assignedUserId.present) {
      map['assigned_user_id'] = Variable<String>(assignedUserId.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('subType: $subType, ')
          ..write('parentId: $parentId, ')
          ..write('currency: $currency, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('assignedUserId: $assignedUserId, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<int> phone = GeneratedColumn<int>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
    'gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta(
    'stateCode',
  );
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinCodeMeta = const VerificationMeta(
    'pinCode',
  );
  @override
  late final GeneratedColumn<String> pinCode = GeneratedColumn<String>(
    'pin_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phone,
    name,
    email,
    address,
    gstin,
    stateCode,
    pinCode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('gstin')) {
      context.handle(
        _gstinMeta,
        gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta),
      );
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    }
    if (data.containsKey('pin_code')) {
      context.handle(
        _pinCodeMeta,
        pinCode.isAcceptableOrUnknown(data['pin_code']!, _pinCodeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phone'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      gstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gstin'],
      ),
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      ),
      pinCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final int phone;
  final String name;
  final String? email;
  final String address;
  final String? gstin;
  final String? stateCode;
  final String? pinCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Customer({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    required this.address,
    this.gstin,
    this.stateCode,
    this.pinCode,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone'] = Variable<int>(phone);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || stateCode != null) {
      map['state_code'] = Variable<String>(stateCode);
    }
    if (!nullToAbsent || pinCode != null) {
      map['pin_code'] = Variable<String>(pinCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      phone: Value(phone),
      name: Value(name),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      address: Value(address),
      gstin: gstin == null && nullToAbsent
          ? const Value.absent()
          : Value(gstin),
      stateCode: stateCode == null && nullToAbsent
          ? const Value.absent()
          : Value(stateCode),
      pinCode: pinCode == null && nullToAbsent
          ? const Value.absent()
          : Value(pinCode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      phone: serializer.fromJson<int>(json['phone']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String>(json['address']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      stateCode: serializer.fromJson<String?>(json['stateCode']),
      pinCode: serializer.fromJson<String?>(json['pinCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phone': serializer.toJson<int>(phone),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String>(address),
      'gstin': serializer.toJson<String?>(gstin),
      'stateCode': serializer.toJson<String?>(stateCode),
      'pinCode': serializer.toJson<String?>(pinCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Customer copyWith({
    String? id,
    int? phone,
    String? name,
    Value<String?> email = const Value.absent(),
    String? address,
    Value<String?> gstin = const Value.absent(),
    Value<String?> stateCode = const Value.absent(),
    Value<String?> pinCode = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Customer(
    id: id ?? this.id,
    phone: phone ?? this.phone,
    name: name ?? this.name,
    email: email.present ? email.value : this.email,
    address: address ?? this.address,
    gstin: gstin.present ? gstin.value : this.gstin,
    stateCode: stateCode.present ? stateCode.value : this.stateCode,
    pinCode: pinCode.present ? pinCode.value : this.pinCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      phone: data.phone.present ? data.phone.value : this.phone,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      pinCode: data.pinCode.present ? data.pinCode.value : this.pinCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('gstin: $gstin, ')
          ..write('stateCode: $stateCode, ')
          ..write('pinCode: $pinCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phone,
    name,
    email,
    address,
    gstin,
    stateCode,
    pinCode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.name == this.name &&
          other.email == this.email &&
          other.address == this.address &&
          other.gstin == this.gstin &&
          other.stateCode == this.stateCode &&
          other.pinCode == this.pinCode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<int> phone;
  final Value<String> name;
  final Value<String?> email;
  final Value<String> address;
  final Value<String?> gstin;
  final Value<String?> stateCode;
  final Value<String?> pinCode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.gstin = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.pinCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required int phone,
    required String name,
    this.email = const Value.absent(),
    required String address,
    this.gstin = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.pinCode = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phone = Value(phone),
       name = Value(name),
       address = Value(address),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<int>? phone,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? gstin,
    Expression<String>? stateCode,
    Expression<String>? pinCode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (gstin != null) 'gstin': gstin,
      if (stateCode != null) 'state_code': stateCode,
      if (pinCode != null) 'pin_code': pinCode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<int>? phone,
    Value<String>? name,
    Value<String?>? email,
    Value<String>? address,
    Value<String?>? gstin,
    Value<String?>? stateCode,
    Value<String?>? pinCode,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      gstin: gstin ?? this.gstin,
      stateCode: stateCode ?? this.stateCode,
      pinCode: pinCode ?? this.pinCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phone.present) {
      map['phone'] = Variable<int>(phone.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (pinCode.present) {
      map['pin_code'] = Variable<String>(pinCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('gstin: $gstin, ')
          ..write('stateCode: $stateCode, ')
          ..write('pinCode: $pinCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $VendorsTable vendors = $VendorsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $BrandsTable brands = $BrandsTable(this);
  late final $PurchaseOrdersTable purchaseOrders = $PurchaseOrdersTable(this);
  late final $PurchaseOrderItemsTable purchaseOrderItems =
      $PurchaseOrderItemsTable(this);
  late final $DebitNotesTable debitNotes = $DebitNotesTable(this);
  late final $DebitNoteItemsTable debitNoteItems = $DebitNoteItemsTable(this);
  late final $GoodsReceiptsTable goodsReceipts = $GoodsReceiptsTable(this);
  late final $GoodsReceiptItemsTable goodsReceiptItems =
      $GoodsReceiptItemsTable(this);
  late final $ProductBatchesTable productBatches = $ProductBatchesTable(this);
  late final $ProductTransactionsTable productTransactions =
      $ProductTransactionsTable(this);
  late final $SalesBillsTable salesBills = $SalesBillsTable(this);
  late final $BillItemsTable billItems = $BillItemsTable(this);
  late final $BillPaymentsTable billPayments = $BillPaymentsTable(this);
  late final $GeneralLedgerTable generalLedger = $GeneralLedgerTable(this);
  late final $VendorPaymentsTable vendorPayments = $VendorPaymentsTable(this);
  late final $PaymentAllocationsTable paymentAllocations =
      $PaymentAllocationsTable(this);
  late final $ProductUomsTable productUoms = $ProductUomsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    vendors,
    categories,
    brands,
    purchaseOrders,
    purchaseOrderItems,
    debitNotes,
    debitNoteItems,
    goodsReceipts,
    goodsReceiptItems,
    productBatches,
    productTransactions,
    salesBills,
    billItems,
    billPayments,
    generalLedger,
    vendorPayments,
    paymentAllocations,
    productUoms,
    users,
    auditLogs,
    accounts,
    customers,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      required String categoryId,
      Value<String?> imageUrl,
      Value<double> mrp,
      Value<double> sellingPrice,
      Value<double> purchaseRate,
      Value<bool> isTaxInclusive,
      required String hsnCode,
      required double gstRate,
      Value<double> cessRate,
      Value<bool> isExempt,
      Value<bool?> isInfiniteStock,
      required String uom,
      required double lowStockLimit,
      Value<bool> isLooseItem,
      Value<bool> batchTracking,
      Value<int> warrantyMonths,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> categoryId,
      Value<String?> imageUrl,
      Value<double> mrp,
      Value<double> sellingPrice,
      Value<double> purchaseRate,
      Value<bool> isTaxInclusive,
      Value<String> hsnCode,
      Value<double> gstRate,
      Value<double> cessRate,
      Value<bool> isExempt,
      Value<bool?> isInfiniteStock,
      Value<String> uom,
      Value<double> lowStockLimit,
      Value<bool> isLooseItem,
      Value<bool> batchTracking,
      Value<int> warrantyMonths,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $ProductTransactionsTable,
    List<ProductTransaction>
  >
  _productTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.productTransactions,
        aliasName: $_aliasNameGenerator(
          db.products.id,
          db.productTransactions.productId,
        ),
      );

  $$ProductTransactionsTableProcessedTableManager get productTransactionsRefs {
    final manager = $$ProductTransactionsTableTableManager(
      $_db,
      $_db.productTransactions,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mrp => $composableBuilder(
    column: $table.mrp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchaseRate => $composableBuilder(
    column: $table.purchaseRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTaxInclusive => $composableBuilder(
    column: $table.isTaxInclusive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gstRate => $composableBuilder(
    column: $table.gstRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cessRate => $composableBuilder(
    column: $table.cessRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isExempt => $composableBuilder(
    column: $table.isExempt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInfiniteStock => $composableBuilder(
    column: $table.isInfiniteStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lowStockLimit => $composableBuilder(
    column: $table.lowStockLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLooseItem => $composableBuilder(
    column: $table.isLooseItem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get batchTracking => $composableBuilder(
    column: $table.batchTracking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warrantyMonths => $composableBuilder(
    column: $table.warrantyMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productTransactionsRefs(
    Expression<bool> Function($$ProductTransactionsTableFilterComposer f) f,
  ) {
    final $$ProductTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productTransactions,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.productTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mrp => $composableBuilder(
    column: $table.mrp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchaseRate => $composableBuilder(
    column: $table.purchaseRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTaxInclusive => $composableBuilder(
    column: $table.isTaxInclusive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gstRate => $composableBuilder(
    column: $table.gstRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cessRate => $composableBuilder(
    column: $table.cessRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isExempt => $composableBuilder(
    column: $table.isExempt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInfiniteStock => $composableBuilder(
    column: $table.isInfiniteStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lowStockLimit => $composableBuilder(
    column: $table.lowStockLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLooseItem => $composableBuilder(
    column: $table.isLooseItem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get batchTracking => $composableBuilder(
    column: $table.batchTracking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warrantyMonths => $composableBuilder(
    column: $table.warrantyMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<double> get mrp =>
      $composableBuilder(column: $table.mrp, builder: (column) => column);

  GeneratedColumn<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchaseRate => $composableBuilder(
    column: $table.purchaseRate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isTaxInclusive => $composableBuilder(
    column: $table.isTaxInclusive,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<double> get gstRate =>
      $composableBuilder(column: $table.gstRate, builder: (column) => column);

  GeneratedColumn<double> get cessRate =>
      $composableBuilder(column: $table.cessRate, builder: (column) => column);

  GeneratedColumn<bool> get isExempt =>
      $composableBuilder(column: $table.isExempt, builder: (column) => column);

  GeneratedColumn<bool> get isInfiniteStock => $composableBuilder(
    column: $table.isInfiniteStock,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uom =>
      $composableBuilder(column: $table.uom, builder: (column) => column);

  GeneratedColumn<double> get lowStockLimit => $composableBuilder(
    column: $table.lowStockLimit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLooseItem => $composableBuilder(
    column: $table.isLooseItem,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get batchTracking => $composableBuilder(
    column: $table.batchTracking,
    builder: (column) => column,
  );

  GeneratedColumn<int> get warrantyMonths => $composableBuilder(
    column: $table.warrantyMonths,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> productTransactionsRefs<T extends Object>(
    Expression<T> Function($$ProductTransactionsTableAnnotationComposer a) f,
  ) {
    final $$ProductTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.productTransactions,
          getReferencedColumn: (t) => t.productId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.productTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({bool productTransactionsRefs})
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<double> mrp = const Value.absent(),
                Value<double> sellingPrice = const Value.absent(),
                Value<double> purchaseRate = const Value.absent(),
                Value<bool> isTaxInclusive = const Value.absent(),
                Value<String> hsnCode = const Value.absent(),
                Value<double> gstRate = const Value.absent(),
                Value<double> cessRate = const Value.absent(),
                Value<bool> isExempt = const Value.absent(),
                Value<bool?> isInfiniteStock = const Value.absent(),
                Value<String> uom = const Value.absent(),
                Value<double> lowStockLimit = const Value.absent(),
                Value<bool> isLooseItem = const Value.absent(),
                Value<bool> batchTracking = const Value.absent(),
                Value<int> warrantyMonths = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                categoryId: categoryId,
                imageUrl: imageUrl,
                mrp: mrp,
                sellingPrice: sellingPrice,
                purchaseRate: purchaseRate,
                isTaxInclusive: isTaxInclusive,
                hsnCode: hsnCode,
                gstRate: gstRate,
                cessRate: cessRate,
                isExempt: isExempt,
                isInfiniteStock: isInfiniteStock,
                uom: uom,
                lowStockLimit: lowStockLimit,
                isLooseItem: isLooseItem,
                batchTracking: batchTracking,
                warrantyMonths: warrantyMonths,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String categoryId,
                Value<String?> imageUrl = const Value.absent(),
                Value<double> mrp = const Value.absent(),
                Value<double> sellingPrice = const Value.absent(),
                Value<double> purchaseRate = const Value.absent(),
                Value<bool> isTaxInclusive = const Value.absent(),
                required String hsnCode,
                required double gstRate,
                Value<double> cessRate = const Value.absent(),
                Value<bool> isExempt = const Value.absent(),
                Value<bool?> isInfiniteStock = const Value.absent(),
                required String uom,
                required double lowStockLimit,
                Value<bool> isLooseItem = const Value.absent(),
                Value<bool> batchTracking = const Value.absent(),
                Value<int> warrantyMonths = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                categoryId: categoryId,
                imageUrl: imageUrl,
                mrp: mrp,
                sellingPrice: sellingPrice,
                purchaseRate: purchaseRate,
                isTaxInclusive: isTaxInclusive,
                hsnCode: hsnCode,
                gstRate: gstRate,
                cessRate: cessRate,
                isExempt: isExempt,
                isInfiniteStock: isInfiniteStock,
                uom: uom,
                lowStockLimit: lowStockLimit,
                isLooseItem: isLooseItem,
                batchTracking: batchTracking,
                warrantyMonths: warrantyMonths,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productTransactionsRefs) db.productTransactions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productTransactionsRefs)
                    await $_getPrefetchedData<
                      Product,
                      $ProductsTable,
                      ProductTransaction
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableReferences
                          ._productTransactionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProductsTableReferences(
                        db,
                        table,
                        p0,
                      ).productTransactionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.productId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({bool productTransactionsRefs})
    >;
typedef $$VendorsTableCreateCompanionBuilder =
    VendorsCompanion Function({
      required String id,
      required String name,
      required String address,
      required String contact,
      Value<String?> email,
      Value<String?> gstin,
      Value<String?> stateCode,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$VendorsTableUpdateCompanionBuilder =
    VendorsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> address,
      Value<String> contact,
      Value<String?> email,
      Value<String?> gstin,
      Value<String?> stateCode,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$VendorsTableFilterComposer
    extends Composer<_$AppDatabase, $VendorsTable> {
  $$VendorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VendorsTableOrderingComposer
    extends Composer<_$AppDatabase, $VendorsTable> {
  $$VendorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VendorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VendorsTable> {
  $$VendorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$VendorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VendorsTable,
          Vendor,
          $$VendorsTableFilterComposer,
          $$VendorsTableOrderingComposer,
          $$VendorsTableAnnotationComposer,
          $$VendorsTableCreateCompanionBuilder,
          $$VendorsTableUpdateCompanionBuilder,
          (Vendor, BaseReferences<_$AppDatabase, $VendorsTable, Vendor>),
          Vendor,
          PrefetchHooks Function()
        > {
  $$VendorsTableTableManager(_$AppDatabase db, $VendorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VendorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VendorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VendorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> contact = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VendorsCompanion(
                id: id,
                name: name,
                address: address,
                contact: contact,
                email: email,
                gstin: gstin,
                stateCode: stateCode,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String address,
                required String contact,
                Value<String?> email = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VendorsCompanion.insert(
                id: id,
                name: name,
                address: address,
                contact: contact,
                email: email,
                gstin: gstin,
                stateCode: stateCode,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VendorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VendorsTable,
      Vendor,
      $$VendorsTableFilterComposer,
      $$VendorsTableOrderingComposer,
      $$VendorsTableAnnotationComposer,
      $$VendorsTableCreateCompanionBuilder,
      $$VendorsTableUpdateCompanionBuilder,
      (Vendor, BaseReferences<_$AppDatabase, $VendorsTable, Vendor>),
      Vendor,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) =>
                  CategoriesCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$BrandsTableCreateCompanionBuilder =
    BrandsCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$BrandsTableUpdateCompanionBuilder =
    BrandsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$BrandsTableFilterComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BrandsTableOrderingComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrandsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$BrandsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrandsTable,
          Brand,
          $$BrandsTableFilterComposer,
          $$BrandsTableOrderingComposer,
          $$BrandsTableAnnotationComposer,
          $$BrandsTableCreateCompanionBuilder,
          $$BrandsTableUpdateCompanionBuilder,
          (Brand, BaseReferences<_$AppDatabase, $BrandsTable, Brand>),
          Brand,
          PrefetchHooks Function()
        > {
  $$BrandsTableTableManager(_$AppDatabase db, $BrandsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrandsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrandsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrandsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrandsCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => BrandsCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BrandsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrandsTable,
      Brand,
      $$BrandsTableFilterComposer,
      $$BrandsTableOrderingComposer,
      $$BrandsTableAnnotationComposer,
      $$BrandsTableCreateCompanionBuilder,
      $$BrandsTableUpdateCompanionBuilder,
      (Brand, BaseReferences<_$AppDatabase, $BrandsTable, Brand>),
      Brand,
      PrefetchHooks Function()
    >;
typedef $$PurchaseOrdersTableCreateCompanionBuilder =
    PurchaseOrdersCompanion Function({
      required String id,
      required String poNumber,
      required String vendorId,
      required DateTime date,
      Value<DateTime?> expectedDeliveryDate,
      Value<String> status,
      required double totalAmount,
      Value<String?> grnId,
      Value<String?> grnNumber,
      Value<String?> challanNumber,
      Value<String?> userId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PurchaseOrdersTableUpdateCompanionBuilder =
    PurchaseOrdersCompanion Function({
      Value<String> id,
      Value<String> poNumber,
      Value<String> vendorId,
      Value<DateTime> date,
      Value<DateTime?> expectedDeliveryDate,
      Value<String> status,
      Value<double> totalAmount,
      Value<String?> grnId,
      Value<String?> grnNumber,
      Value<String?> challanNumber,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PurchaseOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseOrdersTable> {
  $$PurchaseOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poNumber => $composableBuilder(
    column: $table.poNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expectedDeliveryDate => $composableBuilder(
    column: $table.expectedDeliveryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grnId => $composableBuilder(
    column: $table.grnId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grnNumber => $composableBuilder(
    column: $table.grnNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challanNumber => $composableBuilder(
    column: $table.challanNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseOrdersTable> {
  $$PurchaseOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poNumber => $composableBuilder(
    column: $table.poNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expectedDeliveryDate => $composableBuilder(
    column: $table.expectedDeliveryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grnId => $composableBuilder(
    column: $table.grnId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grnNumber => $composableBuilder(
    column: $table.grnNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challanNumber => $composableBuilder(
    column: $table.challanNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseOrdersTable> {
  $$PurchaseOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get poNumber =>
      $composableBuilder(column: $table.poNumber, builder: (column) => column);

  GeneratedColumn<String> get vendorId =>
      $composableBuilder(column: $table.vendorId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get expectedDeliveryDate => $composableBuilder(
    column: $table.expectedDeliveryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get grnId =>
      $composableBuilder(column: $table.grnId, builder: (column) => column);

  GeneratedColumn<String> get grnNumber =>
      $composableBuilder(column: $table.grnNumber, builder: (column) => column);

  GeneratedColumn<String> get challanNumber => $composableBuilder(
    column: $table.challanNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PurchaseOrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseOrdersTable,
          PurchaseOrder,
          $$PurchaseOrdersTableFilterComposer,
          $$PurchaseOrdersTableOrderingComposer,
          $$PurchaseOrdersTableAnnotationComposer,
          $$PurchaseOrdersTableCreateCompanionBuilder,
          $$PurchaseOrdersTableUpdateCompanionBuilder,
          (
            PurchaseOrder,
            BaseReferences<_$AppDatabase, $PurchaseOrdersTable, PurchaseOrder>,
          ),
          PurchaseOrder,
          PrefetchHooks Function()
        > {
  $$PurchaseOrdersTableTableManager(
    _$AppDatabase db,
    $PurchaseOrdersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> poNumber = const Value.absent(),
                Value<String> vendorId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime?> expectedDeliveryDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<String?> grnId = const Value.absent(),
                Value<String?> grnNumber = const Value.absent(),
                Value<String?> challanNumber = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseOrdersCompanion(
                id: id,
                poNumber: poNumber,
                vendorId: vendorId,
                date: date,
                expectedDeliveryDate: expectedDeliveryDate,
                status: status,
                totalAmount: totalAmount,
                grnId: grnId,
                grnNumber: grnNumber,
                challanNumber: challanNumber,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String poNumber,
                required String vendorId,
                required DateTime date,
                Value<DateTime?> expectedDeliveryDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                required double totalAmount,
                Value<String?> grnId = const Value.absent(),
                Value<String?> grnNumber = const Value.absent(),
                Value<String?> challanNumber = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PurchaseOrdersCompanion.insert(
                id: id,
                poNumber: poNumber,
                vendorId: vendorId,
                date: date,
                expectedDeliveryDate: expectedDeliveryDate,
                status: status,
                totalAmount: totalAmount,
                grnId: grnId,
                grnNumber: grnNumber,
                challanNumber: challanNumber,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseOrdersTable,
      PurchaseOrder,
      $$PurchaseOrdersTableFilterComposer,
      $$PurchaseOrdersTableOrderingComposer,
      $$PurchaseOrdersTableAnnotationComposer,
      $$PurchaseOrdersTableCreateCompanionBuilder,
      $$PurchaseOrdersTableUpdateCompanionBuilder,
      (
        PurchaseOrder,
        BaseReferences<_$AppDatabase, $PurchaseOrdersTable, PurchaseOrder>,
      ),
      PurchaseOrder,
      PrefetchHooks Function()
    >;
typedef $$PurchaseOrderItemsTableCreateCompanionBuilder =
    PurchaseOrderItemsCompanion Function({
      Value<int> id,
      required String poId,
      required String productId,
      required int quantity,
      required double unitPrice,
      required String productName,
      Value<String?> hsnCode,
      required double taxRate,
      required double cessRate,
      Value<String?> uom,
      Value<double> conversionFactor,
      Value<int?> receivedQuantity,
    });
typedef $$PurchaseOrderItemsTableUpdateCompanionBuilder =
    PurchaseOrderItemsCompanion Function({
      Value<int> id,
      Value<String> poId,
      Value<String> productId,
      Value<int> quantity,
      Value<double> unitPrice,
      Value<String> productName,
      Value<String?> hsnCode,
      Value<double> taxRate,
      Value<double> cessRate,
      Value<String?> uom,
      Value<double> conversionFactor,
      Value<int?> receivedQuantity,
    });

class $$PurchaseOrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseOrderItemsTable> {
  $$PurchaseOrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poId => $composableBuilder(
    column: $table.poId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cessRate => $composableBuilder(
    column: $table.cessRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receivedQuantity => $composableBuilder(
    column: $table.receivedQuantity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseOrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseOrderItemsTable> {
  $$PurchaseOrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poId => $composableBuilder(
    column: $table.poId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cessRate => $composableBuilder(
    column: $table.cessRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receivedQuantity => $composableBuilder(
    column: $table.receivedQuantity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseOrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseOrderItemsTable> {
  $$PurchaseOrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get poId =>
      $composableBuilder(column: $table.poId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<double> get cessRate =>
      $composableBuilder(column: $table.cessRate, builder: (column) => column);

  GeneratedColumn<String> get uom =>
      $composableBuilder(column: $table.uom, builder: (column) => column);

  GeneratedColumn<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receivedQuantity => $composableBuilder(
    column: $table.receivedQuantity,
    builder: (column) => column,
  );
}

class $$PurchaseOrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseOrderItemsTable,
          PurchaseOrderItem,
          $$PurchaseOrderItemsTableFilterComposer,
          $$PurchaseOrderItemsTableOrderingComposer,
          $$PurchaseOrderItemsTableAnnotationComposer,
          $$PurchaseOrderItemsTableCreateCompanionBuilder,
          $$PurchaseOrderItemsTableUpdateCompanionBuilder,
          (
            PurchaseOrderItem,
            BaseReferences<
              _$AppDatabase,
              $PurchaseOrderItemsTable,
              PurchaseOrderItem
            >,
          ),
          PurchaseOrderItem,
          PrefetchHooks Function()
        > {
  $$PurchaseOrderItemsTableTableManager(
    _$AppDatabase db,
    $PurchaseOrderItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseOrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseOrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseOrderItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> poId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<double> cessRate = const Value.absent(),
                Value<String?> uom = const Value.absent(),
                Value<double> conversionFactor = const Value.absent(),
                Value<int?> receivedQuantity = const Value.absent(),
              }) => PurchaseOrderItemsCompanion(
                id: id,
                poId: poId,
                productId: productId,
                quantity: quantity,
                unitPrice: unitPrice,
                productName: productName,
                hsnCode: hsnCode,
                taxRate: taxRate,
                cessRate: cessRate,
                uom: uom,
                conversionFactor: conversionFactor,
                receivedQuantity: receivedQuantity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String poId,
                required String productId,
                required int quantity,
                required double unitPrice,
                required String productName,
                Value<String?> hsnCode = const Value.absent(),
                required double taxRate,
                required double cessRate,
                Value<String?> uom = const Value.absent(),
                Value<double> conversionFactor = const Value.absent(),
                Value<int?> receivedQuantity = const Value.absent(),
              }) => PurchaseOrderItemsCompanion.insert(
                id: id,
                poId: poId,
                productId: productId,
                quantity: quantity,
                unitPrice: unitPrice,
                productName: productName,
                hsnCode: hsnCode,
                taxRate: taxRate,
                cessRate: cessRate,
                uom: uom,
                conversionFactor: conversionFactor,
                receivedQuantity: receivedQuantity,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseOrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseOrderItemsTable,
      PurchaseOrderItem,
      $$PurchaseOrderItemsTableFilterComposer,
      $$PurchaseOrderItemsTableOrderingComposer,
      $$PurchaseOrderItemsTableAnnotationComposer,
      $$PurchaseOrderItemsTableCreateCompanionBuilder,
      $$PurchaseOrderItemsTableUpdateCompanionBuilder,
      (
        PurchaseOrderItem,
        BaseReferences<
          _$AppDatabase,
          $PurchaseOrderItemsTable,
          PurchaseOrderItem
        >,
      ),
      PurchaseOrderItem,
      PrefetchHooks Function()
    >;
typedef $$DebitNotesTableCreateCompanionBuilder =
    DebitNotesCompanion Function({
      required String id,
      required String vendorId,
      Value<String?> poId,
      required DateTime date,
      required double amount,
      required String reason,
      Value<String?> notes,
      required String status,
      Value<String?> userId,
      Value<int> rowid,
    });
typedef $$DebitNotesTableUpdateCompanionBuilder =
    DebitNotesCompanion Function({
      Value<String> id,
      Value<String> vendorId,
      Value<String?> poId,
      Value<DateTime> date,
      Value<double> amount,
      Value<String> reason,
      Value<String?> notes,
      Value<String> status,
      Value<String?> userId,
      Value<int> rowid,
    });

class $$DebitNotesTableFilterComposer
    extends Composer<_$AppDatabase, $DebitNotesTable> {
  $$DebitNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poId => $composableBuilder(
    column: $table.poId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DebitNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $DebitNotesTable> {
  $$DebitNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poId => $composableBuilder(
    column: $table.poId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebitNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebitNotesTable> {
  $$DebitNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vendorId =>
      $composableBuilder(column: $table.vendorId, builder: (column) => column);

  GeneratedColumn<String> get poId =>
      $composableBuilder(column: $table.poId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);
}

class $$DebitNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebitNotesTable,
          DebitNote,
          $$DebitNotesTableFilterComposer,
          $$DebitNotesTableOrderingComposer,
          $$DebitNotesTableAnnotationComposer,
          $$DebitNotesTableCreateCompanionBuilder,
          $$DebitNotesTableUpdateCompanionBuilder,
          (
            DebitNote,
            BaseReferences<_$AppDatabase, $DebitNotesTable, DebitNote>,
          ),
          DebitNote,
          PrefetchHooks Function()
        > {
  $$DebitNotesTableTableManager(_$AppDatabase db, $DebitNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebitNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebitNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebitNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vendorId = const Value.absent(),
                Value<String?> poId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DebitNotesCompanion(
                id: id,
                vendorId: vendorId,
                poId: poId,
                date: date,
                amount: amount,
                reason: reason,
                notes: notes,
                status: status,
                userId: userId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vendorId,
                Value<String?> poId = const Value.absent(),
                required DateTime date,
                required double amount,
                required String reason,
                Value<String?> notes = const Value.absent(),
                required String status,
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DebitNotesCompanion.insert(
                id: id,
                vendorId: vendorId,
                poId: poId,
                date: date,
                amount: amount,
                reason: reason,
                notes: notes,
                status: status,
                userId: userId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DebitNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebitNotesTable,
      DebitNote,
      $$DebitNotesTableFilterComposer,
      $$DebitNotesTableOrderingComposer,
      $$DebitNotesTableAnnotationComposer,
      $$DebitNotesTableCreateCompanionBuilder,
      $$DebitNotesTableUpdateCompanionBuilder,
      (DebitNote, BaseReferences<_$AppDatabase, $DebitNotesTable, DebitNote>),
      DebitNote,
      PrefetchHooks Function()
    >;
typedef $$DebitNoteItemsTableCreateCompanionBuilder =
    DebitNoteItemsCompanion Function({
      Value<int> id,
      required String dnId,
      required String productId,
      required String productName,
      required int orderedQty,
      required int rejectedQty,
      required String reason,
      required double rate,
      required double taxRate,
    });
typedef $$DebitNoteItemsTableUpdateCompanionBuilder =
    DebitNoteItemsCompanion Function({
      Value<int> id,
      Value<String> dnId,
      Value<String> productId,
      Value<String> productName,
      Value<int> orderedQty,
      Value<int> rejectedQty,
      Value<String> reason,
      Value<double> rate,
      Value<double> taxRate,
    });

class $$DebitNoteItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DebitNoteItemsTable> {
  $$DebitNoteItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dnId => $composableBuilder(
    column: $table.dnId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderedQty => $composableBuilder(
    column: $table.orderedQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rejectedQty => $composableBuilder(
    column: $table.rejectedQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DebitNoteItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebitNoteItemsTable> {
  $$DebitNoteItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dnId => $composableBuilder(
    column: $table.dnId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderedQty => $composableBuilder(
    column: $table.orderedQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rejectedQty => $composableBuilder(
    column: $table.rejectedQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebitNoteItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebitNoteItemsTable> {
  $$DebitNoteItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dnId =>
      $composableBuilder(column: $table.dnId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderedQty => $composableBuilder(
    column: $table.orderedQty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rejectedQty => $composableBuilder(
    column: $table.rejectedQty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);
}

class $$DebitNoteItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebitNoteItemsTable,
          DebitNoteItem,
          $$DebitNoteItemsTableFilterComposer,
          $$DebitNoteItemsTableOrderingComposer,
          $$DebitNoteItemsTableAnnotationComposer,
          $$DebitNoteItemsTableCreateCompanionBuilder,
          $$DebitNoteItemsTableUpdateCompanionBuilder,
          (
            DebitNoteItem,
            BaseReferences<_$AppDatabase, $DebitNoteItemsTable, DebitNoteItem>,
          ),
          DebitNoteItem,
          PrefetchHooks Function()
        > {
  $$DebitNoteItemsTableTableManager(
    _$AppDatabase db,
    $DebitNoteItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebitNoteItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebitNoteItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebitNoteItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dnId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<int> orderedQty = const Value.absent(),
                Value<int> rejectedQty = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
              }) => DebitNoteItemsCompanion(
                id: id,
                dnId: dnId,
                productId: productId,
                productName: productName,
                orderedQty: orderedQty,
                rejectedQty: rejectedQty,
                reason: reason,
                rate: rate,
                taxRate: taxRate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dnId,
                required String productId,
                required String productName,
                required int orderedQty,
                required int rejectedQty,
                required String reason,
                required double rate,
                required double taxRate,
              }) => DebitNoteItemsCompanion.insert(
                id: id,
                dnId: dnId,
                productId: productId,
                productName: productName,
                orderedQty: orderedQty,
                rejectedQty: rejectedQty,
                reason: reason,
                rate: rate,
                taxRate: taxRate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DebitNoteItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebitNoteItemsTable,
      DebitNoteItem,
      $$DebitNoteItemsTableFilterComposer,
      $$DebitNoteItemsTableOrderingComposer,
      $$DebitNoteItemsTableAnnotationComposer,
      $$DebitNoteItemsTableCreateCompanionBuilder,
      $$DebitNoteItemsTableUpdateCompanionBuilder,
      (
        DebitNoteItem,
        BaseReferences<_$AppDatabase, $DebitNoteItemsTable, DebitNoteItem>,
      ),
      DebitNoteItem,
      PrefetchHooks Function()
    >;
typedef $$GoodsReceiptsTableCreateCompanionBuilder =
    GoodsReceiptsCompanion Function({
      required String id,
      required String poId,
      required String grnNumber,
      Value<String?> challanNumber,
      Value<String?> userId,
      required DateTime grnDate,
      Value<double> paidAmount,
      Value<double> totalAmount,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$GoodsReceiptsTableUpdateCompanionBuilder =
    GoodsReceiptsCompanion Function({
      Value<String> id,
      Value<String> poId,
      Value<String> grnNumber,
      Value<String?> challanNumber,
      Value<String?> userId,
      Value<DateTime> grnDate,
      Value<double> paidAmount,
      Value<double> totalAmount,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$GoodsReceiptsTableFilterComposer
    extends Composer<_$AppDatabase, $GoodsReceiptsTable> {
  $$GoodsReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poId => $composableBuilder(
    column: $table.poId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grnNumber => $composableBuilder(
    column: $table.grnNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challanNumber => $composableBuilder(
    column: $table.challanNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get grnDate => $composableBuilder(
    column: $table.grnDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoodsReceiptsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoodsReceiptsTable> {
  $$GoodsReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poId => $composableBuilder(
    column: $table.poId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grnNumber => $composableBuilder(
    column: $table.grnNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challanNumber => $composableBuilder(
    column: $table.challanNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get grnDate => $composableBuilder(
    column: $table.grnDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoodsReceiptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoodsReceiptsTable> {
  $$GoodsReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get poId =>
      $composableBuilder(column: $table.poId, builder: (column) => column);

  GeneratedColumn<String> get grnNumber =>
      $composableBuilder(column: $table.grnNumber, builder: (column) => column);

  GeneratedColumn<String> get challanNumber => $composableBuilder(
    column: $table.challanNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get grnDate =>
      $composableBuilder(column: $table.grnDate, builder: (column) => column);

  GeneratedColumn<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GoodsReceiptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoodsReceiptsTable,
          GoodsReceipt,
          $$GoodsReceiptsTableFilterComposer,
          $$GoodsReceiptsTableOrderingComposer,
          $$GoodsReceiptsTableAnnotationComposer,
          $$GoodsReceiptsTableCreateCompanionBuilder,
          $$GoodsReceiptsTableUpdateCompanionBuilder,
          (
            GoodsReceipt,
            BaseReferences<_$AppDatabase, $GoodsReceiptsTable, GoodsReceipt>,
          ),
          GoodsReceipt,
          PrefetchHooks Function()
        > {
  $$GoodsReceiptsTableTableManager(_$AppDatabase db, $GoodsReceiptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoodsReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoodsReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoodsReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> poId = const Value.absent(),
                Value<String> grnNumber = const Value.absent(),
                Value<String?> challanNumber = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> grnDate = const Value.absent(),
                Value<double> paidAmount = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoodsReceiptsCompanion(
                id: id,
                poId: poId,
                grnNumber: grnNumber,
                challanNumber: challanNumber,
                userId: userId,
                grnDate: grnDate,
                paidAmount: paidAmount,
                totalAmount: totalAmount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String poId,
                required String grnNumber,
                Value<String?> challanNumber = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                required DateTime grnDate,
                Value<double> paidAmount = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoodsReceiptsCompanion.insert(
                id: id,
                poId: poId,
                grnNumber: grnNumber,
                challanNumber: challanNumber,
                userId: userId,
                grnDate: grnDate,
                paidAmount: paidAmount,
                totalAmount: totalAmount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoodsReceiptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoodsReceiptsTable,
      GoodsReceipt,
      $$GoodsReceiptsTableFilterComposer,
      $$GoodsReceiptsTableOrderingComposer,
      $$GoodsReceiptsTableAnnotationComposer,
      $$GoodsReceiptsTableCreateCompanionBuilder,
      $$GoodsReceiptsTableUpdateCompanionBuilder,
      (
        GoodsReceipt,
        BaseReferences<_$AppDatabase, $GoodsReceiptsTable, GoodsReceipt>,
      ),
      GoodsReceipt,
      PrefetchHooks Function()
    >;
typedef $$GoodsReceiptItemsTableCreateCompanionBuilder =
    GoodsReceiptItemsCompanion Function({
      required String id,
      required String grnId,
      required String productId,
      required String productName,
      Value<String?> hsnCode,
      required double orderedQty,
      required double receivedQty,
      required double rejectedQty,
      required double acceptedQty,
      required double rate,
      Value<double> taxRate,
      Value<String?> uom,
      Value<double> conversionFactor,
      Value<int> rowid,
    });
typedef $$GoodsReceiptItemsTableUpdateCompanionBuilder =
    GoodsReceiptItemsCompanion Function({
      Value<String> id,
      Value<String> grnId,
      Value<String> productId,
      Value<String> productName,
      Value<String?> hsnCode,
      Value<double> orderedQty,
      Value<double> receivedQty,
      Value<double> rejectedQty,
      Value<double> acceptedQty,
      Value<double> rate,
      Value<double> taxRate,
      Value<String?> uom,
      Value<double> conversionFactor,
      Value<int> rowid,
    });

class $$GoodsReceiptItemsTableFilterComposer
    extends Composer<_$AppDatabase, $GoodsReceiptItemsTable> {
  $$GoodsReceiptItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grnId => $composableBuilder(
    column: $table.grnId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get orderedQty => $composableBuilder(
    column: $table.orderedQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get receivedQty => $composableBuilder(
    column: $table.receivedQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rejectedQty => $composableBuilder(
    column: $table.rejectedQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get acceptedQty => $composableBuilder(
    column: $table.acceptedQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoodsReceiptItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoodsReceiptItemsTable> {
  $$GoodsReceiptItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grnId => $composableBuilder(
    column: $table.grnId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get orderedQty => $composableBuilder(
    column: $table.orderedQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get receivedQty => $composableBuilder(
    column: $table.receivedQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rejectedQty => $composableBuilder(
    column: $table.rejectedQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get acceptedQty => $composableBuilder(
    column: $table.acceptedQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoodsReceiptItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoodsReceiptItemsTable> {
  $$GoodsReceiptItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get grnId =>
      $composableBuilder(column: $table.grnId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<double> get orderedQty => $composableBuilder(
    column: $table.orderedQty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get receivedQty => $composableBuilder(
    column: $table.receivedQty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rejectedQty => $composableBuilder(
    column: $table.rejectedQty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get acceptedQty => $composableBuilder(
    column: $table.acceptedQty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<String> get uom =>
      $composableBuilder(column: $table.uom, builder: (column) => column);

  GeneratedColumn<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => column,
  );
}

class $$GoodsReceiptItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoodsReceiptItemsTable,
          GoodsReceiptItem,
          $$GoodsReceiptItemsTableFilterComposer,
          $$GoodsReceiptItemsTableOrderingComposer,
          $$GoodsReceiptItemsTableAnnotationComposer,
          $$GoodsReceiptItemsTableCreateCompanionBuilder,
          $$GoodsReceiptItemsTableUpdateCompanionBuilder,
          (
            GoodsReceiptItem,
            BaseReferences<
              _$AppDatabase,
              $GoodsReceiptItemsTable,
              GoodsReceiptItem
            >,
          ),
          GoodsReceiptItem,
          PrefetchHooks Function()
        > {
  $$GoodsReceiptItemsTableTableManager(
    _$AppDatabase db,
    $GoodsReceiptItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoodsReceiptItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoodsReceiptItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoodsReceiptItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> grnId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double> orderedQty = const Value.absent(),
                Value<double> receivedQty = const Value.absent(),
                Value<double> rejectedQty = const Value.absent(),
                Value<double> acceptedQty = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<String?> uom = const Value.absent(),
                Value<double> conversionFactor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoodsReceiptItemsCompanion(
                id: id,
                grnId: grnId,
                productId: productId,
                productName: productName,
                hsnCode: hsnCode,
                orderedQty: orderedQty,
                receivedQty: receivedQty,
                rejectedQty: rejectedQty,
                acceptedQty: acceptedQty,
                rate: rate,
                taxRate: taxRate,
                uom: uom,
                conversionFactor: conversionFactor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String grnId,
                required String productId,
                required String productName,
                Value<String?> hsnCode = const Value.absent(),
                required double orderedQty,
                required double receivedQty,
                required double rejectedQty,
                required double acceptedQty,
                required double rate,
                Value<double> taxRate = const Value.absent(),
                Value<String?> uom = const Value.absent(),
                Value<double> conversionFactor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoodsReceiptItemsCompanion.insert(
                id: id,
                grnId: grnId,
                productId: productId,
                productName: productName,
                hsnCode: hsnCode,
                orderedQty: orderedQty,
                receivedQty: receivedQty,
                rejectedQty: rejectedQty,
                acceptedQty: acceptedQty,
                rate: rate,
                taxRate: taxRate,
                uom: uom,
                conversionFactor: conversionFactor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoodsReceiptItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoodsReceiptItemsTable,
      GoodsReceiptItem,
      $$GoodsReceiptItemsTableFilterComposer,
      $$GoodsReceiptItemsTableOrderingComposer,
      $$GoodsReceiptItemsTableAnnotationComposer,
      $$GoodsReceiptItemsTableCreateCompanionBuilder,
      $$GoodsReceiptItemsTableUpdateCompanionBuilder,
      (
        GoodsReceiptItem,
        BaseReferences<
          _$AppDatabase,
          $GoodsReceiptItemsTable,
          GoodsReceiptItem
        >,
      ),
      GoodsReceiptItem,
      PrefetchHooks Function()
    >;
typedef $$ProductBatchesTableCreateCompanionBuilder =
    ProductBatchesCompanion Function({
      required String id,
      required String productId,
      required double mrp,
      required double sellingPrice,
      required double purchaseRate,
      Value<double> stockQty,
      Value<String?> batchNumber,
      Value<DateTime?> expiryDate,
      Value<bool> isDamaged,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$ProductBatchesTableUpdateCompanionBuilder =
    ProductBatchesCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<double> mrp,
      Value<double> sellingPrice,
      Value<double> purchaseRate,
      Value<double> stockQty,
      Value<String?> batchNumber,
      Value<DateTime?> expiryDate,
      Value<bool> isDamaged,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$ProductBatchesTableReferences
    extends BaseReferences<_$AppDatabase, $ProductBatchesTable, ProductBatch> {
  $$ProductBatchesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ProductTransactionsTable,
    List<ProductTransaction>
  >
  _productTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.productTransactions,
        aliasName: $_aliasNameGenerator(
          db.productBatches.id,
          db.productTransactions.batchId,
        ),
      );

  $$ProductTransactionsTableProcessedTableManager get productTransactionsRefs {
    final manager = $$ProductTransactionsTableTableManager(
      $_db,
      $_db.productTransactions,
    ).filter((f) => f.batchId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductBatchesTable> {
  $$ProductBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mrp => $composableBuilder(
    column: $table.mrp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchaseRate => $composableBuilder(
    column: $table.purchaseRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDamaged => $composableBuilder(
    column: $table.isDamaged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productTransactionsRefs(
    Expression<bool> Function($$ProductTransactionsTableFilterComposer f) f,
  ) {
    final $$ProductTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productTransactions,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.productTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductBatchesTable> {
  $$ProductBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mrp => $composableBuilder(
    column: $table.mrp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchaseRate => $composableBuilder(
    column: $table.purchaseRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDamaged => $composableBuilder(
    column: $table.isDamaged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductBatchesTable> {
  $$ProductBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<double> get mrp =>
      $composableBuilder(column: $table.mrp, builder: (column) => column);

  GeneratedColumn<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchaseRate => $composableBuilder(
    column: $table.purchaseRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDamaged =>
      $composableBuilder(column: $table.isDamaged, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> productTransactionsRefs<T extends Object>(
    Expression<T> Function($$ProductTransactionsTableAnnotationComposer a) f,
  ) {
    final $$ProductTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.productTransactions,
          getReferencedColumn: (t) => t.batchId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.productTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProductBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductBatchesTable,
          ProductBatch,
          $$ProductBatchesTableFilterComposer,
          $$ProductBatchesTableOrderingComposer,
          $$ProductBatchesTableAnnotationComposer,
          $$ProductBatchesTableCreateCompanionBuilder,
          $$ProductBatchesTableUpdateCompanionBuilder,
          (ProductBatch, $$ProductBatchesTableReferences),
          ProductBatch,
          PrefetchHooks Function({bool productTransactionsRefs})
        > {
  $$ProductBatchesTableTableManager(
    _$AppDatabase db,
    $ProductBatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<double> mrp = const Value.absent(),
                Value<double> sellingPrice = const Value.absent(),
                Value<double> purchaseRate = const Value.absent(),
                Value<double> stockQty = const Value.absent(),
                Value<String?> batchNumber = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<bool> isDamaged = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductBatchesCompanion(
                id: id,
                productId: productId,
                mrp: mrp,
                sellingPrice: sellingPrice,
                purchaseRate: purchaseRate,
                stockQty: stockQty,
                batchNumber: batchNumber,
                expiryDate: expiryDate,
                isDamaged: isDamaged,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required double mrp,
                required double sellingPrice,
                required double purchaseRate,
                Value<double> stockQty = const Value.absent(),
                Value<String?> batchNumber = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<bool> isDamaged = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductBatchesCompanion.insert(
                id: id,
                productId: productId,
                mrp: mrp,
                sellingPrice: sellingPrice,
                purchaseRate: purchaseRate,
                stockQty: stockQty,
                batchNumber: batchNumber,
                expiryDate: expiryDate,
                isDamaged: isDamaged,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductBatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productTransactionsRefs) db.productTransactions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productTransactionsRefs)
                    await $_getPrefetchedData<
                      ProductBatch,
                      $ProductBatchesTable,
                      ProductTransaction
                    >(
                      currentTable: table,
                      referencedTable: $$ProductBatchesTableReferences
                          ._productTransactionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProductBatchesTableReferences(
                            db,
                            table,
                            p0,
                          ).productTransactionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.batchId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductBatchesTable,
      ProductBatch,
      $$ProductBatchesTableFilterComposer,
      $$ProductBatchesTableOrderingComposer,
      $$ProductBatchesTableAnnotationComposer,
      $$ProductBatchesTableCreateCompanionBuilder,
      $$ProductBatchesTableUpdateCompanionBuilder,
      (ProductBatch, $$ProductBatchesTableReferences),
      ProductBatch,
      PrefetchHooks Function({bool productTransactionsRefs})
    >;
typedef $$ProductTransactionsTableCreateCompanionBuilder =
    ProductTransactionsCompanion Function({
      Value<String> id,
      required String productId,
      required String type,
      required double quantity,
      required double price,
      required double totalAmount,
      required DateTime date,
      Value<String?> orderId,
      Value<String?> location,
      Value<String?> batchId,
      Value<String?> userId,
      Value<int> rowid,
    });
typedef $$ProductTransactionsTableUpdateCompanionBuilder =
    ProductTransactionsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> type,
      Value<double> quantity,
      Value<double> price,
      Value<double> totalAmount,
      Value<DateTime> date,
      Value<String?> orderId,
      Value<String?> location,
      Value<String?> batchId,
      Value<String?> userId,
      Value<int> rowid,
    });

final class $$ProductTransactionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProductTransactionsTable,
          ProductTransaction
        > {
  $$ProductTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.productTransactions.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductBatchesTable _batchIdTable(_$AppDatabase db) =>
      db.productBatches.createAlias(
        $_aliasNameGenerator(
          db.productTransactions.batchId,
          db.productBatches.id,
        ),
      );

  $$ProductBatchesTableProcessedTableManager? get batchId {
    final $_column = $_itemColumn<String>('batch_id');
    if ($_column == null) return null;
    final manager = $$ProductBatchesTableTableManager(
      $_db,
      $_db.productBatches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductTransactionsTable> {
  $$ProductTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductBatchesTableFilterComposer get batchId {
    final $$ProductBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.productBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductBatchesTableFilterComposer(
            $db: $db,
            $table: $db.productBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductTransactionsTable> {
  $$ProductTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductBatchesTableOrderingComposer get batchId {
    final $$ProductBatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.productBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductBatchesTableOrderingComposer(
            $db: $db,
            $table: $db.productBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductTransactionsTable> {
  $$ProductTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductBatchesTableAnnotationComposer get batchId {
    final $$ProductBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.productBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.productBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductTransactionsTable,
          ProductTransaction,
          $$ProductTransactionsTableFilterComposer,
          $$ProductTransactionsTableOrderingComposer,
          $$ProductTransactionsTableAnnotationComposer,
          $$ProductTransactionsTableCreateCompanionBuilder,
          $$ProductTransactionsTableUpdateCompanionBuilder,
          (ProductTransaction, $$ProductTransactionsTableReferences),
          ProductTransaction,
          PrefetchHooks Function({bool productId, bool batchId})
        > {
  $$ProductTransactionsTableTableManager(
    _$AppDatabase db,
    $ProductTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProductTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> orderId = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> batchId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductTransactionsCompanion(
                id: id,
                productId: productId,
                type: type,
                quantity: quantity,
                price: price,
                totalAmount: totalAmount,
                date: date,
                orderId: orderId,
                location: location,
                batchId: batchId,
                userId: userId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String productId,
                required String type,
                required double quantity,
                required double price,
                required double totalAmount,
                required DateTime date,
                Value<String?> orderId = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> batchId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductTransactionsCompanion.insert(
                id: id,
                productId: productId,
                type: type,
                quantity: quantity,
                price: price,
                totalAmount: totalAmount,
                date: date,
                orderId: orderId,
                location: location,
                batchId: batchId,
                userId: userId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductTransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false, batchId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$ProductTransactionsTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$ProductTransactionsTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (batchId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.batchId,
                                referencedTable:
                                    $$ProductTransactionsTableReferences
                                        ._batchIdTable(db),
                                referencedColumn:
                                    $$ProductTransactionsTableReferences
                                        ._batchIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProductTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductTransactionsTable,
      ProductTransaction,
      $$ProductTransactionsTableFilterComposer,
      $$ProductTransactionsTableOrderingComposer,
      $$ProductTransactionsTableAnnotationComposer,
      $$ProductTransactionsTableCreateCompanionBuilder,
      $$ProductTransactionsTableUpdateCompanionBuilder,
      (ProductTransaction, $$ProductTransactionsTableReferences),
      ProductTransaction,
      PrefetchHooks Function({bool productId, bool batchId})
    >;
typedef $$SalesBillsTableCreateCompanionBuilder =
    SalesBillsCompanion Function({
      required String id,
      required DateTime date,
      Value<String?> customerName,
      Value<String?> customerId,
      required double grandTotal,
      required String paymentStatus,
      Value<String?> userId,
      Value<int> rowid,
    });
typedef $$SalesBillsTableUpdateCompanionBuilder =
    SalesBillsCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String?> customerName,
      Value<String?> customerId,
      Value<double> grandTotal,
      Value<String> paymentStatus,
      Value<String?> userId,
      Value<int> rowid,
    });

final class $$SalesBillsTableReferences
    extends BaseReferences<_$AppDatabase, $SalesBillsTable, SalesBill> {
  $$SalesBillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BillPaymentsTable, List<BillPayment>>
  _billPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.billPayments,
    aliasName: $_aliasNameGenerator(db.salesBills.id, db.billPayments.billId),
  );

  $$BillPaymentsTableProcessedTableManager get billPaymentsRefs {
    final manager = $$BillPaymentsTableTableManager(
      $_db,
      $_db.billPayments,
    ).filter((f) => f.billId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_billPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SalesBillsTableFilterComposer
    extends Composer<_$AppDatabase, $SalesBillsTable> {
  $$SalesBillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> billPaymentsRefs(
    Expression<bool> Function($$BillPaymentsTableFilterComposer f) f,
  ) {
    final $$BillPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billPayments,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.billPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesBillsTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesBillsTable> {
  $$SalesBillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesBillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesBillsTable> {
  $$SalesBillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  Expression<T> billPaymentsRefs<T extends Object>(
    Expression<T> Function($$BillPaymentsTableAnnotationComposer a) f,
  ) {
    final $$BillPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.billPayments,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.billPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesBillsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesBillsTable,
          SalesBill,
          $$SalesBillsTableFilterComposer,
          $$SalesBillsTableOrderingComposer,
          $$SalesBillsTableAnnotationComposer,
          $$SalesBillsTableCreateCompanionBuilder,
          $$SalesBillsTableUpdateCompanionBuilder,
          (SalesBill, $$SalesBillsTableReferences),
          SalesBill,
          PrefetchHooks Function({bool billPaymentsRefs})
        > {
  $$SalesBillsTableTableManager(_$AppDatabase db, $SalesBillsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesBillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesBillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesBillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<double> grandTotal = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesBillsCompanion(
                id: id,
                date: date,
                customerName: customerName,
                customerId: customerId,
                grandTotal: grandTotal,
                paymentStatus: paymentStatus,
                userId: userId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                Value<String?> customerName = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                required double grandTotal,
                required String paymentStatus,
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesBillsCompanion.insert(
                id: id,
                date: date,
                customerName: customerName,
                customerId: customerId,
                grandTotal: grandTotal,
                paymentStatus: paymentStatus,
                userId: userId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SalesBillsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({billPaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (billPaymentsRefs) db.billPayments],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (billPaymentsRefs)
                    await $_getPrefetchedData<
                      SalesBill,
                      $SalesBillsTable,
                      BillPayment
                    >(
                      currentTable: table,
                      referencedTable: $$SalesBillsTableReferences
                          ._billPaymentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SalesBillsTableReferences(
                            db,
                            table,
                            p0,
                          ).billPaymentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.billId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SalesBillsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesBillsTable,
      SalesBill,
      $$SalesBillsTableFilterComposer,
      $$SalesBillsTableOrderingComposer,
      $$SalesBillsTableAnnotationComposer,
      $$SalesBillsTableCreateCompanionBuilder,
      $$SalesBillsTableUpdateCompanionBuilder,
      (SalesBill, $$SalesBillsTableReferences),
      SalesBill,
      PrefetchHooks Function({bool billPaymentsRefs})
    >;
typedef $$BillItemsTableCreateCompanionBuilder =
    BillItemsCompanion Function({
      required String id,
      required String billId,
      required String productId,
      required String productName,
      Value<String?> hsnCode,
      required double quantity,
      required double unitPrice,
      Value<double> taxRate,
      Value<double> cessRate,
      required double taxAmount,
      required double totalAmount,
      Value<DateTime?> warrantyEndDate,
      Value<int> rowid,
    });
typedef $$BillItemsTableUpdateCompanionBuilder =
    BillItemsCompanion Function({
      Value<String> id,
      Value<String> billId,
      Value<String> productId,
      Value<String> productName,
      Value<String?> hsnCode,
      Value<double> quantity,
      Value<double> unitPrice,
      Value<double> taxRate,
      Value<double> cessRate,
      Value<double> taxAmount,
      Value<double> totalAmount,
      Value<DateTime?> warrantyEndDate,
      Value<int> rowid,
    });

class $$BillItemsTableFilterComposer
    extends Composer<_$AppDatabase, $BillItemsTable> {
  $$BillItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billId => $composableBuilder(
    column: $table.billId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cessRate => $composableBuilder(
    column: $table.cessRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get warrantyEndDate => $composableBuilder(
    column: $table.warrantyEndDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BillItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillItemsTable> {
  $$BillItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billId => $composableBuilder(
    column: $table.billId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cessRate => $composableBuilder(
    column: $table.cessRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get warrantyEndDate => $composableBuilder(
    column: $table.warrantyEndDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BillItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillItemsTable> {
  $$BillItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get billId =>
      $composableBuilder(column: $table.billId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<double> get cessRate =>
      $composableBuilder(column: $table.cessRate, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get warrantyEndDate => $composableBuilder(
    column: $table.warrantyEndDate,
    builder: (column) => column,
  );
}

class $$BillItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillItemsTable,
          BillItem,
          $$BillItemsTableFilterComposer,
          $$BillItemsTableOrderingComposer,
          $$BillItemsTableAnnotationComposer,
          $$BillItemsTableCreateCompanionBuilder,
          $$BillItemsTableUpdateCompanionBuilder,
          (BillItem, BaseReferences<_$AppDatabase, $BillItemsTable, BillItem>),
          BillItem,
          PrefetchHooks Function()
        > {
  $$BillItemsTableTableManager(_$AppDatabase db, $BillItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> billId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<double> cessRate = const Value.absent(),
                Value<double> taxAmount = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<DateTime?> warrantyEndDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillItemsCompanion(
                id: id,
                billId: billId,
                productId: productId,
                productName: productName,
                hsnCode: hsnCode,
                quantity: quantity,
                unitPrice: unitPrice,
                taxRate: taxRate,
                cessRate: cessRate,
                taxAmount: taxAmount,
                totalAmount: totalAmount,
                warrantyEndDate: warrantyEndDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String billId,
                required String productId,
                required String productName,
                Value<String?> hsnCode = const Value.absent(),
                required double quantity,
                required double unitPrice,
                Value<double> taxRate = const Value.absent(),
                Value<double> cessRate = const Value.absent(),
                required double taxAmount,
                required double totalAmount,
                Value<DateTime?> warrantyEndDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillItemsCompanion.insert(
                id: id,
                billId: billId,
                productId: productId,
                productName: productName,
                hsnCode: hsnCode,
                quantity: quantity,
                unitPrice: unitPrice,
                taxRate: taxRate,
                cessRate: cessRate,
                taxAmount: taxAmount,
                totalAmount: totalAmount,
                warrantyEndDate: warrantyEndDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BillItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillItemsTable,
      BillItem,
      $$BillItemsTableFilterComposer,
      $$BillItemsTableOrderingComposer,
      $$BillItemsTableAnnotationComposer,
      $$BillItemsTableCreateCompanionBuilder,
      $$BillItemsTableUpdateCompanionBuilder,
      (BillItem, BaseReferences<_$AppDatabase, $BillItemsTable, BillItem>),
      BillItem,
      PrefetchHooks Function()
    >;
typedef $$BillPaymentsTableCreateCompanionBuilder =
    BillPaymentsCompanion Function({
      required String id,
      required String billId,
      required String paymentMode,
      required double amount,
      Value<String?> referenceNo,
      Value<String?> userId,
      Value<int> rowid,
    });
typedef $$BillPaymentsTableUpdateCompanionBuilder =
    BillPaymentsCompanion Function({
      Value<String> id,
      Value<String> billId,
      Value<String> paymentMode,
      Value<double> amount,
      Value<String?> referenceNo,
      Value<String?> userId,
      Value<int> rowid,
    });

final class $$BillPaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $BillPaymentsTable, BillPayment> {
  $$BillPaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesBillsTable _billIdTable(_$AppDatabase db) =>
      db.salesBills.createAlias(
        $_aliasNameGenerator(db.billPayments.billId, db.salesBills.id),
      );

  $$SalesBillsTableProcessedTableManager get billId {
    final $_column = $_itemColumn<String>('bill_id')!;

    final manager = $$SalesBillsTableTableManager(
      $_db,
      $_db.salesBills,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BillPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $BillPaymentsTable> {
  $$BillPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceNo => $composableBuilder(
    column: $table.referenceNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  $$SalesBillsTableFilterComposer get billId {
    final $$SalesBillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.salesBills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesBillsTableFilterComposer(
            $db: $db,
            $table: $db.salesBills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillPaymentsTable> {
  $$BillPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceNo => $composableBuilder(
    column: $table.referenceNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  $$SalesBillsTableOrderingComposer get billId {
    final $$SalesBillsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.salesBills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesBillsTableOrderingComposer(
            $db: $db,
            $table: $db.salesBills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillPaymentsTable> {
  $$BillPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get referenceNo => $composableBuilder(
    column: $table.referenceNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  $$SalesBillsTableAnnotationComposer get billId {
    final $$SalesBillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.salesBills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesBillsTableAnnotationComposer(
            $db: $db,
            $table: $db.salesBills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillPaymentsTable,
          BillPayment,
          $$BillPaymentsTableFilterComposer,
          $$BillPaymentsTableOrderingComposer,
          $$BillPaymentsTableAnnotationComposer,
          $$BillPaymentsTableCreateCompanionBuilder,
          $$BillPaymentsTableUpdateCompanionBuilder,
          (BillPayment, $$BillPaymentsTableReferences),
          BillPayment,
          PrefetchHooks Function({bool billId})
        > {
  $$BillPaymentsTableTableManager(_$AppDatabase db, $BillPaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> billId = const Value.absent(),
                Value<String> paymentMode = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> referenceNo = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillPaymentsCompanion(
                id: id,
                billId: billId,
                paymentMode: paymentMode,
                amount: amount,
                referenceNo: referenceNo,
                userId: userId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String billId,
                required String paymentMode,
                required double amount,
                Value<String?> referenceNo = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillPaymentsCompanion.insert(
                id: id,
                billId: billId,
                paymentMode: paymentMode,
                amount: amount,
                referenceNo: referenceNo,
                userId: userId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BillPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({billId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (billId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.billId,
                                referencedTable: $$BillPaymentsTableReferences
                                    ._billIdTable(db),
                                referencedColumn: $$BillPaymentsTableReferences
                                    ._billIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BillPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillPaymentsTable,
      BillPayment,
      $$BillPaymentsTableFilterComposer,
      $$BillPaymentsTableOrderingComposer,
      $$BillPaymentsTableAnnotationComposer,
      $$BillPaymentsTableCreateCompanionBuilder,
      $$BillPaymentsTableUpdateCompanionBuilder,
      (BillPayment, $$BillPaymentsTableReferences),
      BillPayment,
      PrefetchHooks Function({bool billId})
    >;
typedef $$GeneralLedgerTableCreateCompanionBuilder =
    GeneralLedgerCompanion Function({
      required String id,
      required DateTime date,
      required String type,
      required String description,
      Value<double> debit,
      Value<double> credit,
      Value<String?> referenceId,
      Value<String?> referenceTable,
      Value<int> rowid,
    });
typedef $$GeneralLedgerTableUpdateCompanionBuilder =
    GeneralLedgerCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> type,
      Value<String> description,
      Value<double> debit,
      Value<double> credit,
      Value<String?> referenceId,
      Value<String?> referenceTable,
      Value<int> rowid,
    });

class $$GeneralLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $GeneralLedgerTable> {
  $$GeneralLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceTable => $composableBuilder(
    column: $table.referenceTable,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GeneralLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $GeneralLedgerTable> {
  $$GeneralLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceTable => $composableBuilder(
    column: $table.referenceTable,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GeneralLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeneralLedgerTable> {
  $$GeneralLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<double> get credit =>
      $composableBuilder(column: $table.credit, builder: (column) => column);

  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceTable => $composableBuilder(
    column: $table.referenceTable,
    builder: (column) => column,
  );
}

class $$GeneralLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GeneralLedgerTable,
          GeneralLedgerData,
          $$GeneralLedgerTableFilterComposer,
          $$GeneralLedgerTableOrderingComposer,
          $$GeneralLedgerTableAnnotationComposer,
          $$GeneralLedgerTableCreateCompanionBuilder,
          $$GeneralLedgerTableUpdateCompanionBuilder,
          (
            GeneralLedgerData,
            BaseReferences<
              _$AppDatabase,
              $GeneralLedgerTable,
              GeneralLedgerData
            >,
          ),
          GeneralLedgerData,
          PrefetchHooks Function()
        > {
  $$GeneralLedgerTableTableManager(_$AppDatabase db, $GeneralLedgerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeneralLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeneralLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeneralLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> debit = const Value.absent(),
                Value<double> credit = const Value.absent(),
                Value<String?> referenceId = const Value.absent(),
                Value<String?> referenceTable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GeneralLedgerCompanion(
                id: id,
                date: date,
                type: type,
                description: description,
                debit: debit,
                credit: credit,
                referenceId: referenceId,
                referenceTable: referenceTable,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String type,
                required String description,
                Value<double> debit = const Value.absent(),
                Value<double> credit = const Value.absent(),
                Value<String?> referenceId = const Value.absent(),
                Value<String?> referenceTable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GeneralLedgerCompanion.insert(
                id: id,
                date: date,
                type: type,
                description: description,
                debit: debit,
                credit: credit,
                referenceId: referenceId,
                referenceTable: referenceTable,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GeneralLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GeneralLedgerTable,
      GeneralLedgerData,
      $$GeneralLedgerTableFilterComposer,
      $$GeneralLedgerTableOrderingComposer,
      $$GeneralLedgerTableAnnotationComposer,
      $$GeneralLedgerTableCreateCompanionBuilder,
      $$GeneralLedgerTableUpdateCompanionBuilder,
      (
        GeneralLedgerData,
        BaseReferences<_$AppDatabase, $GeneralLedgerTable, GeneralLedgerData>,
      ),
      GeneralLedgerData,
      PrefetchHooks Function()
    >;
typedef $$VendorPaymentsTableCreateCompanionBuilder =
    VendorPaymentsCompanion Function({
      required String id,
      required String vendorId,
      required double amount,
      required DateTime date,
      Value<String> mode,
      Value<String?> notes,
      Value<String?> reference,
      Value<String?> userId,
      Value<int> rowid,
    });
typedef $$VendorPaymentsTableUpdateCompanionBuilder =
    VendorPaymentsCompanion Function({
      Value<String> id,
      Value<String> vendorId,
      Value<double> amount,
      Value<DateTime> date,
      Value<String> mode,
      Value<String?> notes,
      Value<String?> reference,
      Value<String?> userId,
      Value<int> rowid,
    });

class $$VendorPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $VendorPaymentsTable> {
  $$VendorPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VendorPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $VendorPaymentsTable> {
  $$VendorPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VendorPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VendorPaymentsTable> {
  $$VendorPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vendorId =>
      $composableBuilder(column: $table.vendorId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);
}

class $$VendorPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VendorPaymentsTable,
          VendorPayment,
          $$VendorPaymentsTableFilterComposer,
          $$VendorPaymentsTableOrderingComposer,
          $$VendorPaymentsTableAnnotationComposer,
          $$VendorPaymentsTableCreateCompanionBuilder,
          $$VendorPaymentsTableUpdateCompanionBuilder,
          (
            VendorPayment,
            BaseReferences<_$AppDatabase, $VendorPaymentsTable, VendorPayment>,
          ),
          VendorPayment,
          PrefetchHooks Function()
        > {
  $$VendorPaymentsTableTableManager(
    _$AppDatabase db,
    $VendorPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VendorPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VendorPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VendorPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vendorId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VendorPaymentsCompanion(
                id: id,
                vendorId: vendorId,
                amount: amount,
                date: date,
                mode: mode,
                notes: notes,
                reference: reference,
                userId: userId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vendorId,
                required double amount,
                required DateTime date,
                Value<String> mode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VendorPaymentsCompanion.insert(
                id: id,
                vendorId: vendorId,
                amount: amount,
                date: date,
                mode: mode,
                notes: notes,
                reference: reference,
                userId: userId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VendorPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VendorPaymentsTable,
      VendorPayment,
      $$VendorPaymentsTableFilterComposer,
      $$VendorPaymentsTableOrderingComposer,
      $$VendorPaymentsTableAnnotationComposer,
      $$VendorPaymentsTableCreateCompanionBuilder,
      $$VendorPaymentsTableUpdateCompanionBuilder,
      (
        VendorPayment,
        BaseReferences<_$AppDatabase, $VendorPaymentsTable, VendorPayment>,
      ),
      VendorPayment,
      PrefetchHooks Function()
    >;
typedef $$PaymentAllocationsTableCreateCompanionBuilder =
    PaymentAllocationsCompanion Function({
      required String id,
      required String paymentId,
      required String grnId,
      required double allocatedAmount,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PaymentAllocationsTableUpdateCompanionBuilder =
    PaymentAllocationsCompanion Function({
      Value<String> id,
      Value<String> paymentId,
      Value<String> grnId,
      Value<double> allocatedAmount,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PaymentAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentId => $composableBuilder(
    column: $table.paymentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grnId => $composableBuilder(
    column: $table.grnId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentId => $composableBuilder(
    column: $table.paymentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grnId => $composableBuilder(
    column: $table.grnId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get paymentId =>
      $composableBuilder(column: $table.paymentId, builder: (column) => column);

  GeneratedColumn<String> get grnId =>
      $composableBuilder(column: $table.grnId, builder: (column) => column);

  GeneratedColumn<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PaymentAllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentAllocationsTable,
          PaymentAllocation,
          $$PaymentAllocationsTableFilterComposer,
          $$PaymentAllocationsTableOrderingComposer,
          $$PaymentAllocationsTableAnnotationComposer,
          $$PaymentAllocationsTableCreateCompanionBuilder,
          $$PaymentAllocationsTableUpdateCompanionBuilder,
          (
            PaymentAllocation,
            BaseReferences<
              _$AppDatabase,
              $PaymentAllocationsTable,
              PaymentAllocation
            >,
          ),
          PaymentAllocation,
          PrefetchHooks Function()
        > {
  $$PaymentAllocationsTableTableManager(
    _$AppDatabase db,
    $PaymentAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentAllocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> paymentId = const Value.absent(),
                Value<String> grnId = const Value.absent(),
                Value<double> allocatedAmount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentAllocationsCompanion(
                id: id,
                paymentId: paymentId,
                grnId: grnId,
                allocatedAmount: allocatedAmount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String paymentId,
                required String grnId,
                required double allocatedAmount,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PaymentAllocationsCompanion.insert(
                id: id,
                paymentId: paymentId,
                grnId: grnId,
                allocatedAmount: allocatedAmount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentAllocationsTable,
      PaymentAllocation,
      $$PaymentAllocationsTableFilterComposer,
      $$PaymentAllocationsTableOrderingComposer,
      $$PaymentAllocationsTableAnnotationComposer,
      $$PaymentAllocationsTableCreateCompanionBuilder,
      $$PaymentAllocationsTableUpdateCompanionBuilder,
      (
        PaymentAllocation,
        BaseReferences<
          _$AppDatabase,
          $PaymentAllocationsTable,
          PaymentAllocation
        >,
      ),
      PaymentAllocation,
      PrefetchHooks Function()
    >;
typedef $$ProductUomsTableCreateCompanionBuilder =
    ProductUomsCompanion Function({
      Value<int> id,
      required String productId,
      required String uomName,
      required double conversionFactor,
      Value<bool> isBase,
      Value<String?> barcode,
      Value<DateTime> createdAt,
    });
typedef $$ProductUomsTableUpdateCompanionBuilder =
    ProductUomsCompanion Function({
      Value<int> id,
      Value<String> productId,
      Value<String> uomName,
      Value<double> conversionFactor,
      Value<bool> isBase,
      Value<String?> barcode,
      Value<DateTime> createdAt,
    });

class $$ProductUomsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductUomsTable> {
  $$ProductUomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uomName => $composableBuilder(
    column: $table.uomName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBase => $composableBuilder(
    column: $table.isBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductUomsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductUomsTable> {
  $$ProductUomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uomName => $composableBuilder(
    column: $table.uomName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBase => $composableBuilder(
    column: $table.isBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductUomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductUomsTable> {
  $$ProductUomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get uomName =>
      $composableBuilder(column: $table.uomName, builder: (column) => column);

  GeneratedColumn<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBase =>
      $composableBuilder(column: $table.isBase, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProductUomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductUomsTable,
          ProductUom,
          $$ProductUomsTableFilterComposer,
          $$ProductUomsTableOrderingComposer,
          $$ProductUomsTableAnnotationComposer,
          $$ProductUomsTableCreateCompanionBuilder,
          $$ProductUomsTableUpdateCompanionBuilder,
          (
            ProductUom,
            BaseReferences<_$AppDatabase, $ProductUomsTable, ProductUom>,
          ),
          ProductUom,
          PrefetchHooks Function()
        > {
  $$ProductUomsTableTableManager(_$AppDatabase db, $ProductUomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductUomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductUomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductUomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> uomName = const Value.absent(),
                Value<double> conversionFactor = const Value.absent(),
                Value<bool> isBase = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductUomsCompanion(
                id: id,
                productId: productId,
                uomName: uomName,
                conversionFactor: conversionFactor,
                isBase: isBase,
                barcode: barcode,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String productId,
                required String uomName,
                required double conversionFactor,
                Value<bool> isBase = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductUomsCompanion.insert(
                id: id,
                productId: productId,
                uomName: uomName,
                conversionFactor: conversionFactor,
                isBase: isBase,
                barcode: barcode,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductUomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductUomsTable,
      ProductUom,
      $$ProductUomsTableFilterComposer,
      $$ProductUomsTableOrderingComposer,
      $$ProductUomsTableAnnotationComposer,
      $$ProductUomsTableCreateCompanionBuilder,
      $$ProductUomsTableUpdateCompanionBuilder,
      (
        ProductUom,
        BaseReferences<_$AppDatabase, $ProductUomsTable, ProductUom>,
      ),
      ProductUom,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String name,
      required String username,
      required String password,
      required String role,
      Value<String?> pin,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> username,
      Value<String> password,
      Value<String> role,
      Value<String?> pin,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pin => $composableBuilder(
    column: $table.pin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pin => $composableBuilder(
    column: $table.pin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pin =>
      $composableBuilder(column: $table.pin, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> pin = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                username: username,
                password: password,
                role: role,
                pin: pin,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String username,
                required String password,
                required String role,
                Value<String?> pin = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                username: username,
                password: password,
                role: role,
                pin: pin,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$AuditLogsTableCreateCompanionBuilder =
    AuditLogsCompanion Function({
      required String id,
      Value<String?> userId,
      required String action,
      Value<String?> entityType,
      Value<String?> recordId,
      Value<String?> details,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });
typedef $$AuditLogsTableUpdateCompanionBuilder =
    AuditLogsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String> action,
      Value<String?> entityType,
      Value<String?> recordId,
      Value<String?> details,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$AuditLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogsTable,
          AuditLog,
          $$AuditLogsTableFilterComposer,
          $$AuditLogsTableOrderingComposer,
          $$AuditLogsTableAnnotationComposer,
          $$AuditLogsTableCreateCompanionBuilder,
          $$AuditLogsTableUpdateCompanionBuilder,
          (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
          AuditLog,
          PrefetchHooks Function()
        > {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> entityType = const Value.absent(),
                Value<String?> recordId = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogsCompanion(
                id: id,
                userId: userId,
                action: action,
                entityType: entityType,
                recordId: recordId,
                details: details,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                required String action,
                Value<String?> entityType = const Value.absent(),
                Value<String?> recordId = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogsCompanion.insert(
                id: id,
                userId: userId,
                action: action,
                entityType: entityType,
                recordId: recordId,
                details: details,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogsTable,
      AuditLog,
      $$AuditLogsTableFilterComposer,
      $$AuditLogsTableOrderingComposer,
      $$AuditLogsTableAnnotationComposer,
      $$AuditLogsTableCreateCompanionBuilder,
      $$AuditLogsTableUpdateCompanionBuilder,
      (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
      AuditLog,
      PrefetchHooks Function()
    >;
typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      required String id,
      Value<String?> code,
      required String name,
      required String type,
      Value<String?> subType,
      Value<String?> parentId,
      Value<String> currency,
      Value<double> currentBalance,
      Value<String?> assignedUserId,
      Value<bool> isArchived,
      Value<int> rowid,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<String> id,
      Value<String?> code,
      Value<String> name,
      Value<String> type,
      Value<String?> subType,
      Value<String?> parentId,
      Value<String> currency,
      Value<double> currentBalance,
      Value<String?> assignedUserId,
      Value<bool> isArchived,
      Value<int> rowid,
    });

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _parentIdTable(_$AppDatabase db) => db.accounts
      .createAlias($_aliasNameGenerator(db.accounts.parentId, db.accounts.id));

  $$AccountsTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subType => $composableBuilder(
    column: $table.subType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignedUserId => $composableBuilder(
    column: $table.assignedUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get parentId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subType => $composableBuilder(
    column: $table.subType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignedUserId => $composableBuilder(
    column: $table.assignedUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get parentId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get subType =>
      $composableBuilder(column: $table.subType, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assignedUserId => $composableBuilder(
    column: $table.assignedUserId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get parentId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({bool parentId})
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> subType = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<double> currentBalance = const Value.absent(),
                Value<String?> assignedUserId = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                code: code,
                name: name,
                type: type,
                subType: subType,
                parentId: parentId,
                currency: currency,
                currentBalance: currentBalance,
                assignedUserId: assignedUserId,
                isArchived: isArchived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> code = const Value.absent(),
                required String name,
                required String type,
                Value<String?> subType = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<double> currentBalance = const Value.absent(),
                Value<String?> assignedUserId = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                code: code,
                name: name,
                type: type,
                subType: subType,
                parentId: parentId,
                currency: currency,
                currentBalance: currentBalance,
                assignedUserId: assignedUserId,
                isArchived: isArchived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({parentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (parentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.parentId,
                                referencedTable: $$AccountsTableReferences
                                    ._parentIdTable(db),
                                referencedColumn: $$AccountsTableReferences
                                    ._parentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({bool parentId})
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required int phone,
      required String name,
      Value<String?> email,
      required String address,
      Value<String?> gstin,
      Value<String?> stateCode,
      Value<String?> pinCode,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<int> phone,
      Value<String> name,
      Value<String?> email,
      Value<String> address,
      Value<String?> gstin,
      Value<String?> stateCode,
      Value<String?> pinCode,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinCode => $composableBuilder(
    column: $table.pinCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinCode => $composableBuilder(
    column: $table.pinCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<String> get pinCode =>
      $composableBuilder(column: $table.pinCode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
          Customer,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> phone = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String?> pinCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                phone: phone,
                name: name,
                email: email,
                address: address,
                gstin: gstin,
                stateCode: stateCode,
                pinCode: pinCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int phone,
                required String name,
                Value<String?> email = const Value.absent(),
                required String address,
                Value<String?> gstin = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String?> pinCode = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                phone: phone,
                name: name,
                email: email,
                address: address,
                gstin: gstin,
                stateCode: stateCode,
                pinCode: pinCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
      Customer,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$VendorsTableTableManager get vendors =>
      $$VendorsTableTableManager(_db, _db.vendors);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$BrandsTableTableManager get brands =>
      $$BrandsTableTableManager(_db, _db.brands);
  $$PurchaseOrdersTableTableManager get purchaseOrders =>
      $$PurchaseOrdersTableTableManager(_db, _db.purchaseOrders);
  $$PurchaseOrderItemsTableTableManager get purchaseOrderItems =>
      $$PurchaseOrderItemsTableTableManager(_db, _db.purchaseOrderItems);
  $$DebitNotesTableTableManager get debitNotes =>
      $$DebitNotesTableTableManager(_db, _db.debitNotes);
  $$DebitNoteItemsTableTableManager get debitNoteItems =>
      $$DebitNoteItemsTableTableManager(_db, _db.debitNoteItems);
  $$GoodsReceiptsTableTableManager get goodsReceipts =>
      $$GoodsReceiptsTableTableManager(_db, _db.goodsReceipts);
  $$GoodsReceiptItemsTableTableManager get goodsReceiptItems =>
      $$GoodsReceiptItemsTableTableManager(_db, _db.goodsReceiptItems);
  $$ProductBatchesTableTableManager get productBatches =>
      $$ProductBatchesTableTableManager(_db, _db.productBatches);
  $$ProductTransactionsTableTableManager get productTransactions =>
      $$ProductTransactionsTableTableManager(_db, _db.productTransactions);
  $$SalesBillsTableTableManager get salesBills =>
      $$SalesBillsTableTableManager(_db, _db.salesBills);
  $$BillItemsTableTableManager get billItems =>
      $$BillItemsTableTableManager(_db, _db.billItems);
  $$BillPaymentsTableTableManager get billPayments =>
      $$BillPaymentsTableTableManager(_db, _db.billPayments);
  $$GeneralLedgerTableTableManager get generalLedger =>
      $$GeneralLedgerTableTableManager(_db, _db.generalLedger);
  $$VendorPaymentsTableTableManager get vendorPayments =>
      $$VendorPaymentsTableTableManager(_db, _db.vendorPayments);
  $$PaymentAllocationsTableTableManager get paymentAllocations =>
      $$PaymentAllocationsTableTableManager(_db, _db.paymentAllocations);
  $$ProductUomsTableTableManager get productUoms =>
      $$ProductUomsTableTableManager(_db, _db.productUoms);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
}
