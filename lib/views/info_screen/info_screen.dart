import 'package:abdullah_diary/views/edit_customer.dart/edit_customer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerInfoScreen extends StatelessWidget {
  final String id;
  final String name;
  final String contact;
  final String address;
  final List<Map<String, dynamic>> bankAccounts; 

  const CustomerInfoScreen({
    super.key,
    required this.id,
    required this.name,
    required this.contact,
    required this.address,
    required this.bankAccounts,
  });

  /// Helper method: Detect Urdu
  TextDirection _getDirection(String text) {
    final urduRegex = RegExp(r'[\u0600-\u06FF]');
    return urduRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Customer Info (کسٹمر کی تفصیل)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to Edit Screen
              Get.to(() => EditCustomerScreen(
                    id: id,
                    name: name,
                    contact: contact,
                    address: address,
                  ));
            },
            child: Text(
              "Edit Details (ترمیم کریں)",
              style: TextStyle(color: Colors.blue, fontSize: 14),
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
              // Customer Name
              _buildInfoItem("Customer Name (کسٹمر کا نام)", name),
              SizedBox(height: 10),

              // Contact Number
              _buildInfoItem("Contact Number (رابطہ نمبر)", contact),
              SizedBox(height: 10),

              // Address
              _buildInfoItem("Address (پتہ)", address),
              SizedBox(height: 20),

              // Bank Accounts
              Text(
                "Bank Accounts (بینک اکاؤنٹس)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              bankAccounts.isEmpty
                  ? Text("No Bank Accounts Added (کوئی بینک اکاؤنٹس نہیں)",
                      style: TextStyle(color: Colors.grey))
                  : Column(
                      children: bankAccounts.asMap().entries.map((entry) {
                        int index = entry.key;
                        var account = entry.value;

                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade50,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoItem(
                                  "Account Title #${index + 1} (اکاؤنٹ کا نام)",
                                  account['accountTitle'] ?? ''),
                              SizedBox(height: 8),
                              _buildInfoItem(
                                  "Account Number (اکاؤنٹ نمبر)",
                                  account['accountNumber'] ?? ''),
                              SizedBox(height: 8),
                              _buildInfoItem(
                                  "Bank Name (بینک کا نام)",
                                  account['bankName'] ?? ''),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget for displaying label & value
  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87)),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100,
          ),
          child: Text(
            value,
            textDirection: _getDirection(value),
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}