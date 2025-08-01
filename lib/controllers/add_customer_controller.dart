import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db/db_helper.dart';
import '../../models/customer_card_models.dart';

class CustomerController extends GetxController {
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();

  var accounts = <Map<String, TextEditingController>>[].obs;

  int? customerId;

  @override
  void onInit() {
    super.onInit();
    addBankAccount(); // Always have at least one entry
  }

  void setCustomerData(CustomerItemModel customer) async {
    customerId = customer.id;
    nameController.text = customer.name;
    contactController.text = customer.contactNumber;
    addressController.text = customer.adrress;

    accounts.clear();

    List<BankAccount> existingAccounts =
        await DBHelper.getBankAccountsForCustomer(customer.id!);
    for (var acc in existingAccounts) {
      accounts.add({
        'accountTitle': TextEditingController(text: acc.title),
        'accountNumber': TextEditingController(text: acc.number),
        'bankName': TextEditingController(text: acc.bankName),
      });
    }

    if (accounts.isEmpty) addBankAccount();
  }

  void addBankAccount() {
    accounts.add({
      'accountTitle': TextEditingController(),
      'accountNumber': TextEditingController(),
      'bankName': TextEditingController(),
    });
  }

  void removeBankAccount(int index) {
    accounts[index]['accountTitle']?.dispose();
    accounts[index]['accountNumber']?.dispose();
    accounts[index]['bankName']?.dispose();
    accounts.removeAt(index);
  }

  void loadBankAccountsForCustomer(int customerId) async {
  final fetchedAccounts = await DBHelper.getBankAccountsForCustomer(customerId);

  accounts.clear(); // Clear any existing input fields

  for (var account in fetchedAccounts) {
    accounts.add({
      'accountTitle': TextEditingController(text: account.title),
      'accountNumber': TextEditingController(text: account.number),
      'bankName': TextEditingController(text: account.bankName),
    });
  }

  if (accounts.isEmpty) {
    addBankAccount(); // Ensure at least one blank entry
  }
}


Future<bool> updateCustomer(int id) async {
  final updatedCustomer = CustomerItemModel(
    id: id,
    name: nameController.text,
    contactNumber: contactController.text,
    adrress: addressController.text,
  );

  await DBHelper.updateCustomer(updatedCustomer);
  await DBHelper.deleteBankAccountsByCustomerId(id);

  for (var account in accounts) {
    final bankAccount = BankAccount(
      title: account['accountTitle']!.text,
      number: account['accountNumber']!.text,
      bankName: account['bankName']!.text,
    );
    await DBHelper.insertBankAccount(bankAccount, id);
  }
  return true; // optional return if needed
}

  @override
  void onClose() {
    nameController.dispose();
    contactController.dispose();
    addressController.dispose();
    for (var account in accounts) {
      account['accountTitle']?.dispose();
      account['accountNumber']?.dispose();
      account['bankName']?.dispose();
    }
    super.onClose();
  }
}
