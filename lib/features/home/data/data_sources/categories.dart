import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/models/project_category.dart';
import '../../../../core/utils/app_colors.dart';

Map<ProjectCategory, ProjectCategoryModel> categories = {
  ProjectCategory.work: ProjectCategoryModel(
    title: 'Work',
    color: AppColor.primary,
    icon: Iconsax.briefcase,
  ),
  ProjectCategory.personal: ProjectCategoryModel(
    title: 'Personal',
    color: AppColor.accentPink,
    icon: Iconsax.user,
  ),
  ProjectCategory.dailyStudy: ProjectCategoryModel(
    title: 'Daily Study',
    color: AppColor.primary.withAlpha(70),
    icon: Iconsax.book,
  ),
  ProjectCategory.healthFitness: ProjectCategoryModel(
    title: 'Health & Fitness',
    color: AppColor.accentGreen,
    icon: PhosphorIcons.barbell(),
  ),
  ProjectCategory.finance: ProjectCategoryModel(
    title: 'Finance',
    color: AppColor.secondary,
    icon: PhosphorIcons.chartBar(),
  ),
  ProjectCategory.shopping: ProjectCategoryModel(
    title: 'Shopping',
    color: AppColor.accentOrange,
    icon: Iconsax.shopping_cart,
  ),
  ProjectCategory.travel: ProjectCategoryModel(
    title: 'Travel',
    color: AppColor.accentPurple,
    icon: PhosphorIcons.airplaneTilt(),
  ),
  ProjectCategory.sideProjects: ProjectCategoryModel(
    title: 'Side Projects',
    color: AppColor.accentRed,
    icon: PhosphorIcons.code(),
  ),
  ProjectCategory.socialEvents: ProjectCategoryModel(
    title: 'Social Events',
    color: AppColor.accentTeal,
    icon: PhosphorIcons.users(),
  ),
};
