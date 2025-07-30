import 'package:abdullah_diary/controllers/add_customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomerScreen extends StatelessWidget {
  final CustomerController controller = Get.put(CustomerController());

  final _formKey = GlobalKey<FormState>();

  AddCustomerScreen({super.key});

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 14),
      border: OutlineInputBorder(),
    );
  }

  /// Helper function to detect Urdu characters and set text direction dynamically
  TextDirection _getDirection(String text) {
    final urduRegex = RegExp(r'[\u0600-\u06FF]');
    return urduRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Add Customer (کسٹمر شامل کریں)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Obx(() => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Name
                    TextFormField(
                      controller: controller.nameController,
                      textAlign: TextAlign.center,
                      textDirection: _getDirection(controller.nameController.text),
                      onChanged: (val) => controller.nameController.text = val,
                      decoration:
                          _inputDecoration("Customer Name (کسٹمر کا نام)"),
                      validator: (value) =>
                          value!.isEmpty ? "Enter customer name" : null,
                    ),
                    SizedBox(height: 10),

                    // Contact Number
                    TextFormField(
                      controller: controller.contactController,
                      textAlign: TextAlign.center,
                      textDirection:
                          _getDirection(controller.contactController.text),
                      onChanged: (val) =>
                          controller.contactController.text = val,
                      decoration:
                          _inputDecoration("Contact Number (رابطہ نمبر)"),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? "Enter contact number" : null,
                    ),
                    SizedBox(height: 10),

                    // Address
                    TextFormField(
                      controller: controller.addressController,
                      textAlign: TextAlign.center,
                      textDirection:
                          _getDirection(controller.addressController.text),
                      onChanged: (val) =>
                          controller.addressController.text = val,
                      decoration: _inputDecoration("Address (پتہ)"),
                      validator: (value) =>
                          value!.isEmpty ? "Enter address" : null,
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Bank Accounts (بینک اکاؤنٹس)",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),

                    // Dynamic Bank Accounts
                    ...controller.bankAccounts.asMap().entries.map((entry) {
                      int index = entry.key;
                      var account = entry.value;

                      return Column(
                        children: [
                          TextFormField(
                            controller: account['accountName'],
                            textAlign: TextAlign.center,
                            textDirection: _getDirection(
                                account['accountName']!.text),
                            onChanged: (val) =>
                                account['accountName']!.text = val,
                            decoration: _inputDecoration(
                                "Account Name #${index + 1} (اکاؤنٹ کا نام)"),
                            validator: (value) => value!.isEmpty
                                ? "Enter account name"
                                : null,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: account['accountNumber'],
                            textAlign: TextAlign.center,
                            textDirection: _getDirection(
                                account['accountNumber']!.text),
                            onChanged: (val) =>
                                account['accountNumber']!.text = val,
                            decoration: _inputDecoration(
                                "Account Number #${index + 1} (اکاؤنٹ نمبر)"),
                            keyboardType: TextInputType.number,
                            validator: (value) => value!.isEmpty
                                ? "Enter account number"
                                : null,
                          ),
                          SizedBox(height: 10),

                          // Remove account button
                          if (controller.bankAccounts.length > 1)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: Icon(Icons.delete, color: Colors.red),
                                label: Text("Remove (حذف کریں)",
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () =>
                                    controller.removeBankAccount(index),
                              ),
                            ),
                          SizedBox(height: 20),
                        ],
                      );
                    }),

                    // Add another bank account (Right aligned)
                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: controller.addBankAccount,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                    "Add Another Bank Account (نیا اکاؤنٹ شامل کریں)")
                              ],
                            ),
                          ),
                        )),
                    SizedBox(height: 80), // space before save button
                  ],
                ),
              )),
        ),
      ),

      // Full-width Yellow Save Button at bottom
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              controller.saveCustomer();
            }
          },
          child: Text(
            "SAVE (محفوظ کریں)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}