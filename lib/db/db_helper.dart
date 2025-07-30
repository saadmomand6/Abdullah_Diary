import 'package:abdullah_diary/models/customer_card_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'customer_diary.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE customers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            contact TEXT,
            address TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE bank_accounts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer_id INTEGER,
            account_title TEXT,
            account_number TEXT,
            bank_name TEXT,
            FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
          );
        ''');
      },
    );
  }

  static Future<int> insertCustomer(Customer customer, List<BankAccount> accounts) async {
    final db = await database;

    int customerId = await db.insert('customers', customer.toMap());

    for (final account in accounts) {
      await db.insert('bank_accounts', account.toMap(customerId));
    }

    return customerId;
  }

  static Future<List<Customer>> getAllCustomers() async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.query('customers');

  return List.generate(maps.length, (i) {
    return Customer.fromMap(maps[i]);
  });
}

}
