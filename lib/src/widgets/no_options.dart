import 'package:flutter/material.dart';
import 'package:group_dropdown_button/src/utils/extensions.dart';

class AppNoOptions extends StatelessWidget {
  const AppNoOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            offset: const Offset(0, 3),
            blurRadius: 15.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Text(
        "No results found",
        style: context.textTheme.titleSmall!.copyWith(
          fontSize: 15.0,
          color: Colors.black45,
        ),
      ),
    );
  }
}
