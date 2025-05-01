import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../models/task_category.dart';

Map<TaskCategory, TaskCategoryModel> categories = {
  TaskCategory.work: TaskCategoryModel(
    title: 'Work',
    color: AppColors.primary,
    icon: Iconsax.briefcase_copy,
  ),
  TaskCategory.personal:  TaskCategoryModel(
    title: 'Personal',
    color: AppColors.accentPink,
    icon: Iconsax.user_copy,
  ),
  TaskCategory.dailyStudy: TaskCategoryModel(
    title: 'Daily Study',
    color: AppColors.primary.withAlpha(70),
    icon: Iconsax.book,
  ),
  TaskCategory.healthFitness: TaskCategoryModel(
    title: 'Health & Fitness',
    color: AppColors.accentGreen,
    icon: PhosphorIcons.barbell(),
  ),
  TaskCategory.finance: TaskCategoryModel(
    title: 'Finance',
    color: AppColors.secondary,
    icon: PhosphorIcons.chartBar(),
  ),
  TaskCategory.shopping: TaskCategoryModel(
    title: 'Shopping',
    color: AppColors.accentOrange,
    icon: Iconsax.shopping_cart_copy,
  ),
  TaskCategory.travel: TaskCategoryModel(
    title: 'Travel',
    color: AppColors.accentPurple,
    icon: PhosphorIcons.airplaneTilt(),
  ),
  TaskCategory.sideProjects: TaskCategoryModel(
    title: 'Side Projects',
    color: AppColors.accentRed,
    icon: PhosphorIcons.code(),
  ),
  TaskCategory.socialEvents: TaskCategoryModel(
    title: 'Social Events',
    color: AppColors.accentTeal,
    icon: PhosphorIcons.users(),
  ),
};
