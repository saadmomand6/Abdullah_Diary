import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer_card_models.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> database() async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'abdullah_diary.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE customers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      contact TEXT,           -- ✅ fixed from contactNumber
      address TEXT            -- ✅ fixed from adrress
    )
  ''');

  await db.execute('''
    CREATE TABLE bank_accounts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_id INTEGER,
      title TEXT,
      number TEXT,
      bank_name TEXT
    )
  ''');
}

  static Future<void> insertCustomer(CustomerItemModel customer) async {
  final db = await database();

  // Insert customer
  int customerId = await db.insert(
    'customers',
    customer.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  // Insert bank accounts for that customer
  for (final account in customer.accounts) {
    await insertBankAccount(account, customerId); // ← ✅ insert them now
  }

  print("Inserted customer with ID $customerId and ${customer.accounts.length} accounts");
}

  static Future<List<CustomerItemModel>> getAllCustomers() async {
    final db = await database();
    final customersData = await db.query('customers');

    List<CustomerItemModel> customers = [];

    for (var customerMap in customersData) {
      final customer = CustomerItemModel.fromMap(customerMap);
      final accounts = await getBankAccountsForCustomer(customer.id!);
      customer.accounts = accounts;
      customers.add(customer);
    }

    return customers;
  }

static Future<void> updateCustomer(CustomerItemModel customer) async {
  final db = await DBHelper.database(); // 👈 with parentheses

  await db.update(
    'customers',
    {
      'name': customer.name,
      'contact': customer.contactNumber,
      'address': customer.adrress,
    },
    where: 'id = ?',
    whereArgs: [customer.id],
  );
}

  static Future<void> deleteCustomer(int id) async {
    final db = await database();
    await db.delete('customers', where: 'id = ?', whereArgs: [id]);
    await db.delete('bank_accounts', where: 'customer_id = ?', whereArgs: [id]);
  }

  static Future<void> insertBankAccount(BankAccount account, int customerId) async {
    final db = await database();
    await db.insert('bank_accounts', {
      'customer_id': customerId,
      'title': account.title,
      'number': account.number,
      'bank_name': account.bankName,
    });
  }

  static Future<List<BankAccount>> getBankAccountsForCustomer(int customerId) async {
    final db = await database();
    final maps = await db.query(
      'bank_accounts',
      where: 'customer_id = ?',
      whereArgs: [customerId],
    );

    return maps.map((m) => BankAccount.fromMap(m)).toList();
  }

  static Future<void> deleteBankAccountsByCustomerId(int customerId) async {
    final db = await database();
    await db.delete('bank_accounts', where: 'customer_id = ?', whereArgs: [customerId]);
  }
}
