import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer_card_models.dart';
import 'package:abdullah_diary/db/db_helper.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> database() async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // static Future<Database> _initDB() async {
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, 'abdullah_diary.db');

  //   return await openDatabase(
  //     path,
  //     version: 1,
  //     onCreate: _onCreate,
  //   );
  // }

//   static Future<void> _onCreate(Database db, int version) async {
//   await db.execute('''
//     CREATE TABLE customers (
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       name TEXT,
//       contact TEXT,           -- ✅ fixed from contactNumber
//       address TEXT            -- ✅ fixed from adrress
//     )
//   ''');

//   await db.execute('''
//     CREATE TABLE bank_accounts (
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       customer_id INTEGER,
//       title TEXT,
//       number TEXT,
//       bank_name TEXT
//     )
//   ''');
// }
static Future<Database> _initDB() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'abdullah_diary.db');

  return await openDatabase(
    path,
    version: 2, // increment version
    onCreate: _onCreate,
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute("ALTER TABLE bank_accounts ADD COLUMN status TEXT DEFAULT 'Active'");
      }
    },
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
      status TEXT DEFAULT 'Active'   -- NEW COLUMN
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

// static Future<void> updateCustomer(CustomerItemModel customer) async {
//   final db = await DBHelper.database(); // 👈 with parentheses

//   await db.update(
//     'customers',
//     {
//       'name': customer.name,
//       'contact': customer.contactNumber,
//       'address': customer.adrress,
//     },
//     where: 'id = ?',
//     whereArgs: [customer.id],
//   );
// }
static Future<void> updateCustomer(CustomerItemModel customer) async {
  final db = await DBHelper.database();

  // Update the customer details
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

  // Update each bank account including status
  for (final account in customer.accounts) {
    if (account.id != null) {
      // If account exists, update it
      await db.update(
        'bank_accounts',
        {
          'title': account.title,
          'number': account.number,
          'bank_name': account.bankName,
          'status': account.status, // 👈 Update status here
        },
        where: 'id = ?',
        whereArgs: [account.id],
      );
    } else {
      // If it's a new account (no ID yet), insert it
      await insertBankAccount(account, customer.id!);
    }
  }
}

  static Future<void> deleteCustomer(int id) async {
  final db = await database();

  await db.transaction((txn) async {
    // Delete related bank accounts first
    await txn.delete(
      'bank_accounts',
      where: 'customer_id = ?',
      whereArgs: [id],
    );

    // Then delete the customer
    await txn.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  });
}


  // static Future<void> insertBankAccount(BankAccount account, int customerId) async {
  //   final db = await database();
  //   await db.insert('bank_accounts', {
  //     'customer_id': customerId,
  //     'title': account.title,
  //     'number': account.number,
  //     'bank_name': account.bankName,
  //   });
  // }
static Future<void> insertBankAccount(BankAccount account, int customerId) async {
  final db = await database();
  await db.insert('bank_accounts', {
    'customer_id': customerId,
    'title': account.title,
    'number': account.number,
    'bank_name': account.bankName,
    'status': account.status, // NEW
  });
}
static Future<void> updateBankAccountStatus(int id, String status) async {
  final db = await database();
  await db.update(
    'bank_accounts',
    {'status': status},
    where: 'id = ?',
    whereArgs: [id],
  );
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
  
 
// a function to fetch a specific customer
  static Future<CustomerItemModel?> getCustomerById(int customerId) async {
  final db = await database();

  // Fetch customer details
  final customerMaps = await db.query(
    'customers',
    where: 'id = ?',
    whereArgs: [customerId],
  );

  if (customerMaps.isEmpty) return null;

  final customer = CustomerItemModel.fromMap(customerMaps.first);

  // Fetch associated bank accounts
  final accounts = await getBankAccountsForCustomer(customerId);
  customer.accounts = accounts;

  return customer;
}

}
