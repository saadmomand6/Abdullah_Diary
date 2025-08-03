import 'package:abdullah_diary/controllers/get_customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:abdullah_diary/db/db_helper.dart';
import 'package:abdullah_diary/models/customer_card_models.dart';
import 'package:abdullah_diary/views/edit_customer.dart/edit_customer.dart';

class CustomerInfoScreen extends StatefulWidget {
  final int id;

  const CustomerInfoScreen({super.key, required this.id});

  @override
  State<CustomerInfoScreen> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  final GetCustomerController controller = Get.find<GetCustomerController>();
  CustomerItemModel? customer;
  bool isLoading = true;
  List<Map<String, dynamic>> bankAccounts = [];

  @override
  void initState() {
    super.initState();
    fetchCustomerData();
    fetchBankAccounts();
  }

  Future<void> fetchCustomerData() async {
    setState(() => isLoading = true);
    final fetchedCustomer = await DBHelper.getCustomerById(widget.id);
    setState(() {
      customer = fetchedCustomer;
      isLoading = false;
    });
  }

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

  TextStyle _textStyle(
    String text,
    double size, [
    FontWeight weight = FontWeight.normal,
  ]) {
    final urduRegex = RegExp(r'[\u0600-\u06FF]');
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      fontFamily: urduRegex.hasMatch(text) ? 'JameelNooriNastaleeq' : null,
    );
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
        title: Text(
          "Customer Info (کسٹمر کی تفصیل)",
          style: _textStyle(
            "Customer Info (کسٹمر کی تفصیل)",
            20,
            FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : customer == null
          ? const Center(child: Text("Customer not found"))
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoItem(
                            "Customer Name (کسٹمر کا نام)",
                            customer!.name,
                          ),
                          const SizedBox(height: 10),
                          _buildInfoItem(
                            "Contact Number (رابطہ نمبر)",
                            customer!.contactNumber,
                          ),
                          const SizedBox(height: 10),
                          _buildInfoItem("Address (پتہ)", customer!.adrress),
                          const SizedBox(height: 20),
                          Text(
                            "Bank Accounts (بینک اکاؤنٹس)",
                            style: _textStyle(
                              "Bank Accounts (بینک اکاؤنٹس)",
                              25,
                              FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : (bankAccounts.isEmpty &&
                                    (customer?.accounts.isEmpty ?? true))
                              ? Text(
                                  "No Bank Accounts Added (کوئی بینک اکاؤنٹس نہیں)",
                                  style: _textStyle(
                                    "No Bank Accounts Added (کوئی بینک اکاؤنٹس نہیں)",
                                    15,
                                    FontWeight.normal,
                                  ).copyWith(color: Colors.grey),
                                )
                              : _buildBankAccountsTable(),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        if (customer != null) {
                          final updated = await Get.to(
                            () => EditCustomerScreen(
                              id: customer!.id!,
                              name: customer!.name,
                              contact: customer!.contactNumber,
                              address: customer!.adrress,
                            ),
                          );
                          if (updated == true) {
                            await fetchCustomerData();
                            await fetchBankAccounts();
                          }
                        }
                      },
                      child: Text(
                        "Edit Details (ترمیم کریں)",
                        style: _textStyle(
                          "Edit Details (ترمیم کریں)",
                          20,
                          FontWeight.bold,
                        ).copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _textStyle(label, 20, FontWeight.bold)),
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
            style: _textStyle(value, 20),
          ),
        ),
      ],
    );
  }

  Widget _buildBankAccountsTable() {
    final List<Map<String, dynamic>> accountsList =
        customer!.accounts.isNotEmpty
        ? customer!.accounts
              .map(
                (acc) => {
                  'title': acc.title,
                  'number': acc.number,
                  'bank_name': acc.bankName,
                  'status': acc.status, // include status
                },
              )
              .toList()
        : bankAccounts;

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1.5), // Status column
        4: IntrinsicColumnWidth(), // Share column
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Account Title',
                style: _textStyle('Account Title', 18, FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Account Number',
                style: _textStyle('Account Number', 18, FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Bank Name',
                style: _textStyle('Bank Name', 18, FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Status',
                style: _textStyle('Status', 18, FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Share',
                style: _textStyle('Share', 18, FontWeight.bold),
              ),
            ),
          ],
        ),
        ...accountsList.map((account) {
          final title = account['title'] ?? '';
          final number = account['number'] ?? '';
          final bankName = account['bank_name'] ?? '';
          final status = account['status'] ?? 'Active';

          // Row background based on status
          final Color rowColor = status == 'Active'
              ? Colors
                    .green
                    .shade100 // light green
              : Colors.red.shade100; // light red

          return TableRow(
            decoration: BoxDecoration(color: rowColor),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title, style: _textStyle(title, 18)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(number, style: _textStyle(number, 18)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(bankName, style: _textStyle(bankName, 18)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  status,
                  style: _textStyle(status, 18, FontWeight.bold).copyWith(
                    color: status == 'Active' ? Colors.green : Colors.red,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  icon: const Icon(Icons.share, size: 30, color: Colors.green),
                  onPressed: () {
                    final message =
                        '''
📋 *Bank Account Details*

🏦 *Title:* $title
🔢 *Number:* $number
🏛️ *Bank:* $bankName
🟢 *Status:* $status
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
