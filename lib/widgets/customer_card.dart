import 'package:abdullah_diary/views/edit_customer.dart/edit_customer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerrCard extends StatefulWidget {
  final String name;
  final String? id;
  final String? contact;
  final String? address;

  const CustomerrCard({
    required this.name,
    this.id,
    this.address,
    this.contact,
    super.key,
  });

  @override
  State<CustomerrCard> createState() => _CustomerrCardState();
}

class _CustomerrCardState extends State<CustomerrCard> {
  /// Helper method: Detect if text is Urdu
  bool _isUrdu(String text) {
    final urduRegex = RegExp(r'[\u0600-\u06FF]');
    return urduRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    // Determine text direction based on name
    bool isUrdu = _isUrdu(widget.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ]),
        child: Column(
          crossAxisAlignment:
              isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  isUrdu ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                // If Urdu -> edit icon first, then text
                if (isUrdu)
                  InkWell(
                    onTap: () {
                      Get.to(() => EditCustomerScreen(
          name: widget.name,
          contact: widget.contact ?? '',
          address: widget.address ?? '',
          id: widget.id ?? '',
        ));
                    },
                    child: const Icon(Icons.edit, color: Colors.black),
                  ),
                if (isUrdu) const SizedBox(width: 8),
    
                // Name text
                Expanded(
                  child: Text(
                    widget.name,
                    textAlign: isUrdu ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:
                          MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
    
                // If English -> text first, then edit icon
                if (!isUrdu) const SizedBox(width: 8),
                if (!isUrdu)
                  InkWell(
                      onTap: () {
                      Get.to(() => EditCustomerScreen(
          name: widget.name,
          contact: widget.contact ?? '',
          address: widget.address ?? '',
          id: widget.id ?? '',
        ));
                    },
                    child: const Icon(Icons.edit, color: Colors.black),
                  ),
              ],
            ),
    
            const SizedBox(height: 5),
    
            // Contact
            Text(
              widget.contact.toString(),
              textAlign: isUrdu ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.height * 0.015,
              ),
            ),
    
            // Address
            Text(
              widget.address.toString(),
              textAlign: isUrdu ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.height * 0.015,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

