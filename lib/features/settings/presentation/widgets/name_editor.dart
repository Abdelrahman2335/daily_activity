import 'package:daily_activity/core/utils/app_colors.dart';
import 'package:daily_activity/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class NameEditor extends StatefulWidget {
  const NameEditor({
    super.key,
  });

  @override
  State<NameEditor> createState() => _NameEditorState();
}

class _NameEditorState extends State<NameEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller =
        TextEditingController(text: context.read<SettingCubit>().currentName);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme.surface;
    return TextField(
      onChanged: (value) {
        context.read<SettingCubit>().updateUserName(value);
      },
      controller: _controller,
      decoration: InputDecoration(
        fillColor: theme,
        focusColor: theme,
        prefixIcon: Icon(
          Iconsax.user,
          color: AppColor.accentTeal,
        ),
        hintText: "Name",
        border: OutlineInputBorder(
          borderSide: BorderSide(color: theme),
          borderRadius: BorderRadius.circular(19),
        ),
      ),
    );
  }
}
