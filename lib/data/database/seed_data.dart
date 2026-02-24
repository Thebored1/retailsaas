import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'app_database.dart';

Future<void> seedDatabase(AppDatabase db) async {
  // 1. Seed Categories
  final categoryCount = await db
      .select(db.categories)
      .get()
      .then((l) => l.length);
  if (categoryCount == 0) {
    print('Seeding Categories...');
    await db.batch((batch) {
      batch.insertAll(db.categories, [
        CategoriesCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174011'),
          name: const Value('Beverages'),
        ),
        CategoriesCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174012'),
          name: const Value('Snacks'),
        ),
        CategoriesCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174013'),
          name: const Value('Groceries'),
        ),
        CategoriesCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174014'),
          name: const Value('Dairy'),
        ),
        CategoriesCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174015'),
          name: const Value('Personal Care'),
        ),
      ]);
    });
  }

  // 2. Seed Brands
  final brandCount = await db.select(db.brands).get().then((l) => l.length);
  if (brandCount == 0) {
    print('Seeding Brands...');
    await db.batch((batch) {
      batch.insertAll(db.brands, [
        BrandsCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174021'),
          name: const Value('Coca Cola'),
        ),
        BrandsCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174022'),
          name: const Value('PepsiCo'),
        ),
        BrandsCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174023'),
          name: const Value('Parle'),
        ),
        BrandsCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174024'),
          name: const Value('Amul'),
        ),
        BrandsCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174025'),
          name: const Value('Britannia'),
        ),
        BrandsCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174026'),
          name: const Value('Tata Consumer'),
        ),
        BrandsCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174027'),
          name: const Value('Reckitt'),
        ),
      ]);
    });
  }

  // 3. Seed Products
  final productCount = await db.select(db.products).get().then((l) => l.length);
  if (productCount == 0) {
    print('Seeding Products...');
    final now = DateTime.now();
    await db.batch((batch) {
      batch.insertAll(db.products, [
        ProductsCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174001'),
          name: const Value('Coca Cola 1L'),
          categoryId: const Value('123e4567-e89b-12d3-a456-426614174011'),
          hsnCode: const Value('2202'),
          gstRate: const Value(18.00),
          cessRate: const Value(12.00),
          uom: const Value('PCS'),
          lowStockLimit: const Value(20.0),
          createdAt: Value(now.subtract(const Duration(days: 30))),
          updatedAt: Value(now),
          mrp: const Value(80.0),
          sellingPrice: const Value(75.0),
          purchaseRate: const Value(60.0),
        ),
        ProductsCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174002'),
          name: const Value('Parle-G Biscuits 200g'),
          categoryId: const Value('123e4567-e89b-12d3-a456-426614174012'),
          hsnCode: const Value('1905'),
          gstRate: const Value(12.00),
          uom: const Value('PCS'),
          lowStockLimit: const Value(50.0),
          createdAt: Value(now.subtract(const Duration(days: 45))),
          updatedAt: Value(now),
          mrp: const Value(20.0),
          sellingPrice: const Value(20.0),
          purchaseRate: const Value(16.0),
        ),
        ProductsCompanion(
          id: const Value('123e4567-e89b-12d3-a456-426614174003'),
          name: const Value('Amul Butter 500g'),
          categoryId: const Value('123e4567-e89b-12d3-a456-426614174014'),
          hsnCode: const Value('0405'),
          gstRate: const Value(12.00),
          uom: const Value('PCS'),
          lowStockLimit: const Value(15.0),
          createdAt: Value(now.subtract(const Duration(days: 20))),
          updatedAt: Value(now),
          mrp: const Value(280.0),
          sellingPrice: const Value(275.0),
          purchaseRate: const Value(240.0),
        ),
      ]);
    });

    // 3a. Seed Batches (New)
    print('Seeding Product Batches...');
    await db.batch((batch) {
      batch.insertAll(db.productBatches, [
        ProductBatchesCompanion(
          id: Value(const Uuid().v4()),
          productId: const Value(
            '123e4567-e89b-12d3-a456-426614174001',
          ), // Coke
          mrp: const Value(80.0),
          sellingPrice: const Value(75.0),
          purchaseRate: const Value(60.0),
          stockQty: const Value(150.0),
          createdAt: Value(now),
        ),
        ProductBatchesCompanion(
          id: Value(const Uuid().v4()),
          productId: const Value(
            '123e4567-e89b-12d3-a456-426614174002',
          ), // Parle-G
          mrp: const Value(20.0),
          sellingPrice: const Value(20.0),
          purchaseRate: const Value(16.0),
          stockQty: const Value(500.0),
          createdAt: Value(now),
        ),
        ProductBatchesCompanion(
          id: Value(const Uuid().v4()),
          productId: const Value(
            '123e4567-e89b-12d3-a456-426614174003',
          ), // Butter
          mrp: const Value(280.0),
          sellingPrice: const Value(275.0),
          purchaseRate: const Value(240.0),
          stockQty: const Value(80.0),
          createdAt: Value(now),
        ),
      ]);
    });
  }

  // 5. Ensure Fake Vendor Exists (User Request)
  final fakeVendor = await db
      .select(db.vendors)
      .get()
      .then((l) => l.where((v) => v.id == '999').firstOrNull);
  if (fakeVendor == null) {
    print('Seeding Fake Vendor...');
    await db
        .into(db.vendors)
        .insert(
          VendorsCompanion.insert(
            id: '999',
            name: 'Fake Vendor Entry',
            address: '99, Fake Street,\nNeverland - 000000',
            contact: '+91 00000 00000',
            email: const Value('fake@vendor.com'),
            gstin: const Value('99FAKE9999F1Z9'),
            stateCode: const Value('99'),
          ),
        );
  }

  // 6. Seed Default Admin
  final adminUser = await (db.select(
    db.users,
  )..where((t) => t.username.equals('admin'))).getSingleOrNull();
  if (adminUser == null) {
    print('Seeding Default Admin...');
    await db
        .into(db.users)
        .insert(
          UsersCompanion.insert(
            id: const Uuid().v4(),
            name: 'Administrator',
            username: 'admin',
            password: 'admin',
            role: 'admin',
          ),
        );
  }

  // 7. Seed Liquid Assets Chart of Accounts
  final accountsCount = await db
      .select(db.accounts)
      .get()
      .then((l) => l.length);
  if (accountsCount == 0) {
    print('Seeding Chart of Accounts (Liquid Assets)...');

    // Root: Current Assets
    const currentAssetsId = '1000';
    await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(
            id: currentAssetsId,
            name: 'Current Assets',
            type: 'Asset',
            code: const Value('1000'),
          ),
        );

    // Level 2: Cash & Bank
    const cashGroupId = '1001';
    await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(
            id: cashGroupId,
            parentId: const Value(currentAssetsId),
            name: 'Cash & Cash Equivalents',
            type: 'Asset',
            code: const Value('1001'),
          ),
        );

    // Level 3: Cash Accounts
    await db.batch((batch) {
      batch.insertAll(db.accounts, [
        // Cash
        AccountsCompanion.insert(
          id: '1001-01',
          parentId: const Value(cashGroupId),
          name: 'Main Safe / Vault',
          type: 'Asset',
          subType: const Value('Cash'),
          currentBalance: const Value(150000.0),
        ),
        AccountsCompanion.insert(
          id: '1001-02',
          parentId: const Value(cashGroupId),
          name: 'Petty Cash Fund',
          type: 'Asset',
          subType: const Value('Cash'),
          currentBalance: const Value(5000.0),
        ),
        // POS Registers (Dynamic)
        AccountsCompanion.insert(
          id: '1001-Register-1',
          parentId: const Value(cashGroupId),
          name: 'POS Register 1',
          type: 'Asset',
          subType: const Value('Cash'),
          assignedUserId: const Value('admin'), // Default assignment
          currentBalance: const Value(12000.0),
        ),

        // Banks
        AccountsCompanion.insert(
          id: '1001-Bank-1',
          parentId: const Value(cashGroupId),
          name: 'HDFC Bank (****1234)',
          type: 'Asset',
          subType: const Value('Bank'),
          currentBalance: const Value(850000.0),
        ),
        AccountsCompanion.insert(
          id: '1001-Bank-2',
          parentId: const Value(cashGroupId),
          name: 'SBI Savings (****5678)',
          type: 'Asset',
          subType: const Value('Bank'),
          currentBalance: const Value(150000.0),
        ),

        // Digital
        AccountsCompanion.insert(
          id: '1001-Digital-1',
          parentId: const Value(cashGroupId),
          name: 'UPI / QR Settlement',
          type: 'Asset',
          subType: const Value('Digital'),
          currentBalance: const Value(45000.0),
        ),
      ]);
    });
  }
}
