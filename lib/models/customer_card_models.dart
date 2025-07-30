class BankAccount {
  final String accountTitle;
  final String accountNumber;
  final String bankName;

  BankAccount({
    required this.accountTitle,
    required this.accountNumber,
    required this.bankName,
  });

  Map<String, dynamic> toMap(int customerId) => {
        'customer_id': customerId,
        'account_title': accountTitle,
        'account_number': accountNumber,
        'bank_name': bankName,
      };
}

class Customer {
  final int? id;
  final String name;
  final String contact;
  final String address;

  Customer({this.id, required this.name, required this.contact, required this.address});

  Map<String, dynamic> toMap() => {
        'name': name,
        'contact': contact,
        'address': address,
      };
}