import 'package:flutter/material.dart';

class SettingSectionTitle extends StatelessWidget {
  final String title;

  const SettingSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }
}
