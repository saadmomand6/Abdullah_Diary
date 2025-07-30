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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Add Customer (کسٹمر شامل کریں)",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(nameController, "Customer Name"),
            const SizedBox(height: 10),
            _buildTextField(contactController, "Contact Number"),
            const SizedBox(height: 10),
            _buildTextField(addressController, "Address"),
            const SizedBox(height: 20),
            const Text("Bank Accounts", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              itemCount: bankAccountControllers.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                final bankAcc = bankAccountControllers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _buildTextField(bankAcc['title']!, "Account Title"),
                        _buildTextField(bankAcc['number']!, "Account Number"),
                        _buildTextField(bankAcc['bankName']!, "Bank Name"),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeBankAccountFields(index),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            TextButton.icon(
              onPressed: _addBankAccountFields,
              icon: const Icon(Icons.add),
              label: const Text("Add Another Account"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCustomer,
              child: const Text("Save Customer"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
