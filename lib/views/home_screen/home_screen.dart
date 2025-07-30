import 'package:abdullah_diary/models/customer_card_models.dart';
import 'package:abdullah_diary/views/add_customer/add_customers.dart';
import 'package:abdullah_diary/widgets/customer_card.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 TextEditingController searchedtext = TextEditingController();
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Abdullah Diary",style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.yellow,
      actions: [
        InkWell(
          onTap: (){
             Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddCustomerScreen()));
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            
            child: Icon(Icons.add),
          ),
        ),
        SizedBox(
          width: 20,
        )
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
                      bottomRight: Radius.circular(40))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: TextFormField(
                  controller: searchedtext,
                  obscureText: false,
                  
                  cursorColor: Colors.yellow,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search Customers",
                    contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                        )),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )),
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
           Expanded(
            child: ListView.builder(
              itemCount: CustomerHelper.itemCount,
              itemBuilder: (context, index) {
                CustomerItemModel customer =
                    CustomerHelper.getchatitem(index);
                String name = customer.name;
                if (searchedtext.text.isEmpty) {
                  return CustomerrCard(
                    name: customer.name,
                    address: customer.adrress,
                    contact: customer.contactNumber,
                  );
                } else if (name
                    .toLowerCase()
                    .contains(searchedtext.text.toLowerCase())) {
                  return CustomerrCard(
                    name: customer.name,
                    address: customer.adrress,
                    contact: customer.contactNumber,
                  );
                } else {
                  return const Center();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}