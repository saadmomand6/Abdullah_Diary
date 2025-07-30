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
        contact TEXT,
        address TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE bank_accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER,
        title TEXT,
        number TEXT,
        bank_name TEXT,
        FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
      )
    ''');
  }

  // Insert Customer with Accounts
  static Future<void> insertCustomer(CustomerItemModel customer) async {
    final db = await database();

    int customerId = await db.insert('customers', customer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    for (var account in customer.accounts) {
      await db.insert('bank_accounts', account.toMap(customerId));
    }
  }

  // Get all Customers with Accounts
  static Future<List<CustomerItemModel>> getAllCustomers() async {
    final db = await database();

    final customerMaps = await db.query('customers');

    List<CustomerItemModel> customers = [];

    for (var customerMap in customerMaps) {
      final customer = CustomerItemModel.fromMap(customerMap);

      final accounts = await db.query(
        'bank_accounts',
        where: 'customer_id = ?',
        whereArgs: [customer.id],
      );

      customer.accounts =
          accounts.map((accMap) => BankAccount.fromMap(accMap)).toList();

      customers.add(customer);
    }

    return customers;
  }

  // Delete customer
  static Future<void> deleteCustomer(int id) async {
    final db = await database();
    await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  // Update customer
  static Future<void> updateCustomer(CustomerItemModel customer) async {
    final db = await database();

    await db.update('customers', customer.toMap(),
        where: 'id = ?', whereArgs: [customer.id]);

    // Delete old accounts
    await db.delete('bank_accounts',
        where: 'customer_id = ?', whereArgs: [customer.id]);

    // Insert updated accounts
    for (var account in customer.accounts) {
      await db.insert('bank_accounts', account.toMap(customer.id!));
    }
  }
}
