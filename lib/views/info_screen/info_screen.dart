import 'package:abdullah_diary/controllers/get_customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:abdullah_diary/db/db_helper.dart';
import 'package:abdullah_diary/models/customer_card_models.dart';
import 'package:abdullah_diary/views/edit_customer.dart/edit_customer.dart';

class CustomerInfoScreen extends StatefulWidget {
  final int id;

  const CustomerInfoScreen({
    super.key,
    required this.id,
  });

  @override
  State<CustomerInfoScreen> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  final GetCustomerController controller = Get.find<GetCustomerController>();
  CustomerItemModel? customer;
  bool isLoading = true;

  /// ✅ Keep bankAccounts list for old logic
  List<Map<String, dynamic>> bankAccounts = [];

  @override
  void initState() {
    super.initState();
    fetchCustomerData();
    fetchBankAccounts();
  }

  /// ✅ Fetch complete customer details (name, contact, address, and accounts)
  Future<void> fetchCustomerData() async {
    setState(() => isLoading = true);

    final fetchedCustomer = await DBHelper.getCustomerById(widget.id);

    setState(() {
      customer = fetchedCustomer;
      isLoading = false;
    });
  }

  /// ✅ Fetch only the bank accounts separately (old logic)
  Future<void> fetchBankAccounts() async {
    final db = await DBHelper.database();

    final accounts = await db.query(
      'bank_accounts',
      where: 'customer_id = ?',
      whereArgs: [widget.id],
    );

    final allAccounts = await db.query('bank_accounts');
    print("ALL ACCOUNTS IN DB: $allAccounts");
    print("Fetched accounts for ${widget.id}: $accounts");

    setState(() {
      bankAccounts = accounts;
    });
  }

  TextDirection _getDirection(String text) {
    final urduRegex = RegExp(r'[\u0600-\u06FF]');
    return urduRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            controller.fetchCustomers();
            Get.back();
          },
          child: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.yellow,
        title: const Text(
          "Customer Info (کسٹمر کی تفصیل)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (customer != null) {
                final updated = await Get.to(() => EditCustomerScreen(
                      id: customer!.id!,
                      name: customer!.name,
                      contact: customer!.contactNumber,
                      address: customer!.adrress,
                    ));

                if (updated == true) {
                  await fetchCustomerData();
                  await fetchBankAccounts();
                }
              }
            },
            child: const Text(
              "Edit Details (ترمیم کریں)",
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : customer == null
              ? const Center(child: Text("Customer not found"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem(
                            "Customer Name (کسٹمر کا نام)", customer!.name),
                        const SizedBox(height: 10),
                        _buildInfoItem("Contact Number (رابطہ نمبر)",
                            customer!.contactNumber),
                        const SizedBox(height: 10),
                        _buildInfoItem("Address (پتہ)", customer!.adrress),
                        const SizedBox(height: 20),
                        const Text(
                          "Bank Accounts (بینک اکاؤنٹس)",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        /// ✅ Bank accounts handling
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : (bankAccounts.isEmpty &&
                                    (customer?.accounts.isEmpty ?? true))
                                ? const Text(
                                    "No Bank Accounts Added (کوئی بینک اکاؤنٹس نہیں)",
                                    style: TextStyle(color: Colors.grey),
                                  )
                                : _buildBankAccountsTable(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Text(
            value,
            textDirection: _getDirection(value),
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  /// ✅ Bank accounts table (combines customer.accounts + bankAccounts list)
  Widget _buildBankAccountsTable() {
    // Prefer customer.accounts if available, else use bankAccounts list
    final List<Map<String, dynamic>> accountsList = customer!.accounts.isNotEmpty
        ? customer!.accounts
            .map((acc) => {
                  'title': acc.title,
                  'number': acc.number,
                  'bank_name': acc.bankName
                })
            .toList()
        : bankAccounts;

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: IntrinsicColumnWidth(),
      },
      children: [
        // Header Row
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Account Title',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Account Number',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Bank Name',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Share',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        // Data Rows
        ...accountsList.map((account) {
          final title = account['title'] ?? '';
          final number = account['number'] ?? '';
          final bankName = account['bank_name'] ?? '';

          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(number),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(bankName),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  icon:
                      const Icon(Icons.share, size: 20, color: Colors.green),
                  onPressed: () {
                    final message = '''
📋 *Bank Account Details*

🏦 *Title:* $title
🔢 *Number:* $number
🏛️ *Bank:* $bankName
''';
                    Share.share(message);
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}