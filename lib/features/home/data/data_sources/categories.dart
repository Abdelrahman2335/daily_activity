import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/utils/app_colors.dart';
import '../models/task_category.dart';

Map<TaskCategory, TaskCategoryModel> categories = {
  TaskCategory.work: TaskCategoryModel(
    title: 'Work',
    color: AppColor.primary,
    icon: Iconsax.briefcase,
  ),
  TaskCategory.personal: TaskCategoryModel(
    title: 'Personal',
    color: AppColor.accentPink,
    icon: Iconsax.user,
  ),
  TaskCategory.dailyStudy: TaskCategoryModel(
    title: 'Daily Study',
    color: AppColor.primary.withAlpha(70),
    icon: Iconsax.book,
  ),
  TaskCategory.healthFitness: TaskCategoryModel(
    title: 'Health & Fitness',
    color: AppColor.accentGreen,
    icon: PhosphorIcons.barbell(),
  ),
  TaskCategory.finance: TaskCategoryModel(
    title: 'Finance',
    color: AppColor.secondary,
    icon: PhosphorIcons.chartBar(),
  ),
  TaskCategory.shopping: TaskCategoryModel(
    title: 'Shopping',
    color: AppColor.accentOrange,
    icon: Iconsax.shopping_cart,
  ),
  TaskCategory.travel: TaskCategoryModel(
    title: 'Travel',
    color: AppColor.accentPurple,
    icon: PhosphorIcons.airplaneTilt(),
  ),
  TaskCategory.sideProjects: TaskCategoryModel(
    title: 'Side Projects',
    color: AppColor.accentRed,
    icon: PhosphorIcons.code(),
  ),
  TaskCategory.socialEvents: TaskCategoryModel(
    title: 'Social Events',
    color: AppColor.accentTeal,
    icon: PhosphorIcons.users(),
  ),
};
