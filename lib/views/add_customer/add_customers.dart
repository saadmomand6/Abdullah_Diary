import 'package:flutter/material.dart';
import '../../db/db_helper.dart';
import '../../models/customer_card_models.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerScreen> {
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();

  List<Map<String, TextEditingController>> bankAccountControllers = [];

  @override
  void initState() {
    super.initState();
    _addBankAccountFields(); // Start with one by default
  }

  void _addBankAccountFields() {
    setState(() {
      bankAccountControllers.add({
        'title': TextEditingController(),
        'number': TextEditingController(),
        'bankName': TextEditingController(),
      });
    });
  }

  void _removeBankAccountFields(int index) {
    setState(() {
      bankAccountControllers.removeAt(index);
    });
  }

  Future<void> _saveCustomer() async {
    final customer = CustomerItemModel(
      name: nameController.text.trim(),
      contactNumber: contactController.text.trim(),
      adrress: addressController.text.trim(),
      accounts: bankAccountControllers.map((e) {
        return BankAccount(
          title: e['title']!.text.trim(),
          number: e['number']!.text.trim(),
          bankName: e['bankName']!.text.trim(),
        );
      }).toList(),
    );

    await DBHelper.insertCustomer(customer);

    if (mounted) {
      Navigator.pop(context); // Go back to home screen
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    addressController.dispose();
    for (var acc in bankAccountControllers) {
      acc.values.forEach((c) => c.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          "Add Customer (کسٹمر شامل کریں)",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(nameController, "Customer Name (کسٹمر کا نام)"),
            const SizedBox(height: 10),
            _buildTextField(contactController, "Contact Number (رابطہ نمبر)"),
            const SizedBox(height: 10),
            _buildTextField(addressController, "Address (پتہ)"),
            const SizedBox(height: 20),
            const Text(
              "Bank Accounts (بینک اکاؤنٹس)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              itemCount: bankAccountControllers.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                final bankAcc = bankAccountControllers[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _buildTextField(
                          bankAcc['title']!,
                          "Account Title (اکاؤنٹ کا عنوان)",
                        ),
                        _buildTextField(
                          bankAcc['number']!,
                          "Account Number (اکاؤنٹ نمبر)",
                        ),
                        _buildTextField(
                          bankAcc['bankName']!,
                          "Bank Name (بینک کا نام)",
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeBankAccountFields(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            TextButton.icon(
              onPressed: _addBankAccountFields,
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                "Add Another Account (نیا اکاؤنٹ شامل کریں)",
                style: TextStyle(
                  color: Colors.black,
                ), // White text for contrast
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade200, // 👈 Grey background
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: _saveCustomer,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text("Save Customer (کسٹمر محفوظ کریں)"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center, // 👈 Center the typing
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
