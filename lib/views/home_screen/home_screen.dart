import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abdullah_diary/controllers/get_customer_controller.dart';
import 'package:abdullah_diary/widgets/customer_card.dart';
import 'package:abdullah_diary/views/add_customer/add_customers.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GetCustomerController controller = Get.put(GetCustomerController());
  final TextEditingController searchedtext = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ABD Accounts Diary", style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.yellow,
        actions: [
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddCustomerScreen()),
              );
              controller.fetchCustomers(); // reload customers after adding
            },
            child: Container(
              decoration: const BoxDecoration(
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
          // Search bar
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: TextFormField(
                controller: searchedtext,
                cursorColor: Colors.yellow,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Search Customers (کسٹمرز تلاش کریں)",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () => controller.fetchCustomers(),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onChanged: (value) => controller.fetchCustomers(),
              ),
            ),
          ),

          // Customer list using Obx
          Expanded(
            child: Obx(() {
              if (controller.customers.isEmpty) {
                return const Center(child: Text("No customers found."));
              }

              final filtered = controller.customers.where((customer) {
                return customer.name
                    .toLowerCase()
                    .contains(searchedtext.text.toLowerCase());
              }).toList();

              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final customer = filtered[index];
                  return CustomerCard(
                    id: customer.id!,
                    name: customer.name,
                    contact: customer.contactNumber,
                    address: customer.adrress,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
