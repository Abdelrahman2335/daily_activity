import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Badge(
      label: IconButton(
        onPressed: () {
          // adding user image
        },
        icon: Icon(
          Iconsax.edit,
          color: colorScheme.primary,
        ),
      ),
      backgroundColor: Colors.transparent,
      offset: Offset(-20, -20),
      alignment: Alignment.bottomRight,
      child: CircleAvatar(
        backgroundImage: null, // user image
        backgroundColor:
            colorScheme.error, // Using error color instead of accentPink
        radius: 41,
        child: const Icon(
          Iconsax.user,
          size: 30,
        ),
      ),
    );
  }
}
