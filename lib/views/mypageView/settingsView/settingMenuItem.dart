import 'package:flutter/material.dart';

class SettingMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final Color? textColor;
  final VoidCallback onTap;

  const SettingMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (textColor ?? const Color(0xFF7C4DFF)).withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: textColor ?? const Color(0xFF7C4DFF),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
