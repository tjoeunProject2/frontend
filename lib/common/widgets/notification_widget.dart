import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool hasNotification;

  const NotificationWidget({
    super.key,
    this.onTap,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onTap,
        ),
        if (hasNotification)
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
