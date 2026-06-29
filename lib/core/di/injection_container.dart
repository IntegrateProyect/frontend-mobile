import 'package:get_it/get_it.dart';

import '../api/IApi.dart';
import '../api/API.dart';
import '../utils/StorageService.dart';
import '../utils/UserService.dart';

// Auth
import '../../features/auth/data/remote/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// Counselor
import '../../features/counselor/data/repositories/counselor_repository_impl.dart';
import '../../features/counselor/domain/repositories/counselor_repository.dart';
import '../../features/counselor/domain/usecases/get_groups_usecase.dart';
import '../../features/counselor/domain/usecases/create_group_usecase.dart';
import '../../features/counselor/domain/usecases/assign_task_usecase.dart';
import '../../features/counselor/domain/usecases/register_session_usecase.dart';
import '../../features/counselor/domain/usecases/get_consultations_usecase.dart';
import '../../features/counselor/domain/usecases/get_counselor_profile_usecase.dart';
import '../../features/counselor/domain/usecases/get_counselor_stats_usecase.dart';
import '../../features/counselor/domain/usecases/get_counselor_students_usecase.dart';
import '../../features/counselor/presentation/providers/counselor_provider.dart';

// Admin
import '../../features/admin/data/repositories/admin_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_repository.dart';
import '../../features/admin/domain/usecases/get_admin_stats_usecase.dart';
import '../../features/admin/domain/usecases/manage_users_usecase.dart';
import '../../features/admin/presentation/providers/admin_provider.dart';

// Student
import '../../features/student/data/repositories/student_repository_impl.dart';
import '../../features/student/domain/repositories/student_repository.dart';
import '../../features/student/domain/usecases/get_student_profile_usecase.dart';
import '../../features/student/domain/usecases/update_student_profile_usecase.dart';
import '../../features/student/domain/usecases/get_vocational_results_usecase.dart';
import '../../features/student/presentation/providers/student_home_provider.dart';
import '../../features/student/presentation/providers/student_profile_provider.dart';
import '../../features/student/presentation/providers/student_results_provider.dart';

// Vocational Games
import '../../features/vocational_games/data/repositories/vocational_games_repository_impl.dart';
import '../../features/vocational_games/domain/repositories/vocational_games_repository.dart';
import '../../features/vocational_games/domain/usecases/get_available_games_usecase.dart';
import '../../features/vocational_games/domain/usecases/start_game_usecase.dart';
import '../../features/vocational_games/domain/usecases/send_game_answer_usecase.dart';
import '../../features/vocational_games/domain/usecases/finish_game_usecase.dart';
import '../../features/vocational_games/domain/usecases/submit_game_result_usecase.dart';
import '../../features/vocational_games/domain/usecases/get_game_questions_usecase.dart';
import '../../features/vocational_games/presentation/providers/games_provider.dart';

// Chat
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/chat_usecases.dart';
import '../../features/chat/presentation/providers/chat_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- CORE ---
  sl.registerLazySingleton<StorageService>(() => StorageService());

  sl.registerLazySingleton<UserService>(
        () => UserService(sl<StorageService>()),
  );

  sl.registerLazySingleton<IApi>(() => API());

  // --- AUTH ---
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () =>
        AuthRemoteDataSourceImpl(
          api: sl<IApi>(),
          userService: sl<UserService>(),
        ),
  );

  sl.registerLazySingleton<AuthRepository>(
        () =>
        AuthRepositoryImpl(
          remoteDataSource: sl<AuthRemoteDataSource>(),
        ),
  );

  sl.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<RegisterUseCase>(
        () => RegisterUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<LogoutUseCase>(
        () => LogoutUseCase(sl<AuthRepository>()),
  );

  sl.registerFactory<AuthProvider>(
        () =>
        AuthProvider(
          loginUseCase: sl<LoginUseCase>(),
          registerUseCase: sl<RegisterUseCase>(),
          logoutUseCase: sl<LogoutUseCase>(),
          api: sl<IApi>(),
          userService: sl<UserService>(),
        ),
  );

  // --- COUNSELOR ---
  sl.registerLazySingleton<CounselorRepository>(
        () =>
        CounselorRepositoryImpl(
          api: sl<IApi>(),
          userService: sl<UserService>(),
        ),
  );

  sl.registerLazySingleton<GetGroupsUseCase>(
        () => GetGroupsUseCase(sl<CounselorRepository>()),
  );

  sl.registerLazySingleton<CreateGroupUseCase>(
        () => CreateGroupUseCase(sl<CounselorRepository>()),
  );

  sl.registerLazySingleton<AssignTaskUseCase>(
        () => AssignTaskUseCase(sl<CounselorRepository>()),
  );

  sl.registerLazySingleton<RegisterSessionUseCase>(
        () => RegisterSessionUseCase(sl<CounselorRepository>()),
  );

  sl.registerLazySingleton<GetConsultationsUseCase>(
        () => GetConsultationsUseCase(sl<CounselorRepository>()),
  );

  sl.registerLazySingleton<GetCounselorProfileUseCase>(
        () => GetCounselorProfileUseCase(sl<CounselorRepository>()),
  );

  sl.registerLazySingleton<GetCounselorStatsUseCase>(
        () => GetCounselorStatsUseCase(sl<CounselorRepository>()),
  );

  sl.registerLazySingleton<GetCounselorStudentsUseCase>(
        () => GetCounselorStudentsUseCase(sl<CounselorRepository>()),
  );

  sl.registerFactory<CounselorProvider>(
        () =>
        CounselorProvider(
          getGroupsUseCase: sl<GetGroupsUseCase>(),
          createGroupUseCase: sl<CreateGroupUseCase>(),
          registerSessionUseCase: sl<RegisterSessionUseCase>(),
          assignTaskUseCase: sl<AssignTaskUseCase>(),
          getConsultationsUseCase: sl<GetConsultationsUseCase>(),
          getCounselorProfileUseCase: sl<GetCounselorProfileUseCase>(),
          getCounselorStatsUseCase: sl<GetCounselorStatsUseCase>(),
          getStudentsUseCase: sl<GetCounselorStudentsUseCase>(),
        ),
  );

  // --- ADMIN ---
  sl.registerLazySingleton<AdminRepository>(
        () =>
        AdminRepositoryImpl(
          api: sl<IApi>(),
          userService: sl<UserService>(),
        ),
  );

  sl.registerLazySingleton<GetAdminStatsUseCase>(
        () => GetAdminStatsUseCase(sl<AdminRepository>()),
  );

  sl.registerLazySingleton<ManageUsersUseCase>(
        () => ManageUsersUseCase(sl<AdminRepository>()),
  );

  sl.registerFactory<AdminProvider>(
        () =>
        AdminProvider(
          getStatsUseCase: sl<GetAdminStatsUseCase>(),
          manageUsersUseCase: sl<ManageUsersUseCase>(),
        ),
  );

  // --- VOCATIONAL GAMES ---
  sl.registerLazySingleton<VocationalGamesRepository>(
        () =>
        VocationalGamesRepositoryImpl(
          api: sl<IApi>(),
          userService: sl<UserService>(),
        ),
  );

  sl.registerLazySingleton<GetAvailableGamesUseCase>(
        () => GetAvailableGamesUseCase(sl<VocationalGamesRepository>()),
  );

  sl.registerLazySingleton<StartGameUseCase>(
        () => StartGameUseCase(sl<VocationalGamesRepository>()),
  );

  sl.registerLazySingleton<SendGameAnswerUseCase>(
        () => SendGameAnswerUseCase(sl<VocationalGamesRepository>()),
  );

  sl.registerLazySingleton<FinishGameUseCase>(
        () => FinishGameUseCase(sl<VocationalGamesRepository>()),
  );

  sl.registerLazySingleton<SubmitGameResultUseCase>(
        () => SubmitGameResultUseCase(sl<VocationalGamesRepository>()),
  );

  // --- STUDENT ---
  sl.registerLazySingleton<StudentRepository>(
        () =>
        StudentRepositoryImpl(
          api: sl<IApi>(),
          userService: sl<UserService>(),
        ),
  );

  sl.registerLazySingleton<GetStudentProfileUseCase>(
        () => GetStudentProfileUseCase(sl<StudentRepository>()),
  );

  sl.registerLazySingleton<UpdateStudentProfileUseCase>(
        () => UpdateStudentProfileUseCase(sl<StudentRepository>()),
  );

  sl.registerLazySingleton<GetVocationalResultsUseCase>(
        () => GetVocationalResultsUseCase(sl<StudentRepository>()),
  );

  sl.registerFactory<StudentHomeProvider>(
        () => StudentHomeProvider(
      getProfileUseCase: sl<GetStudentProfileUseCase>(),
      getResultsUseCase: sl<GetVocationalResultsUseCase>(),
      getGamesUseCase: sl<GetAvailableGamesUseCase>(),
      userService: sl<UserService>(),
      api: sl<IApi>(),
    ),
  );

  sl.registerFactory<StudentProfileProvider>(
        () =>
        StudentProfileProvider(
          getProfileUseCase: sl<GetStudentProfileUseCase>(),
          updateProfileUseCase: sl<UpdateStudentProfileUseCase>(),
        ),
  );

  sl.registerLazySingleton<GetGameQuestionsUseCase>(
        () => GetGameQuestionsUseCase(sl<VocationalGamesRepository>()),
  );

  sl.registerFactory<GamesProvider>(
        () =>
        GamesProvider(
          getGamesUseCase: sl<GetAvailableGamesUseCase>(),
          getQuestionsUseCase: sl<GetGameQuestionsUseCase>(),
          startGameUseCase: sl<StartGameUseCase>(),
          sendAnswerUseCase: sl<SendGameAnswerUseCase>(),
          finishGameUseCase: sl<FinishGameUseCase>(),
        ),
  );

  // --- CHAT ---
  sl.registerLazySingleton<ChatRepository>(
        () => ChatRepositoryImpl(
      api: sl<IApi>(),
      userService: sl<UserService>(),
    ),
  );

  sl.registerLazySingleton<GetChatContactsUseCase>(
        () => GetChatContactsUseCase(sl<ChatRepository>()),
  );

  sl.registerLazySingleton<GetChatHistoryUseCase>(
        () => GetChatHistoryUseCase(sl<ChatRepository>()),
  );

  sl.registerLazySingleton<SendChatMessageUseCase>(
        () => SendChatMessageUseCase(sl<ChatRepository>()),
  );

  sl.registerLazySingleton<ConnectChatSocketUseCase>(
        () => ConnectChatSocketUseCase(sl<ChatRepository>()),
  );

  sl.registerLazySingleton<DisconnectChatSocketUseCase>(
        () => DisconnectChatSocketUseCase(sl<ChatRepository>()),
  );

  sl.registerLazySingleton<MarkMessagesAsReadUseCase>(
        () => MarkMessagesAsReadUseCase(sl<ChatRepository>()),
  );

  sl.registerFactory<ChatProvider>(
        () => ChatProvider(repository: sl<ChatRepository>()),
  );
}
