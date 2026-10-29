import 'package:dartz/dartz.dart';
import 'package:flowi/core/models/project_model.dart';
import 'package:flowi/core/models/project_status.dart';
import 'package:flowi/features/ai_assistant/data/model/chat_message.dart';
import 'package:flowi/features/ai_assistant/presentation/manager/cubit/ai_assistant_cubit.dart';
import 'package:flowi/features/home/data/repository/home_repo.dart';
import 'package:flowi/features/home/presentation/manager/cubit/home_cubit.dart';
import 'package:flowi/features/project/data/project_repository/project_repo.dart';
import 'package:flowi/features/project/presentation/manager/cubit/project_cubit.dart';
import 'package:flowi/features/settings/presentation/manager/cubit/setting_cubit.dart';
import 'package:mocktail/mocktail.dart';

import 'widget_test_harness.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockHomeRepo extends Mock implements HomeRepo {}

class MockProjectRepository extends Mock implements ProjectRepository {}

// ---------------------------------------------------------------------------
// Cubits with an explicit seed hook
//
// The cubits fetch their data in the constructor, so a state can only be
// pinned down by emitting after construction.
// ---------------------------------------------------------------------------

class SeedableHomeCubit extends HomeCubit {
  SeedableHomeCubit(super.homeRepo);

  void seed(HomeState state) => emit(state);
}

class SeedableSettingCubit extends SettingCubit {}

class SeedableAiCubit extends AiAssistantCubit {
  void seed(AiAssistantState state) => emit(state);
}

class SeedableProjectCubit extends ProjectCubit {
  SeedableProjectCubit(
    super.projectRepo, {
    super.initialProject,
  });

  void seed(ProjectState state) => emit(state);
}

// ---------------------------------------------------------------------------
// Registration + default stubs
// ---------------------------------------------------------------------------

void registerTestFallbacks() {
  registerFallbackValue(sampleProject());
  registerFallbackValue(DateTime(2026));
  registerFallbackValue(TaskStatus.inProgress);
}

/// Stubs every [HomeRepo] member so no test trips over an unstubbed call.
MockHomeRepo buildHomeRepo({
  List<ProjectModel> projects = const <ProjectModel>[],
  List<ProjectModel>? inProgress,
  String overallProgress = '0',
  String projectProgress = '0%',
  bool failGetProjects = false,
}) {
  final repo = MockHomeRepo();
  final inProgressProjects = inProgress ?? const <ProjectModel>[];

  when(() => repo.getProjects()).thenReturn(
    failGetProjects ? const Left('Failed to get projects') : Right(projects),
  );
  when(() => repo.statusFilter(any())).thenReturn(Right(inProgressProjects));
  when(() => repo.dateFilter(any())).thenReturn(Right(const <ProjectModel>[]));
  // Mirrors HomeRepoImpl: the calendar range is derived from the projects, so
  // with no projects there is no range at all.
  when(() => repo.dateTimeList()).thenReturn(
    projects.isEmpty
        ? const <DateTime>[]
        : <DateTime>[DateTime(2026, 10, 20), DateTime(2026, 10, 21)],
  );
  when(() => repo.getOverallProgress()).thenReturn(overallProgress);
  when(() => repo.progressValue(any())).thenReturn(projectProgress);
  return repo;
}

/// Project repository whose writes succeed unless a failure is requested.
MockProjectRepository buildProjectRepo({bool fail = false}) {
  final repo = MockProjectRepository();
  when(() => repo.addProject(project: any(named: 'project'))).thenAnswer(
    (_) async =>
        fail ? const Left('Could not save the project') : const Right(null),
  );
  when(
    () => repo.editProject(updatedProject: any(named: 'updatedProject')),
  ).thenAnswer(
    (_) async =>
        fail ? const Left('Could not save the project') : const Right(null),
  );
  when(() => repo.deleteProject(projectId: any(named: 'projectId'))).thenAnswer(
    (_) async =>
        fail ? const Left('Could not delete the project') : const Right(null),
  );
  return repo;
}

// ---------------------------------------------------------------------------
// Conversation fixtures
// ---------------------------------------------------------------------------

List<ChatMessage> conversation({
  String assistantText = 'Here is what I found in your projects.',
  bool streaming = false,
}) {
  return <ChatMessage>[
    ChatMessage(
      role: ChatRole.user,
      text: 'How am I doing this week?',
      timestamp: DateTime(2026, 10, 20, 9),
    ),
    ChatMessage(
      role: ChatRole.assistant,
      text: assistantText,
      isStreaming: streaming,
      timestamp: DateTime(2026, 10, 20, 9, 1),
    ),
  ];
}
