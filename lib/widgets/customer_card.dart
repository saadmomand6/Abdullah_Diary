import 'package:abdullah_diary/views/info_screen/info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerCard extends StatelessWidget {
  final int id;
  final String name;
  final String? contact;
  final String? address;

  const CustomerCard({
    super.key,
    required this.id,
    required this.name,
    this.contact,
    this.address,
  });

  /// Helper method: Detect if text is Urdu
  bool _isUrdu(String text) {
    final urduRegex = RegExp(r'[\u0600-\u06FF]');
    return urduRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    bool isUrdu = _isUrdu(name);

    return InkWell(
      onTap: () {
        Get.to(() => CustomerInfoScreen(
              id: id,
              name: name,
              contact: contact ?? '',
              address: address ?? '',
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(5.0, 5.0),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    isUrdu ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  if (isUrdu)
                    const Icon(Icons.remove_red_eye, color: Colors.black),
                  if (isUrdu) const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      name,
                      textAlign: isUrdu ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                  ),

                  if (!isUrdu) const SizedBox(width: 8),
                  if (!isUrdu)
                    const Icon(Icons.remove_red_eye, color: Colors.black),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                contact ?? '',
                textAlign: isUrdu ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                ),
              ),
              Text(
                address ?? '',
                textAlign: isUrdu ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
