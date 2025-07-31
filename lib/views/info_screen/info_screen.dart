import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abdullah_diary/db/db_helper.dart';
import 'package:abdullah_diary/views/edit_customer.dart/edit_customer.dart';
import 'package:share_plus/share_plus.dart';

class CustomerInfoScreen extends StatefulWidget {
  final int id;
  final String name;
  final String contact;
  final String address;

  const CustomerInfoScreen({
    super.key,
    required this.id,
    required this.name,
    required this.contact,
    required this.address,
  });

  @override
  State<CustomerInfoScreen> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  List<Map<String, dynamic>> bankAccounts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBankAccounts();
  }

  Future<void> fetchBankAccounts() async {
  final db = await DBHelper.database();

  final accounts = await db.query(
    'bank_accounts',
    where: 'customer_id = ?',
    whereArgs: [widget.id], // ← fixed here
  );

  final allAccounts = await db.query('bank_accounts');
print("ALL ACCOUNTS IN DB: $allAccounts");

  print("Fetched accounts for ${widget.id}: $accounts");

  setState(() {
    bankAccounts = accounts;
    isLoading = false;
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
        backgroundColor: Colors.yellow,
        title: Text(
          "Customer Info (کسٹمر کی تفصیل)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => EditCustomerScreen(
                    id: widget.id,
                    name: widget.name,
                    contact: widget.contact,
                    address: widget.address,
                  ));
            },
            child: const Text(
              "Edit Details (ترمیم کریں)",
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem("Customer Name (کسٹمر کا نام)", widget.name),
              const SizedBox(height: 10),
              _buildInfoItem("Contact Number (رابطہ نمبر)", widget.contact),
              const SizedBox(height: 10),
              _buildInfoItem("Address (پتہ)", widget.address),
              const SizedBox(height: 20),
              const Text(
                "Bank Accounts (بینک اکاؤنٹس)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              isLoading
    ? const Center(child: CircularProgressIndicator())
    : bankAccounts.isEmpty
        ? const Text(
            "No Bank Accounts Added (کوئی بینک اکاؤنٹس نہیں)",
            style: TextStyle(color: Colors.grey),
          )
        :Table(
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
          child: Text('Account Title', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Account Number', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Bank Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Share', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    ),
    // Data Rows
    ...bankAccounts.map((account) {
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
              icon: const Icon(Icons.share, size: 20, color: Colors.green),
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
),

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
}
