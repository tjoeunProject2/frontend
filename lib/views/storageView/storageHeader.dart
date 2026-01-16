import 'package:flutter/material.dart';

class StorageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onSearchTap;
  final Color primaryColor;

  const StorageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onSearchTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          GestureDetector(
            onTap: onSearchTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFF3EFFF),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search, color: primaryColor, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}