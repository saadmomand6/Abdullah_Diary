import 'package:abdullah_diary/controllers/add_customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/customer_card_models.dart';

class EditCustomerScreen extends StatefulWidget {
  final int id;
  final String name;
  final String contact;
  final String address;

  const EditCustomerScreen({
    super.key,
    required this.id,
    required this.name,
    required this.contact,
    required this.address,
  });

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final CustomerController controller = Get.put(CustomerController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Set customer data properly
    controller.setCustomerData(
      CustomerItemModel(
        id: widget.id,
        name: widget.name,
        contactNumber: widget.contact,
        adrress: widget.address,
        accounts: [],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 14),
      border: const OutlineInputBorder(),
    );
  }

  TextDirection _getDirection(String text) {
    final urduRegex = RegExp(r'[\u0600-\u06FF]');
    return urduRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          "Edit Customer (کسٹمر میں ترمیم کریں)",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
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
                      textDirection:
                          _getDirection(controller.nameController.text),
                      decoration:
                          _inputDecoration("Customer Name (کسٹمر کا نام)"),
                      validator: (value) =>
                          value!.isEmpty ? "Enter customer name" : null,
                    ),
                    const SizedBox(height: 10),

                    // Contact Number
                    TextFormField(
                      controller: controller.contactController,
                      textAlign: TextAlign.center,
                      textDirection:
                          _getDirection(controller.contactController.text),
                      decoration:
                          _inputDecoration("Contact Number (رابطہ نمبر)"),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? "Enter contact number" : null,
                    ),
                    const SizedBox(height: 10),

                    // Address
                    TextFormField(
                      controller: controller.addressController,
                      textAlign: TextAlign.center,
                      textDirection:
                          _getDirection(controller.addressController.text),
                      decoration: _inputDecoration("Address (پتہ)"),
                      validator: (value) =>
                          value!.isEmpty ? "Enter address" : null,
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Bank Accounts (بینک اکاؤنٹس)",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Dynamic Bank Accounts
                    ...controller.accounts.asMap().entries.map((entry) {
                      int index = entry.key;
                      var account = entry.value;

                      return Column(
                        children: [
                          TextFormField(
                            controller: account['accountTitle'],
                            textAlign: TextAlign.center,
                            textDirection: _getDirection(
                                account['accountTitle']!.text),
                            decoration: _inputDecoration(
                                "Account Title #${index + 1} (اکاؤنٹ کا نام)"),
                            validator: (value) => value!.isEmpty
                                ? "Enter account title"
                                : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: account['accountNumber'],
                            textAlign: TextAlign.center,
                            textDirection: _getDirection(
                                account['accountNumber']!.text),
                            decoration: _inputDecoration(
                                "Account Number #${index + 1} (اکاؤنٹ نمبر)"),
                            keyboardType: TextInputType.number,
                            validator: (value) => value!.isEmpty
                                ? "Enter account number"
                                : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: account['bankName'],
                            textAlign: TextAlign.center,
                            textDirection:
                                _getDirection(account['bankName']!.text),
                            decoration: _inputDecoration(
                                "Bank Name #${index + 1} (بینک کا نام)"),
                            validator: (value) =>
                                value!.isEmpty ? "Enter bank name" : null,
                          ),
                          const SizedBox(height: 10),

                          if (controller.accounts.length > 1)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                label: const Text("Remove (حذف کریں)",
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () =>
                                    controller.removeBankAccount(index),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }),

                    // Add another bank account
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: controller.addBankAccount,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.add),
                              SizedBox(width: 8),
                              Text("Add Another Account (نیا اکاؤنٹ شامل کریں)"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),

                    // Submit button
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          controller.updateCustomer(widget.id);
                          Get.back(result: true); // ✅ Send result
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "UPDATE (اپ ڈیٹ کریں)",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
