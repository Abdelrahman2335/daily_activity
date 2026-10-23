import 'package:dartz/dartz.dart';
import 'package:flowi/core/data/categories.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/features/project/data/project_repository/project_repo.dart';
import 'package:flowi/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:flowi/features/project/presentation/widgets/add_project_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProjectRepository extends Mock implements ProjectRepository {}

ProjectModel _fallbackProject() => ProjectModel(
      title: '',
      description: '',
      category: categories.values.first,
      startDate: DateTime(2026),
      endDate: DateTime(2026),
      tasks: const [],
      status: TaskStatus.notStarted,
    );

void main() {
  late MockProjectRepository repo;

  setUpAll(() {
    registerFallbackValue(_fallbackProject());
  });

  setUp(() {
    repo = MockProjectRepository();
    when(() => repo.addProject(project: any(named: 'project')))
        .thenAnswer((_) async => const Right(null));
  });

  testWidgets('tapping Done on an empty form blocks the submit',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider(
            create: (_) => ProjectCubit(repo),
            child: const AddProjectViewBody(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // The UI validators fire for every empty field instead of saving.
    expect(find.text('Field is required'), findsWidgets);
    verifyNever(() => repo.addProject(project: any(named: 'project')));
  });
}
