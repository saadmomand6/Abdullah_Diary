import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  // Customer info controllers
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();

  // Dynamic bank accounts
  var bankAccounts = <Map<String, TextEditingController>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Add initial bank account
    addBankAccount();
  }

  void addBankAccount() {
    bankAccounts.add({
      'accountName': TextEditingController(),
      'accountNumber': TextEditingController(),
    });
  }

  void removeBankAccount(int index) {
    bankAccounts[index]['accountName']!.dispose();
    bankAccounts[index]['accountNumber']!.dispose();
    bankAccounts.removeAt(index);
  }

  void saveCustomer() {
    // Collect data
    final customer = {
      'name': nameController.text,
      'contact': contactController.text,
      'address': addressController.text,
      'bankAccounts': bankAccounts
          .map((account) => {
                'accountName': account['accountName']!.text,
                'accountNumber': account['accountNumber']!.text,
              })
          .toList()
    };

    

    Get.snackbar("Success", "Customer Saved Successfully!",
        snackPosition: SnackPosition.BOTTOM);
  }

  void updateCustomer(String id) {
  // Update logic
  // e.g., find customer by id in database or list and update values
  Get.snackbar("Updated", "Customer updated successfully");
  Get.back(); // Go back after saving
}

  @override
  void onClose() {
    nameController.dispose();
    contactController.dispose();
    addressController.dispose();
    for (var account in bankAccounts) {
      account['accountName']!.dispose();
      account['accountNumber']!.dispose();
    }
    super.onClose();
  }
}
