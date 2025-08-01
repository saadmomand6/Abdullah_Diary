import 'package:get/get.dart';
import 'package:abdullah_diary/db/db_helper.dart';
import 'package:abdullah_diary/models/customer_card_models.dart';

class GetCustomerController extends GetxController {
  var customers = <CustomerItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  /// Fetch all customers from DB
  void fetchCustomers() async {
    customers.value = await DBHelper.getAllCustomers();
  }
}