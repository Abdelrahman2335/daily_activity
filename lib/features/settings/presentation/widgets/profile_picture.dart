import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: IconButton(
        onPressed: () {
          // adding user image
        },
        icon: Icon(
          Iconsax.edit,
          color: AppColor.primary,
        ),
      ),
      backgroundColor: Colors.transparent,
      offset: Offset(-20, -20),
      alignment: Alignment.bottomRight,
      child: const CircleAvatar(
        backgroundImage: null, // user image
        backgroundColor: AppColor.accentPink,
        radius: 41,
        child: Icon(
          Iconsax.user,
          size: 30,
        ),
      ),
    );
  }
}
