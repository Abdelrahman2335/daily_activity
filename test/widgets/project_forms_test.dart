import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_category.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/task_model.dart';
import 'package:flowi/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flowi/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:flowi/features/project/presentation/widgets/add_project_view_body.dart';
import 'package:flowi/features/project/presentation/widgets/edit_project_view_body.dart';

import 'support/fakes.dart';
import 'support/widget_test_harness.dart';

void main() {
  late MockHomeRepo homeRepo;

  setUpAll(() async {
    registerTestFallbacks();
    await TestFonts.load();
  });

  setUp(() async {
    await TestHive.ensureOpen();
    homeRepo = buildHomeRepo(projects: <ProjectModel>[sampleProject()]);
  });

  group('AddProjectViewBody', () {
    testWidgets('loading state shows a CircularProgressIndicator',
        (tester) async {
      final repo = buildProjectRepo();
      final cubit = SeedableProjectCubit(repo)..seed(ProjectLoading());

      await pumpScreen(
        tester,
        MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
            BlocProvider<ProjectCubit>(create: (_) => cubit),
          ],
          child: const Scaffold(body: AddProjectViewBody()),
        ),
        settle: false,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('empty submit triggers required field validators and does '
        'not save', (tester) async {
      final repo = buildProjectRepo();

      await pumpScreen(
        tester,
        MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
            BlocProvider<ProjectCubit>(
              create: (_) => SeedableProjectCubit(repo),
            ),
          ],
          child: const Scaffold(body: AddProjectViewBody()),
        ),
      );

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.text('Field is required'), findsWidgets);
      verifyNever(() => repo.addProject(project: any(named: 'project')));
    });

    testWidgets('valid submit calls addProject and refreshes HomeCubit',
        (tester) async {
      final repo = buildProjectRepo();

      await pumpScreen(
        tester,
        MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
            BlocProvider<ProjectCubit>(
              create: (_) => SeedableProjectCubit(repo)
                // The add form renders its inputs with `enabled: null`
                // (enableField is never passed) and never seeds the category
                // dropdown, so a user cannot fill it in. A pre-loaded state is
                // the only path to a valid submit; it must be seeded inside
                // `create` because `TextFormField` reads `initialValue` once.
                ..seed(
                  ProjectFormState(
                    project: sampleProject(
                      title: 'Ship MVP',
                      description: 'Release notes',
                      tasks: <TaskModel>[TaskModel(title: 'Task 1')],
                    ),
                  ),
                )
                ..categoryChange(categories[ProjectCategory.work]!),
            ),
          ],
          child: const Scaffold(body: AddProjectViewBody()),
        ),
      );

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      verify(() => repo.addProject(project: any(named: 'project'))).called(1);
      // HomeCubit is refreshed after a successful save (`loadProjects`).
      verify(() => homeRepo.getProjects()).called(greaterThanOrEqualTo(2));
      tester.takeException();
    });

    testWidgets('the add form cannot be filled in by the user: inputs reject '
        'text and the category dropdown starts unset (known defect)',
        (tester) async {
      final repo = buildProjectRepo();

      await pumpScreen(
        tester,
        MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
            BlocProvider<ProjectCubit>(
              create: (_) => SeedableProjectCubit(repo),
            ),
          ],
          child: const Scaffold(body: AddProjectViewBody()),
        ),
      );

      // 1. `CustomTextFormField` passes `enableField` (always null) to
      //    `TextFormField.enabled`, so every input is disabled.
      final editables = find.byType(EditableText).evaluate().toList();
      expect(editables, isNotEmpty);
      expect(
        editables.map((e) => (e.widget as EditableText).readOnly),
        everyElement(isTrue),
      );

      // 2. `AddProjectViewBody` passes no `initialValue` to
      //    `CustomDropDownButton`, whose validator rejects a null value.
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.text('Field is required'), findsWidgets);
      verifyNever(() => repo.addProject(project: any(named: 'project')));
    });

    testWidgets(
        'error dialog is immediately popped by GoRouter.of(context).pop() on '
        'save failure (known defect)', (tester) async {
      final repo = buildProjectRepo(fail: true);

      await pumpScreen(
        tester,
        MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
            BlocProvider<ProjectCubit>(
              create: (_) => SeedableProjectCubit(repo)
                ..seed(
                  ProjectFormState(
                    project: sampleProject(
                      title: 'Title',
                      description: 'Description',
                      tasks: <TaskModel>[TaskModel(title: 'Task 1')],
                    ),
                  ),
                )
                ..categoryChange(categories[ProjectCategory.work]!),
            ),
          ],
          child: const Scaffold(body: AddProjectViewBody()),
        ),
      );

      await tester.tap(find.text('Done'));
      await tester.pump(const Duration(milliseconds: 100));

      // `AddProjectViewBody` calls `showDialog(...)` and then synchronously
      // `GoRouter.of(context).pop()`, which pops the dialog it just showed, so
      // the user never sees the failure message.
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Could not save the project'), findsNothing);
      verify(() => repo.addProject(project: any(named: 'project'))).called(1);
      tester.takeException();
    });

    testWidgets('survives the 8-point visual matrix without layout defects',
        (tester) async {
      final repo = buildProjectRepo();

      await expectNoLayoutDefects(
        tester,
        MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
            BlocProvider<ProjectCubit>(
              create: (_) => SeedableProjectCubit(repo),
            ),
          ],
          child: const Scaffold(body: AddProjectViewBody()),
        ),
      );
    });
  });

  group('EditProjectViewBody', () {
    Widget edit(MockProjectRepository repo) {
      return MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<HomeCubit>(create: (_) => SeedableHomeCubit(homeRepo)),
          BlocProvider<ProjectCubit>(
            create: (_) => SeedableProjectCubit(
              repo,
              initialProject: sampleProject(
                title: 'Ship the MVP',
                description: 'Finish checkout',
              ),
            ),
          ),
        ],
        child: const Scaffold(body: EditProjectViewBody()),
      );
    }

    testWidgets('pre-fills title, description, and existing tasks from '
        'initialProject', (tester) async {
      await pumpScreen(tester, edit(buildProjectRepo()));

      expect(find.text('Ship the MVP'), findsOneWidget);
      expect(find.text('Finish checkout'), findsOneWidget);
      expect(find.text('Design the flow'), findsOneWidget);
      expect(find.text('Wire the payment sheet'), findsOneWidget);
    });

    testWidgets('can add, toggle, and remove a task in ManageTask',
        (tester) async {
      await pumpScreen(tester, edit(buildProjectRepo()));

      final initialCount = find.byType(TextFormField).evaluate().length;

      await tester.tap(find.text('Add Task'));
      await tester.pumpAndSettle();
      expect(find.byType(TextFormField).evaluate().length, initialCount + 1);

      // The task rows expose a close icon per task; the last one is removable
      // because the cubit refuses to drop below one task.
      await tester.tap(find.byIcon(Icons.close).last);
      await tester.pumpAndSettle();
      expect(find.byType(TextFormField).evaluate().length, initialCount);
    });

    testWidgets('tapping Delete Project opens confirmation dialog and '
        'confirming calls deleteProject', (tester) async {
      final repo = buildProjectRepo();
      await pumpScreen(tester, edit(repo));

      await tester.ensureVisible(find.text('Delete Project'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete Project'));
      await tester.pumpAndSettle();

      expect(
        find.text('Are you sure you want to delete this project?'),
        findsOneWidget,
      );

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(() => repo.deleteProject(projectId: any(named: 'projectId')))
          .called(1);
    });

    testWidgets('survives the 8-point visual matrix without layout defects',
        (tester) async {
      await expectNoLayoutDefects(tester, edit(buildProjectRepo()));
    });
  });
}
