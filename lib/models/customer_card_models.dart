class BankAccount {
  int? id;
  String title;
  String number;
  String bankName;
  String status; // Active or Inactive

  BankAccount({
    this.id,
    required this.title,
    required this.number,
    required this.bankName,
    this.status = 'Active',
  });

  Map<String, dynamic> toMap(int customerId) {
    return {
      'id': id,
      'customer_id': customerId,
      'title': title,
      'number': number,
      'bank_name': bankName,
      'status': status,
    };
  }

  factory BankAccount.fromMap(Map<String, dynamic> map) {
    return BankAccount(
      id: map['id'],
      title: map['title'],
      number: map['number'],
      bankName: map['bank_name'],
      status: map['status'] ?? 'Active',
    );
  }
}

class CustomerItemModel {
  int? id;
  String name;
  String contactNumber;
  String adrress;
  List<BankAccount> accounts;

  CustomerItemModel({
    this.id,
    required this.name,
    required this.contactNumber,
    required this.adrress,
    this.accounts = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contactNumber,
      'address': adrress,
    };
  }

  factory CustomerItemModel.fromMap(Map<String, dynamic> map) {
    return CustomerItemModel(
      id: map['id'],
      name: map['name'],
      contactNumber: map['contact'],
      adrress: map['address'],
    );
  }
}
