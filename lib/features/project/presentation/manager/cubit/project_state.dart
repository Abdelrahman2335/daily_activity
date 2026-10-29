part of 'project_cubit.dart';

@immutable
sealed class ProjectState {}

final class ProjectInitial extends ProjectState {}

final class ProjectLoading extends ProjectState {}

final class ProjectSuccess extends ProjectState {}

final class ProjectError extends ProjectState {
  ProjectError(this.errMessage);
  final String errMessage;
}

final class ProjectFormState extends ProjectState {
  final ProjectModel project;
  final bool isValid;

  // Reminder form fields. Kept separate from [project] because the Hive
  // model uses `null` for "daily" and [copyWith] cannot write nulls; the
  // cubit normalizes them into the model on submit.
  final String reminderMode;

  /// Cadence while reminderMode == 'custom'.
  final ReminderCadence reminderCadence;

  /// Daily 'HH:mm' times (0..3) while custom + daily.
  final List<String> customSlots;

  /// ISO weekdays while custom + weekly (1=Mon..7=Sun).
  final List<int> customWeekdays;

  /// Weekly 'HH:mm' time.
  final String weeklyTime;

  ProjectFormState({
    required this.project,
    this.isValid = false,
    this.reminderMode = 'default',
    this.reminderCadence = ReminderCadence.daily,
    this.customSlots = const [],
    this.customWeekdays = const [],
    this.weeklyTime = '09:00',
  });

  ProjectFormState copyWith({
    ProjectModel? project,
    bool? isValid,
    String? reminderMode,
    ReminderCadence? reminderCadence,
    List<String>? customSlots,
    List<int>? customWeekdays,
    String? weeklyTime,
  }) {
    return ProjectFormState(
        project: project ?? this.project,
        isValid: isValid ?? this.isValid,
        reminderMode: reminderMode ?? this.reminderMode,
        reminderCadence: reminderCadence ?? this.reminderCadence,
        customSlots: customSlots ?? this.customSlots,
        customWeekdays: customWeekdays ?? this.customWeekdays,
        weeklyTime: weeklyTime ?? this.weeklyTime);
  }

  String get title => project.title;
  String get description => project.description;
  ProjectCategoryModel get category => project.category;
  DateTime get startDate => project.startDate;
  DateTime get endDate => project.endDate;
  DateTime get date => project.startDate;
  double get progress => project.progress;
  TaskStatus get status => project.status;
  List<TaskModel> get tasks => project.tasks;
}
