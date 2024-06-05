import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({
    super.key,
    required this.title,
    this.value,
    required this.icon,
  });

  final String title;
  final String? value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        height: 65,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          border: Border.all(
            color: MyColors.grey,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: MyColors.primary,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (value != null) Text(value!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
