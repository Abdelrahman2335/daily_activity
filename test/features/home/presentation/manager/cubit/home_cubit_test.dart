import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/features/home/data/repository/home_repo.dart';
import 'package:flowi/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

ProjectModel _project({
  required String title,
  required TaskStatus status,
  required List<TaskModel> tasks,
  DateTime? startDate,
  DateTime? endDate,
}) {
  return ProjectModel(
    title: title,
    description: 'desc',
    category: categories.values.first,
    startDate: startDate ?? DateTime(2026, 1, 1),
    endDate: endDate ?? DateTime(2026, 1, 2),
    tasks: tasks,
    status: status,
  );
}

void main() {
  late MockHomeRepo mockHomeRepo;
  final filterDate = DateTime(2026, 1, 10);
  final projectA = _project(
    title: 'A',
    status: TaskStatus.inProgress,
    tasks: [TaskModel(title: 't1', isCompleted: true)],
  );
  final projectB = _project(
    title: 'B',
    status: TaskStatus.notStarted,
    tasks: [TaskModel(title: 't2', isCompleted: false)],
  );

  setUp(() {
    mockHomeRepo = MockHomeRepo();
    when(() => mockHomeRepo.getProjects()).thenReturn(Right([projectA, projectB]));
    when(() => mockHomeRepo.dateFilter(filterDate)).thenReturn(Right([projectA]));
    when(() => mockHomeRepo.statusFilter(TaskStatus.inProgress))
        .thenReturn(Right([projectA]));
    when(() => mockHomeRepo.dateTimeList())
        .thenReturn([DateTime(2026, 1, 1), DateTime(2026, 1, 2)]);
    when(() => mockHomeRepo.getOverallProgress()).thenReturn('50');
    when(() => mockHomeRepo.progressValue(projectA)).thenReturn('100%');
  });

  blocTest<HomeCubit, HomeState>(
    'loadProjects emits loading then success',
    build: () => HomeCubit(mockHomeRepo),
    act: (cubit) => cubit.loadProjects(),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeSuccess>().having((s) => s.projects.length, 'project count', 2),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'loadProjects emits loading then error when repository returns Left',
    build: () {
      when(() => mockHomeRepo.getProjects()).thenReturn(Left('load failed'));
      return HomeCubit(mockHomeRepo);
    },
    act: (cubit) => cubit.loadProjects(),
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeError>().having((s) => s.message, 'message', 'load failed'),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'applyDateFilter emits filtered results after successful load',
    build: () => HomeCubit(mockHomeRepo),
    act: (cubit) {
      cubit.loadProjects();
      cubit.applyDateFilter(filterDate);
    },
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeSuccess>(),
      isA<HomeLoading>(),
      isA<HomeFiltered>()
          .having((s) => s.filterType, 'filterType', FilterType.date)
          .having((s) => s.projects.length, 'project count', 1),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'applyStatusFilter emits error when repository returns Left',
    build: () {
      when(() => mockHomeRepo.statusFilter(TaskStatus.inProgress))
          .thenReturn(Left('status filter failed'));
      return HomeCubit(mockHomeRepo);
    },
    act: (cubit) {
      cubit.loadProjects();
      cubit.applyStatusFilter(TaskStatus.inProgress);
    },
    expect: () => [
      isA<HomeLoading>(),
      isA<HomeSuccess>(),
      isA<HomeLoading>(),
      isA<HomeError>()
          .having((s) => s.message, 'message', 'status filter failed'),
    ],
  );

  test('inProgressProjects returns empty list on Left', () {
    when(() => mockHomeRepo.statusFilter(TaskStatus.inProgress))
        .thenReturn(Left('error'));
    final cubit = HomeCubit(mockHomeRepo);
    final projects = cubit.inProgressProjects;
    expect(projects, isEmpty);
    cubit.close();
  });

  test('hasProjectsInProgress reflects repository output', () {
    final cubit = HomeCubit(mockHomeRepo);
    expect(cubit.hasProjectsInProgress, isTrue);
    when(() => mockHomeRepo.statusFilter(TaskStatus.inProgress))
        .thenReturn(Right(const []));
    expect(cubit.hasProjectsInProgress, isFalse);
    cubit.close();
  });

  test('customDateList maps dateTimeList values', () {
    final cubit = HomeCubit(mockHomeRepo);
    expect(cubit.customDateList.length, 2);
    expect(cubit.customDateList.first.day, 1);
    cubit.close();
  });

  test('overallProgress and progressValue delegate to repository', () {
    final cubit = HomeCubit(mockHomeRepo);
    expect(cubit.overallProgress, '50');
    expect(cubit.progressValue(projectA), '100%');
    cubit.close();
  });
}
