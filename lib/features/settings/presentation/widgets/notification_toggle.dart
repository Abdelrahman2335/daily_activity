import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NotificationToggle extends StatefulWidget {
  const NotificationToggle({
    super.key,
  });

  @override
  State<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  bool notificationEnabled = false;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(19),
      ),
      leading: Icon(
        Iconsax.notification,
        color: colorScheme
            .error, // Using error color for notification (similar to pink)
      ),
      title: const Text(
        "Notification",
      ),
      trailing: Switch(
          activeColor: colorScheme.error,
          value: notificationEnabled,
          onChanged: (value) {
            setState(() {
              notificationEnabled = !notificationEnabled;
            });
          }),
    );
  }
}
