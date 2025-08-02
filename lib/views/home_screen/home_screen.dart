import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:abdullah_diary/controllers/get_customer_controller.dart';
import 'package:abdullah_diary/widgets/customer_card.dart';
import 'package:abdullah_diary/views/add_customer/add_customers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetCustomerController controller = Get.put(GetCustomerController());
  final TextEditingController searchedtext = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
  }

  Future<void> _requestStoragePermission() async {
  if (await Permission.storage.isGranted ||
      await Permission.manageExternalStorage.isGranted ||
      await Permission.photos.isGranted) {
    debugPrint("✅ Storage permission already granted");
    return;
  }

  // For Android 13+
  if (await Permission.photos.isDenied ||
      await Permission.videos.isDenied ||
      await Permission.audio.isDenied) {
    await [
      Permission.photos,
      Permission.videos,
      Permission.audio,
    ].request();
  }

  // For Full Access (Android 11+)
  if (await Permission.manageExternalStorage.isDenied ||
      await Permission.manageExternalStorage.isPermanentlyDenied) {
    await Permission.manageExternalStorage.request();
  }

  if (await Permission.manageExternalStorage.isPermanentlyDenied) {
    openAppSettings();
  }
}

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Storage Permission Required"),
        content: const Text(
          "This app needs storage access to import/export your account data.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final result = await Permission.storage.request();
              if (result.isGranted) {
                debugPrint("✅ Permission granted from dialog");
              } else if (result.isPermanentlyDenied) {
                openAppSettings();
              }
            },
            child: const Text("Allow"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("ABD Accounts Diary", style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.yellow,
        actions: [
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddCustomerScreen()),
              );
              controller.fetchCustomers(); // Reload customers after adding
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
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18, // 👈 Input text font size
      ),
      decoration: InputDecoration(
        hintText: "Search Customers (کسٹمرز تلاش کریں)",
        hintStyle: const TextStyle(
          fontSize: 18, // 👈 Hint text font size
          color: Colors.grey,
          fontFamily: 'NooriNastaliq', // 👈 Optional Urdu font for hint
        ),
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

          // Customer list
          Expanded(
            child: Obx(() {
  if (controller.customers.isEmpty) {
    return const Center(
      child: Text(
        "No customers found.",
        style: TextStyle(
          fontSize: 20, // 👈 Increase this value for larger text
          fontWeight: FontWeight.w500, // Optional: make it semi-bold
        ),
        textAlign: TextAlign.center,
      ),
    );
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
