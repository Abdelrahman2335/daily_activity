import 'package:daily_activity/core/utils/app_colors.dart';
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
    return ListTile(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(19),
      ),
      leading: const Icon(
        Iconsax.notification,
        color: AppColor.accentPink,
      ),
      title: const Text(
        "Notification",
      ),
      trailing: Switch(
          activeColor: AppColor.accentPink,
          value: notificationEnabled,
          onChanged: (value) {
            setState(() {
              notificationEnabled = !notificationEnabled;
            });
          }),
    );
  }
}
