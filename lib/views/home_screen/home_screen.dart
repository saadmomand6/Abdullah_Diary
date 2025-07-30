import 'package:flutter/material.dart';
import 'package:abdullah_diary/models/customer_card_models.dart';
import 'package:abdullah_diary/views/add_customer/add_customers.dart';
import 'package:abdullah_diary/widgets/customer_card.dart';
import 'package:abdullah_diary/db/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

TextEditingController searchedtext = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<CustomerItemModel>> _customerList;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() {
    _customerList = DBHelper.getAllCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Abdullah Diary",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.yellow,
        actions: [
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddCustomerScreen(),
                ),
              );
              _loadCustomers(); // reload after adding
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 95,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: TextFormField(
                controller: searchedtext,
                cursorColor: Colors.yellow,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Search Customers",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  hintStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(width: 2, color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(width: 1, color: Colors.grey),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.search, color: Colors.black),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CustomerItemModel>>(
              future: _customerList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No customers found."));
                }

                final filtered = snapshot.data!.where((customer) {
                  return customer.name
                      .toLowerCase()
                      .contains(searchedtext.text.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final customer = filtered[index];
                    return CustomerrCard(
                      name: customer.name,
                      address: customer.adrress,
                      contact: customer.contactNumber,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
