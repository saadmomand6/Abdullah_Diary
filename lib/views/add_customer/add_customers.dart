import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../db/db_helper.dart';
import '../model/customer_model.dart';

class AddCustomerPage extends StatefulWidget {
  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();

  List<Map<String, TextEditingController>> bankAccounts = [];

  @override
  void initState() {
    super.initState();
    addBankAccount();
  }

  void addBankAccount() {
    setState(() {
      bankAccounts.add({
        'accountTitle': TextEditingController(),
        'accountNumber': TextEditingController(),
        'bankName': TextEditingController(),
      });
    });
  }

  void removeBankAccount(int index) {
    setState(() {
      bankAccounts.removeAt(index);
    });
  }

  Future<void> saveCustomer() async {
    if (_formKey.currentState!.validate()) {
      final customer = Customer(
        name: nameController.text.trim(),
        contact: contactController.text.trim(),
        address: addressController.text.trim(),
      );

      final accounts = bankAccounts.map((e) => BankAccount(
        accountTitle: e['accountTitle']!.text.trim(),
        accountNumber: e['accountNumber']!.text.trim(),
        bankName: e['bankName']!.text.trim(),
      )).toList();

      await DBHelper.insertCustomer(customer, accounts);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Customer Saved')));

      // Clear form
      nameController.clear();
      contactController.clear();
      addressController.clear();
      bankAccounts.clear();
      addBankAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Customer (کسٹمر شامل کریں)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(nameController, 'Customer Name (نام)', TextInputType.text),
              buildTextField(contactController, 'Contact Number (فون)', TextInputType.phone),
              buildTextField(addressController, 'Address (پتہ)', TextInputType.text),

              SizedBox(height: 20),
              Text("Bank Accounts", style: TextStyle(fontWeight: FontWeight.bold)),
              ...bankAccounts.asMap().entries.map((entry) {
                int index = entry.key;
                var account = entry.value;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        buildTextField(account['accountTitle']!, 'Account Title', TextInputType.text),
                        buildTextField(account['accountNumber']!, 'Account Number', TextInputType.number),
                        buildTextField(account['bankName']!, 'Bank Name', TextInputType.text),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: bankAccounts.length > 1 ? () => removeBankAccount(index) : null,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
              OutlinedButton.icon(
                onPressed: addBankAccount,
                icon: Icon(Icons.add),
                label: Text("Add Bank Account"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveCustomer,
                child: Text("Save Customer"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}
