import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/project_category.dart';
import '../utils/app_colors.dart';

Map<ProjectCategory, ProjectCategoryModel> categories = {
  ProjectCategory.work: ProjectCategoryModel(
    title: 'Work',
    colorValue: AppColor.primary.toARGB32(),
    icon: Iconsax.briefcase,
  ),
  ProjectCategory.personal: ProjectCategoryModel(
    title: 'Personal',
    colorValue: AppColor.accentPink.toARGB32(),
    icon: Iconsax.user,
  ),
  ProjectCategory.dailyStudy: ProjectCategoryModel(
    title: 'Daily Study',
    colorValue: AppColor.primary.withAlpha(70).toARGB32(),
    icon: Iconsax.book,
  ),
  ProjectCategory.healthFitness: ProjectCategoryModel(
    title: 'Health & Fitness',
    colorValue: AppColor.accentGreen.toARGB32(),
    icon: PhosphorIcons.barbell(),
  ),
  ProjectCategory.finance: ProjectCategoryModel(
    title: 'Finance',
    colorValue: AppColor.secondary.toARGB32(),
    icon: PhosphorIcons.chartBar(),
  ),
  ProjectCategory.shopping: ProjectCategoryModel(
    title: 'Shopping',
    colorValue: AppColor.accentOrange.toARGB32(),
    icon: Iconsax.shopping_cart,
  ),
  ProjectCategory.travel: ProjectCategoryModel(
    title: 'Travel',
    colorValue: AppColor.accentPurple.toARGB32(),
    icon: PhosphorIcons.airplaneTilt(),
  ),
  ProjectCategory.sideProjects: ProjectCategoryModel(
    title: 'Side Projects',
    colorValue: AppColor.accentRed.toARGB32(),
    icon: PhosphorIcons.code(),
  ),
  ProjectCategory.socialEvents: ProjectCategoryModel(
    title: 'Social Events',
    colorValue: AppColor.accentTeal.toARGB32(),
    icon: PhosphorIcons.users(),
  ),
};
