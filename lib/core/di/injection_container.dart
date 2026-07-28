import 'package:get_it/get_it.dart';

import '../api/API.dart';
import '../api/IApi.dart';
import '../utils/StorageService.dart';
import '../utils/UserService.dart';
import '../utils/media_service.dart';
import '../utils/media_service_impl.dart';

// AUTH
import '../../features/auth/data/remote/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/update_avatar_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// COUNSELOR
import '../../features/counselor/data/repositories/counselor_repository_impl.dart';
import '../../features/counselor/domain/repositories/counselor_repository.dart';
import '../../features/counselor/domain/usecases/assign_task_usecase.dart';
import '../../features/counselor/domain/usecases/create_group_usecase.dart';
import '../../features/counselor/domain/usecases/get_consultations_usecase.dart';
import '../../features/counselor/domain/usecases/get_counselor_profile_usecase.dart';
import '../../features/counselor/domain/usecases/get_counselor_stats_usecase.dart';
import '../../features/counselor/domain/usecases/get_counselor_students_usecase.dart';
import '../../features/counselor/domain/usecases/get_group_details_usecase.dart';
import '../../features/counselor/domain/usecases/get_groups_usecase.dart';
import '../../features/counselor/domain/usecases/get_student_file_usecase.dart';
import '../../features/counselor/domain/usecases/register_session_usecase.dart';
import '../../features/counselor/domain/usecases/update_group_usecase.dart';
import '../../features/counselor/domain/usecases/get_counselor_appointments_usecase.dart';
import '../../features/counselor/domain/usecases/get_group_students_usecase.dart';
import '../../features/counselor/domain/usecases/schedule_counselor_appointment_usecase.dart';
import '../../features/counselor/presentation/providers/counselor_provider.dart';

// ADMIN
import '../../features/admin/data/repositories/admin_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_repository.dart';
import '../../features/admin/domain/usecases/get_admin_stats_usecase.dart';
import '../../features/admin/domain/usecases/manage_users_usecase.dart';
import '../../features/admin/presentation/providers/admin_provider.dart';

// UNIVERSITY
import '../../features/university/data/repositories/university_repository_impl.dart';
import '../../features/university/domain/repositories/university_repository.dart';
import '../../features/university/domain/usecases/get_university_profile_usecase.dart';
import '../../features/university/domain/usecases/get_university_careers_usecase.dart';
import '../../features/university/domain/usecases/add_university_career_usecase.dart';
import '../../features/university/domain/usecases/delete_university_career_usecase.dart';
import '../../features/university/domain/usecases/get_university_events_usecase.dart';
import '../../features/university/domain/usecases/create_university_event_usecase.dart';
import '../../features/university/domain/usecases/update_university_event_usecase.dart';
import '../../features/university/domain/usecases/delete_university_event_usecase.dart';
import '../../features/university/domain/usecases/upload_event_image_usecase.dart';
import '../../features/university/domain/usecases/get_university_announcements_usecase.dart';
import '../../features/university/domain/usecases/create_university_announcement_usecase.dart';
import '../../features/university/domain/usecases/update_university_announcement_usecase.dart';
import '../../features/university/domain/usecases/delete_university_announcement_usecase.dart';
import '../../features/university/domain/usecases/get_university_alumni_usecase.dart';
import '../../features/university/domain/usecases/create_university_alumni_usecase.dart';
import '../../features/university/domain/usecases/update_university_alumni_usecase.dart';
import '../../features/university/domain/usecases/delete_university_alumni_usecase.dart';
import '../../features/university/domain/usecases/get_compatible_universities_usecase.dart' as uni_usecase;
import '../../features/university/presentation/providers/university_profile_provider.dart';
import '../../features/university/presentation/providers/university_careers_provider.dart';
import '../../features/university/presentation/providers/university_events_provider.dart';
import '../../features/university/presentation/providers/university_announcements_provider.dart';
import '../../features/university/presentation/providers/university_alumni_provider.dart';
import '../../features/university/presentation/providers/universities_provider.dart';

// STUDENT
import '../../features/student/data/repositories/student_repository_impl.dart';
import '../../features/student/domain/repositories/student_repository.dart';
import '../../features/student/domain/usecases/get_student_profile_usecase.dart';
import '../../features/student/domain/usecases/get_vocational_results_usecase.dart';
import '../../features/student/domain/usecases/update_student_profile_usecase.dart';
import '../../features/student/domain/usecases/get_student_appointments_usecase.dart';
import '../../features/student/domain/usecases/schedule_appointment_usecase.dart';
import '../../features/student/domain/usecases/get_events_usecase.dart';
import '../../features/student/presentation/providers/student_home_provider.dart';
import '../../features/student/presentation/providers/student_profile_provider.dart';
import '../../features/student/presentation/providers/student_results_provider.dart';

// ALUMNI
import '../../features/alumni/data/repositories/alumni_repository_impl.dart';
import '../../features/alumni/domain/repositories/alumni_repository.dart';
import '../../features/alumni/domain/usecases/get_alumni_profile_usecase.dart';
import '../../features/alumni/domain/usecases/update_alumni_profile_usecase.dart';
import '../../features/alumni/domain/usecases/manage_stories_usecase.dart';
import '../../features/alumni/presentation/providers/alumni_home_provider.dart';
import '../../features/alumni/presentation/providers/alumni_provider.dart';
import '../../features/alumni/presentation/providers/success_stories_provider.dart';
import '../../features/alumni/presentation/providers/alumni_profile_form_provider.dart';
import '../../features/alumni/presentation/providers/write_story_provider.dart';

// VOCATIONAL GAMES
import '../../features/vocational_games/data/repositories/vocational_games_repository_impl.dart';
import '../../features/vocational_games/domain/repositories/vocational_games_repository.dart';
import '../../features/vocational_games/domain/usecases/finish_game_usecase.dart';
import '../../features/vocational_games/domain/usecases/get_available_games_usecase.dart';
import '../../features/vocational_games/domain/usecases/get_game_questions_usecase.dart';
import '../../features/vocational_games/domain/usecases/send_game_answer_usecase.dart';
import '../../features/vocational_games/domain/usecases/start_game_usecase.dart';
import '../../features/vocational_games/domain/usecases/submit_game_result_usecase.dart';
import '../../features/vocational_games/presentation/providers/games_provider.dart';

// CHAT (Standard)
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/chat_usecases.dart';
import '../../features/chat/presentation/providers/chat_provider.dart';

// CHATBOT
import '../../features/chatbot/data/datasources/remote/chatbot_remote_datasource.dart';
import '../../features/chatbot/data/repositories/chatbot_repository_impl.dart';
import '../../features/chatbot/domain/repositories/chatbot_repository.dart';
import '../../features/chatbot/domain/usecases/send_message_usecase.dart';
import '../../features/chatbot/presentation/providers/chat_provider.dart' as chatbot_prov;

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // ==========================================================
  // CORE
  // ==========================================================
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<UserService>(() => UserService(sl<StorageService>()));
  sl.registerLazySingleton<IApi>(() => API());
  sl.registerLazySingleton<MediaService>(() => MediaServiceImpl());

  // ==========================================================
  // AUTH
  // ==========================================================
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(api: sl<IApi>(), userService: sl<UserService>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()));
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<UpdateAvatarUseCase>(() => UpdateAvatarUseCase(sl<AuthRepository>()));

  sl.registerFactory<AuthProvider>(() => AuthProvider(
    loginUseCase: sl<LoginUseCase>(),
    registerUseCase: sl<RegisterUseCase>(),
    logoutUseCase: sl<LogoutUseCase>(),
    updateAvatarUseCase: sl<UpdateAvatarUseCase>(),
    api: sl<IApi>(),
    userService: sl<UserService>(),
    mediaService: sl<MediaService>(),
  ));

  // ==========================================================
  // COUNSELOR
  // ==========================================================
  sl.registerLazySingleton<CounselorRepository>(() => CounselorRepositoryImpl(api: sl<IApi>(), userService: sl<UserService>()));
  sl.registerLazySingleton<GetGroupsUseCase>(() => GetGroupsUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<CreateGroupUseCase>(() => CreateGroupUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<UpdateGroupUseCase>(() => UpdateGroupUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<GetGroupDetailsUseCase>(() => GetGroupDetailsUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<AssignTaskUseCase>(() => AssignTaskUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<RegisterSessionUseCase>(() => RegisterSessionUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<GetConsultationsUseCase>(() => GetConsultationsUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<GetCounselorProfileUseCase>(() => GetCounselorProfileUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<GetCounselorStatsUseCase>(() => GetCounselorStatsUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<GetCounselorStudentsUseCase>(() => GetCounselorStudentsUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<GetStudentFileUseCase>(() => GetStudentFileUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<GetCounselorAppointmentsUseCase>(() => GetCounselorAppointmentsUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<GetGroupStudentsUseCase>(() => GetGroupStudentsUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<ScheduleCounselorAppointmentUseCase>(() => ScheduleCounselorAppointmentUseCase(sl<CounselorRepository>()));

  sl.registerFactory<CounselorProvider>(() => CounselorProvider(
    getGroupsUseCase: sl<GetGroupsUseCase>(),
    createGroupUseCase: sl<CreateGroupUseCase>(),
    updateGroupUseCase: sl<UpdateGroupUseCase>(),
    getGroupDetailsUseCase: sl<GetGroupDetailsUseCase>(),
    registerSessionUseCase: sl<RegisterSessionUseCase>(),
    assignTaskUseCase: sl<AssignTaskUseCase>(),
    getConsultationsUseCase: sl<GetConsultationsUseCase>(),
    getCounselorProfileUseCase: sl<GetCounselorProfileUseCase>(),
    getCounselorStatsUseCase: sl<GetCounselorStatsUseCase>(),
    getStudentsUseCase: sl<GetCounselorStudentsUseCase>(),
    getStudentFileUseCase: sl<GetStudentFileUseCase>(),
    getAppointmentsUseCase: sl<GetCounselorAppointmentsUseCase>(),
    getGroupStudentsUseCase: sl<GetGroupStudentsUseCase>(),
    scheduleAppointmentUseCase: sl<ScheduleCounselorAppointmentUseCase>(),
    repository: sl<CounselorRepository>(),
  ));

  // ==========================================================
  // ADMIN
  // ==========================================================
  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(api: sl<IApi>(), userService: sl<UserService>()));
  sl.registerLazySingleton<GetAdminStatsUseCase>(() => GetAdminStatsUseCase(sl<AdminRepository>()));
  sl.registerLazySingleton<ManageUsersUseCase>(() => ManageUsersUseCase(sl<AdminRepository>()));

  sl.registerFactory<AdminProvider>(() => AdminProvider(
    getStatsUseCase: sl<GetAdminStatsUseCase>(),
    manageUsersUseCase: sl<ManageUsersUseCase>(),
  ));

  // ==========================================================
  // UNIVERSITY
  // ==========================================================
  sl.registerLazySingleton<UniversityRepository>(() => UniversityRepositoryImpl(api: sl<IApi>(), userService: sl<UserService>()));
  
  // UseCases
  sl.registerLazySingleton<GetUniversityProfileUseCase>(() => GetUniversityProfileUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<GetUniversityCareersUseCase>(() => GetUniversityCareersUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<AddUniversityCareerUseCase>(() => AddUniversityCareerUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<DeleteUniversityCareerUseCase>(() => DeleteUniversityCareerUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<GetUniversityEventsUseCase>(() => GetUniversityEventsUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<CreateUniversityEventUseCase>(() => CreateUniversityEventUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<UpdateUniversityEventUseCase>(() => UpdateUniversityEventUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<DeleteUniversityEventUseCase>(() => DeleteUniversityEventUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<UploadEventImageUseCase>(() => UploadEventImageUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<GetUniversityAnnouncementsUseCase>(() => GetUniversityAnnouncementsUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<CreateUniversityAnnouncementUseCase>(() => CreateUniversityAnnouncementUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<UpdateUniversityAnnouncementUseCase>(() => UpdateUniversityAnnouncementUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<DeleteUniversityAnnouncementUseCase>(() => DeleteUniversityAnnouncementUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<GetUniversityAlumniUseCase>(() => GetUniversityAlumniUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<CreateUniversityAlumniUseCase>(() => CreateUniversityAlumniUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<UpdateUniversityAlumniUseCase>(() => UpdateUniversityAlumniUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<DeleteUniversityAlumniUseCase>(() => DeleteUniversityAlumniUseCase(sl<UniversityRepository>()));
  sl.registerLazySingleton<uni_usecase.GetCompatibleUniversitiesUseCase>(() => uni_usecase.GetCompatibleUniversitiesUseCase(sl<UniversityRepository>()));

  // Providers
  sl.registerFactory<UniversityProfileProvider>(() => UniversityProfileProvider(
    getProfileUseCase: sl<GetUniversityProfileUseCase>(),
  ));
  sl.registerFactory<UniversityCareersProvider>(() => UniversityCareersProvider(
    getCareersUseCase: sl<GetUniversityCareersUseCase>(),
    addCareerUseCase: sl<AddUniversityCareerUseCase>(),
    deleteCareerUseCase: sl<DeleteUniversityCareerUseCase>(),
    getProfileUseCase: sl<GetUniversityProfileUseCase>(),
  ));
  sl.registerFactory<UniversityEventsProvider>(() => UniversityEventsProvider(
    getEventsUseCase: sl<GetUniversityEventsUseCase>(),
    createEventUseCase: sl<CreateUniversityEventUseCase>(),
    updateEventUseCase: sl<UpdateUniversityEventUseCase>(),
    deleteEventUseCase: sl<DeleteUniversityEventUseCase>(),
    uploadImageUseCase: sl<UploadEventImageUseCase>(),
  ));
  sl.registerFactory<UniversityAnnouncementsProvider>(() => UniversityAnnouncementsProvider(
    getAnnouncementsUseCase: sl<GetUniversityAnnouncementsUseCase>(),
    createAnnouncementUseCase: sl<CreateUniversityAnnouncementUseCase>(),
    updateAnnouncementUseCase: sl<UpdateUniversityAnnouncementUseCase>(),
    deleteAnnouncementUseCase: sl<DeleteUniversityAnnouncementUseCase>(),
  ));
  sl.registerFactory<UniversityAlumniProvider>(() => UniversityAlumniProvider(
    getAlumniUseCase: sl<GetUniversityAlumniUseCase>(),
    createAlumniUseCase: sl<CreateUniversityAlumniUseCase>(),
    updateAlumniUseCase: sl<UpdateUniversityAlumniUseCase>(),
    deleteAlumniUseCase: sl<DeleteUniversityAlumniUseCase>(),
    api: sl<IApi>(),
    userService: sl<UserService>(),
  ));
  sl.registerFactory<UniversitiesProvider>(() => UniversitiesProvider(
    getCompatibleUniversitiesUseCase: sl<uni_usecase.GetCompatibleUniversitiesUseCase>(),
  ));

  // ==========================================================
  // VOCATIONAL GAMES
  // ==========================================================
  sl.registerLazySingleton<VocationalGamesRepository>(() => VocationalGamesRepositoryImpl(api: sl<IApi>(), userService: sl<UserService>()));
  sl.registerLazySingleton<GetAvailableGamesUseCase>(() => GetAvailableGamesUseCase(sl<VocationalGamesRepository>()));
  sl.registerLazySingleton<StartGameUseCase>(() => StartGameUseCase(sl<VocationalGamesRepository>()));
  sl.registerLazySingleton<SendGameAnswerUseCase>(() => SendGameAnswerUseCase(sl<VocationalGamesRepository>()));
  sl.registerLazySingleton<FinishGameUseCase>(() => FinishGameUseCase(sl<VocationalGamesRepository>()));
  sl.registerLazySingleton<SubmitGameResultUseCase>(() => SubmitGameResultUseCase(sl<VocationalGamesRepository>()));
  sl.registerLazySingleton<GetGameQuestionsUseCase>(() => GetGameQuestionsUseCase(sl<VocationalGamesRepository>()));

  sl.registerFactory<GamesProvider>(() => GamesProvider(
    getGamesUseCase: sl<GetAvailableGamesUseCase>(),
    getQuestionsUseCase: sl<GetGameQuestionsUseCase>(),
    startGameUseCase: sl<StartGameUseCase>(),
    sendAnswerUseCase: sl<SendGameAnswerUseCase>(),
    finishGameUseCase: sl<FinishGameUseCase>(),
  ));

  // ==========================================================
  // STUDENT
  // ==========================================================
  sl.registerLazySingleton<StudentRepository>(() => StudentRepositoryImpl(api: sl<IApi>(), userService: sl<UserService>()));
  sl.registerLazySingleton<GetStudentProfileUseCase>(() => GetStudentProfileUseCase(sl<StudentRepository>()));
  sl.registerLazySingleton<UpdateStudentProfileUseCase>(() => UpdateStudentProfileUseCase(sl<StudentRepository>()));
  sl.registerLazySingleton<GetVocationalResultsUseCase>(() => GetVocationalResultsUseCase(sl<StudentRepository>()));
  sl.registerLazySingleton<GetEventsUseCase>(() => GetEventsUseCase(sl<StudentRepository>()));

  sl.registerLazySingleton<GetStudentAppointmentsUseCase>(() => GetStudentAppointmentsUseCase(sl<CounselorRepository>()));
  sl.registerLazySingleton<ScheduleAppointmentUseCase>(() => ScheduleAppointmentUseCase(sl<CounselorRepository>()));

  sl.registerFactory<StudentHomeProvider>(() => StudentHomeProvider(
    getProfileUseCase: sl<GetStudentProfileUseCase>(),
    getResultsUseCase: sl<GetVocationalResultsUseCase>(),
    getGamesUseCase: sl<GetAvailableGamesUseCase>(),
    userService: sl<UserService>(),
    api: sl<IApi>(),
    getAppointmentsUseCase: sl<GetStudentAppointmentsUseCase>(),
    scheduleAppointmentUseCase: sl<ScheduleAppointmentUseCase>(),
    getEventsUseCase: sl<GetEventsUseCase>(),
  ));
  sl.registerFactory<StudentProfileProvider>(() => StudentProfileProvider(getProfileUseCase: sl<GetStudentProfileUseCase>(), updateProfileUseCase: sl<UpdateStudentProfileUseCase>()));
  sl.registerFactory<StudentResultsProvider>(() => StudentResultsProvider(getResultsUseCase: sl<GetVocationalResultsUseCase>()));

  // ==========================================================
  // ALUMNI
  // ==========================================================
  sl.registerLazySingleton<AlumniRepository>(() => AlumniRepositoryImpl(api: sl<IApi>(), userService: sl<UserService>()));
  
  sl.registerLazySingleton<GetAlumniProfileUseCase>(() => GetAlumniProfileUseCase(sl<AlumniRepository>()));
  sl.registerLazySingleton<UpdateAlumniProfileUseCase>(() => UpdateAlumniProfileUseCase(sl<AlumniRepository>()));
  sl.registerLazySingleton<ManageStoriesUseCase>(() => ManageStoriesUseCase(sl<AlumniRepository>()));

  sl.registerFactory<AlumniHomeProvider>(() => AlumniHomeProvider(
    getProfileUseCase: sl<GetAlumniProfileUseCase>(),
    manageStoriesUseCase: sl<ManageStoriesUseCase>(),
  ));
  sl.registerFactory<AlumniProvider>(() => AlumniProvider(
    repository: sl<AlumniRepository>(),
  ));
  sl.registerFactory<SuccessStoriesProvider>(() => SuccessStoriesProvider(
    manageStoriesUseCase: sl<ManageStoriesUseCase>(),
  ));
  sl.registerFactory<AlumniProfileFormProvider>(() => AlumniProfileFormProvider(
    getProfileUseCase: sl<GetAlumniProfileUseCase>(),
    updateProfileUseCase: sl<UpdateAlumniProfileUseCase>(),
  ));
  sl.registerFactory<WriteStoryProvider>(() => WriteStoryProvider(
    getProfileUseCase: sl<GetAlumniProfileUseCase>(),
    manageStoriesUseCase: sl<ManageStoriesUseCase>(),
  ));

  // ==========================================================
  // CHAT
  // ==========================================================
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(api: sl<IApi>(), userService: sl<UserService>()));
  sl.registerLazySingleton<GetChatContactsUseCase>(() => GetChatContactsUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton<GetChatHistoryUseCase>(() => GetChatHistoryUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton<SendChatMessageUseCase>(() => SendChatMessageUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton<ConnectChatSocketUseCase>(() => ConnectChatSocketUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton<DisconnectChatSocketUseCase>(() => DisconnectChatSocketUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton<MarkMessagesAsReadUseCase>(() => MarkMessagesAsReadUseCase(sl<ChatRepository>()));

  sl.registerFactory<ChatProvider>(() => ChatProvider(repository: sl<ChatRepository>()));

  // ==========================================================
  // CHATBOT
  // ==========================================================
  sl.registerLazySingleton<ChatbotRemoteDataSource>(() => ChatbotRemoteDataSourceImpl());
  sl.registerLazySingleton<ChatbotRepository>(() => ChatbotRepositoryImpl(remoteDataSource: sl<ChatbotRemoteDataSource>(), userService: sl<UserService>()));
  sl.registerLazySingleton<SendMessageUseCase>(() => SendMessageUseCase(sl<ChatbotRepository>()));

  sl.registerFactory<chatbot_prov.ChatbotProvider>(() => chatbot_prov.ChatbotProvider(
    sendMessageUseCase: sl<SendMessageUseCase>(),
  ));
}
