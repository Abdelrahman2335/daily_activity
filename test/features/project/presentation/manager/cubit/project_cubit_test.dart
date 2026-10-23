import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/features/project/data/project_repository/project_repo.dart';
import 'package:flowi/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProjectRepository extends Mock implements ProjectRepository {}

ProjectModel _project({
  String? id,
  String title = '',
  String description = '',
  TaskStatus status = TaskStatus.notStarted,
  List<TaskModel>? tasks,
}) {
  return ProjectModel(
    id: id,
    title: title,
    description: description,
    category: categories.values.first,
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2026, 1, 2),
    tasks: tasks ?? [TaskModel(title: '')],
    status: status,
  );
}

/// Fills the blank draft task the cubit starts with, the same way the UI does:
/// by replacing the task that already exists instead of appending a new one.
void _fillDraftTask(ProjectCubit cubit, {String title = 'Task 1'}) {
  final draft = cubit.currentTasks.first;
  cubit.tasksChange(
    TaskModel(id: draft.id, title: title, isCompleted: draft.isCompleted),
  );
}

void main() {
  late MockProjectRepository mockProjectRepo;

  setUpAll(() {
    registerFallbackValue(_project());
  });

  setUp(() {
    mockProjectRepo = MockProjectRepository();
    when(() => mockProjectRepo.addProject(project: any(named: 'project')))
        .thenAnswer((_) async => const Right(null));
    when(() =>
            mockProjectRepo.editProject(updatedProject: any(named: 'updatedProject')))
        .thenAnswer((_) async => const Right(null));
    when(() => mockProjectRepo.deleteProject(projectId: any(named: 'projectId')))
        .thenAnswer((_) async => const Right(null));
  });

  blocTest<ProjectCubit, ProjectState>(
    'categoryChange updates form category',
    build: () => ProjectCubit(mockProjectRepo),
    act: (cubit) => cubit.categoryChange(categories.values.elementAt(1)),
    expect: () => [
      isA<ProjectFormState>().having((s) => s.category.title, 'category title',
          categories.values.elementAt(1).title),
    ],
  );

  blocTest<ProjectCubit, ProjectState>(
    'tasksChange updates duplicate task (same id) instead of adding new task',
    build: () {
      final initial = _project(
        title: 'title',
        description: 'desc',
        tasks: [TaskModel(id: 't1', title: 'first', isCompleted: false)],
      );
      return ProjectCubit(mockProjectRepo, initialProject: initial);
    },
    act: (cubit) => cubit.tasksChange(
      TaskModel(id: 't1', title: 'first-updated', isCompleted: true),
    ),
    expect: () => [
      isA<ProjectFormState>()
          .having((s) => s.tasks.length, 'task length', 1)
          .having((s) => s.tasks.first.title, 'updated title', 'first-updated'),
      isA<ProjectFormState>()
          .having((s) => s.tasks.length, 'task length', 1)
          .having((s) => s.status, 'status', TaskStatus.completed),
    ],
  );

  blocTest<ProjectCubit, ProjectState>(
    'removeTask emits ProjectError for invalid index',
    build: () => ProjectCubit(mockProjectRepo),
    act: (cubit) => cubit.removeTask(2),
    expect: () => [
      isA<ProjectError>()
          .having((s) => s.errMessage, 'message', 'Invalid task index'),
    ],
  );

  blocTest<ProjectCubit, ProjectState>(
    'removeTask emits ProjectError when trying to remove the last task',
    build: () => ProjectCubit(mockProjectRepo),
    act: (cubit) => cubit.removeTask(0),
    expect: () => [
      isA<ProjectError>().having(
          (s) => s.errMessage, 'message', 'At least one task is required'),
    ],
  );

  blocTest<ProjectCubit, ProjectState>(
    'initial state is invalid for a blank project',
    build: () => ProjectCubit(mockProjectRepo),
    verify: (cubit) {
      final state = cubit.state as ProjectFormState;
      expect(state.isValid, isFalse);
    },
  );

  blocTest<ProjectCubit, ProjectState>(
    'submitForm emits ProjectSuccess when addProject returns Right',
    build: () {
      final cubit = ProjectCubit(mockProjectRepo);
      cubit.titleChange('New');
      cubit.descriptionChange('Desc');
      _fillDraftTask(cubit);
      return cubit;
    },
    act: (cubit) async {
      final saved = await cubit.submitForm();
      expect(saved, isTrue);
    },
    expect: () => [isA<ProjectSuccess>()],
    verify: (_) {
      verify(() => mockProjectRepo.addProject(project: any(named: 'project')))
          .called(1);
    },
  );

  blocTest<ProjectCubit, ProjectState>(
    'submitForm emits ProjectError when addProject returns Left',
    build: () {
      when(() => mockProjectRepo.addProject(project: any(named: 'project')))
          .thenAnswer((_) async => const Left('add failed'));
      final cubit = ProjectCubit(mockProjectRepo);
      cubit.titleChange('New');
      cubit.descriptionChange('Desc');
      _fillDraftTask(cubit);
      return cubit;
    },
    act: (cubit) async {
      final saved = await cubit.submitForm();
      expect(saved, isFalse);
    },
    expect: () => [
      isA<ProjectError>().having((s) => s.errMessage, 'message', 'add failed'),
    ],
  );

  blocTest<ProjectCubit, ProjectState>(
    'submitForm in edit mode emits ProjectSuccess when editProject returns Right',
    build: () {
      final existing = _project(
        id: 'p1',
        title: 'Old',
        description: 'Old desc',
        tasks: [TaskModel(id: 't1', title: 'task', isCompleted: false)],
      );
      final cubit = ProjectCubit(mockProjectRepo, initialProject: existing);
      cubit.titleChange('Edited');
      return cubit;
    },
    act: (cubit) => cubit.submitForm(),
    expect: () => [isA<ProjectSuccess>()],
    verify: (_) {
      verify(() => mockProjectRepo.editProject(
          updatedProject: any(named: 'updatedProject'))).called(1);
    },
  );

  test('submitForm does not save a blank form and does not emit', () async {
    final cubit = ProjectCubit(mockProjectRepo);
    final emitted = <ProjectState>[];
    final sub = cubit.stream.listen(emitted.add);

    final saved = await cubit.submitForm();
    await Future<void>.delayed(Duration.zero);

    expect(saved, isFalse);
    expect(emitted, isEmpty);
    verifyNever(
        () => mockProjectRepo.addProject(project: any(named: 'project')));

    await sub.cancel();
    await cubit.close();
  });

  test('submitForm does not save while a task title is blank', () async {
    final cubit = ProjectCubit(mockProjectRepo);
    cubit.titleChange('Has title');
    cubit.descriptionChange('Has description');

    expect((cubit.state as ProjectFormState).isValid, isFalse);
    expect(await cubit.submitForm(), isFalse);

    _fillDraftTask(cubit);
    expect((cubit.state as ProjectFormState).isValid, isTrue);

    await cubit.close();
  });

  test('submitForm trims whitespace-only input', () async {
    final cubit = ProjectCubit(mockProjectRepo);
    cubit.titleChange('   ');
    cubit.descriptionChange('   ');
    _fillDraftTask(cubit, title: '   ');

    expect((cubit.state as ProjectFormState).isValid, isFalse);
    expect(await cubit.submitForm(), isFalse);

    await cubit.close();
  });
}
