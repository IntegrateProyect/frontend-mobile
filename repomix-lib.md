This file is a merged representation of the entire codebase, combined into a single document by Repomix.

<file_summary>
This section contains a summary of this file.

<purpose>
This file contains a packed representation of the entire repository's contents.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.
</purpose>

<file_format>
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  - File path as an attribute
  - Full contents of the file
</file_format>

<usage_guidelines>
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.
</usage_guidelines>

<notes>
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Files are sorted by Git change count (files with more changes are at the bottom)
</notes>

</file_summary>

<directory_structure>
core/
  api/
    API.dart
    IApi.dart
  components/
    MainScaffold.dart
  di/
    AppContainer.dart
    injection_container.dart
  routes/
    app_router.dart
    AppRoutes.dart
    RouteGenerator.dart
  security/
    security_service.dart
  utils/
    handlers.dart
    media_service_impl.dart
    media_service.dart
    StorageService.dart
    UserService.dart
features/
  admin/
    data/
      datasources/
        mappers/
          admin_mapper.dart
        models/
          admin_stats_model.dart
          app_user_model.dart
      repositories/
        admin_repository_impl.dart
    domain/
      entities/
        admin_stats_entity.dart
        app_user_entity.dart
      repositories/
        admin_repository.dart
      usecases/
        get_admin_stats_usecase.dart
        manage_users_usecase.dart
    presentation/
      components/
        admin_stat_card.dart
      providers/
        admin_provider.dart
      screens/
        admin_home_screen.dart
        user_management_screen.dart
  alumni/
    data/
      datasources/
        mappers/
          alumni_mapper.dart
        models/
          alumni_profile_model.dart
          success_story_model.dart
      repositories/
        alumni_repository_impl.dart
    domain/
      entities/
        alumni_profile_entity.dart
        success_story_entity.dart
      repositories/
        alumni_repository.dart
      usecases/
        get_alumni_profile_usecase.dart
        manage_stories_usecase.dart
    presentation/
      components/
        success_story_card.dart
      providers/
        alumni_provider.dart
      screens/
        alumni_home_screen.dart
        alumni_profile_screen.dart
  auth/
    data/
      datasources/
        mappers/
          auth_mapper.dart
        models/
          AuthResponse.dart
          user_model.dart
        remote/
          auth_remote_datasource.dart
      remote/
        auth_remote_datasource.dart
      repositories/
        auth_repository_impl.dart
    di/
      AuthModule.dart
    domain/
      entities/
        user_entity.dart
      repositories/
        auth_repository.dart
      usecases/
        login_usecase.dart
        logout_usecase.dart
        register_usecase.dart
        update_avatar_usecase.dart
    presentation/
      components/
        role_card.dart
        social_login_button.dart
      providers/
        auth_provider.dart
      screens/
        login_screen.dart
        register_screen.dart
        role_selection_screen.dart
  chat/
    data/
      datasources/
        models/
          chat_contact_model.dart
          chat_message_model.dart
      repositories/
        chat_repository_impl.dart
    domain/
      entities/
        chat_contact_entity.dart
        chat_message_entity.dart
      repositories/
        chat_repository.dart
      usecases/
        chat_usecases.dart
    presentation/
      providers/
        chat_provider.dart
      screens/
        chat_contacts_screen.dart
        real_chat_screen.dart
  chatbot/
    data/
      datasources/
        mappers/
          chat_mapper.dart
        models/
          chat_message_model.dart
        remote/
          chatbot_remote_datasource.dart
      repositories/
        chatbot_repository_impl.dart
    domain/
      entities/
        chat_message_entity.dart
        chat_source_entity.dart
      repositories/
        chatbot_repository.dart
      usecases/
        get_chat_history_usecase.dart
        send_message_usecase.dart
    presentation/
      components/
        chat_bubble.dart
      providers/
        chat_provider.dart
      screens/
        chat_screen.dart
        chatbot_screen.dart
  counselor/
    data/
      datasources/
        mappers/
          counselor_mapper.dart
        models/
          counselor_profile_model.dart
          student_consultation_model.dart
      repositories/
        counselor_repository_impl.dart
    domain/
      entities/
        counselor_profile_entity.dart
        student_alert_entity.dart
        student_consultation_entity.dart
        student_file_entity.dart
      repositories/
        counselor_repository.dart
      usecases/
        assign_task_usecase.dart
        create_group_usecase.dart
        get_consultations_usecase.dart
        get_counselor_profile_usecase.dart
        get_counselor_stats_usecase.dart
        get_counselor_students_usecase.dart
        get_group_details_usecase.dart
        get_groups_usecase.dart
        get_student_file_usecase.dart
        register_session_usecase.dart
        respond_consultation_usecase.dart
        update_group_usecase.dart
    presentation/
      components/
        consultation_card.dart
      providers/
        counselor_provider.dart
      screens/
        counselor_home_screen.dart
        counselor_profile_screen.dart
        student_file_screen.dart
        vocational_map_screen.dart
  onboarding/
    data/
      datasources/
        mappers/
          onboarding_mapper.dart
        models/
          onboarding_model.dart
      repositories/
        onboarding_repository_impl.dart
    domain/
      entities/
        onboarding_entity.dart
      repositories/
        onboarding_repository.dart
      usecases/
        complete_onboarding_usecase.dart
        get_onboarding_data.dart
    presentation/
      components/
        onboarding_item.dart
      providers/
        onboarding_provider.dart
      screens/
        onboarding_screen.dart
        splash_screen.dart
  student/
    data/
      datasources/
        mappers/
          student_mapper.dart
        models/
          alumni_model.dart
          career_model.dart
          event_model.dart
          scholarship_model.dart
          student_profile_model.dart
          university_model.dart
          vocational_result_model.dart
      repositories/
        student_repository_impl.dart
    domain/
      entities/
        alumni_entity.dart
        career_entity.dart
        event_entity.dart
        scholarship_entity.dart
        student_profile_entity.dart
        university_entity.dart
        vocational_result_entity.dart
      repositories/
        student_repository.dart
      usecases/
        get_compatible_universities_usecase.dart
        get_recommended_careers_usecase.dart
        get_student_profile_usecase.dart
        get_vocational_results_usecase.dart
        request_counselor_support_usecase.dart
        save_favorite_usecase.dart
        update_student_profile_usecase.dart
    presentation/
      components/
        alumni_card.dart
        career_card.dart
        event_card.dart
        scholarship_card.dart
        student_progress_card.dart
        university_card.dart
      providers/
        careers_provider.dart
        favorites_provider.dart
        student_home_provider.dart
        student_profile_provider.dart
        student_results_provider.dart
        universities_provider.dart
      screens/
        alumni_list_screen.dart
        career_compare_screen.dart
        career_detail_screen.dart
        CareersScreen.dart
        events_screen.dart
        favorites_screen.dart
        request_support_screen.dart
        scholarships_screen.dart
        student_home_screen.dart
        student_profile_screen.dart
        universities_screen.dart
        university_detail_screen.dart
        vocational_results_screen.dart
        vocational_route_screen.dart
  university/
    data/
      datasources/
        mappers/
          university_mapper.dart
        models/
          university_career_model.dart
          university_profile_model.dart
      repositories/
        university_repository_impl.dart
    domain/
      entities/
        university_career_entity.dart
        university_profile_entity.dart
      repositories/
        university_repository.dart
      usecases/
        get_university_profile_usecase.dart
        manage_careers_usecase.dart
    presentation/
      components/
        university_career_card.dart
      providers/
        university_provider.dart
      screens/
        manage_careers_screen.dart
        university_home_screen.dart
  vocational_games/
    data/
      datasources/
        mappers/
          game_mapper.dart
        models/
          game_model.dart
          game_question_model.dart
          game_result_model.dart
      repositories/
        vocational_games_repository_impl.dart
    domain/
      entities/
        game_entity.dart
        game_question_entity.dart
        game_result_entity.dart
      repositories/
        vocational_games_repository.dart
      usecases/
        finish_game_usecase.dart
        get_available_games_usecase.dart
        get_game_questions_usecase.dart
        send_game_answer_usecase.dart
        start_game_usecase.dart
        submit_game_result_usecase.dart
    presentation/
      components/
        game_card.dart
      providers/
        games_provider.dart
      screens/
        game_detail_screen.dart
        game_result_screen.dart
        games_list_screen.dart
shared/
  theme/
    theme.dart
app.dart
main.dart
</directory_structure>

<files>
This section contains the contents of the repository's files.

<file path="core/api/API.dart">
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'IApi.dart';
import '../utils/handlers.dart';

class API implements IApi {
  static final String _baseUrl =
      dotenv.env['API_URL'] ?? 'https://orientate-backend.shop/api/v1';

  Map<String, String> getHeaders([String? token]) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // --- 🔐 SERVICIO DE AUTENTICACIÓN ---

  @override
  Future<Map<String, dynamic>> checkAuthHealth() async {
    final url = '$_baseUrl/auth/health';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = '$_baseUrl/auth/login';

    try {
      ApiLogger.request('POST', url, {
        'email': email,
        'password': '[HIDDEN]',
      });

      final response = await http.post(
        Uri.parse(url),
        headers: getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final dynamic decoded = processResponse(response);
      final Map<String, dynamic> result =
          decoded is Map ? Map<String, dynamic>.from(decoded) : {};

      String? token;
      final authHeader =
          response.headers['authorization'] ?? response.headers['Authorization'];

      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        token = authHeader.substring(7);
      } else if (authHeader != null) {
        token = authHeader;
      }

      token ??=
          response.headers['x-auth-token'] ?? response.headers['X-Auth-Token'];

      if (token != null && token.isNotEmpty) {
        result['token'] = token;
      }

      ApiLogger.response('POST', url, result);
      return result;
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final url = '$_baseUrl/auth/register';

    try {
      ApiLogger.request('POST', url, data);

      final response = await http.post(
        Uri.parse(url),
        headers: getHeaders(),
        body: jsonEncode(data),
      );

      final result = processResponse(response);
      ApiLogger.response('POST', url, result);
      return result;
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getMe(String token) async {
    final url = '$_baseUrl/auth/me';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile(
    String token,
    Map<String, dynamic> data,
  ) async {
    final url = '$_baseUrl/auth/me';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode(data),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('PATCH', url, e);
      rethrow;
    }
  }

  @override
  Future<void> logout(String token) async {
    final url = '$_baseUrl/auth/logout';

    try {
      await http.post(
        Uri.parse(url),
        headers: getHeaders(token),
      );
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> recoverPassword(String email) async {
    final url = '$_baseUrl/auth/recover-password';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: getHeaders(),
        body: jsonEncode({'email': email}),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
    String token,
    String newPassword,
  ) async {
    final url = '$_baseUrl/auth/reset-password';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: getHeaders(),
        body: jsonEncode({
          'token': token,
          'newPassword': newPassword,
        }),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getRoles(String token) async {
    final url = '$_baseUrl/auth/roles';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserRole(
    String token,
    String userId,
    String roleName,
  ) async {
    final url = '$_baseUrl/auth/users/$userId/role';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode({'roleName': roleName}),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('PATCH', url, e);
      rethrow;
    }
  }

  // --- 🖼️ SERVICIO DE AVATAR (AWS S3) ---

  @override
  Future<Map<String, dynamic>> getAvatarUploadUrl(String token) async {
    final url = '$_baseUrl/auth/users/avatar-upload-url';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );
      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  @override
  Future<void> uploadImageToS3(String uploadUrl, Uint8List imageBytes) async {
    try {
      final response = await http.put(
        Uri.parse(uploadUrl),
        headers: {
          'Content-Type': 'image/jpeg',
        },
        body: imageBytes,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Error uploading image to S3: ${response.statusCode}');
      }
    } catch (e) {
      ApiLogger.error('PUT (S3)', uploadUrl, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateAvatarInBackend(String token, String avatarUrl) async {
    final url = '$_baseUrl/auth/users/avatar';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode({'avatarUrl': avatarUrl}),
      );
      return processResponse(response);
    } catch (e) {
      ApiLogger.error('PUT', url, e);
      rethrow;
    }
  }

  // --- 👑 SERVICIO DE ADMINISTRADOR ---

  @override
  Future<Map<String, dynamic>> getAdminStats(String token) async {
    final url = '$_baseUrl/admin/stats';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      return {};
    }
  }

  @override
  Future<List<dynamic>> getAllUsers(String token) async {
    final url = '$_baseUrl/admin/users';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      final dynamic result = processResponse(response);

      if (result is List) return result;
      if (result is Map && result['data'] is List) return result['data'];

      return [];
    } catch (e) {
      ApiLogger.error('GET', url, e);
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> toggleUserStatus(
    String token,
    String userId,
    bool isActive,
  ) async {
    final url = '$_baseUrl/admin/users/$userId/status';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode({'isActive': isActive}),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('PATCH', url, e);
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String token, String userId) async {
    final url = '$_baseUrl/admin/users/$userId';

    try {
      await http.delete(
        Uri.parse(url),
        headers: getHeaders(token),
      );
    } catch (e) {
      ApiLogger.error('DELETE', url, e);
      rethrow;
    }
  }

  // --- 🎓 SERVICIO DE ESTUDIANTES ---

  @override
  Future<Map<String, dynamic>> checkStudentsHealth() async {
    final url = '$_baseUrl/students/health';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createStudentProfile(
    String token,
    Map<String, dynamic> data,
  ) async {
    final url = '$_baseUrl/students/profile';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode(data),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getStudentProfile(String token) async {
    final url = '$_baseUrl/students/profile';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateStudentProfile(
    String token,
    Map<String, dynamic> data,
  ) async {
    final url = '$_baseUrl/students/profile';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode(data),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('PATCH', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> joinGroup(
    String token,
    String accessCode,
  ) async {
    final url = '$_baseUrl/students/join-group';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode({'accessCode': accessCode}),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getStudentGroups(String token) async {
    final url = '$_baseUrl/students/groups';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      final dynamic result = processResponse(response);

      if (result is List) return result;

      if (result is Map) {
        if (result['data'] is List) return result['data'];
        if (result['groups'] is List) return result['groups'];
      }

      return [];
    } catch (e) {
      ApiLogger.error('GET', url, e);
      return [];
    }
  }

  // --- 🎓 SERVICIO DE ORIENTADORES ---

  @override
  Future<Map<String, dynamic>> createGroup(
    String token,
    Map<String, dynamic> data,
  ) async {
    final url = '$_baseUrl/counselors/groups';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode(data),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getGroups(String token) async {
    final url = '$_baseUrl/counselors/groups';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      final dynamic result = processResponse(response);

      if (result is List) return result;

      if (result is Map) {
        if (result['data'] is List) return result['data'];
        if (result['groups'] is List) return result['groups'];
      }

      return [];
    } catch (e) {
      ApiLogger.error('GET', url, e);
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getGroupDetail(
    String token,
    String groupId,
  ) async {
    final url = '$_baseUrl/counselors/groups/$groupId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateGroup(
    String token,
    String groupId,
    Map<String, dynamic> data,
  ) async {
    final url = '$_baseUrl/counselors/groups/$groupId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode(data),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('PUT', url, e);
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getGroupStudents(
    String token,
    String groupId,
  ) async {
    final url = '$_baseUrl/counselors/groups/$groupId/students';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      final dynamic result = processResponse(response);

      if (result is List) return result;

      if (result is Map) {
        if (result['data'] is List) return result['data'];
        if (result['students'] is List) return result['students'];
      }

      return [];
    } catch (e) {
      ApiLogger.error('GET', url, e);
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getStudentFile(
    String token,
    String studentId,
  ) async {
    final url = '$_baseUrl/counselors/students/$studentId/file';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> registerSession(
    String token,
    String studentId,
    Map<String, dynamic> data,
  ) async {
    final url = '$_baseUrl/counselors/students/$studentId/sessions';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode(data),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createTask(
    String token,
    Map<String, dynamic> data,
  ) async {
    final url = '$_baseUrl/counselors/tasks';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode(data),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getCounselorStudents(String token) async {
    final url = '$_baseUrl/counselors/students';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      final dynamic result = processResponse(response);

      if (result is List) return result;

      if (result is Map) {
        if (result['data'] is List) return result['data'];
        if (result['students'] is List) return result['students'];
      }

      return [];
    } catch (e) {
      ApiLogger.error('GET', url, e);
      return [];
    }
  }

  @override
  Future<List<dynamic>> getConsultations(String token) async {
    final url = '$_baseUrl/counselors/consultations';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      final dynamic result = processResponse(response);

      if (result is List) return result;
      if (result is Map && result['data'] is List) return result['data'];

      return [];
    } catch (e) {
      ApiLogger.error('GET', url, e);
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getCounselorStats(String token) async {
    final url = '$_baseUrl/counselors/stats';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      final dynamic result = processResponse(response);

      if (result is Map) {
        if (result['data'] is Map) {
          return Map<String, dynamic>.from(result['data']);
        }

        return Map<String, dynamic>.from(result);
      }

      return {};
    } catch (e) {
      ApiLogger.error('GET', url, e);
      return {};
    }
  }

  // --- 💬 SERVICIO DE CHAT ---

  @override
  Future<Map<String, dynamic>> getChatHistory(
    String token,
    String partnerId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final url = '$_baseUrl/chat/history/$partnerId?limit=$limit&offset=$offset';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getChatContacts(String token) async {
    final url = '$_baseUrl/chat/contacts';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  // --- 🎮 SERVICIO DE MINIJUEGOS ---

  @override
  Future<Map<String, dynamic>> checkGamesHealth() async {
    final url = '$_baseUrl/games/health';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getGames() async {
    final url = '$_baseUrl/games';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(),
      );

      final dynamic result = processResponse(response);

      if (result is List) return result;
      if (result is Map && result['data'] is List) return result['data'];

      return [];
    } catch (e) {
      ApiLogger.error('GET', url, e);
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getGameDetail(
    String token,
    String gameId,
  ) async {
    final url = '$_baseUrl/games/$gameId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('GET', url, e);
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getGameQuestions(
    String token,
    String gameId,
  ) async {
    final url = '$_baseUrl/games/$gameId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      final dynamic result = processResponse(response);

      final data =
          result is Map && result['data'] != null ? result['data'] : result;

      if (data is Map && data['questions'] is List) {
        return data['questions'];
      }

      return [];
    } catch (e) {
      ApiLogger.error('GET', url, e);
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> startGame(
    String token,
    String gameId,
  ) async {
    final url = '$_baseUrl/games/$gameId/start';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<void> sendAnswer(
    String token,
    String gameId,
    Map<String, dynamic> data,
  ) async {
    final url = '$_baseUrl/games/$gameId/answers';

    try {
      await http.post(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode(data),
      );
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> finishGame(
    String token,
    String gameId,
    String sessionId,
  ) async {
    final url = '$_baseUrl/games/$gameId/finish';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: getHeaders(token),
        body: jsonEncode({'sessionId': sessionId}),
      );

      return processResponse(response);
    } catch (e) {
      ApiLogger.error('POST', url, e);
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getGameResults(String token) async {
    final url = '$_baseUrl/games/students/results';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: getHeaders(token),
      );

      final dynamic result = processResponse(response);

      if (result is List) return result;
      if (result is Map && result['data'] is List) return result['data'];

      return [];
    } catch (e) {
      ApiLogger.error('GET', url, e);
      return [];
    }
  }
}
</file>

<file path="core/api/IApi.dart">
import 'dart:typed_data';

abstract class IApi {
  // --- 🔐 SERVICIO DE AUTENTICACIÓN ---

  Future<Map<String, dynamic>> checkAuthHealth();

  Future<Map<String, dynamic>> login(String email, String password);

  Future<Map<String, dynamic>> register(Map<String, dynamic> data);

  Future<Map<String, dynamic>> getMe(String token);

  Future<Map<String, dynamic>> updateProfile(
    String token,
    Map<String, dynamic> data,
  );

  Future<void> logout(String token);

  Future<Map<String, dynamic>> recoverPassword(String email);

  Future<Map<String, dynamic>> resetPassword(
    String token,
    String newPassword,
  );

  Future<Map<String, dynamic>> getRoles(String token);

  Future<Map<String, dynamic>> updateUserRole(
    String token,
    String userId,
    String roleName,
  );

  // --- 🖼️ SERVICIO DE AVATAR (AWS S3) ---

  Future<Map<String, dynamic>> getAvatarUploadUrl(String token);

  Future<void> uploadImageToS3(String uploadUrl, Uint8List imageBytes);

  Future<Map<String, dynamic>> updateAvatarInBackend(String token, String avatarUrl);

  // --- 👑 SERVICIO DE ADMINISTRADOR ---

  Future<Map<String, dynamic>> getAdminStats(String token);

  Future<List<dynamic>> getAllUsers(String token);

  Future<Map<String, dynamic>> toggleUserStatus(
    String token,
    String userId,
    bool isActive,
  );

  Future<void> deleteUser(String token, String userId);

  // --- 🎓 SERVICIO DE ESTUDIANTES ---

  Future<Map<String, dynamic>> checkStudentsHealth();

  Future<Map<String, dynamic>> createStudentProfile(
    String token,
    Map<String, dynamic> data,
  );

  Future<Map<String, dynamic>> getStudentProfile(String token);

  Future<Map<String, dynamic>> updateStudentProfile(
    String token,
    Map<String, dynamic> data,
  );

  Future<Map<String, dynamic>> joinGroup(
    String token,
    String accessCode,
  );

  Future<List<dynamic>> getStudentGroups(String token);

  // --- 🎓 SERVICIO DE ORIENTADORES ---

  Future<Map<String, dynamic>> createGroup(
    String token,
    Map<String, dynamic> data,
  );

  Future<List<dynamic>> getGroups(String token);

  Future<Map<String, dynamic>> getGroupDetail(
    String token,
    String groupId,
  );

  Future<Map<String, dynamic>> updateGroup(
    String token,
    String groupId,
    Map<String, dynamic> data,
  );

  Future<List<dynamic>> getGroupStudents(
    String token,
    String groupId,
  );

  Future<Map<String, dynamic>> getStudentFile(
    String token,
    String studentId,
  );

  Future<Map<String, dynamic>> registerSession(
    String token,
    String studentId,
    Map<String, dynamic> data,
  );

  Future<Map<String, dynamic>> createTask(
    String token,
    Map<String, dynamic> data,
  );

  Future<List<dynamic>> getCounselorStudents(String token);

  Future<List<dynamic>> getConsultations(String token);

  Future<Map<String, dynamic>> getCounselorStats(String token);

  // --- 💬 SERVICIO DE CHAT ---

  Future<Map<String, dynamic>> getChatHistory(
    String token,
    String partnerId, {
    int limit = 50,
    int offset = 0,
  });

  Future<Map<String, dynamic>> getChatContacts(String token);

  // --- 🎮 SERVICIO DE MINIJUEGOS ---

  Future<Map<String, dynamic>> checkGamesHealth();

  Future<List<dynamic>> getGames();

  Future<Map<String, dynamic>> getGameDetail(
    String token,
    String gameId,
  );

  Future<List<dynamic>> getGameQuestions(
    String token,
    String gameId,
  );

  Future<Map<String, dynamic>> startGame(
    String token,
    String gameId,
  );

  Future<void> sendAnswer(
    String token,
    String gameId,
    Map<String, dynamic> data,
  );

  Future<Map<String, dynamic>> finishGame(
    String token,
    String gameId,
    String sessionId,
  );

  Future<List<dynamic>> getGameResults(String token);
}
</file>

<file path="core/components/MainScaffold.dart">
import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget content;
  final Alignment contentAlignment;
  final Color? backgroundColor;

  const MainScaffold({
    super.key,
    required this.title,
    required this.content,
    this.contentAlignment = Alignment.topCenter,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: title.isEmpty 
          ? null 
          : AppBar(
              title: Text(
                title,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
      body: SafeArea(
        child: Align(
          alignment: contentAlignment,
          child: content,
        ),
      ),
    );
  }
}
</file>

<file path="core/di/AppContainer.dart">
import '../api/API.dart';
import '../api/IApi.dart';
import '../utils/StorageService.dart';
import '../utils/UserService.dart';
import '../../features/auth/data/remote/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

class AppContainer {
  static final AppContainer _instance = AppContainer._internal();
  factory AppContainer() => _instance;
  AppContainer._internal();

  // Core Services
  static final IApi _api = API();
  static final StorageService _storage = StorageService();
  static final UserService _userService = UserService(_storage);

  // Data Sources
  static final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSourceImpl(
    api: _api,
    userService: _userService,
  );

  // Repositories
  static final AuthRepositoryImpl _authRepository = AuthRepositoryImpl(
    remoteDataSource: _authRemoteDataSource,
  );

  // Getters
  IApi get api => _api;
  UserService get userService => _userService;
  AuthRepositoryImpl get authRepository => _authRepository;
}
</file>

<file path="core/di/injection_container.dart">
import 'package:get_it/get_it.dart';

import '../../features/chatbot/data/datasources/remote/chatbot_remote_datasource.dart';
import '../../features/chatbot/data/repositories/chatbot_repository_impl.dart';
import '../../features/chatbot/domain/repositories/chatbot_repository.dart';
import '../../features/chatbot/domain/usecases/send_message_usecase.dart';
import '../../features/chatbot/presentation/providers/chat_provider.dart';
import '../api/IApi.dart';
import '../api/API.dart';
import '../utils/StorageService.dart';
import '../utils/UserService.dart';
import '../utils/media_service.dart';
import '../utils/media_service_impl.dart';

// Auth
import '../../features/auth/data/remote/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/update_avatar_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// Counselor
import '../../features/counselor/data/repositories/counselor_repository_impl.dart';
import '../../features/counselor/domain/repositories/counselor_repository.dart';
import '../../features/counselor/domain/usecases/get_groups_usecase.dart';
import '../../features/counselor/domain/usecases/create_group_usecase.dart';
import '../../features/counselor/domain/usecases/update_group_usecase.dart';
import '../../features/counselor/domain/usecases/get_group_details_usecase.dart';
import '../../features/counselor/domain/usecases/assign_task_usecase.dart';
import '../../features/counselor/domain/usecases/register_session_usecase.dart';
import '../../features/counselor/domain/usecases/get_consultations_usecase.dart';
import '../../features/counselor/domain/usecases/get_counselor_profile_usecase.dart';
import '../../features/counselor/domain/usecases/get_counselor_stats_usecase.dart';
import '../../features/counselor/domain/usecases/get_counselor_students_usecase.dart';
import '../../features/counselor/domain/usecases/get_student_file_usecase.dart';
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

  sl.registerLazySingleton<MediaService>(() => MediaServiceImpl());

  // --- AUTH ---
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      api: sl<IApi>(),
      userService: sl<UserService>(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
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

  sl.registerLazySingleton<UpdateAvatarUseCase>(
        () => UpdateAvatarUseCase(sl<AuthRepository>()),
  );

  sl.registerFactory<AuthProvider>(
        () => AuthProvider(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      updateAvatarUseCase: sl<UpdateAvatarUseCase>(),
      api: sl<IApi>(),
      userService: sl<UserService>(),
      mediaService: sl<MediaService>(),
    ),
  );

  // --- COUNSELOR ---
  sl.registerLazySingleton<CounselorRepository>(
        () => CounselorRepositoryImpl(
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

  sl.registerLazySingleton<UpdateGroupUseCase>(
        () => UpdateGroupUseCase(sl<CounselorRepository>()),
  );

  sl.registerLazySingleton<GetGroupDetailsUseCase>(
        () => GetGroupDetailsUseCase(sl<CounselorRepository>()),
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

  sl.registerLazySingleton<GetStudentFileUseCase>(
        () => GetStudentFileUseCase(sl<CounselorRepository>()),
  );

  sl.registerFactory<CounselorProvider>(
        () => CounselorProvider(
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
    ),
  );

  // --- ADMIN ---
  sl.registerLazySingleton<AdminRepository>(
        () => AdminRepositoryImpl(
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
        () => AdminProvider(
      getStatsUseCase: sl<GetAdminStatsUseCase>(),
      manageUsersUseCase: sl<ManageUsersUseCase>(),
    ),
  );

  // --- VOCATIONAL GAMES ---
  sl.registerLazySingleton<VocationalGamesRepository>(
        () => VocationalGamesRepositoryImpl(
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

  sl.registerLazySingleton<GetGameQuestionsUseCase>(
        () => GetGameQuestionsUseCase(sl<VocationalGamesRepository>()),
  );

  // --- STUDENT ---
  sl.registerLazySingleton<StudentRepository>(
        () => StudentRepositoryImpl(
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
        () => StudentProfileProvider(
      getProfileUseCase: sl<GetStudentProfileUseCase>(),
      updateProfileUseCase: sl<UpdateStudentProfileUseCase>(),
    ),
  );

  sl.registerFactory<StudentResultsProvider>(
        () => StudentResultsProvider(
      getResultsUseCase: sl<GetVocationalResultsUseCase>(),
    ),
  );

  sl.registerFactory<GamesProvider>(
        () => GamesProvider(
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

  // --- CHATBOT ---
  sl.registerLazySingleton<ChatbotRemoteDataSource>(
        () => ChatbotRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ChatbotRepository>(
        () => ChatbotRepositoryImpl(
      remoteDataSource: sl<ChatbotRemoteDataSource>(),
      userService: sl<UserService>(),
    ),
  );

  sl.registerLazySingleton<SendMessageUseCase>(
        () => SendMessageUseCase(sl<ChatbotRepository>()),
  );

  sl.registerFactory<ChatbotProvider>(
        () => ChatbotProvider(sendMessageUseCase: sl<SendMessageUseCase>()),
  );
}
</file>

<file path="core/routes/app_router.dart">
import 'package:go_router/go_router.dart';

import '../../features/counselor/presentation/screens/counselor_profile_screen.dart';
import '../../features/student/presentation/screens/CareersScreen.dart';
import 'AppRoutes.dart';

import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';

import '../../features/student/presentation/screens/student_home_screen.dart';
import '../../features/student/presentation/screens/student_profile_screen.dart';
import '../../features/student/presentation/screens/vocational_results_screen.dart';

import '../../features/vocational_games/presentation/screens/games_list_screen.dart';

import '../../features/counselor/presentation/screens/counselor_home_screen.dart';
import '../../features/counselor/presentation/screens/vocational_map_screen.dart';
import '../../features/counselor/presentation/screens/student_file_screen.dart';

import '../../features/admin/presentation/screens/admin_home_screen.dart';
import '../../features/alumni/presentation/screens/alumni_home_screen.dart';
import '../../features/university/presentation/screens/university_home_screen.dart';

import '../../features/chat/presentation/screens/chat_contacts_screen.dart';
import '../../features/chat/presentation/screens/real_chat_screen.dart';
import '../../features/chatbot/presentation/screens/chat_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash.path,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash.path,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding.path,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login.path,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.roleSelection.path,
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.register.path,
      builder: (context, state) {
        final role = state.extra as String? ?? 'estudiante';
        return RegisterScreen(role: role);
      },
    ),

    // Student
    GoRoute(
      path: AppRoutes.home.path,
      builder: (context, state) => const StudentHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.studentProfile.path,
      builder: (context, state) => const StudentProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.vocationalResults.path,
      builder: (context, state) => const VocationalResultsScreen(),
    ),
    GoRoute(
      path: AppRoutes.careers.path,
      builder: (context, state) => const CareersScreen(),
    ),

    // Games
    GoRoute(
      path: AppRoutes.games.path,
      builder: (context, state) => const GamesListScreen(),
    ),

    // Chat
    GoRoute(
      path: AppRoutes.chat.path,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.chatContacts.path,
      builder: (context, state) => const ChatContactsScreen(),
    ),
    GoRoute(
      path: AppRoutes.realChat.path,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return RealChatScreen(
          contactId: args['contactId'],
          contactName: args['contactName'],
        );
      },
    ),

    // Counselor
    GoRoute(
      path: AppRoutes.counselorHome.path,
      builder: (context, state) => const CounselorHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.vocationalMap.path,
      builder: (context, state) => const VocationalMapScreen(),
    ),
    GoRoute(
      path: AppRoutes.studentFile.path,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return StudentFileScreen(
          studentId: args['studentId'],
          studentName: args['studentName'],
        );
      },
    ),

    // Otros roles
    GoRoute(
      path: AppRoutes.counselorProfile.path,
      builder: (context, state) => const CounselorProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminHome.path,
      builder: (context, state) => const AdminHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.alumniHome.path,
      builder: (context, state) => const AlumniHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.universityHome.path,
      builder: (context, state) => const UniversityHomeScreen(),
    ),
  ],
);
</file>

<file path="core/routes/AppRoutes.dart">
enum AppRoutes {
  splash('/'),
  onboarding('/onboarding'),
  login('/login'),
  register('/register'),
  roleSelection('/role-selection'),

  // Student
  home('/home'),
  studentProfile('/student-profile'),
  vocationalResults('/vocational-results'),
  careers('/careers'),
  careerDetail('/career-detail'),
  careerCompare('/career-compare'),
  universities('/universities'),
  universityDetail('/university-detail'),
  scholarships('/scholarships'),
  events('/events'),
  alumniList('/alumni-list'),
  favorites('/favorites'),
  requestSupport('/request-support'),
  vocationalRoute('/vocational-route'),

  // Chat
  chat('/chat'),
  chatContacts('/chat-contacts'),
  realChat('/real-chat'),

  // Games
  games('/games'),
  gameDetail('/game-detail'),

  // Counselor
  counselorHome('/counselor-home'),
  counselorProfile('/counselor-profile'),
  vocationalMap('/vocational-map'),
  studentFile('/student-file'),

  // University
  universityHome('/university-home'),
  manageCareers('/manage-careers'),

  // Alumni
  alumniHome('/alumni-home'),
  alumniProfile('/alumni-profile'),

  // Admin
  adminHome('/admin-home'),
  adminUsers('/admin-users');

  final String path;
  const AppRoutes(this.path);
}
</file>

<file path="core/routes/RouteGenerator.dart">
import 'package:flutter/material.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

// Onboarding & Auth
import 'package:orientate/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:orientate/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:orientate/features/auth/presentation/screens/login_screen.dart';
import 'package:orientate/features/auth/presentation/screens/register_screen.dart';
import 'package:orientate/features/auth/presentation/screens/role_selection_screen.dart';

// Student
import 'package:orientate/features/student/presentation/screens/student_home_screen.dart';
import 'package:orientate/features/student/presentation/screens/student_profile_screen.dart';
import 'package:orientate/features/student/presentation/screens/vocational_results_screen.dart';

import 'package:orientate/features/student/presentation/screens/career_detail_screen.dart';
import 'package:orientate/features/student/presentation/screens/career_compare_screen.dart';
import 'package:orientate/features/student/presentation/screens/universities_screen.dart';
import 'package:orientate/features/student/presentation/screens/university_detail_screen.dart';
import 'package:orientate/features/student/presentation/screens/scholarships_screen.dart';
import 'package:orientate/features/student/presentation/screens/events_screen.dart';
import 'package:orientate/features/student/presentation/screens/alumni_list_screen.dart';
import 'package:orientate/features/student/presentation/screens/favorites_screen.dart';
import 'package:orientate/features/student/presentation/screens/request_support_screen.dart';
import 'package:orientate/features/student/presentation/screens/vocational_route_screen.dart';

// Chatbot & Chat
import 'package:orientate/features/chatbot/presentation/screens/chat_screen.dart';
import 'package:orientate/features/chat/presentation/screens/chat_contacts_screen.dart';
import 'package:orientate/features/chat/presentation/screens/real_chat_screen.dart';

// Games
import 'package:orientate/features/vocational_games/presentation/screens/games_list_screen.dart';

// Counselor
import 'package:orientate/features/counselor/presentation/screens/counselor_home_screen.dart';
import 'package:orientate/features/counselor/presentation/screens/counselor_profile_screen.dart';

// University Institution
import 'package:orientate/features/university/presentation/screens/university_home_screen.dart';
import 'package:orientate/features/university/presentation/screens/manage_careers_screen.dart';

// Alumni
import 'package:orientate/features/alumni/presentation/screens/alumni_home_screen.dart';
import 'package:orientate/features/alumni/presentation/screens/alumni_profile_screen.dart';

// Admin
import 'package:orientate/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:orientate/features/admin/presentation/screens/user_management_screen.dart';

import '../../features/student/presentation/screens/CareersScreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name;

    if (name == AppRoutes.splash.path) {
      return MaterialPageRoute(builder: (_) => const SplashScreen(), settings: settings);
    } else if (name == AppRoutes.onboarding.path) {
      return MaterialPageRoute(builder: (_) => const OnboardingScreen(), settings: settings);
    } else if (name == AppRoutes.login.path) {
      return MaterialPageRoute(builder: (_) => const LoginScreen(), settings: settings);
    } else if (name == AppRoutes.register.path) {
      return MaterialPageRoute(builder: (_) => const RegisterScreen(), settings: settings);
    } else if (name == AppRoutes.roleSelection.path) {
      return MaterialPageRoute(builder: (_) => const RoleSelectionScreen(), settings: settings);
    }
    
    // Student Routes
    else if (name == AppRoutes.home.path) {
      return MaterialPageRoute(builder: (_) => const StudentHomeScreen(), settings: settings);
    } else if (name == AppRoutes.studentProfile.path) {
      return MaterialPageRoute(builder: (_) => const StudentProfileScreen(), settings: settings);
    } else if (name == AppRoutes.vocationalResults.path) {
      return MaterialPageRoute(builder: (_) => const VocationalResultsScreen(), settings: settings);
    } else if (name == AppRoutes.careers.path) {
      return MaterialPageRoute(builder: (_) => const CareersScreen(), settings: settings);
    } else if (name == AppRoutes.careerDetail.path) {
      return MaterialPageRoute(builder: (_) => const CareerDetailScreen(), settings: settings);
    } else if (name == AppRoutes.careerCompare.path) {
      return MaterialPageRoute(builder: (_) => const CareerCompareScreen(), settings: settings);
    } else if (name == AppRoutes.universities.path) {
      return MaterialPageRoute(builder: (_) => const UniversitiesScreen(), settings: settings);
    } else if (name == AppRoutes.universityDetail.path) {
      return MaterialPageRoute(builder: (_) => const UniversityDetailScreen(), settings: settings);
    } else if (name == AppRoutes.scholarships.path) {
      return MaterialPageRoute(builder: (_) => const ScholarshipsScreen(), settings: settings);
    } else if (name == AppRoutes.events.path) {
      return MaterialPageRoute(builder: (_) => const EventsScreen(), settings: settings);
    } else if (name == AppRoutes.alumniList.path) {
      return MaterialPageRoute(builder: (_) => const AlumniListScreen(), settings: settings);
    } else if (name == AppRoutes.favorites.path) {
      return MaterialPageRoute(builder: (_) => const FavoritesScreen(), settings: settings);
    } else if (name == AppRoutes.requestSupport.path) {
      return MaterialPageRoute(builder: (_) => const RequestSupportScreen(), settings: settings);
    } else if (name == AppRoutes.vocationalRoute.path) {
      return MaterialPageRoute(builder: (_) => const VocationalRouteScreen(), settings: settings);
    }

    // Chat
    else if (name == AppRoutes.chat.path) {
      return MaterialPageRoute(builder: (_) => const ChatScreen(), settings: settings);
    } else if (name == AppRoutes.chatContacts.path) {
      return MaterialPageRoute(builder: (_) => const ChatContactsScreen(), settings: settings);
    } else if (name == AppRoutes.realChat.path) {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => RealChatScreen(
          contactId: args['contactId'],
          contactName: args['contactName'],
        ),
        settings: settings
      );
    }

    // Games
    else if (name == AppRoutes.games.path) {
      return MaterialPageRoute(builder: (_) => const GamesListScreen(), settings: settings);
    } else if (name == AppRoutes.gameDetail.path) {
      return _errorRoute();
    }
    // Counselor
    else if (name == AppRoutes.counselorHome.path) {
      return MaterialPageRoute(builder: (_) => const CounselorHomeScreen(), settings: settings);
    } else if (name == AppRoutes.counselorProfile.path) {
      return MaterialPageRoute(builder: (_) => const CounselorProfileScreen(), settings: settings);
    }

    // University Institution
    else if (name == AppRoutes.universityHome.path) {
      return MaterialPageRoute(builder: (_) => const UniversityHomeScreen(), settings: settings);
    } else if (name == AppRoutes.manageCareers.path) {
      return MaterialPageRoute(builder: (_) => const ManageCareersScreen(), settings: settings);
    }

    // Alumni
    else if (name == AppRoutes.alumniHome.path) {
      return MaterialPageRoute(builder: (_) => const AlumniHomeScreen(), settings: settings);
    } else if (name == AppRoutes.alumniProfile.path) {
      return MaterialPageRoute(builder: (_) => const AlumniProfileScreen(), settings: settings);
    }

    // Admin
    else if (name == AppRoutes.adminHome.path) {
      return MaterialPageRoute(builder: (_) => const AdminHomeScreen(), settings: settings);
    } else if (name == AppRoutes.adminUsers.path) {
      return MaterialPageRoute(builder: (_) => const UserManagementScreen(), settings: settings);
    }

    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Página no encontrada')),
      );
    });
  }
}
</file>

<file path="core/security/security_service.dart">
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SecurityService {
  static const MethodChannel _channel = MethodChannel('orientate/security');

  static Future<bool> isSecureEnvironment() async {
    if (kDebugMode) {
      return true;
    }

    try {
      final bool adbEnabled =
          await _channel.invokeMethod<bool>('isAdbEnabled') ?? false;

      final bool emulator =
          await _channel.invokeMethod<bool>('isEmulator') ?? false;

      final bool rooted =
          await _channel.invokeMethod<bool>('isRooted') ?? false;

      if (adbEnabled || emulator || rooted) {
        return false; // Entorno no seguro (dispositivo real comprometido en producción)
      }

      return true;
    } catch (_) {
      return true;
    }
  }
}
</file>

<file path="core/utils/handlers.dart">
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

Map<String, String> getHeaders([String? token]) {
  final headers = {
    'Content-Type': 'application/json',
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  };
  
  if (kDebugMode) {
    print('DEBUG HEADERS: $headers');
  }
  
  return headers;
}

dynamic processResponse(http.Response response) {
  final body = response.body;
  final dynamic json = body.isNotEmpty ? jsonDecode(body) : null;

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return json;
  } else {
    if (kDebugMode) {
      print('--- ERROR DE API ---');
      print('Status: ${response.statusCode}');
      print('URL: ${response.request?.url}');
      print('Body: $body');
    }
    
    final message = json != null && json['message'] != null 
        ? json['message'] 
        : (json != null && json['error'] != null ? json['error'] : 'Error: ${response.statusCode}');
        
    throw Exception(message);
  }
}

class ApiLogger {
  static void request(String method, String url, dynamic data) {
    if (kDebugMode) {
      print('--> $method $url');
      if (data != null) print('Body: $data');
    }
  }

  static void response(String method, String url, dynamic data) {
    if (kDebugMode) {
      print('<-- $method $url');
      if (data != null) print('Response: $data');
    }
  }

  static void error(String method, String url, dynamic error) {
    if (kDebugMode) {
      print('XXX $method $url - ERROR: $error');
    }
  }
}
</file>

<file path="core/utils/media_service_impl.dart">
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'media_service.dart';

class MediaServiceImpl implements MediaService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<Uint8List?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (image == null) return null;
      return await image.readAsBytes();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Uint8List?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (image == null) return null;
      return await image.readAsBytes();
    } catch (e) {
      return null;
    }
  }
}
</file>

<file path="core/utils/media_service.dart">
import 'dart:typed_data';

abstract class MediaService {
  Future<Uint8List?> pickImageFromGallery();
  Future<Uint8List?> takePhoto();
}
</file>

<file path="core/utils/StorageService.dart">
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
</file>

<file path="core/utils/UserService.dart">
import 'dart:convert';

import 'StorageService.dart';
import '../../features/auth/data/datasources/models/user_model.dart';

class UserService {
  final StorageService _storage;

  static const String _userKey = 'user_data';

  UserService(this._storage);

  // =========================
  // SAVE SESSION
  // =========================

  Future<void> saveSession(
      String token,
      UserModel user,
      ) async {
    final cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      throw Exception('Token inválido');
    }

    await _storage.saveToken(cleanToken);

    final userJson = jsonEncode(
      user.toJson(),
    );

    await _storage.write(
      _userKey,
      userJson,
    );
  }

  // =========================
  // GET USER
  // =========================

  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(
      _userKey,
    );

    if (userJson == null || userJson.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(userJson);

      if (decoded is Map<String, dynamic>) {
        return UserModel.fromJson(decoded);
      }

      if (decoded is Map) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(decoded),
        );
      }

      return null;
    } catch (_) {
      await logout();
      return null;
    }
  }

  // =========================
  // GET TOKEN
  // =========================

  Future<String?> getToken() async {
    final token = await _storage.getToken();

    if (token == null || token.trim().isEmpty) {
      return null;
    }

    return token.trim();
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    await _storage.delete(_userKey);
    await _storage.deleteToken();
  }

  // =========================
  // CHECK LOGIN
  // =========================

  Future<bool> isLoggedIn() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      return false;
    }

    return true;
  }
}
</file>

<file path="features/admin/data/datasources/mappers/admin_mapper.dart">
import '../../../domain/entities/admin_stats_entity.dart';
import '../../../domain/entities/app_user_entity.dart';
import '../models/admin_stats_model.dart';
import '../models/app_user_model.dart';

class AdminMapper {
  static AdminStatsEntity toStatsEntity(AdminStatsModel model) {
    return AdminStatsEntity(
      totalStudents: model.totalStudents,
      totalCounselors: model.totalCounselors,
      totalUniversities: model.totalUniversities,
      totalAlumni: model.totalAlumni,
    );
  }

  static AppUserEntity toUserEntity(AppUserModel model) {
    return AppUserEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      role: model.role,
      isActive: model.isActive,
    );
  }
}
</file>

<file path="features/admin/data/datasources/models/admin_stats_model.dart">
import '../../../domain/entities/admin_stats_entity.dart';

class AdminStatsModel extends AdminStatsEntity {
  AdminStatsModel({
    required super.totalStudents,
    required super.totalCounselors,
    required super.totalUniversities,
    required super.totalAlumni,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalStudents: json['totalStudents'] ?? 0,
      totalCounselors: json['totalCounselors'] ?? 0,
      totalUniversities: json['totalUniversities'] ?? 0,
      totalAlumni: json['totalAlumni'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalStudents': totalStudents,
      'totalCounselors': totalCounselors,
      'totalUniversities': totalUniversities,
      'totalAlumni': totalAlumni,
    };
  }
}
</file>

<file path="features/admin/data/datasources/models/app_user_model.dart">
import '../../../domain/entities/app_user_entity.dart';

class AppUserModel extends AppUserEntity {
  AppUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.isActive,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isActive': isActive,
    };
  }
}
</file>

<file path="features/admin/data/repositories/admin_repository_impl.dart">
import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/admin_stats_entity.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/models/app_user_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final IApi api;
  final UserService userService;

  AdminRepositoryImpl({required this.api, required this.userService});

  @override
  Future<AdminStatsEntity> getGlobalStats() async {
    final token = await userService.getToken();
    final data = await api.getAdminStats(token ?? '');
    
    // Asumiendo que la API devuelve los campos totalStudents, totalCounselors, etc.
    return AdminStatsEntity(
      totalStudents: (data['totalStudents'] ?? data['students_count'] ?? 0) as int,
      totalCounselors: (data['totalCounselors'] ?? data['counselors_count'] ?? 0) as int,
      totalUniversities: (data['totalUniversities'] ?? data['universities_count'] ?? 0) as int,
      totalAlumni: (data['totalAlumni'] ?? data['alumni_count'] ?? 0) as int,
    );
  }

  @override
  Future<List<AppUserEntity>> getAllUsers() async {
    final token = await userService.getToken();
    final list = await api.getAllUsers(token ?? '');
    return list.map((item) => AppUserModel.fromJson(item)).toList();
  }

  @override
  Future<void> toggleUserStatus(String userId, bool isActive) async {
    final token = await userService.getToken();
    await api.toggleUserStatus(token ?? '', userId, isActive);
  }

  @override
  Future<void> deleteUser(String userId) async {
    final token = await userService.getToken();
    await api.deleteUser(token ?? '', userId);
  }
}
</file>

<file path="features/admin/domain/entities/admin_stats_entity.dart">
class AdminStatsEntity {
  final int totalStudents;
  final int totalCounselors;
  final int totalUniversities;
  final int totalAlumni;

  AdminStatsEntity({
    required this.totalStudents,
    required this.totalCounselors,
    required this.totalUniversities,
    required this.totalAlumni,
  });
}
</file>

<file path="features/admin/domain/entities/app_user_entity.dart">
class AppUserEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;

  AppUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
  });
}
</file>

<file path="features/admin/domain/repositories/admin_repository.dart">
import '../entities/admin_stats_entity.dart';
import '../entities/app_user_entity.dart';

abstract class AdminRepository {
  Future<AdminStatsEntity> getGlobalStats();
  Future<List<AppUserEntity>> getAllUsers();
  Future<void> toggleUserStatus(String userId, bool isActive);
  Future<void> deleteUser(String userId);
}
</file>

<file path="features/admin/domain/usecases/get_admin_stats_usecase.dart">
import '../entities/admin_stats_entity.dart';
import '../repositories/admin_repository.dart';

class GetAdminStatsUseCase {
  final AdminRepository repository;

  GetAdminStatsUseCase(this.repository);

  Future<AdminStatsEntity> call() {
    return repository.getGlobalStats();
  }
}
</file>

<file path="features/admin/domain/usecases/manage_users_usecase.dart">
import '../entities/app_user_entity.dart';
import '../repositories/admin_repository.dart';

class ManageUsersUseCase {
  final AdminRepository repository;

  ManageUsersUseCase(this.repository);

  Future<List<AppUserEntity>> getUsers() => repository.getAllUsers();
  Future<void> toggleStatus(String id, bool isActive) => repository.toggleUserStatus(id, isActive);
  Future<void> deleteUser(String id) => repository.deleteUser(id);
}
</file>

<file path="features/admin/presentation/components/admin_stat_card.dart">
import 'package:flutter/material.dart';

class AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const AdminStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
</file>

<file path="features/admin/presentation/providers/admin_provider.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/admin_stats_entity.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/usecases/get_admin_stats_usecase.dart';
import '../../domain/usecases/manage_users_usecase.dart';

class AdminProvider extends ChangeNotifier {
  final GetAdminStatsUseCase _getStatsUseCase;
  final ManageUsersUseCase _manageUsersUseCase;

  AdminStatsEntity? _stats;
  List<AppUserEntity> _users = [];
  bool _isLoading = false;

  AdminProvider({
    required this._getStatsUseCase,
    required this._manageUsersUseCase,
  });

  AdminStatsEntity? get stats => _stats;
  List<AppUserEntity> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchStats() async {
    _isLoading = true;
    notifyListeners();
    try {
      _stats = await _getStatsUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _manageUsersUseCase.getUsers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
</file>

<file path="features/admin/presentation/screens/admin_home_screen.dart">
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/features/admin/presentation/providers/admin_provider.dart';
import 'package:orientate/features/admin/presentation/components/admin_stat_card.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargamos las estadísticas reales de la API al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();
    final stats = adminProvider.stats;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Panel de Administrador',
          style: TextStyle(color: Color(0xFF1D1B4B), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF311B92)),
            onPressed: () => adminProvider.fetchStats(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: adminProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF311B92)))
          : RefreshIndicator(
              onRefresh: () => adminProvider.fetchStats(),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Estado del Sistema',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B)),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tarjetas de Estadísticas conectadas a la API
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      AdminStatCard(
                        title: 'Estudiantes',
                        value: stats?.totalStudents.toString() ?? '0',
                        icon: Icons.school_outlined,
                        color: const Color(0xFF311B92),
                      ),
                      AdminStatCard(
                        title: 'Orientadores',
                        value: stats?.totalCounselors.toString() ?? '0',
                        icon: Icons.people_alt_outlined,
                        color: Colors.orange,
                      ),
                      AdminStatCard(
                        title: 'Universidades',
                        value: stats?.totalUniversities.toString() ?? '0',
                        icon: Icons.account_balance_outlined,
                        color: Colors.green,
                      ),
                      AdminStatCard(
                        title: 'Egresados',
                        value: stats?.totalAlumni.toString() ?? '0',
                        icon: Icons.workspace_premium_outlined,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  const Text(
                    'Gestión de plataforma',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B)),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildActionTile(
                    title: 'Control de Usuarios',
                    subtitle: 'Ver, editar o suspender cuentas',
                    icon: Icons.manage_accounts_outlined,
                    onTap: () => Navigator.pushNamed(context, '/admin-users'),
                  ),
                  _buildActionTile(
                    title: 'Validación de Instituciones',
                    subtitle: 'Validar nuevos códigos',
                    icon: Icons.verified_user_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildActionTile({required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF311B92)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
</file>

<file path="features/admin/presentation/screens/user_management_screen.dart">
import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Usuarios')),
      body: ListView.builder(
        itemCount: 10, // Placeholder
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text('Usuario ${index + 1}'),
            subtitle: const Text('student • activo'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'toggle', child: Text('Desactivar')),
                const PopupMenuItem(value: 'delete', child: Text('Eliminar', style: TextStyle(color: Colors.red))),
              ],
            ),
          );
        },
      ),
    );
  }
}
</file>

<file path="features/alumni/data/datasources/mappers/alumni_mapper.dart">
import '../../../domain/entities/alumni_profile_entity.dart';
import '../../../domain/entities/success_story_entity.dart';
import '../models/alumni_profile_model.dart';
import '../models/success_story_model.dart';

class AlumniMapper {
  static AlumniProfileEntity toProfileEntity(AlumniProfileModel model) {
    return AlumniProfileEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      career: model.career,
      university: model.university,
      currentJob: model.currentJob,
      bio: model.bio,
      profileImageUrl: model.profileImageUrl,
    );
  }

  static SuccessStoryEntity toStoryEntity(SuccessStoryModel model) {
    return SuccessStoryEntity(
      id: model.id,
      alumniName: model.alumniName,
      title: model.title,
      story: model.story,
      imageUrl: model.imageUrl,
      createdAt: model.createdAt,
    );
  }

  static SuccessStoryModel fromStoryEntity(SuccessStoryEntity entity) {
    return SuccessStoryModel(
      id: entity.id,
      alumniName: entity.alumniName,
      title: entity.title,
      story: entity.story,
      imageUrl: entity.imageUrl,
      createdAt: entity.createdAt,
    );
  }
}
</file>

<file path="features/alumni/data/datasources/models/alumni_profile_model.dart">
import '../../../domain/entities/alumni_profile_entity.dart';

class AlumniProfileModel extends AlumniProfileEntity {
  AlumniProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.career,
    required super.university,
    required super.currentJob,
    super.bio,
    super.profileImageUrl,
  });

  factory AlumniProfileModel.fromJson(Map<String, dynamic> json) {
    return AlumniProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      career: json['career'] ?? '',
      university: json['university'] ?? '',
      currentJob: json['currentJob'] ?? '',
      bio: json['bio'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'career': career,
      'university': university,
      'currentJob': currentJob,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }
}
</file>

<file path="features/alumni/data/datasources/models/success_story_model.dart">
import '../../../domain/entities/success_story_entity.dart';

class SuccessStoryModel extends SuccessStoryEntity {
  SuccessStoryModel({
    required super.id,
    required super.alumniName,
    required super.title,
    required super.story,
    super.imageUrl,
    required super.createdAt,
  });

  factory SuccessStoryModel.fromJson(Map<String, dynamic> json) {
    return SuccessStoryModel(
      id: json['id'] ?? '',
      alumniName: json['alumniName'] ?? '',
      title: json['title'] ?? '',
      story: json['story'] ?? '',
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alumniName': alumniName,
      'title': title,
      'story': story,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
</file>

<file path="features/alumni/data/repositories/alumni_repository_impl.dart">
import '../../domain/entities/alumni_profile_entity.dart';
import '../../domain/entities/success_story_entity.dart';
import '../../domain/repositories/alumni_repository.dart';

class AlumniRepositoryImpl implements AlumniRepository {
  @override
  Future<AlumniProfileEntity> getProfile() async {
    // TODO: Implement actual fetch
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile(AlumniProfileEntity profile) async {
    // TODO: Implement update
  }

  @override
  Future<List<SuccessStoryEntity>> getSuccessStories() async {
    return [];
  }

  @override
  Future<void> shareSuccessStory(SuccessStoryEntity story) async {
    // TODO: Implement sharing
  }
}
</file>

<file path="features/alumni/domain/entities/alumni_profile_entity.dart">
class AlumniProfileEntity {
  final String id;
  final String name;
  final String email;
  final String career;
  final String university;
  final String currentJob;
  final String? bio;
  final String? profileImageUrl;

  AlumniProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.career,
    required this.university,
    required this.currentJob,
    this.bio,
    this.profileImageUrl,
  });
}
</file>

<file path="features/alumni/domain/entities/success_story_entity.dart">
class SuccessStoryEntity {
  final String id;
  final String alumniName;
  final String title;
  final String story;
  final String? imageUrl;
  final DateTime createdAt;

  SuccessStoryEntity({
    required this.id,
    required this.alumniName,
    required this.title,
    required this.story,
    this.imageUrl,
    required this.createdAt,
  });
}
</file>

<file path="features/alumni/domain/repositories/alumni_repository.dart">
import '../entities/alumni_profile_entity.dart';
import '../entities/success_story_entity.dart';

abstract class AlumniRepository {
  Future<AlumniProfileEntity> getProfile();
  Future<void> updateProfile(AlumniProfileEntity profile);
  Future<List<SuccessStoryEntity>> getSuccessStories();
  Future<void> shareSuccessStory(SuccessStoryEntity story);
}
</file>

<file path="features/alumni/domain/usecases/get_alumni_profile_usecase.dart">
import '../entities/alumni_profile_entity.dart';
import '../repositories/alumni_repository.dart';

class GetAlumniProfileUseCase {
  final AlumniRepository repository;

  GetAlumniProfileUseCase(this.repository);

  Future<AlumniProfileEntity> call() {
    return repository.getProfile();
  }
}
</file>

<file path="features/alumni/domain/usecases/manage_stories_usecase.dart">
import '../entities/success_story_entity.dart';
import '../repositories/alumni_repository.dart';

class ManageStoriesUseCase {
  final AlumniRepository repository;

  ManageStoriesUseCase(this.repository);

  Future<List<SuccessStoryEntity>> getStories() => repository.getSuccessStories();
  Future<void> shareStory(SuccessStoryEntity story) => repository.shareSuccessStory(story);
}
</file>

<file path="features/alumni/presentation/components/success_story_card.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/success_story_entity.dart';

class SuccessStoryCard extends StatelessWidget {
  final SuccessStoryEntity story;

  const SuccessStoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (story.imageUrl != null)
            Image.network(story.imageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(story.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Por ${story.alumniName}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Text(story.story, maxLines: 3, overflow: TextOverflow.ellipsis),
                TextButton(
                  onPressed: () {},
                  child: const Text('Leer más'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
</file>

<file path="features/alumni/presentation/providers/alumni_provider.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/alumni_profile_entity.dart';
import '../../domain/entities/success_story_entity.dart';
import '../../domain/usecases/get_alumni_profile_usecase.dart';
import '../../domain/usecases/manage_stories_usecase.dart';

class AlumniProvider extends ChangeNotifier {
  final GetAlumniProfileUseCase _getProfileUseCase;
  final ManageStoriesUseCase _manageStoriesUseCase;

  AlumniProfileEntity? _profile;
  List<SuccessStoryEntity> _stories = [];
  bool _isLoading = false;

  AlumniProvider({
    required this._getProfileUseCase,
    required this._manageStoriesUseCase,
  });

  AlumniProfileEntity? get profile => _profile;
  List<SuccessStoryEntity> get stories => _stories;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _getProfileUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _stories = await _manageStoriesUseCase.getStories();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
</file>

<file path="features/alumni/presentation/screens/alumni_home_screen.dart">
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import '../components/success_story_card.dart';
import '../../domain/entities/success_story_entity.dart';

class AlumniHomeScreen extends StatelessWidget {
  const AlumniHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Egresado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Tus Historias de Éxito', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildStoryList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Compartir Historia'),
        icon: const Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildStoryList() {
    return Column(
      children: List.generate(2, (index) {
        return SuccessStoryCard(
          story: SuccessStoryEntity(
            id: '$index',
            alumniName: 'Juan Pérez',
            title: 'Mi camino a la Ingeniería',
            story: 'Desde pequeño me gustaba desarmar cosas. Orientate me ayudó a elegir la mejor universidad...',
            createdAt: DateTime.now(),
          ),
        );
      }),
    );
  }
}
</file>

<file path="features/alumni/presentation/screens/alumni_profile_screen.dart">
import 'package:flutter/material.dart';

class AlumniProfileScreen extends StatelessWidget {
  const AlumniProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil de Egresado')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            const Text('Nombre del Egresado', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Ingeniería de Software • UNAM', style: TextStyle(color: Colors.blue)),
            const SizedBox(height: 32),
            _buildInfoItem(Icons.work, 'Puesto Actual', 'Senior Developer en TechCorp'),
            _buildInfoItem(Icons.history, 'Generación', '2015 - 2020'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: const Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
</file>

<file path="features/auth/data/datasources/mappers/auth_mapper.dart">
import '../../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class AuthMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      name: model.name,
      photoUrl: model.photoUrl,
      avatarUrl: model.avatarUrl,
      role: model.role,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photoUrl: entity.photoUrl,
      avatarUrl: entity.avatarUrl,
      role: entity.role,
    );
  }
}
</file>

<file path="features/auth/data/datasources/models/AuthResponse.dart">
import 'user_model.dart';

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Buscamos el token en la raíz o dentro de 'data' de forma segura
    String? extractedToken = json['token']?.toString();
    if (extractedToken == null && json['data'] != null) {
      extractedToken = json['data']['token']?.toString();
    }

    // Extraemos los datos del usuario de forma segura
    Map<String, dynamic>? userData = json['user'];
    if (userData == null && json['data'] != null) {
      userData = json['data']['user'];
    }

    return AuthResponse(
      token: extractedToken ?? '', // Si no hay token, enviamos string vacío en lugar de null
      user: UserModel.fromJson(userData ?? {}), // Si no hay usuario, enviamos mapa vacío
    );
  }
}
</file>

<file path="features/auth/data/datasources/models/user_model.dart">
import '../../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    super.avatarUrl,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Búsqueda profunda: el usuario puede venir en la raíz, en 'data', en 'user' o en 'data.user'
    Map<String, dynamic> data = json;
    
    if (json['data'] is Map) {
      data = Map<String, dynamic>.from(json['data']);
    }
    
    // Si después de extraer 'data', existe una clave 'user', entramos un nivel más
    if (data['user'] is Map) {
      data = Map<String, dynamic>.from(data['user']);
    }

    return UserModel(
      id: (data['id'] ?? data['_id'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      name: (data['name'] ?? data['fullName'] ?? '').toString(),
      photoUrl: data['photoUrl']?.toString(),
      avatarUrl: (data['avatarUrl'] ?? data['avatar_url'])?.toString(),
      role: (data['roleName'] ?? data['role'] ?? data['type'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'avatarUrl': avatarUrl,
      'roleName': role,
    };
  }
}
</file>

<file path="features/auth/data/datasources/remote/auth_remote_datasource.dart">
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name);
  Future<void> logout();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // TODO: Implement remote login
    throw UnimplementedError();
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    // TODO: Implement remote register
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: Implement remote logout
    throw UnimplementedError();
  }

  @override
  Stream<UserModel?> get authStateChanges {
    // TODO: Implement auth state changes
    throw UnimplementedError();
  }
}
</file>

<file path="features/auth/data/remote/auth_remote_datasource.dart">
import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../datasources/models/user_model.dart';
import '../datasources/models/AuthResponse.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);

  Future<UserModel> register(
    String email,
    String password,
    String name,
    String role, {
    required bool privacyAccepted,
    Uint8List? profileImage,
    Map<String, dynamic>? additionalData,
  });

  Future<void> logout();

  Future<UserModel> updateAvatar(Uint8List imageBytes);

  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final IApi api;
  final UserService userService;

  final _authStateController = StreamController<UserModel?>.broadcast();

  AuthRemoteDataSourceImpl({
    required this.api,
    required this.userService,
  }) {
    _init();
  }

  Future<void> _init() async {
    final user = await userService.getUser();
    _authStateController.add(user);
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final responseMap = await api.login(email, password);
    final authResponse = AuthResponse.fromJson(responseMap);

    if (authResponse.token.isEmpty) {
      throw Exception('No se recibió un token válido');
    }

    await userService.saveSession(authResponse.token, authResponse.user);
    _authStateController.add(authResponse.user);

    return authResponse.user;
  }

  @override
  Future<UserModel> register(
    String email,
    String password,
    String name,
    String role, {
    required bool privacyAccepted,
    Uint8List? profileImage,
    Map<String, dynamic>? additionalData,
  }) async {
    // 1. Registro inicial
    final Map<String, dynamic> regData = {
      'email': email,
      'password': password,
      'name': name,
      'roleName': role,
      'privacyAccepted': privacyAccepted,
    };

    await api.register(regData);

    // 2. Login automático para obtener Token
    final loginResponse = await api.login(email, password);
    final authResponse = AuthResponse.fromJson(loginResponse);

    if (authResponse.token.isEmpty) {
      throw Exception('Error al iniciar sesión tras el registro');
    }

    UserModel currentUser = authResponse.user;
    final String token = authResponse.token;

    // 3. Si hay imagen, ejecutar el flujo de 3 pasos de S3
    if (profileImage != null) {
      try {
        debugPrint('--- INICIANDO CARGA DE AVATAR EN REGISTRO ---');
        // Paso A: Obtener URL firmada
        final uploadData = await api.getAvatarUploadUrl(token);
        final String uploadUrl = uploadData['data']['uploadUrl'];
        final String fileUrl = uploadData['data']['fileUrl'];

        // Paso B: Subir binario a S3
        await api.uploadImageToS3(uploadUrl, profileImage);

        // Paso C: Notificar al backend
        final updateResponse = await api.updateAvatarInBackend(token, fileUrl);
        currentUser = UserModel.fromJson(updateResponse);
        debugPrint('--- AVATAR REGISTRADO CON ÉXITO: ${currentUser.avatarUrl} ---');
      } catch (e) {
        debugPrint('XXX Error cargando avatar en registro: $e');
        // No lanzamos excepción aquí para permitir que el usuario entre aunque falle la foto
      }
    }

    // 4. Guardar sesión final
    await userService.saveSession(token, currentUser);
    _authStateController.add(currentUser);

    return currentUser;
  }

  @override
  Future<UserModel> updateAvatar(Uint8List imageBytes) async {
    final token = await userService.getToken();
    if (token == null) throw Exception('Sesión no encontrada');

    final uploadData = await api.getAvatarUploadUrl(token);
    final String uploadUrl = uploadData['data']['uploadUrl'];
    final String fileUrl = uploadData['data']['fileUrl'];

    await api.uploadImageToS3(uploadUrl, imageBytes);
    final updateResponse = await api.updateAvatarInBackend(token, fileUrl);

    final UserModel updatedUser = UserModel.fromJson(updateResponse);

    await userService.saveSession(token, updatedUser);
    _authStateController.add(updatedUser);

    return updatedUser;
  }

  @override
  Future<void> logout() async {
    try {
      final token = await userService.getToken();
      if (token != null && token.isNotEmpty) {
        await api.logout(token);
      }
    } finally {
      await userService.logout();
      _authStateController.add(null);
    }
  }

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;
}
</file>

<file path="features/auth/data/repositories/auth_repository_impl.dart">
import 'dart:typed_data';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mappers/auth_mapper.dart';
import '../remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    return AuthMapper.toEntity(userModel);
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    required String role,
    required bool privacyAccepted,
    Uint8List? profileImage,
    Map<String, dynamic>? additionalData,
  }) async {
    final userModel = await remoteDataSource.register(
      email,
      password,
      name,
      role,
      privacyAccepted: privacyAccepted,
      profileImage: profileImage,
      additionalData: additionalData,
    );
    return AuthMapper.toEntity(userModel);
  }

  @override
  Future<UserEntity> updateAvatar(Uint8List imageBytes) async {
    final userModel = await remoteDataSource.updateAvatar(imageBytes);
    return AuthMapper.toEntity(userModel);
  }

  @override
  Future<void> logout() async {
    return await remoteDataSource.logout();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((model) => model != null ? AuthMapper.toEntity(model) : null);
  }
}
</file>

<file path="features/auth/di/AuthModule.dart">
import 'package:orientate/core/di/AppContainer.dart';
import 'package:orientate/features/auth/domain/repositories/auth_repository.dart';
import 'package:orientate/features/auth/domain/usecases/login_usecase.dart';
import 'package:orientate/features/auth/domain/usecases/logout_usecase.dart';

import '../domain/usecases/register_usecase.dart';

class AuthModule {
  final AppContainer container;

  AuthModule(this.container);

  AuthRepository provideAuthRepository() {
    return container.authRepository;
  }

  LoginUseCase provideLoginUseCase() {
    return LoginUseCase(provideAuthRepository());
  }

  RegisterUseCase provideRegisterUseCase() {
    return RegisterUseCase(provideAuthRepository());
  }

  LogoutUseCase provideLogoutUseCase() {
    return LogoutUseCase(provideAuthRepository());
  }
}
</file>

<file path="features/auth/domain/entities/user_entity.dart">
class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl; // Keeping for backward compatibility
  final String? avatarUrl; // New field from API
  final String? role;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.avatarUrl,
    this.role,
  });

  // Helper to get the best available image URL
  String? get effectivePhotoUrl => avatarUrl ?? photoUrl;
}
</file>

<file path="features/auth/domain/repositories/auth_repository.dart">
import 'dart:typed_data';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
    required String role,
    required bool privacyAccepted,
    Uint8List? profileImage,
    Map<String, dynamic>? additionalData,
  });
  Future<void> logout();
  Future<UserEntity> updateAvatar(Uint8List imageBytes);
  Stream<UserEntity?> get authStateChanges;
}
</file>

<file path="features/auth/domain/usecases/login_usecase.dart">
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.login(email, password);
  }
}
</file>

<file path="features/auth/domain/usecases/logout_usecase.dart">
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
</file>

<file path="features/auth/domain/usecases/register_usecase.dart">
import 'dart:typed_data';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String name,
    required String role,
    required bool privacyAccepted,
    Uint8List? profileImage,
    Map<String, dynamic>? additionalData,
  }) {
    return repository.register(
      email: email,
      password: password,
      name: name,
      role: role,
      privacyAccepted: privacyAccepted,
      profileImage: profileImage,
      additionalData: additionalData,
    );
  }
}
</file>

<file path="features/auth/domain/usecases/update_avatar_usecase.dart">
import 'dart:typed_data';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateAvatarUseCase {
  final AuthRepository repository;

  UpdateAvatarUseCase(this.repository);

  Future<UserEntity> call(Uint8List imageBytes) {
    return repository.updateAvatar(imageBytes);
  }
}
</file>

<file path="features/auth/presentation/components/role_card.dart">
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  const RoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Ink(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected ? const Color(0xFF311B92) : Colors.grey[200]!,
                width: isSelected ? 2.w : 1.w,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF311B92).withValues(alpha: 0.08),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      )
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8.r,
                        offset: Offset(0, 2.h),
                      )
                    ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    size: 24.sp,
                    color: const Color(0xFF311B92),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D1B4B),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right,
                  color: isSelected ? const Color(0xFF311B92) : Colors.grey[300],
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
</file>

<file path="features/auth/presentation/components/social_login_button.dart">
import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
</file>

<file path="features/auth/presentation/providers/auth_provider.dart">
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/update_avatar_usecase.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../../../core/utils/media_service.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final UpdateAvatarUseCase _updateAvatarUseCase;
  final IApi _api;
  final UserService _userService;
  final MediaService _mediaService;

  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({
    required this._loginUseCase,
    required this._registerUseCase,
    required this._logoutUseCase,
    required this._updateAvatarUseCase,
    required this._api,
    required this._userService,
    required this._mediaService,
  });

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? _validateName(String name) {
    final value = name.trim();

    if (value.isEmpty) return 'El nombre completo es obligatorio';

    if (value.length < 3) {
      return 'El nombre debe tener mínimo 3 letras';
    }

    final nameRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s\.\-\']+$");
    if (!nameRegex.hasMatch(value)) {
      return 'El nombre contiene caracteres no permitidos';
    }

    return null;
  }

  String? _validateEmail(String email) {
    final value = email.trim();

    if (value.isEmpty) return 'El correo electrónico es obligatorio';

    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!regex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido. Ejemplo: usuario@correo.com';
    }

    return null;
  }

  String? _validatePassword(String password) {
    final value = password.trim();

    if (value.isEmpty) return 'La contraseña es obligatoria';

    if (value.length < 8) {
      return 'La contraseña debe tener mínimo 8 caracteres';
    }

    return null;
  }

  String? _validateRole(String role) {
    final value = role.trim().toLowerCase();

    const validRoles = [
      'estudiante',
      'orientador',
      'universidad',
      'alumni',
      'admin',
    ];

    if (value.isEmpty) return 'Debes seleccionar un rol';

    if (!validRoles.contains(value)) {
      return 'El rol seleccionado no es válido';
    }

    return null;
  }

  String? _validateStudentProfile(Map<String, dynamic>? profile) {
    if (profile == null) {
      return 'Faltan los datos del perfil vocacional';
    }

    final subjectsLiked = profile['subjectsLiked'];
    final subjectsDisliked = profile['subjectsDisliked'];
    final interests = profile['interests'];
    final skills = profile['skills'];
    final vocationalClarity = profile['vocationalClarity'];

    if (subjectsLiked is! List || subjectsLiked.isEmpty) {
      return 'Selecciona al menos una materia que te gusta';
    }

    if (subjectsDisliked is! List || subjectsDisliked.isEmpty) {
      return 'Selecciona al menos una materia que no te gusta';
    }

    if (interests is! List || interests.isEmpty) {
      return 'Selecciona al menos un área de interés';
    }

    if (skills is! List || skills.isEmpty) {
      return 'Selecciona al menos una habilidad';
    }

    if (vocationalClarity is! int ||
        vocationalClarity < 1 ||
        vocationalClarity > 10) {
      return 'La claridad vocacional debe estar entre 1 y 10';
    }

    return null;
  }

  String? _validateGroupCode(String? accessCode) {
    final value = accessCode?.trim() ?? '';

    if (value.isEmpty) return 'El código del grupo es obligatorio';

    if (value.length < 4) {
      return 'El código del grupo debe tener mínimo 4 caracteres';
    }

    if (!RegExp(r'^[a-zA-Z0-9\-_]+$').hasMatch(value)) {
      return 'El código del grupo solo puede tener letras, números, guion o guion bajo';
    }

    return null;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final normalizedEmail = email.trim().toLowerCase();
      final normalizedPassword = password.trim();

      final emailError = _validateEmail(normalizedEmail);
      if (emailError != null) throw Exception(emailError);

      if (normalizedPassword.isEmpty) {
        throw Exception('La contraseña es obligatoria');
      }

      _user = await _loginUseCase(
        normalizedEmail,
        normalizedPassword,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String role,
    required bool privacyAccepted,
    Uint8List? profileImage,
    Map<String, dynamic>? studentProfile,
    String? accessCode,
    Map<String, dynamic>? additionalData,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final normalizedEmail = email.trim().toLowerCase();
      final normalizedPassword = password.trim();
      final normalizedName = name.trim();
      final normalizedRole = role.trim().toLowerCase();

      final nameError = _validateName(normalizedName);
      if (nameError != null) throw Exception(nameError);

      final emailError = _validateEmail(normalizedEmail);
      if (emailError != null) throw Exception(emailError);

      final passwordError = _validatePassword(normalizedPassword);
      if (passwordError != null) throw Exception(passwordError);

      final roleError = _validateRole(normalizedRole);
      if (roleError != null) throw Exception(roleError);

      if (!privacyAccepted) {
        throw Exception('Debe aceptar el aviso de privacidad para poder registrarse.');
      }

      if (normalizedRole == 'estudiante') {
        final profileError = _validateStudentProfile(studentProfile);
        if (profileError != null) throw Exception(profileError);

        final groupError = _validateGroupCode(accessCode);
        if (groupError != null) throw Exception(groupError);
      }

      _user = await _registerUseCase(
        email: normalizedEmail,
        password: normalizedPassword,
        name: normalizedName,
        role: normalizedRole,
        privacyAccepted: privacyAccepted,
        profileImage: profileImage,
        additionalData: additionalData,
      );

      final token = await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No se encontró token después del registro');
      }

      if (normalizedRole == 'estudiante') {
        await _api.createStudentProfile(token, studentProfile!);
        final code = accessCode!.trim();
        await _api.joinGroup(token, code);
        await _api.getStudentProfile(token);
      }

      if (normalizedRole == 'orientador') {
        if (additionalData == null) {
          throw Exception('Faltan datos del orientador');
        }

        if (additionalData['group'] != null) {
          await _api.createGroup(token, additionalData['group']);
        }
      }

      return true;
    } catch (e) {
      debugPrint('XXX Error register seguro: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAvatar(Uint8List imageBytes) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _updateAvatarUseCase(imageBytes);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAvatarFromGallery() async {
    final bytes = await _mediaService.pickImageFromGallery();
    if (bytes == null) return false;
    return await updateAvatar(bytes);
  }

  Future<bool> updateAvatarFromCamera() async {
    final bytes = await _mediaService.takePhoto();
    if (bytes == null) return false;
    return await updateAvatar(bytes);
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _logoutUseCase();
      _user = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
</file>

<file path="features/auth/presentation/screens/login_screen.dart">
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Por favor, completa los campos');
      return;
    }

    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      final role = authProvider.user?.role?.toLowerCase() ?? '';
      
      if (role == 'orientador') {
        context.go('/counselor-home');
      } else if (role == 'estudiante') {
        context.go('/home');
      } else if (role.contains('uni')) {
        context.go('/university-home');
      } else if (role.contains('alum') || role.contains('egresado')) {
        context.go('/alumni-home');
      } else {
        context.go('/home');
      }
    } else if (mounted) {
      _showError(authProvider.errorMessage ?? 'Error de autenticación');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return PlatformScaffold(
      backgroundColor: Colors.white,
      material: (_, _) => MaterialScaffoldData(
        resizeToAvoidBottomInset: true, // Ahora permitimos el ajuste para que el scroll funcione con teclado
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // ESTO CENTRA TODO VERTICALMENTE
                    children: [
                      SizedBox(height: 40.h),
                      
                      // LOGO Y TÍTULO
                      Column(
                        children: [
                          Container(
                            width: 90.w,
                            height: 90.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF311B92).withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF311B92), width: 1.5.w),
                            ),
                            child: Icon(
                              Icons.explore,
                              size: 45.sp,
                              color: const Color(0xFF311B92),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'Oriéntate+',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32.sp, 
                              fontWeight: FontWeight.w900, 
                              color: const Color(0xFF1D1B4B),
                              letterSpacing: -1.0,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Tu futuro profesional comienza aquí.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 45.h),

                      // FORMULARIO
                      _buildLabel('Correo Electrónico'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 15.sp),
                        decoration: _inputStyle(hint: 'ejemplo@correo.com', icon: Icons.email_outlined),
                      ),
                      
                      SizedBox(height: 20.h),

                      _buildLabel('Contraseña'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: TextStyle(fontSize: 15.sp),
                        decoration: _inputStyle(
                          hint: '••••••••', 
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, 
                              size: 20.sp,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 45.h),

                      // BOTÓN DE ACCIÓN
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF311B92),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 18.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                            elevation: 0,
                          ),
                          child: authProvider.isLoading
                              ? SizedBox(
                                  height: 22.h, 
                                  width: 22.h, 
                                  child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : Text('Iniciar Sesión', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      
                      const Spacer(), // Empuja el enlace de registro hacia abajo
                      
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text('¿No tienes una cuenta? ', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                            GestureDetector(
                              onTap: () => context.push('/role-selection'),
                              child: Text(
                                'Regístrate aquí', 
                                style: TextStyle(color: const Color(0xFF311B92), fontWeight: FontWeight.bold, fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1D1B4B)),
      ),
    );
  }

  InputDecoration _inputStyle({required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF311B92), size: 22.sp),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8F9FE),
      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r), 
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r), 
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r), 
        borderSide: const BorderSide(color: Color(0xFF311B92), width: 1.5),
      ),
    );
  }
}
</file>

<file path="features/auth/presentation/screens/register_screen.dart">
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../../../../core/utils/media_service.dart';
import '../../../../core/di/injection_container.dart';

class RegisterScreen extends StatefulWidget {
  final String role;

  const RegisterScreen({
    super.key,
    this.role = 'student',
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;

  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _selectedRole;
  Uint8List? _profileImage;

  final ScrollController _scrollController = ScrollController();
  late ConfettiController _confettiController;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _ageController = TextEditingController();
  final _schoolController = TextEditingController();
  final _specialtyController = TextEditingController();

  final _groupCodeController = TextEditingController();
  final _groupNameController = TextEditingController();

  final Set<String> _likes = {};
  final Set<String> _dislikes = {};
  final Set<String> _interests = {};
  final Set<String> _skills = {};

  bool _needsScholarship = false;
  bool _studyAbroad = false;
  double _careerCertainty = 5.0;

  final List<String> _subjectsList = [
    'Matemáticas', 'Física', 'Química', 'Biología', 'Programación',
    'Español', 'Historia', 'Inglés', 'Arte', 'Educación Física', 'Otra',
  ];

  final List<String> _areasList = [
    'Tecnología', 'Robótica', 'Medicina', 'Educación', 'Negocios',
    'Arte', 'Música', 'Deportes', 'Derecho', 'Psicología', 'Comunicación',
    'Medio ambiente', 'Investigación', 'Otra',
  ];

  final List<String> _skillsList = [
    'Liderazgo', 'Comunicación', 'Creatividad', 'Pensamiento lógico',
    'Resolución de problemas', 'Trabajo en equipo', 'Organización',
    'Programación', 'Diseño', 'Investigación', 'Empatía', 'Otra',
  ];

  bool get _isStudent =>
      _selectedRole == 'student' || _selectedRole == 'estudiante';

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.role;
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _schoolController.dispose();
    _specialtyController.dispose();
    _groupCodeController.dispose();
    _groupNameController.dispose();
    _scrollController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF311B92),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickImage() async {
    final mediaService = sl<MediaService>();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () async {
                final bytes = await mediaService.pickImageFromGallery();
                if (bytes != null) setState(() => _profileImage = bytes);
                if (mounted) Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () async {
                final bytes = await mediaService.takePhoto();
                if (bytes != null) setState(() => _profileImage = bytes);
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        _showMessage('Por favor rellena los campos obligatorios');
        return false;
      }
      if (password != confirmPassword) {
        _showMessage('Las contraseñas no coinciden');
        return false;
      }
      if (!_acceptTerms) {
        _showMessage('Debes aceptar los términos y condiciones');
        return false;
      }
    }
    return true;
  }

  Future<void> _handleRegister() async {
    if (!_validateCurrentStep()) return;

    final authProvider = context.read<AuthProvider>();
    final router = GoRouter.of(context);

    final String mappedRole = _isStudent ? 'estudiante' : 'orientador';

    final Map<String, dynamic> studentProfile = {
      'subjectsLiked': _likes.toList(),
      'subjectsDisliked': _dislikes.toList(),
      'interests': _interests.toList(),
      'skills': _skills.toList(),
      'needsScholarship': _needsScholarship,
      'studyAbroad': _studyAbroad,
      'vocationalClarity': _careerCertainty.round().clamp(1, 10),
    };

    final Map<String, dynamic> counselorData = {
      'age': int.tryParse(_ageController.text.trim()) ?? 0,
      'institution': _schoolController.text.trim(),
      'specialty': _specialtyController.text.trim(),
      'group': {
        'name': _groupNameController.text.trim().isEmpty ? 'Mi Grupo' : _groupNameController.text.trim(),
        'accessCode': _groupCodeController.text.trim(),
      },
    };

    // Pasamos el _profileImage directamente al método register
    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      role: mappedRole,
      privacyAccepted: _acceptTerms,
      profileImage: _profileImage, // <-- Esto asegura que se inicie el flujo de S3
      studentProfile: _isStudent ? studentProfile : null,
      accessCode: _isStudent ? _groupCodeController.text.trim() : null,
      additionalData: _isStudent ? null : counselorData,
    );

    if (success && mounted) {
      _confettiController.play();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 280.w,
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.celebration, color: const Color(0xFFFFD700), size: 80.sp),
                SizedBox(height: 24.h),
                Text('¡Bienvenido!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22.sp)),
                SizedBox(height: 8.h),
                const Text('Tu cuenta ha sido creada exitosamente.', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 2000));
      if (mounted) router.go('/login');
    } else if (mounted) {
      _showMessage(authProvider.errorMessage ?? 'Error al registrar');
    }
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _scrollToTop();
    } else {
      _handleRegister();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _scrollToTop();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: _previousStep),
        title: Text(_isStudent ? 'Registro Estudiante' : 'Registro Orientador', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 40.w),
            child: Row(
              children: [
                _buildStepCircle(icon: Icons.person, step: 0),
                _buildStepLine(step: 0),
                _buildStepCircle(icon: _isStudent ? Icons.psychology : Icons.work, step: 1),
                _buildStepLine(step: 1),
                _buildStepCircle(icon: _isStudent ? Icons.groups : Icons.group_add, step: 2),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildCurrentStepContent(),
            ),
          ),
          _buildBottomAction(authProvider.isLoading),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    if (_currentStep == 0) return _buildStepAccount();
    if (_isStudent) return _currentStep == 1 ? _buildStepVocationalProfile() : _buildStepJoinGroup();
    return _currentStep == 1 ? _buildStepCounselorProfile() : _buildStepInitialGroup();
  }

  Widget _buildStepAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: const Color(0xFFF3F4F6),
                backgroundImage: _profileImage != null ? MemoryImage(_profileImage!) : null,
                child: _profileImage == null ? Icon(Icons.person, size: 50.sp, color: Colors.grey[400]) : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(color: Color(0xFF311B92), shape: BoxShape.circle),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 18.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        const Text('Información personal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
        SizedBox(height: 24.h),
        _buildInputField(label: 'Nombre completo *', hint: 'Ej. Juan Pérez', icon: Icons.person_outline, controller: _nameController),
        SizedBox(height: 16.h),
        _buildInputField(label: 'Correo electrónico *', hint: 'juan@gmail.com', icon: Icons.email_outlined, controller: _emailController, keyboardType: TextInputType.emailAddress),
        SizedBox(height: 16.h),
        _buildInputField(label: 'Contraseña *', hint: 'Mínimo 8 caracteres', icon: Icons.lock_outline, isPassword: true, controller: _passwordController, isObs: _obscurePassword, onToggleObs: () => setState(() => _obscurePassword = !_obscurePassword)),
        SizedBox(height: 16.h),
        _buildInputField(label: 'Confirmar contraseña *', hint: 'Repite tu contraseña', icon: Icons.lock_reset, isPassword: true, controller: _confirmPasswordController, isObs: _obscureConfirmPassword, onToggleObs: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
        SizedBox(height: 24.h),
        Row(
          children: [
            Checkbox(value: _acceptTerms, onChanged: (v) => setState(() => _acceptTerms = v ?? false), activeColor: const Color(0xFF311B92)),
            const Expanded(child: Text('Acepto los términos y condiciones')),
          ],
        ),
      ],
    );
  }

  Widget _buildStepVocationalProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cuéntanos sobre ti', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
        SizedBox(height: 24.h),
        _buildMultiSelect('Materias que te gustan *', _subjectsList, _likes),
        _buildMultiSelect('Materias que no te gustan *', _subjectsList, _dislikes),
        _buildMultiSelect('¿Qué áreas te interesan? *', _areasList, _interests),
        _buildMultiSelect('¿Cuáles consideras que son tus habilidades? *', _skillsList, _skills),
        _buildRadioOption('¿Necesitas apoyo mediante una beca? *', _needsScholarship, (v) => setState(() => _needsScholarship = v)),
        _buildRadioOption('¿Te gustaría estudiar en el extranjero? *', _studyAbroad, (v) => setState(() => _studyAbroad = v)),
        SizedBox(height: 24.h),
        Text('¿Qué tan claro tienes qué carrera estudiar? *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        Slider(value: _careerCertainty, min: 1, max: 10, divisions: 9, label: _careerCertainty.round().toString(), activeColor: const Color(0xFF311B92), onChanged: (v) => setState(() => _careerCertainty = v)),
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Nada claro', style: TextStyle(fontSize: 12, color: Colors.grey)), Text('Muy claro', style: TextStyle(fontSize: 12, color: Colors.grey))]),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildStepJoinGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Unirse a un grupo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
        SizedBox(height: 8.h),
        const Text('Ingresa el código que te dio tu orientador.', style: TextStyle(color: Colors.grey)),
        SizedBox(height: 32.h),
        _buildInputField(label: 'Código del grupo *', hint: 'Ej. INV-69941', icon: Icons.qr_code, controller: _groupCodeController, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-_]'))]),
      ],
    );
  }

  Widget _buildStepCounselorProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Perfil profesional', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
        SizedBox(height: 32.h),
        _buildInputField(label: 'Edad', hint: 'Ej. 35', icon: Icons.calendar_today, controller: _ageController, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
        SizedBox(height: 16.h),
        _buildInputField(label: 'Institución', hint: 'Ej. Prepa Sur', icon: Icons.business, controller: _schoolController),
        SizedBox(height: 16.h),
        _buildInputField(label: 'Especialidad / Cargo', hint: 'Ej. Psicólogo Educativo', icon: Icons.badge, controller: _specialtyController),
      ],
    );
  }

  Widget _buildStepInitialGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Crear mi primer grupo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
        SizedBox(height: 32.h),
        _buildInputField(label: 'Nombre del grupo', hint: 'Ej. 6to Semestre A', icon: Icons.groups, controller: _groupNameController),
        SizedBox(height: 16.h),
        _buildInputField(label: 'Código de acceso inicial', hint: 'Ej. GRUPO-2024', icon: Icons.vpn_key, controller: _groupCodeController, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-_]'))]),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isObs = false,
    VoidCallback? onToggleObs,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          obscureText: isPassword && isObs,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18),
            suffixIcon: isPassword ? IconButton(icon: Icon(isObs ? Icons.visibility : Icons.visibility_off), onPressed: onToggleObs) : null,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Color(0xFF311B92), width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelect(String title, List<String> options, Set<String> selection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((opt) => FilterChip(
            label: Text(opt, style: TextStyle(fontSize: 11.sp)),
            selected: selection.contains(opt),
            onSelected: (v) => setState(() => v ? selection.add(opt) : selection.remove(opt)),
            selectedColor: const Color(0xFF311B92).withValues(alpha: 0.2),
            checkmarkColor: const Color(0xFF311B92),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            side: BorderSide(color: selection.contains(opt) ? const Color(0xFF311B92) : Colors.grey[300]!),
          )).toList(),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildRadioOption(String title, bool current, Function(bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        Row(
          children: [
            Radio<bool>(value: true, groupValue: current, onChanged: (v) => onChanged(v ?? false), activeColor: const Color(0xFF311B92)),
            const Text('Sí'),
            const SizedBox(width: 20),
            Radio<bool>(value: false, groupValue: current, onChanged: (v) => onChanged(v ?? false), activeColor: const Color(0xFF311B92)),
            const Text('No'),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomAction(bool isLoading) {
    String buttonText = 'Siguiente';
    if (_currentStep == 2) buttonText = _isStudent ? 'Crear cuenta y unirme' : 'Finalizar registro';
    return Container(
      padding: EdgeInsets.all(24.w),
      child: ElevatedButton(
        onPressed: isLoading ? null : _nextStep,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF311B92), foregroundColor: Colors.white, minimumSize: Size.fromHeight(56.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))),
        child: isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text(buttonText),
      ),
    );
  }

  Widget _buildStepCircle({required IconData icon, required int step}) {
    final bool done = _currentStep > step;
    final bool active = _currentStep == step;
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(color: done ? const Color(0xFF311B92) : Colors.white, shape: BoxShape.circle, border: Border.all(color: active || done ? const Color(0xFF311B92) : Colors.grey[300]!, width: 2)),
      child: Icon(done ? Icons.check : icon, size: 18.sp, color: done ? Colors.white : active ? const Color(0xFF311B92) : Colors.grey[300]),
    );
  }

  Widget _buildStepLine({required int step}) {
    return Expanded(child: Container(height: 2, color: _currentStep > step ? const Color(0xFF311B92) : Colors.grey[200]));
  }
}
</file>

<file path="features/auth/presentation/screens/role_selection_screen.dart">
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../components/role_card.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.white,
      appBar: PlatformAppBar(
        leading: PlatformIconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black, size: 28.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Crea tu cuenta',
          style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                children: [
                  Text(
                    '¿Cómo usarás la app?',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D1B4B),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600], height: 1.5),
                      children: [
                        const TextSpan(text: 'Personalizaremos tu experiencia en '),
                        TextSpan(
                          text: 'Oriéntate+',
                          style: TextStyle(color: const Color(0xFF311B92), fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' según el rol que elijas.'),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  
                  // Cambiamos GridView por una lista de Widgets para permitir altura dinámica
                  _buildRoleCard(
                    title: 'Estudiante',
                    description: 'Explora carreras, juega minijuegos y descubre tu futuro profesional.',
                    icon: Icons.school_outlined,
                    role: 'estudiante',
                  ),
                  _buildRoleCard(
                    title: 'Orientador',
                    description: 'Gestiona el progreso de tus alumnos y brinda apoyo vocacional directo.',
                    icon: Icons.people_outline,
                    role: 'orientador',
                  ),
                  _buildRoleCard(
                    title: 'Universidad',
                    description: 'Publica tu oferta académica, becas y conecta con futuros estudiantes.',
                    icon: Icons.account_balance_outlined,
                    role: 'universidad',
                  ),
                  _buildRoleCard(
                    title: 'Alumni',
                    description: 'Comparte tu experiencia profesional y ayuda a otros a elegir su camino.',
                    icon: Icons.person_outline,
                    role: 'alumni',
                  ),
                ],
              ),
            ),
            
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({required String title, required String description, required IconData icon, required String role}) {
    return RoleCard(
      title: title,
      description: description,
      icon: icon,
      isSelected: _selectedRole == role,
      onTap: () => setState(() => _selectedRole = role),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FractionallySizedBox(
            widthFactor: 1.0,
            child: ElevatedButton(
              onPressed: _selectedRole == null ? null : () => context.push('/register', extra: _selectedRole),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF311B92),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                padding: EdgeInsets.symmetric(vertical: 18.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 0,
              ),
              child: Text('Continuar', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Al continuar, aceptas nuestros Términos de Servicio.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
</file>

<file path="features/chat/data/datasources/models/chat_contact_model.dart">
import 'package:orientate/features/chat/domain/entities/chat_contact_entity.dart';

class ChatContactModel extends ChatContactEntity {
  ChatContactModel({
    required super.contactId,
    required super.contactName,
    required super.contactEmail,
    required super.contactRole,
    required super.lastMessageText,
    required super.lastMessageCreatedAt,
    required super.unreadCount,
  });

  factory ChatContactModel.fromJson(Map<String, dynamic> json) {
    return ChatContactModel(
      contactId: json['contactId'] ?? '',
      contactName: json['contactName'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactRole: json['contactRole'] ?? '',
      lastMessageText: json['lastMessageText'] ?? '',
      lastMessageCreatedAt: DateTime.parse(json['lastMessageCreatedAt'] ?? DateTime.now().toIso8601String()),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}
</file>

<file path="features/chat/data/datasources/models/chat_message_model.dart">
import 'package:orientate/features/chat/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.text,
    required super.isRead,
    required super.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      senderId: (json['senderId'] ?? '').toString(),
      receiverId: (json['receiverId'] ?? '').toString(),
      text: (json['messageText'] ?? json['text'] ?? '').toString(),
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'].toString()) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'messageText': text,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
</file>

<file path="features/chat/data/repositories/chat_repository_impl.dart">
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:orientate/core/api/IApi.dart';
import 'package:orientate/core/utils/UserService.dart';
import 'package:orientate/features/chat/domain/entities/chat_contact_entity.dart';
import 'package:orientate/features/chat/domain/entities/chat_message_entity.dart';
import 'package:orientate/features/chat/domain/repositories/chat_repository.dart';
import 'package:orientate/features/chat/data/datasources/models/chat_contact_model.dart';
import 'package:orientate/features/chat/data/datasources/models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final IApi api;
  final UserService userService;
  io.Socket? _socket;
  final _messageController = StreamController<ChatMessageEntity>.broadcast();

  ChatRepositoryImpl({required this.api, required this.userService});

  @override
  Future<void> connect(String url) async {
    if (_socket?.connected == true) return;

    final token = await userService.getToken();
    if (token == null || token.isEmpty) {
      debugPrint('XXX CHAT: Error - No hay token para conectar');
      return;
    }

    // El servidor requiere el token sin "Bearer "
    final cleanToken = token.replaceFirst('Bearer ', '').trim();
    debugPrint('XXX CHAT: Intentando conectar a $url');

    _socket = io.io(url, io.OptionBuilder()
      .setTransports(['websocket', 'polling'])
      .setAuth({'token': cleanToken})
      .enableForceNew()
      .setReconnectionAttempts(10)
      .setReconnectionDelay(3000)
      .build());

    _socket!.onConnect((_) => debugPrint('XXX CHAT: ¡Conectado al Socket!'));
    _socket!.onConnectError((data) => debugPrint('XXX CHAT: Error de conexión: $data'));
    _socket!.onError((data) => debugPrint('XXX CHAT: Error de servidor: $data'));
    
    // Escuchar mensajes de otros (Receptor)
    _socket!.on('new_message', (data) {
      debugPrint('XXX CHAT: Nuevo mensaje recibido: $data');
      _handleIncoming(data);
    });

    // Confirmación de que MI mensaje se guardó (Emisor)
    _socket!.on('message_delivered', (data) {
      debugPrint('XXX CHAT: Confirmación de entrega recibida');
      final msgData = (data is Map && data.containsKey('message')) ? data['message'] : data;
      _handleIncoming(msgData);
    });

    _socket!.connect();
  }

  void _handleIncoming(dynamic data) {
    if (data == null) return;
    try {
      final message = ChatMessageModel.fromJson(data);
      _messageController.add(message);
    } catch (e) {
      debugPrint('XXX CHAT: Error al procesar mensaje: $e');
    }
  }

  @override
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  @override
  Future<List<ChatContactEntity>> getContacts() async {
    final token = await userService.getToken();
    final response = await api.getChatContacts(token!);
    final dynamic data = response['data'] ?? response;
    final List<dynamic> contactsData = data['contacts'] ?? [];
    return contactsData.map((json) => ChatContactModel.fromJson(json)).toList();
  }

  @override
  Future<List<ChatMessageEntity>> getHistory(String partnerId) async {
    final token = await userService.getToken();
    final response = await api.getChatHistory(token!, partnerId);
    final dynamic data = response['data'] ?? response;
    final List<dynamic> historyData = data['history'] ?? [];
    return historyData.map((json) => ChatMessageModel.fromJson(json)).toList();
  }

  @override
  void sendMessage(String receiverId, String text) {
    if (_socket == null || !_socket!.connected) {
      debugPrint('XXX CHAT: Socket no listo. Intentando conectar...');
      _socket?.connect();
      return;
    }
    
    debugPrint('XXX CHAT: Emitiendo event send_message a $receiverId con texto: "$text"');
    _socket!.emit('send_message', {
      'receiverId': receiverId,
      'text': text,
    });
  }

  @override
  Stream<ChatMessageEntity> onMessageReceived() => _messageController.stream;

  @override
  void markAsRead(String senderId) {
    if (_socket?.connected == true) {
      _socket!.emit('read_messages', {'senderId': senderId});
    }
  }

  @override
  void sendTyping(String receiverId, bool isTyping) {
    if (_socket?.connected == true) {
      _socket!.emit('typing', {
        'receiverId': receiverId,
        'isTyping': isTyping,
      });
    }
  }
}
</file>

<file path="features/chat/domain/entities/chat_contact_entity.dart">
class ChatContactEntity {
  final String contactId;
  final String contactName;
  final String contactEmail;
  final String contactRole;
  final String lastMessageText;
  final DateTime lastMessageCreatedAt;
  final int unreadCount;

  ChatContactEntity({
    required this.contactId,
    required this.contactName,
    required this.contactEmail,
    required this.contactRole,
    required this.lastMessageText,
    required this.lastMessageCreatedAt,
    required this.unreadCount,
  });
}
</file>

<file path="features/chat/domain/entities/chat_message_entity.dart">
class ChatMessageEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final bool isRead;
  final DateTime createdAt;

  ChatMessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.isRead,
    required this.createdAt,
  });

  bool isMe(String currentUserId) => senderId == currentUserId;
}
</file>

<file path="features/chat/domain/repositories/chat_repository.dart">
import '../../domain/entities/chat_contact_entity.dart';
import '../../domain/entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<void> connect(String url);
  void disconnect();
  Future<List<ChatContactEntity>> getContacts();
  Future<List<ChatMessageEntity>> getHistory(String partnerId);
  void sendMessage(String receiverId, String text);
  Stream<ChatMessageEntity> onMessageReceived();
  void markAsRead(String senderId);
  void sendTyping(String receiverId, bool isTyping);
}
</file>

<file path="features/chat/domain/usecases/chat_usecases.dart">
import '../entities/chat_contact_entity.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatContactsUseCase {
  final ChatRepository repository;
  GetChatContactsUseCase(this.repository);
  Future<List<ChatContactEntity>> call() => repository.getContacts();
}

class GetChatHistoryUseCase {
  final ChatRepository repository;
  GetChatHistoryUseCase(this.repository);
  Future<List<ChatMessageEntity>> call(String partnerId) => repository.getHistory(partnerId);
}

class SendChatMessageUseCase {
  final ChatRepository repository;
  SendChatMessageUseCase(this.repository);
  void call(String receiverId, String text) => repository.sendMessage(receiverId, text);
}

class ConnectChatSocketUseCase {
  final ChatRepository repository;
  ConnectChatSocketUseCase(this.repository);
  Future<void> call(String url) => repository.connect(url);
}

class DisconnectChatSocketUseCase {
  final ChatRepository repository;
  DisconnectChatSocketUseCase(this.repository);
  void call() => repository.disconnect();
}

class MarkMessagesAsReadUseCase {
  final ChatRepository repository;
  MarkMessagesAsReadUseCase(this.repository);
  void call(String senderId) => repository.markAsRead(senderId);
}
</file>

<file path="features/chat/presentation/providers/chat_provider.dart">
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/chat_contact_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository repository;
  
  List<ChatContactEntity> _contacts = [];
  List<ChatMessageEntity> _messages = [];
  bool _isLoading = false;
  String? _activeChatPartnerId;
  bool _isConnected = false;

  List<ChatContactEntity> get contacts => _contacts;
  List<ChatMessageEntity> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;

  ChatProvider({required this.repository}) {
    repository.onMessageReceived().listen((message) {
      debugPrint('XXX CHAT PROVIDER: New message received: ${message.text}');
      
      // Si el mensaje es de la conversación actual, lo añadimos
      if (message.senderId == _activeChatPartnerId || message.receiverId == _activeChatPartnerId) {
        // Reemplazar mensaje optimista si existe o añadir nuevo
        final index = _messages.indexWhere((m) => m.id == message.id || (m.text == message.text && m.id.startsWith('temp_')));
        
        if (index != -1) {
          _messages[index] = message;
        } else {
          _messages.add(message);
        }
        notifyListeners();
      }
      loadContacts(); 
    });
  }

  Future<void> connect() async {
    if (_isConnected) return;
    
    String apiUrl = dotenv.env['API_URL'] ?? 'https://orientate-backend.shop/api/v1';
    String socketUrl = apiUrl.replaceAll('/api/v1', '');
    
    try {
      await repository.connect(socketUrl);
      _isConnected = true;
      notifyListeners();
    } catch (e) {
      debugPrint('XXX CHAT PROVIDER: Connection failed: $e');
      _isConnected = false;
      notifyListeners();
    }
  }

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _contacts = await repository.getContacts();
    } catch (e) {
      debugPrint('XXX CHAT PROVIDER: Error contacts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHistory(String partnerId) async {
    _activeChatPartnerId = partnerId;
    _isLoading = true;
    _messages = [];
    notifyListeners();
    try {
      final history = await repository.getHistory(partnerId);
      _messages = List<ChatMessageEntity>.from(history);
      repository.markAsRead(partnerId);
    } catch (e) {
      debugPrint('XXX CHAT PROVIDER: Error history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sendMessage(String receiverId, String text, String currentUserId) {
    debugPrint('XXX CHAT PROVIDER: Entrada a sendMessage. Conectado = $_isConnected');
    // ACTUALIZACIÓN OPTIMISTA: Añadir mensaje a la UI de inmediato
    final tempMessage = ChatMessageEntity(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: currentUserId,
      receiverId: receiverId,
      text: text,
      isRead: false,
      createdAt: DateTime.now(),
    );

    try {
      debugPrint('XXX CHAT PROVIDER: Añadiendo mensaje temporal a la lista');
      _messages.add(tempMessage);
      notifyListeners();
      debugPrint('XXX CHAT PROVIDER: Notificación exitosa.');
    } catch (e, stack) {
      debugPrint('XXX CHAT PROVIDER: EXCEPCIÓN al añadir/notificar: $e\n$stack');
    }

    try {
      if (!_isConnected) {
        debugPrint('XXX CHAT PROVIDER: No conectado. Conectando primero...');
        connect().then((_) {
          try {
            debugPrint('XXX CHAT PROVIDER: Conexión completada. Llamando a repository.sendMessage...');
            repository.sendMessage(receiverId, text);
          } catch (e, stack) {
            debugPrint('XXX CHAT PROVIDER: EXCEPCIÓN en callback sendMessage: $e\n$stack');
          }
        });
      } else {
        debugPrint('XXX CHAT PROVIDER: Ya conectado. Llamando a repository.sendMessage...');
        repository.sendMessage(receiverId, text);
      }
    } catch (e, stack) {
      debugPrint('XXX CHAT PROVIDER: EXCEPCIÓN al llamar al repositorio: $e\n$stack');
    }
  }

  void clearMessages() {
    _messages = [];
    _activeChatPartnerId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    repository.disconnect();
    super.dispose();
  }
}
</file>

<file path="features/chat/presentation/screens/chat_contacts_screen.dart">
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';
import '../../../../core/routes/AppRoutes.dart';
import 'package:go_router/go_router.dart';

class ChatContactsScreen extends StatefulWidget {
  const ChatContactsScreen({super.key});

  @override
  State<ChatContactsScreen> createState() => _ChatContactsScreenState();
}

class _ChatContactsScreenState extends State<ChatContactsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ChatProvider>();
      provider.connect(); // Asegura conexión para recibir nuevos mensajes
      provider.loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.contacts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.contacts.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => provider.loadContacts(),
              child: ListView(
                children: [
                  SizedBox(height: 200, child: Center(child: Text('No tienes conversaciones activas.'))),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadContacts(),
            child: ListView.builder(
              itemCount: provider.contacts.length,
              itemBuilder: (context, index) {
                final contact = provider.contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF311B92).withValues(alpha: 0.1),
                    child: Text(contact.contactName.isNotEmpty ? contact.contactName[0] : '?',
                      style: const TextStyle(color: Color(0xFF311B92), fontWeight: FontWeight.bold)),
                  ),
                  title: Text(contact.contactName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    contact.lastMessageText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(contact.lastMessageCreatedAt),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      if (contact.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF311B92),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${contact.unreadCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    context.push(
                      AppRoutes.realChat.path,
                      extra: {
                        'contactId': contact.contactId,
                        'contactName': contact.contactName,
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
</file>

<file path="features/chat/presentation/screens/real_chat_screen.dart">
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orientate/features/chat/presentation/providers/chat_provider.dart';
import 'package:orientate/features/chat/domain/entities/chat_message_entity.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class RealChatScreen extends StatefulWidget {
  final String contactId;
  final String contactName;

  const RealChatScreen({
    super.key,
    required this.contactId,
    required this.contactName,
  });

  @override
  State<RealChatScreen> createState() => _RealChatScreenState();
}

class _RealChatScreenState extends State<RealChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ChatProvider>();
      provider.connect(); // Aseguramos conexión al entrar
      provider.loadHistory(widget.contactId);
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSend() {
    final text = _controller.text.trim();
    debugPrint('XXX CHAT SCREEN: Botón enviar presionado. Texto: "$text"');
    if (text.isEmpty) {
      debugPrint('XXX CHAT SCREEN: Cancelado porque el texto está vacío.');
      return;
    }
    
    final authProvider = context.read<AuthProvider>();
    final currentUserId = authProvider.user?.id ?? '';
    debugPrint('XXX CHAT SCREEN: Identidades - Emisor (Yo): "$currentUserId", Receptor (Contacto): "${widget.contactId}"');
    
    if (currentUserId.isEmpty) {
      debugPrint('XXX CHAT SCREEN: Error - currentUserId está vacío.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se pudo identificar al usuario actual')),
      );
      return;
    }

    debugPrint('XXX CHAT SCREEN: Llamando a ChatProvider.sendMessage...');
    context.read<ChatProvider>().sendMessage(widget.contactId, text, currentUserId);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.contactName),
            Text(
              provider.isConnected ? 'En línea' : 'Conectando...',
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.normal,
                color: provider.isConnected ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('No hay mensajes aún', style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    final bool isMe = message.senderId != widget.contactId;

                    return _ChatBubble(
                      message: message,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF311B92),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _handleSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMe;

  const _ChatBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF311B92) : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.createdAt),
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
</file>

<file path="features/chatbot/data/datasources/mappers/chat_mapper.dart">
import '../../../domain/entities/chat_message_entity.dart';
import '../models/chat_message_model.dart';

class ChatMapper {
  static ChatMessageEntity toEntity(ChatMessageModel model) {
    return ChatMessageEntity(
      id: model.id,
      text: model.text,
      sender: model.sender,
      timestamp: model.timestamp,
    );
  }

  static ChatMessageModel fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      text: entity.text,
      sender: entity.sender,
      timestamp: entity.timestamp,
    );
  }
}
</file>

<file path="features/chatbot/data/datasources/models/chat_message_model.dart">
import '../../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.text,
    required super.sender,
    required super.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      sender: json['sender'] == 'user' ? MessageSender.user : MessageSender.bot,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sender': sender == MessageSender.user ? 'user' : 'bot',
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
</file>

<file path="features/chatbot/data/datasources/remote/chatbot_remote_datasource.dart">
// data/datasources/remote/chatbot_remote_datasource.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/utils/handlers.dart';

abstract class ChatbotRemoteDataSource {
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body, {String? studentId});
  Future<bool> checkHealth();
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  //static final String _baseUrl = dotenv.env['API_URL'] ?? '...';
  static final String _baseUrl = "https://k9z0v6hf-8000.use2.devtunnels.ms" ?? '...';

  @override
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body, {String? studentId}) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-Student-Id': ?studentId,
    };
    final response = await http.post(
      Uri.parse('$_baseUrl/chat/'),
      headers: headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 500)); // el LLM puede tardar
    return processResponse(response); // reutiliza core/utils/handlers.dart
  }

  @override
  Future<bool> checkHealth() async {
    final response = await http.get(Uri.parse('$_baseUrl/health'));
    final json = processResponse(response);
    return json['status'] == 'ok';
  }
}
</file>

<file path="features/chatbot/data/repositories/chatbot_repository_impl.dart">
// features/chatbot/data/repositories/chatbot_repository_impl.dart
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/chat_source_entity.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../datasources/remote/chatbot_remote_datasource.dart';

// ── Model (vive aquí porque solo lo usa este repositorio) ────────────────────
class _ChatbotResponseModel {
  final String response;
  final String modelUsed;
  final int tokensUsed;
  final bool usedSearch;
  final List<ChatSourceEntity> sources;

  _ChatbotResponseModel({
    required this.response,
    required this.modelUsed,
    required this.tokensUsed,
    required this.usedSearch,
    required this.sources,
  });

  factory _ChatbotResponseModel.fromJson(Map<String, dynamic> json) {
    final sourcesList = (json['sources'] as List<dynamic>? ?? [])
        .map((s) => ChatSourceEntity.fromJson(Map<String, dynamic>.from(s)))
        .toList();

    return _ChatbotResponseModel(
      response:    json['response']     ?? '',
      modelUsed:   json['model_used']   ?? '',
      tokensUsed:  json['tokens_used']  ?? 0,
      usedSearch:  json['used_search']  == true,
      sources:     sourcesList,
    );
  }

  ChatbotResponseEntity toEntity() => ChatbotResponseEntity(
    response:    response,
    modelUsed:   modelUsed,
    tokensUsed:  tokensUsed,
    usedSearch:  usedSearch,
    sources:     sources,
  );
}

// ── Implementación del repositorio ───────────────────────────────────────────
class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;
  final UserService userService;

  ChatbotRepositoryImpl({
    required this.remoteDataSource,
    required this.userService,
  });

  @override
  Future<ChatbotResponseEntity> sendMessage(
      String message, {
        List<Map<String, String>> history = const [],
        bool search = false,
      }) async {
    final user = await userService.getUser();
    final json = await remoteDataSource.sendMessage(
      {
        'message': message,
        'history': history,
        'search':  search,
      },
      studentId: user?.id,
    );
    return _ChatbotResponseModel.fromJson(json).toEntity();
  }

  @override
  Future<bool> checkHealth() => remoteDataSource.checkHealth();
}
</file>

<file path="features/chatbot/domain/entities/chat_message_entity.dart">
enum MessageSender { user, bot }

class ChatMessageEntity {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;

  ChatMessageEntity({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
  });
}
</file>

<file path="features/chatbot/domain/entities/chat_source_entity.dart">
// features/chatbot/domain/entities/chat_source_entity.dart

class ChatSourceEntity {
  final String careerId;
  final String careerName;
  final String universidad;
  final String area;
  final String descripcionCorta;
  final bool isClusterAlternative;

  ChatSourceEntity({
    required this.careerId,
    required this.careerName,
    required this.universidad,
    required this.area,
    required this.descripcionCorta,
    this.isClusterAlternative = false,
  });

  factory ChatSourceEntity.fromJson(Map<String, dynamic> json) {
    return ChatSourceEntity(
      careerId:            json['career_id']           ?? '',
      careerName:          json['career_name']         ?? '',
      universidad:         json['universidad']         ?? '',
      area:                json['area']                ?? '',
      descripcionCorta:    json['descripcion_corta']   ?? '',
      isClusterAlternative: json['is_cluster_alternative'] == true,
    );
  }
}

// La respuesta completa del endpoint POST /chat/
class ChatbotResponseEntity {
  final String response;
  final String modelUsed;
  final int tokensUsed;
  final bool usedSearch;
  final List<ChatSourceEntity> sources;

  ChatbotResponseEntity({
    required this.response,
    required this.modelUsed,
    required this.tokensUsed,
    required this.usedSearch,
    required this.sources,
  });
}
</file>

<file path="features/chatbot/domain/repositories/chatbot_repository.dart">
// features/chatbot/domain/repositories/chatbot_repository.dart
import '../entities/chat_source_entity.dart';

abstract class ChatbotRepository {
  Future<ChatbotResponseEntity> sendMessage(
      String message, {
        List<Map<String, String>> history,
        bool search,
      });

  Future<bool> checkHealth();
}
</file>

<file path="features/chatbot/domain/usecases/get_chat_history_usecase.dart">
// features/chatbot/domain/usecases/get_chat_history_usecase.dart

// El historial del chatbot es en-memoria (no hay endpoint GET /chat/history).
// Este use case existe solo para que injection_container no explote.
// El ChatProvider maneja la lista directamente.
class GetChatHistoryUseCase {
  // vacío a propósito
}
</file>

<file path="features/chatbot/domain/usecases/send_message_usecase.dart">
// features/chatbot/domain/usecases/send_message_usecase.dart
import '../entities/chat_source_entity.dart';
import '../repositories/chatbot_repository.dart';

class SendMessageUseCase {
  final ChatbotRepository repository;
  SendMessageUseCase(this.repository);

  Future<ChatbotResponseEntity> call(
      String message, {
        List<Map<String, String>> history = const [],
        bool search = false,
      }) {
    return repository.sendMessage(message, history: history, search: search);
  }
}
</file>

<file path="features/chatbot/presentation/components/chat_bubble.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isUser ? 12 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 12),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
</file>

<file path="features/chatbot/presentation/providers/chat_provider.dart">
// features/chatbot/presentation/providers/chat_provider.dart
import 'package:flutter/material.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_source_entity.dart';
import '../../domain/usecases/send_message_usecase.dart';

class ChatbotProvider extends ChangeNotifier {
  final SendMessageUseCase _sendMessageUseCase;

  // Historial en-memoria para multi-turn
  final List<ChatMessageEntity> _messages = [];
  // Historial en formato para la API  [{role: user/assistant, content: ...}]
  final List<Map<String, String>> _apiHistory = [];

  List<ChatSourceEntity> _lastSources = [];
  bool _isLoading = false;
  bool _usedSearch = false;
  String? _error;

  ChatbotProvider({required this._sendMessageUseCase});

  List<ChatMessageEntity> get messages    => List.unmodifiable(_messages);
  List<ChatSourceEntity>  get lastSources => List.unmodifiable(_lastSources);
  bool    get isLoading  => _isLoading;
  bool    get usedSearch => _usedSearch;
  String? get error      => _error;

  Future<void> sendMessage(String text, {bool search = false}) async {
    if (text.trim().isEmpty) return;

    // Mensaje del usuario → UI inmediata
    final userMsg = ChatMessageEntity(
      id:        DateTime.now().millisecondsSinceEpoch.toString(),
      text:      text.trim(),
      sender:    MessageSender.user,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _sendMessageUseCase(
        text,
        history: List.from(_apiHistory),  // copia para evitar mutación
        search:  search,
      );

      // Guardar en historial multi-turn para la próxima request
      _apiHistory.add({'role': 'user',      'content': text});
      _apiHistory.add({'role': 'assistant', 'content': result.response});

      // Limitar historial a 10 turnos (20 mensajes) para no saturar tokens
      while (_apiHistory.length > 20) {
        _apiHistory.removeAt(0);
      }

      final botMsg = ChatMessageEntity(
        id:        '${DateTime.now().millisecondsSinceEpoch}_bot',
        text:      result.response,
        sender:    MessageSender.bot,
        timestamp: DateTime.now(),
      );
      _messages.add(botMsg);
      _lastSources = result.sources;
      _usedSearch  = result.usedSearch;
    } catch (e) {
      debugPrint('❌ Chatbot error real: $e');   // 👈 AGREGAR ESTA LÍNEA
      _error = e.toString().replaceAll('Exception: ', '');
      _messages.add(ChatMessageEntity(
        id:        '${DateTime.now().millisecondsSinceEpoch}_err',
        text:      'Lo siento, no pude procesar tu mensaje. Intenta de nuevo.',
        sender:    MessageSender.bot,
        timestamp: DateTime.now(),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearConversation() {
    _messages.clear();
    _apiHistory.clear();
    _lastSources = [];
    _error = null;
    notifyListeners();
  }
}
</file>

<file path="features/chatbot/presentation/screens/chat_screen.dart">
// features/chatbot/presentation/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../components/chat_bubble.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller   = TextEditingController();
  final _scrollCtrl   = ScrollController();
  bool  _searchMode   = false;   // toggle RAG

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    await context.read<ChatbotProvider>().sendMessage(
      text,
      search: _searchMode,
    );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatbotProvider>();

    // Scroll cuando llega respuesta
    if (!provider.isLoading) _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oriéntate+ Chat'),
        actions: [
          // Toggle RAG
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 18,
                  color: _searchMode
                      ? const Color(0xFF311B92)
                      : Colors.grey,
                ),
                Switch(
                  value: _searchMode,
                  activeThumbColor: const Color(0xFF311B92),
                  onChanged: (v) => setState(() => _searchMode = v),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner RAG activo
          if (_searchMode)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              color: const Color(0xFFEDE7F6),
              child: const Text(
                '🔍 Búsqueda de carreras activada',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF311B92),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // Lista de mensajes
          Expanded(
            child: provider.messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              controller:  _scrollCtrl,
              padding:     const EdgeInsets.all(16),
              itemCount:   provider.messages.length,
              itemBuilder: (context, index) {
                final msg = provider.messages[index];
                // Si es el último mensaje del bot + hubo fuentes, mostralas
                final isLastBot = index == provider.messages.length - 1 &&
                    msg.sender == MessageSender.bot;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChatBubble(message: msg),
                    if (isLastBot && provider.lastSources.isNotEmpty)
                      _buildSourcesChips(provider),
                  ],
                );
              },
            ),
          ),

          // Indicador de carga
          if (provider.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(
                color: Color(0xFF311B92),
                backgroundColor: Color(0xFFEDE7F6),
              ),
            ),

          _buildInputArea(provider.isLoading),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Color(0xFFCBB8FF)),
          SizedBox(height: 16),
          Text(
            '¡Hola! Soy Oriéntate+\n¿En qué puedo ayudarte hoy?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourcesChips(ChatbotProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4, bottom: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: provider.lastSources.take(4).map((src) {
          return Chip(
            label: Text(
              src.careerName,
              style: const TextStyle(fontSize: 10),
            ),
            backgroundColor: src.isClusterAlternative
                ? const Color(0xFFF3E5F5)
                : const Color(0xFFE8EAF6),
            avatar: Icon(
              src.isClusterAlternative
                  ? Icons.auto_awesome
                  : Icons.school_outlined,
              size: 14,
              color: const Color(0xFF311B92),
            ),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputArea(bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  enabled:    !isLoading,
                  maxLines:   null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border:   InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical:   10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF311B92),
              child: isLoading
                  ? const SizedBox(
                width:  20,
                height: 20,
                child:  CircularProgressIndicator(
                  color:       Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : IconButton(
                icon:    const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _handleSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
</file>

<file path="features/chatbot/presentation/screens/chatbot_screen.dart">
import 'package:flutter/material.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: const Center(
        child: Text('Chatbot Screen Content'),
      ),
    );
  }
}
</file>

<file path="features/counselor/data/datasources/mappers/counselor_mapper.dart">
import '../../../domain/entities/counselor_profile_entity.dart';
import '../../../domain/entities/student_consultation_entity.dart';
import '../models/counselor_profile_model.dart';
import '../models/student_consultation_model.dart';

class CounselorMapper {
  static CounselorProfileEntity toProfileEntity(CounselorProfileModel model) {
    return CounselorProfileEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      institution: model.institution,
      profileImageUrl: model.profileImageUrl,
    );
  }

  static StudentConsultationEntity toConsultationEntity(StudentConsultationModel model) {
    return StudentConsultationEntity(
      id: model.id,
      studentId: model.studentId,
      studentName: model.studentName,
      message: model.message,
      createdAt: model.createdAt,
      status: model.status,
    );
  }
}
</file>

<file path="features/counselor/data/datasources/models/counselor_profile_model.dart">
import '../../../domain/entities/counselor_profile_entity.dart';

class CounselorProfileModel extends CounselorProfileEntity {
  CounselorProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.institution,
    super.profileImageUrl,
  });

  factory CounselorProfileModel.fromJson(Map<String, dynamic> json) {
    return CounselorProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      institution: json['institution'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'institution': institution,
      'profileImageUrl': profileImageUrl,
    };
  }
}
</file>

<file path="features/counselor/data/datasources/models/student_consultation_model.dart">
import '../../../domain/entities/student_consultation_entity.dart';

class StudentConsultationModel extends StudentConsultationEntity {
  StudentConsultationModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.message,
    required super.createdAt,
    required super.status,
  });

  factory StudentConsultationModel.fromJson(Map<String, dynamic> json) {
    return StudentConsultationModel(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}
</file>

<file path="features/counselor/data/repositories/counselor_repository_impl.dart">
import 'package:flutter/material.dart';

import 'package:orientate/features/student/data/datasources/models/student_profile_model.dart';
import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../../auth/data/datasources/mappers/auth_mapper.dart';

import '../../domain/entities/counselor_profile_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../../domain/repositories/counselor_repository.dart';
import '../datasources/models/student_consultation_model.dart';

class CounselorRepositoryImpl implements CounselorRepository {
  final IApi api;
  final UserService userService;

  CounselorRepositoryImpl({
    required this.api,
    required this.userService,
  });

  Future<String> _getToken() async {
    final token = await userService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No hay sesión activa');
    }

    return token;
  }

  @override
  Future<CounselorProfileEntity> getProfile() async {
    final userModel = await userService.getUser();

    if (userModel == null) {
      throw Exception('No se encontró sesión de usuario');
    }

    final userEntity = AuthMapper.toEntity(userModel);

    return CounselorProfileEntity(
      id: userEntity.id,
      name: userEntity.name ?? 'Sin nombre',
      email: userEntity.email,
      institution: 'Institución no especificada',
      profileImageUrl: userEntity.photoUrl,
    );
  }

  @override
  Future<List<dynamic>> getGroups() async {
    final token = await _getToken();
    return api.getGroups(token);
  }

  @override
  Future<Map<String, dynamic>> getGroupDetails(String groupId) async {
    final token = await _getToken();
    return api.getGroupDetail(token, groupId);
  }

  @override
  Future<Map<String, dynamic>> createGroup(
      String name,
      String? accessCode,
      ) async {
    final token = await _getToken();

    return api.createGroup(token, {
      'name': name,
      'accessCode': accessCode ?? '',
    });
  }

  @override
  Future<Map<String, dynamic>> updateGroup(
      String groupId, {
        String? name,
        String? accessCode,
      }) async {
    final token = await _getToken();

    final data = <String, dynamic>{};

    if (name != null && name.trim().isNotEmpty) {
      data['name'] = name.trim();
    }

    if (accessCode != null && accessCode.trim().isNotEmpty) {
      data['accessCode'] = accessCode.trim();
    }

    return api.updateGroup(token, groupId, data);
  }

  @override
  Future<List<dynamic>> getGroupStudents(String groupId) async {
    final token = await _getToken();
    return api.getGroupStudents(token, groupId);
  }

  @override
  Future<List<StudentProfileEntity>> getStudents() async {
    final token = await _getToken();

    final directStudents = await api.getCounselorStudents(token);

    debugPrint('XXX COUNSELOR STUDENTS RAW: $directStudents');

    if (directStudents.isNotEmpty) {
      final students = directStudents.map((item) {
        final normalized = _normalizeStudentJson(item);
        debugPrint('XXX COUNSELOR STUDENT NORMALIZED: $normalized');
        return StudentProfileModel.fromJson(normalized);
      }).toList();

      return _removeDuplicatedStudents(students);
    }

    final groups = await api.getGroups(token);

    debugPrint('XXX COUNSELOR GROUPS RAW: $groups');

    final List<StudentProfileEntity> allStudents = [];

    for (final groupRaw in groups) {
      final group = _asMap(groupRaw);
      final groupId = _getString(
        group['id'] ??
            group['_id'] ??
            group['groupId'],
      );

      if (groupId.isEmpty) continue;

      final groupName = _getString(
        group['name'] ??
            group['groupName'],
      );

      final groupCode = _getString(
        group['accessCode'] ??
            group['access_code'] ??
            group['code'],
      );

      final studentsByGroup = await api.getGroupStudents(token, groupId);

      debugPrint(
        'XXX GROUP STUDENTS RAW group=$groupName id=$groupId: $studentsByGroup',
      );

      for (final item in studentsByGroup) {
        final normalized = _normalizeStudentJson(
          item,
          groupName: groupName,
          groupCode: groupCode,
        );

        debugPrint('XXX GROUP STUDENT NORMALIZED: $normalized');

        allStudents.add(StudentProfileModel.fromJson(normalized));
      }
    }

    return _removeDuplicatedStudents(allStudents);
  }

  List<StudentProfileEntity> _removeDuplicatedStudents(
      List<StudentProfileEntity> students,
      ) {
    final Map<String, StudentProfileEntity> unique = {};

    for (final student in students) {
      final key = student.id.trim().isNotEmpty
          ? student.id
          : '${student.name}-${student.email}';

      unique[key] = student;
    }

    return unique.values.toList();
  }

  Map<String, dynamic> _normalizeStudentJson(
      dynamic raw, {
        String? groupName,
        String? groupCode,
      }) {
    final map = _asMap(raw);

    final student = _asMap(map['student']);
    final user = _asMap(map['user']);
    final profile = _asMap(map['profile']);
    final authUser = _asMap(map['authUser']);
    final account = _asMap(map['account']);
    final group = _asMap(map['group']);
    final schoolGroup = _asMap(map['schoolGroup']);
    final classroom = _asMap(map['classroom']);

    final source = <String, dynamic>{};

    source.addAll(map);
    source.addAll(student);
    source.addAll(profile);

    source['id'] = _firstNotEmpty([
      map['id'],
      map['_id'],
      map['studentId'],
      map['userId'],
      student['id'],
      student['_id'],
      profile['id'],
      profile['_id'],
      user['id'],
      user['_id'],
      authUser['id'],
      account['id'],
    ]);

    source['name'] = _firstNotEmpty([
      map['name'],
      map['fullName'],
      map['studentName'],
      map['nombre'],
      map['nombre_completo'],
      student['name'],
      student['fullName'],
      student['nombre'],
      student['nombre_completo'],
      profile['name'],
      profile['fullName'],
      user['name'],
      user['fullName'],
      user['nombre'],
      authUser['name'],
      authUser['fullName'],
      account['name'],
      account['fullName'],
      _buildFullName([
        map['firstName'],
        map['lastName'],
      ]),
      _buildFullName([
        student['firstName'],
        student['lastName'],
      ]),
      _buildFullName([
        user['firstName'],
        user['lastName'],
      ]),
      _buildFullName([
        map['nombre'],
        map['apellido'],
      ]),
      _buildFullName([
        student['nombre'],
        student['apellido'],
      ]),
    ]);

    source['email'] = _firstNotEmpty([
      map['email'],
      map['studentEmail'],
      map['correo'],
      student['email'],
      student['studentEmail'],
      student['correo'],
      profile['email'],
      user['email'],
      user['correo'],
      authUser['email'],
      account['email'],
    ]);

    source['profileImageUrl'] = _firstNotEmpty([
      map['profileImageUrl'],
      map['avatarUrl'],
      map['photoUrl'],
      student['profileImageUrl'],
      student['avatarUrl'],
      student['photoUrl'],
      profile['profileImageUrl'],
      user['profileImageUrl'],
      user['avatarUrl'],
      user['photoUrl'],
      authUser['avatarUrl'],
      account['avatarUrl'],
    ]);

    source['groupName'] = _firstNotEmpty([
      groupName,
      map['groupName'],
      map['group_name'],
      group['name'],
      group['groupName'],
      schoolGroup['name'],
      classroom['name'],
    ]);

    source['groupCode'] = _firstNotEmpty([
      groupCode,
      map['groupCode'],
      map['accessCode'],
      map['group_code'],
      group['accessCode'],
      group['access_code'],
      group['code'],
      schoolGroup['accessCode'],
      classroom['accessCode'],
    ]);

    source['interests'] = _firstList([
      map['interests'],
      map['intereses'],
      student['interests'],
      student['intereses'],
      profile['interests'],
      profile['intereses'],
    ]);

    source['skills'] = _firstList([
      map['skills'],
      map['habilidades'],
      student['skills'],
      student['habilidades'],
      profile['skills'],
      profile['habilidades'],
    ]);

    source['subjectsLiked'] = _firstList([
      map['subjectsLiked'],
      map['favoriteSubjects'],
      profile['subjectsLiked'],
      student['subjectsLiked'],
    ]);

    source['subjectsDisliked'] = _firstList([
      map['subjectsDisliked'],
      profile['subjectsDisliked'],
      student['subjectsDisliked'],
    ]);

    source['needsScholarship'] =
        map['needsScholarship'] ?? profile['needsScholarship'] ?? false;

    source['studyAbroad'] =
        map['studyAbroad'] ?? profile['studyAbroad'] ?? false;

    source['vocationalClarity'] = _firstNotEmpty([
      map['vocationalClarity'],
      map['careerCertainty'],
      map['clarity'],
      map['claridadVocacional'],
      student['vocationalClarity'],
      profile['vocationalClarity'],
      profile['clarity'],
    ]);

    return source;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  String _getString(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  dynamic _firstNotEmpty(List<dynamic> values) {
    for (final value in values) {
      if (value == null) continue;

      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }

      if (value is num || value is bool) {
        return value;
      }
    }

    return null;
  }

  List<String> _firstList(List<dynamic> values) {
    for (final value in values) {
      if (value is List && value.isNotEmpty) {
        return value.map((e) => e.toString()).toList();
      }

      if (value is String && value.trim().isNotEmpty) {
        return value
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    return [];
  }

  String? _buildFullName(List<dynamic> parts) {
    final text = parts
        .where((part) => part != null && part.toString().trim().isNotEmpty)
        .map((part) => part.toString().trim())
        .join(' ');

    return text.isEmpty ? null : text;
  }

  @override
  Future<Map<String, dynamic>> getStudentFile(String studentId) async {
    final token = await _getToken();
    return api.getStudentFile(token, studentId);
  }

  @override
  Future<void> registerSession(
      String studentId,
      Map<String, dynamic> sessionData,
      ) async {
    final token = await _getToken();
    await api.registerSession(token, studentId, sessionData);
  }

  @override
  Future<void> assignTask(Map<String, dynamic> taskData) async {
    final token = await _getToken();
    await api.createTask(token, taskData);
  }

  @override
  Future<List<StudentConsultationEntity>> getConsultations() async {
    final token = await _getToken();
    final list = await api.getConsultations(token);

    return list.map((item) {
      return StudentConsultationModel.fromJson(_asMap(item));
    }).toList();
  }

  @override
  Future<void> respondToConsultation(
      String consultationId,
      String response,
      ) async {
    // Pendiente si el backend agrega este endpoint.
  }

  @override
  Future<Map<String, dynamic>> getStats() async {
    final token = await _getToken();
    return api.getCounselorStats(token);
  }
}
</file>

<file path="features/counselor/domain/entities/counselor_profile_entity.dart">
class CounselorProfileEntity {
  final String id;
  final String name;
  final String email;
  final String institution;
  final String? profileImageUrl;

  CounselorProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.institution,
    this.profileImageUrl,
  });
}
</file>

<file path="features/counselor/domain/entities/student_alert_entity.dart">
enum AlertType { highIndecision, scholarshipNeed, other }

enum AlertStatus { pending, resolved }

class StudentAlertEntity {
  final String id;
  final String studentId;
  final AlertType alertType;
  final AlertStatus status;
  final String details;
  final DateTime createdAt;

  StudentAlertEntity({
    required this.id,
    required this.studentId,
    required this.alertType,
    required this.status,
    required this.details,
    required this.createdAt,
  });
}
</file>

<file path="features/counselor/domain/entities/student_consultation_entity.dart">
class StudentConsultationEntity {
  final String id;
  final String studentId;
  final String studentName;
  final String message;
  final DateTime createdAt;
  final String status; // 'pending', 'responded'

  StudentConsultationEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.message,
    required this.createdAt,
    required this.status,
  });
}
</file>

<file path="features/counselor/domain/entities/student_file_entity.dart">
import 'student_alert_entity.dart';

class StudentFileEntity {
  final Map<String, dynamic> profile;
  final List<dynamic> tasks;
  final List<dynamic> sessions;
  final List<StudentAlertEntity> alerts;

  StudentFileEntity({
    required this.profile,
    required this.tasks,
    required this.sessions,
    required this.alerts,
  });
}
</file>

<file path="features/counselor/domain/repositories/counselor_repository.dart">
import '../entities/counselor_profile_entity.dart';
import '../entities/student_consultation_entity.dart';

abstract class CounselorRepository {
  Future<CounselorProfileEntity> getProfile();
  
  // Groups
  Future<List<dynamic>> getGroups();
  Future<Map<String, dynamic>> getGroupDetails(String groupId);
  Future<Map<String, dynamic>> createGroup(String name, String? accessCode);
  Future<Map<String, dynamic>> updateGroup(String groupId, {String? name, String? accessCode});
  Future<List<dynamic>> getGroupStudents(String groupId);
  
  // Students
  Future<List<dynamic>> getStudents();
  Future<Map<String, dynamic>> getStudentFile(String studentId);
  
  // Actions
  Future<void> registerSession(String studentId, Map<String, dynamic> sessionData);
  Future<void> assignTask(Map<String, dynamic> taskData);
  
  // Consultations
  Future<List<StudentConsultationEntity>> getConsultations();
  Future<void> respondToConsultation(String consultationId, String response);

  // Stats
  Future<Map<String, dynamic>> getStats();
}
</file>

<file path="features/counselor/domain/usecases/assign_task_usecase.dart">
import '../repositories/counselor_repository.dart';

class AssignTaskUseCase {
  final CounselorRepository repository;

  AssignTaskUseCase(this.repository);

  Future<void> call(Map<String, dynamic> taskData) {
    return repository.assignTask(taskData);
  }
}
</file>

<file path="features/counselor/domain/usecases/create_group_usecase.dart">
import '../repositories/counselor_repository.dart';

class CreateGroupUseCase {
  final CounselorRepository repository;

  CreateGroupUseCase(this.repository);

  Future<Map<String, dynamic>> call(String name, String? accessCode) {
    return repository.createGroup(name, accessCode);
  }
}
</file>

<file path="features/counselor/domain/usecases/get_consultations_usecase.dart">
import '../entities/student_consultation_entity.dart';
import '../repositories/counselor_repository.dart';

class GetConsultationsUseCase {
  final CounselorRepository repository;

  GetConsultationsUseCase(this.repository);

  Future<List<StudentConsultationEntity>> call() {
    return repository.getConsultations();
  }
}
</file>

<file path="features/counselor/domain/usecases/get_counselor_profile_usecase.dart">
import '../entities/counselor_profile_entity.dart';
import '../repositories/counselor_repository.dart';

class GetCounselorProfileUseCase {
  final CounselorRepository repository;

  GetCounselorProfileUseCase(this.repository);

  Future<CounselorProfileEntity> call() {
    return repository.getProfile();
  }
}
</file>

<file path="features/counselor/domain/usecases/get_counselor_stats_usecase.dart">
import '../repositories/counselor_repository.dart';

class GetCounselorStatsUseCase {
  final CounselorRepository repository;

  GetCounselorStatsUseCase(this.repository);

  Future<Map<String, dynamic>> call() {
    return repository.getStats();
  }
}
</file>

<file path="features/counselor/domain/usecases/get_counselor_students_usecase.dart">
import '../repositories/counselor_repository.dart';

class GetCounselorStudentsUseCase {
  final CounselorRepository repository;

  GetCounselorStudentsUseCase(this.repository);

  Future<List<dynamic>> call() {
    return repository.getStudents();
  }
}
</file>

<file path="features/counselor/domain/usecases/get_group_details_usecase.dart">
import '../repositories/counselor_repository.dart';

class GetGroupDetailsUseCase {
  final CounselorRepository repository;

  GetGroupDetailsUseCase(this.repository);

  Future<Map<String, dynamic>> call(String groupId) {
    return repository.getGroupDetails(groupId);
  }
}
</file>

<file path="features/counselor/domain/usecases/get_groups_usecase.dart">
import '../repositories/counselor_repository.dart';

class GetGroupsUseCase {
  final CounselorRepository repository;

  GetGroupsUseCase(this.repository);

  Future<List<dynamic>> call() {
    return repository.getGroups();
  }
}
</file>

<file path="features/counselor/domain/usecases/get_student_file_usecase.dart">
import '../entities/student_file_entity.dart';
import '../entities/student_alert_entity.dart';
import '../repositories/counselor_repository.dart';

class GetStudentFileUseCase {
  final CounselorRepository repository;

  GetStudentFileUseCase(this.repository);

  Future<StudentFileEntity> call(String studentId) async {
    final data = await repository.getStudentFile(studentId);
    return _mapToEntity(data);
  }

  StudentFileEntity _mapToEntity(Map<String, dynamic> data) {
    final List<dynamic> alertsJson = data['alerts'] ?? [];
    
    return StudentFileEntity(
      profile: data['profile'] ?? {},
      tasks: data['tasks'] ?? [],
      sessions: data['sessions'] ?? [],
      alerts: alertsJson.map((json) {
        return StudentAlertEntity(
          id: json['id'] ?? '',
          studentId: json['studentId'] ?? '',
          alertType: _mapAlertType(json['alertType']),
          status: _mapAlertStatus(json['status']),
          details: json['details'] ?? '',
          createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
        );
      }).toList(),
    );
  }

  AlertType _mapAlertType(String? type) {
    switch (type) {
      case 'HIGH_INDECISION': return AlertType.highIndecision;
      case 'SCHOLARSHIP_NEED': return AlertType.scholarshipNeed;
      default: return AlertType.other;
    }
  }

  AlertStatus _mapAlertStatus(String? status) {
    switch (status) {
      case 'RESOLVED': return AlertStatus.resolved;
      default: return AlertStatus.pending;
    }
  }
}
</file>

<file path="features/counselor/domain/usecases/register_session_usecase.dart">
import '../repositories/counselor_repository.dart';

class RegisterSessionUseCase {
  final CounselorRepository repository;

  RegisterSessionUseCase(this.repository);

  Future<void> call(String studentId, Map<String, dynamic> sessionData) {
    return repository.registerSession(studentId, sessionData);
  }
}
</file>

<file path="features/counselor/domain/usecases/respond_consultation_usecase.dart">
import '../repositories/counselor_repository.dart';

class RespondConsultationUseCase {
  final CounselorRepository repository;

  RespondConsultationUseCase(this.repository);

  Future<void> call(String consultationId, String response) {
    return repository.respondToConsultation(consultationId, response);
  }
}
</file>

<file path="features/counselor/domain/usecases/update_group_usecase.dart">
import '../repositories/counselor_repository.dart';

class UpdateGroupUseCase {
  final CounselorRepository repository;

  UpdateGroupUseCase(this.repository);

  Future<Map<String, dynamic>> call(String groupId, {String? name, String? accessCode}) {
    return repository.updateGroup(groupId, name: name, accessCode: accessCode);
  }
}
</file>

<file path="features/counselor/presentation/components/consultation_card.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/student_consultation_entity.dart';
import 'package:intl/intl.dart';

class ConsultationCard extends StatelessWidget {
  final StudentConsultationEntity consultation;
  final VoidCallback onTap;

  const ConsultationCard({
    super.key,
    required this.consultation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(consultation.studentName),
        subtitle: Text(
          consultation.message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('dd/MM/yy').format(consultation.createdAt),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: consultation.status == 'pending' ? Colors.orange : Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                consultation.status == 'pending' ? 'Pendiente' : 'Respondido',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
</file>

<file path="features/counselor/presentation/providers/counselor_provider.dart">
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';

import '../../domain/entities/counselor_profile_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../../domain/entities/student_file_entity.dart';

import '../../domain/usecases/get_groups_usecase.dart';
import '../../domain/usecases/create_group_usecase.dart';
import '../../domain/usecases/update_group_usecase.dart';
import '../../domain/usecases/get_group_details_usecase.dart';
import '../../domain/usecases/register_session_usecase.dart';
import '../../domain/usecases/assign_task_usecase.dart';
import '../../domain/usecases/get_consultations_usecase.dart';
import '../../domain/usecases/get_counselor_profile_usecase.dart';
import '../../domain/usecases/get_counselor_stats_usecase.dart';
import '../../domain/usecases/get_counselor_students_usecase.dart';
import '../../domain/usecases/get_student_file_usecase.dart';

class CounselorProvider extends ChangeNotifier {
  final GetGroupsUseCase _getGroupsUseCase;
  final CreateGroupUseCase _createGroupUseCase;
  final UpdateGroupUseCase _updateGroupUseCase;
  final GetGroupDetailsUseCase _getGroupDetailsUseCase;
  final RegisterSessionUseCase _registerSessionUseCase;
  final AssignTaskUseCase _assignTaskUseCase;
  final GetConsultationsUseCase _getConsultationsUseCase;
  final GetCounselorProfileUseCase _getCounselorProfileUseCase;
  final GetCounselorStatsUseCase _getCounselStatsUseCase;
  final GetCounselorStudentsUseCase _getStudentsUseCase;
  final GetStudentFileUseCase _getStudentFileUseCase;

  CounselorProfileEntity? _profile;
  List<dynamic> _groups = [];
  List<StudentProfileEntity> _students = [];
  List<StudentConsultationEntity> _consultations = [];
  Map<String, dynamic> _stats = {};

  StudentFileEntity? _currentStudentFile;

  bool _isLoading = false;
  bool _isLoadingFile = false;
  String? _errorMessage;

  CounselorProvider({
    required this._getGroupsUseCase,
    required this._createGroupUseCase,
    required this._updateGroupUseCase,
    required this._getGroupDetailsUseCase,
    required this._registerSessionUseCase,
    required this._assignTaskUseCase,
    required this._getConsultationsUseCase,
    required this._getCounselorProfileUseCase,
    required GetCounselorStatsUseCase getCounselorStatsUseCase,
    required this._getStudentsUseCase,
    required this._getStudentFileUseCase,
  })  : _getCounselStatsUseCase = getCounselorStatsUseCase;

  CounselorProfileEntity? get profile => _profile;
  List<dynamic> get groups => _groups;
  List<StudentProfileEntity> get students => _students;
  List<StudentConsultationEntity> get consultations => _consultations;
  StudentFileEntity? get currentStudentFile => _currentStudentFile;

  bool get isLoading => _isLoading;
  bool get isLoadingFile => _isLoadingFile;
  String? get errorMessage => _errorMessage;

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  int get totalStudentsCount {
    final apiValue = _toInt(_stats['totalStudents']);
    return apiValue > 0 ? apiValue : _students.length;
  }

  int get activeStudentsCount {
    return _toInt(_stats['activeStudents']);
  }

  int get lowProgressCount {
    return _toInt(_stats['lowProgress']);
  }

  int get highIndecisionCount {
    return _toInt(_stats['highIndecision']);
  }

  int get solicitudesCount {
    return _toInt(_stats['requests']);
  }

  int get groupsCount {
    final apiValue = _toInt(_stats['groups']);
    return apiValue > 0 ? apiValue : _groups.length;
  }

  int get reportesCount {
    return _toInt(_stats['reports']);
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait<dynamic>([
        _getGroupsUseCase.call().catchError((e) {
          debugPrint('XXX Error cargando grupos: $e');
          return <dynamic>[];
        }),
        _getConsultationsUseCase.call().catchError((e) {
          debugPrint('XXX Error cargando consultas: $e');
          return <StudentConsultationEntity>[];
        }),
        _getCounselorProfileUseCase.call().catchError((e) {
          debugPrint('XXX Error cargando perfil orientador: $e');
          return null;
        }),
        _getCounselStatsUseCase.call().catchError((e) {
          debugPrint('XXX Error cargando estadísticas: $e');
          return <String, dynamic>{};
        }),
        _getStudentsUseCase.call().catchError((e) {
          debugPrint('XXX Error cargando alumnos: $e');
          return <StudentProfileEntity>[];
        }),
      ]);

      _groups = List<dynamic>.from(results[0] as List);
      _consultations =
      List<StudentConsultationEntity>.from(results[1] as List);
      _profile = results[2] as CounselorProfileEntity?;
      _stats = Map<String, dynamic>.from(results[3] as Map);
      _students = List<StudentProfileEntity>.from(results[4] as List);

      debugPrint('XXX GRUPOS CARGADOS: ${_groups.length}');
      debugPrint('XXX ALUMNOS CARGADOS: ${_students.length}');
      debugPrint('XXX STATS: $_stats');
    } catch (e) {
      debugPrint('XXX Error general CounselorProvider: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStudentFile(String studentId) async {
    _isLoadingFile = true;
    _errorMessage = null;
    _currentStudentFile = null;
    notifyListeners();

    try {
      _currentStudentFile = await _getStudentFileUseCase.call(studentId);
    } catch (e) {
      debugPrint('XXX Error cargando expediente alumno: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingFile = false;
      notifyListeners();
    }
  }

  Future<bool> createGroup(String name, String accessCode) async {
    final cleanName = name.trim();
    final cleanCode = accessCode.trim();

    if (cleanName.isEmpty) {
      _errorMessage = 'Ingresa el nombre del grupo';
      notifyListeners();
      return false;
    }

    if (cleanCode.isEmpty) {
      _errorMessage = 'Ingresa el código de acceso';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _createGroupUseCase.call(cleanName, cleanCode);
      await loadDashboardData();
      return true;
    } catch (e) {
      debugPrint('XXX Error creando grupo: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> getGroupDetails(String groupId) async {
    try {
      final details = await _getGroupDetailsUseCase.call(groupId);
      return Map<String, dynamic>.from(details);
    } catch (e) {
      debugPrint('XXX Error obteniendo detalle grupo: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateGroup(
      String groupId, {
        String? name,
        String? accessCode,
      }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateGroupUseCase.call(
        groupId,
        name: name?.trim(),
        accessCode: accessCode?.trim(),
      );

      await loadDashboardData();
      return true;
    } catch (e) {
      debugPrint('XXX Error actualizando grupo: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerSession(
      String studentId,
      Map<String, dynamic> sessionData,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _registerSessionUseCase.call(studentId, sessionData);
      await loadStudentFile(studentId);
    } catch (e) {
      debugPrint('XXX Error registrando sesión: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> assignTask(Map<String, dynamic> taskData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _assignTaskUseCase.call(taskData);
    } catch (e) {
      debugPrint('XXX Error asignando tarea: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
</file>

<file path="features/counselor/presentation/screens/counselor_home_screen.dart">
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:orientate/features/counselor/presentation/providers/counselor_provider.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/student/domain/entities/student_profile_entity.dart';

class CounselorHomeScreen extends StatefulWidget {
  const CounselorHomeScreen({super.key});

  @override
  State<CounselorHomeScreen> createState() => _CounselorHomeScreenState();
}

class _CounselorHomeScreenState extends State<CounselorHomeScreen> {
  int _selectedIndex = 0;
  static const Color primaryColor = Color(0xFF311B92);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CounselorProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounselorProvider>();
    final authProvider = context.watch<AuthProvider>();

    final String? avatarUrl =
        authProvider.user?.effectivePhotoUrl ?? provider.profile?.profileImageUrl;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Oriéntate+',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 22.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: Badge(
              backgroundColor: Colors.redAccent,
              label: Text(provider.consultations.length.toString()),
              child: Icon(
                Icons.notifications_none_outlined,
                color: Colors.grey[700],
              ),
            ),
            onPressed: () => setState(() => _selectedIndex = 3),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w, left: 8.w),
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.counselorProfile.path),
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.grey[200],
                backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null || avatarUrl.isEmpty
                    ? Icon(Icons.person, color: Colors.grey[500], size: 20.sp)
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: provider.isLoading && provider.groups.isEmpty
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _buildBody(provider),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[400],
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Resumen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Grupos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Alumnos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_rounded),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Reportes',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(CounselorProvider provider) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardTab(provider);
      case 1:
        return _buildGroupsTab(provider);
      case 2:
        return _buildStudentsTab(provider);
      case 3:
        return _buildAlertsTab(provider);
      case 4:
        return _buildReportsTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDashboardTab(CounselorProvider provider) {
    return RefreshIndicator(
      onRefresh: provider.loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Resumen General',
              trailing: 'Actualizado hoy',
            ),
            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: _buildMainStatCard(
                    'ALUMNOS TOTALES',
                    provider.totalStudentsCount.toString(),
                    Icons.people_outline,
                    Colors.blue,
                    'Inscritos en el ciclo',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildMainStatCard(
                    'ACTIVOS',
                    provider.activeStudentsCount.toString(),
                    Icons.trending_up,
                    Colors.purple,
                    'Participación mensual',
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: _buildMainStatCard(
                    'SIN AVANCE',
                    provider.lowProgressCount.toString(),
                    Icons.person_off_outlined,
                    Colors.grey,
                    'Últimos 15 días',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildMainStatCard(
                    'INDECISIÓN ALTA',
                    provider.highIndecisionCount.toString(),
                    Icons.error_outline,
                    Colors.red,
                    'Riesgo de abandono',
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),
            _buildMiniStatsRow(provider),

            SizedBox(height: 32.h),

            _buildSectionHeader(
              'Alertas Prioritarias',
              hasDot: provider.consultations.isNotEmpty,
              trailing: 'Ver todas',
            ),

            SizedBox(height: 16.h),

            if (provider.consultations.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Text(
                    'No hay alertas pendientes',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              )
            else
              ...provider.consultations.take(3).map(
                    (alert) => _buildAlertItem(
                  alert.studentName,
                  alert.message,
                  'Hace poco',
                ),
              ),

            SizedBox(height: 32.h),

            _buildSectionHeader('Herramientas y Acciones'),
            SizedBox(height: 16.h),
            _buildQuickActionsGrid(),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsTab(CounselorProvider provider) {
    if (provider.groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_outlined, size: 80.sp, color: Colors.grey[300]),
            SizedBox(height: 16.h),
            Text(
              'No tienes grupos creados',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: () => _showCreateGroupDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Crear mi primer grupo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadDashboardData,
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: provider.groups.length,
        itemBuilder: (context, index) {
          final group = Map<String, dynamic>.from(provider.groups[index] as Map);
          return _buildGroupCard(group);
        },
      ),
    );
  }

  Widget _buildGroupCard(Map<String, dynamic> group) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.groups_rounded,
                  color: primaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group['name']?.toString() ?? 'Sin nombre',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: const Color(0xFF1D1B4B),
                      ),
                    ),
                    Text(
                      'Código: ${group['accessCode'] ?? group['code'] ?? '---'}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: primaryColor),
                onPressed: () => _showEditGroupDialog(context, group),
              ),
            ],
          ),
          Divider(height: 24.h, color: Colors.grey[50]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Creado: ${group['createdAt']?.toString().split('T')[0] ?? '---'}',
                style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
              ),
              TextButton(
                onPressed: () => _showGroupDetails(group['id'].toString()),
                child: Text(
                  'Ver Detalle',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsTab(CounselorProvider provider) {
    if (provider.students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search_outlined, size: 80.sp, color: Colors.grey[300]),
            SizedBox(height: 16.h),
            Text(
              'No hay alumnos registrados aún',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Comparte el código de grupo para que se unan.',
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadDashboardData,
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: provider.students.length,
        itemBuilder: (context, index) {
          final student = provider.students[index];
          return _buildStudentCard(student);
        },
      ),
    );
  }

  Widget _buildStudentCard(StudentProfileEntity student) {
    final groupText = student.groupName != null && student.groupName!.isNotEmpty
        ? 'Grupo: ${student.groupName}'
        : 'Grupo no disponible';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor: primaryColor.withValues(alpha: 0.1),
                child: Text(
                  student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: const Color(0xFF1D1B4B),
                      ),
                    ),
                    Text(
                      groupText,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      student.email,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '${student.vocationalClarity * 10}% Claridad',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 24.h, color: Colors.grey[50]),
          Row(
            children: [
              Icon(Icons.star_outline_rounded, size: 14.sp, color: Colors.orange),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  student.interests.isNotEmpty
                      ? student.interests.join(' • ')
                      : 'Sin intereses definidos',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 20.sp,
                  color: primaryColor,
                ),
                onPressed: () {
                  context.push(
                    AppRoutes.realChat.path,
                    extra: {
                      'contactId': student.id,
                      'contactName': student.name,
                    },
                  );
                },
                visualDensity: VisualDensity.compact,
              ),
              TextButton(
                onPressed: () {
                  context.push(
                    AppRoutes.studentFile.path,
                    extra: {
                      'studentId': student.id,
                      'studentName': student.name,
                    },
                  );
                },
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                child: Text(
                  'Ver Perfil',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsTab(CounselorProvider provider) {
    if (provider.consultations.isEmpty) {
      return Center(
        child: Text(
          'No hay alertas pendientes',
          style: TextStyle(color: Colors.grey[500], fontSize: 16.sp),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(20.w),
      children: provider.consultations
          .map((alert) => _buildAlertItem(alert.studentName, alert.message, 'Hace poco'))
          .toList(),
    );
  }

  Widget _buildReportsTab() {
    return Center(
      child: Text(
        'Reportes en desarrollo',
        style: TextStyle(color: Colors.grey[500], fontSize: 16.sp),
      ),
    );
  }

  Widget _buildMiniStatsRow(CounselorProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMiniStat(provider.solicitudesCount.toString(), 'SOLICITUDES'),
          Container(height: 20.h, width: 1.w, color: Colors.grey[100]),
          _buildMiniStat(provider.groupsCount.toString(), 'GRUPOS'),
          Container(height: 20.h, width: 1.w, color: Colors.grey[100]),
          _buildMiniStat(provider.reportesCount.toString(), 'REPORTES'),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.w,
      children: [
        _buildQuickAction(
          'Mapa Vocacional',
          Icons.map_outlined,
              () => context.push(AppRoutes.vocationalMap.path),
          highlight: true,
        ),
        _buildQuickAction(
          'Crear Grupo',
          Icons.group_add_outlined,
              () => _showCreateGroupDialog(context),
        ),
        _buildQuickAction(
          'Mensajes',
          Icons.chat_bubble_outline_rounded,
              () => context.push(AppRoutes.chatContacts.path),
        ),
        _buildQuickAction(
          'Ver Reportes',
          Icons.description_outlined,
              () => setState(() => _selectedIndex = 4),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
      String title, {
        String? trailing,
        bool hasDot = false,
      }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1D1B4B),
          ),
        ),
        if (hasDot) ...[
          SizedBox(width: 8.w),
          Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
          ),
        ],
        const Spacer(),
        if (trailing != null)
          Text(
            trailing,
            style: TextStyle(
              fontSize: 12.sp,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildMainStatCard(
      String label,
      String value,
      IconData icon,
      Color color,
      String sub,
      ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22.sp),
              Text(
                value,
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: Colors.grey[800],
            ),
          ),
          Text(
            sub,
            style: TextStyle(fontSize: 9.sp, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertItem(String name, String sub, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            child: Text(name.isNotEmpty ? name[0] : '?'),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
      String title,
      IconData icon,
      VoidCallback onTap, {
        bool highlight = false,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFFF5F3FF) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: highlight ? const Color(0xFFDED9FF) : Colors.grey[100]!,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primaryColor, size: 28.sp),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: const Color(0xFF1D1B4B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMexicoDate(String? isoString) {
    if (isoString == null) return 'N/A';

    try {
      final date = DateTime.parse(isoString).toUtc().subtract(
        const Duration(hours: 6),
      );
      return DateFormat('dd/MM/yyyy hh:mm a').format(date);
    } catch (_) {
      return isoString;
    }
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value?.toString() ?? 'N/A',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showGroupDetails(String groupId) async {
    final provider = context.read<CounselorProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final details = await provider.getGroupDetails(groupId);

    if (mounted) Navigator.pop(context);

    if (details != null && mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalles del Grupo',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 16.h),
              _buildDetailItem('Nombre', details['name']),
              _buildDetailItem('Código de Acceso', details['accessCode']),
              _buildDetailItem(
                'Fecha de Creación',
                _formatMexicoDate(details['createdAt']),
              ),
              _buildDetailItem(
                'Última Actualización',
                _formatMexicoDate(details['updatedAt']),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showEditGroupDialog(BuildContext context, Map<String, dynamic> group) {
    final nameController = TextEditingController(text: group['name']?.toString());
    final codeController =
    TextEditingController(text: group['accessCode']?.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24.h,
          left: 24.w,
          right: 24.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar Grupo',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del grupo',
                  prefixIcon: const Icon(Icons.edit_outlined),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: 'Código de acceso',
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  onPressed: () async {
                    final success =
                    await context.read<CounselorProvider>().updateGroup(
                      group['id'].toString(),
                      name: nameController.text,
                      accessCode: codeController.text,
                    );

                    if (success && mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Grupo actualizado correctamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text('Guardar Cambios'),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final codeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24.h,
          left: 24.w,
          right: 24.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.group_add_outlined,
                      color: primaryColor,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Crear Nuevo Grupo',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1D1B4B),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Define un nombre y un código único para que tus alumnos puedan unirse.',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del grupo',
                  hintText: 'Ej. 6to Semestre A',
                  prefixIcon: const Icon(Icons.edit_outlined),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: 'Código de acceso',
                  hintText: 'Ej. ORIENTA2024',
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  helperText: 'Este código es el que compartirás con tus alumnos.',
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        codeController.text.isNotEmpty) {
                      final success =
                      await context.read<CounselorProvider>().createGroup(
                        nameController.text,
                        codeController.text,
                      );

                      if (success && mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Grupo creado correctamente'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Crear Grupo',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
</file>

<file path="features/counselor/presentation/screens/counselor_profile_screen.dart">
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:orientate/features/counselor/presentation/providers/counselor_provider.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';

class CounselorProfileScreen extends StatelessWidget {
  const CounselorProfileScreen({super.key});

  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    final counselorProvider = context.watch<CounselorProvider>();
    final authProvider = context.watch<AuthProvider>();

    final profile = counselorProvider.profile;
    final user = authProvider.user;

    final name = profile?.name ?? user?.name ?? 'Orientador';
    final email = profile?.email ?? user?.email ?? 'Sin correo';
    final institution = profile?.institution ?? 'Institución no especificada';
    final avatarUrl = user?.effectivePhotoUrl ?? profile?.profileImageUrl;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Perfil del Orientador',
          style: TextStyle(
            color: darkText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(22.w),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44.r,
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: avatarUrl == null || avatarUrl.isEmpty
                        ? Icon(
                      Icons.person,
                      color: primaryColor,
                      size: 46.sp,
                    )
                        : null,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: darkText,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    institution,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            _infoTile(
              icon: Icons.badge_outlined,
              title: 'Rol',
              value: 'Orientador',
            ),
            _infoTile(
              icon: Icons.email_outlined,
              title: 'Correo',
              value: email,
            ),
            _infoTile(
              icon: Icons.school_outlined,
              title: 'Institución',
              value: institution,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Cerrar sesión',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: primaryColor, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: darkText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
</file>

<file path="features/counselor/presentation/screens/student_file_screen.dart">
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/counselor_provider.dart';
import '../../domain/entities/student_alert_entity.dart';

class StudentFileScreen extends StatefulWidget {
  final String studentId;
  final String studentName;

  const StudentFileScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<StudentFileScreen> createState() => _StudentFileScreenState();
}

class _StudentFileScreenState extends State<StudentFileScreen> {
  static const Color primaryColor = Color(0xFF311B92);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CounselorProvider>().loadStudentFile(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounselorProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Expediente del Alumno',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: provider.isLoadingFile
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : provider.errorMessage != null && provider.currentStudentFile == null
              ? _buildErrorView(provider)
              : _buildContent(provider),
    );
  }

  Widget _buildErrorView(CounselorProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.redAccent),
          SizedBox(height: 16.h),
          Text(
            'Error al cargar el expediente',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
            child: Text(
              provider.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => provider.loadStudentFile(widget.studentId),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(CounselorProvider provider) {
    final file = provider.currentStudentFile;
    if (file == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentHeader(),
          SizedBox(height: 24.h),
          _buildProfileSection(file.profile),
          SizedBox(height: 24.h),
          AlertsSection(alerts: file.alerts),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildStudentHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30.r,
          backgroundColor: primaryColor.withValues(alpha: 0.1),
          child: Text(
            widget.studentName.isNotEmpty ? widget.studentName[0].toUpperCase() : '?',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 24.sp),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.studentName,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: const Color(0xFF1D1B4B)),
              ),
              Text(
                'ID: ${widget.studentId}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(Map<String, dynamic> profile) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información General', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          SizedBox(height: 12.h),
          _buildInfoRow('Claridad Vocacional', '${(profile['vocationalClarity'] ?? 0) * 10}%'),
          _buildInfoRow('Requiere Beca', profile['needsScholarship'] == true ? 'Sí' : 'No'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class AlertsSection extends StatelessWidget {
  final List<StudentAlertEntity> alerts;

  const AlertsSection({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alertas del Alumno',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D1B4B)),
        ),
        SizedBox(height: 12.h),
        if (alerts.isEmpty)
          Container(
            padding: EdgeInsets.all(24.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green[300], size: 48.sp),
                SizedBox(height: 12.h),
                Text(
                  'Sin alertas pendientes',
                  style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        else
          ...alerts.map((alert) => AlertCard(alert: alert)),
      ],
    );
  }
}

class AlertCard extends StatelessWidget {
  final StudentAlertEntity alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final isHighIndecision = alert.alertType == AlertType.highIndecision;
    
    final Color cardColor = isHighIndecision 
        ? const Color(0xFFFFEBEE) // Rojo suave
        : const Color(0xFFFFF8E1); // Amarillo suave
        
    final Color textColor = isHighIndecision 
        ? Colors.red[900]! 
        : Colors.orange[900]!;

    final IconData icon = isHighIndecision ? Icons.warning_rounded : Icons.info_rounded;
    final String title = isHighIndecision ? 'Alta Indecisión' : 'Necesidad de Beca';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: textColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 16.sp),
              ),
              const Spacer(),
              Text(
                DateFormat('dd/MM/yyyy').format(alert.createdAt),
                style: TextStyle(fontSize: 11.sp, color: textColor.withValues(alpha: 0.7)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            alert.details,
            style: TextStyle(fontSize: 13.sp, color: textColor.withValues(alpha: 0.8)),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Acción para agendar sesión
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: textColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: const Text('Agendar Sesión de Asesoría'),
            ),
          ),
        ],
      ),
    );
  }
}
</file>

<file path="features/counselor/presentation/screens/vocational_map_screen.dart">
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// --- MODELOS DE DATOS ---

class StudentPoint {
  final String id; // iniciales del alumno
  final String name; // nombre completo
  final double x; // posición normalizada 0.0 a 1.0
  final double y; // posición normalizada 0.0 a 1.0
  final int clusterId;

  StudentPoint({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.clusterId,
  });
}

class VocationalCluster {
  final int id;
  final String name;
  final String insight;
  final Color color;
  final List<StudentPoint> students;

  VocationalCluster({
    required this.id,
    required this.name,
    required this.insight,
    required this.color,
    required this.students,
  });

  Offset getCentroid() {
    if (students.isEmpty) return Offset.zero;
    double sumX = 0;
    double sumY = 0;
    for (var s in students) {
      sumX += s.x;
      sumY += s.y;
    }
    return Offset(sumX / students.length, sumY / students.length);
  }
}

// --- DATOS DE EJEMPLO (MOCKS) ---

final List<VocationalCluster> sampleClusters = [
  VocationalCluster(
    id: 0,
    name: "Ciencias exactas",
    insight: "El grupo muestra una alta inclinación hacia el razonamiento lógico. Se sugiere organizar una visita al centro de ingeniería.",
    color: const Color(0xFF534AB7),
    students: [
      StudentPoint(id: "AM", name: "Alberto Martínez", x: 0.2, y: 0.2, clusterId: 0),
      StudentPoint(id: "JV", name: "Javier Vargas", x: 0.25, y: 0.15, clusterId: 0),
      StudentPoint(id: "SR", name: "Sofía Rojas", x: 0.15, y: 0.25, clusterId: 0),
      StudentPoint(id: "LG", name: "Luis García", x: 0.3, y: 0.22, clusterId: 0),
      StudentPoint(id: "CP", name: "Carlos Pérez", x: 0.22, y: 0.32, clusterId: 0),
      StudentPoint(id: "MT", name: "María Torres", x: 0.28, y: 0.28, clusterId: 0),
      StudentPoint(id: "RN", name: "Roberto Niño", x: 0.18, y: 0.18, clusterId: 0),
    ],
  ),
  VocationalCluster(
    id: 1,
    name: "Ciencias sociales",
    insight: "Predominan habilidades de comunicación. Recomendado fortalecer el club de debate y oratoria.",
    color: const Color(0xFF0F6E56),
    students: [
      StudentPoint(id: "EL", name: "Elena López", x: 0.75, y: 0.2, clusterId: 1),
      StudentPoint(id: "FP", name: "Fernando Pozos", x: 0.8, y: 0.25, clusterId: 1),
      StudentPoint(id: "GD", name: "Gloria Díaz", x: 0.7, y: 0.15, clusterId: 1),
      StudentPoint(id: "HM", name: "Hugo Morales", x: 0.85, y: 0.18, clusterId: 1),
      StudentPoint(id: "IP", name: "Isabel Peralta", x: 0.78, y: 0.3, clusterId: 1),
      StudentPoint(id: "JC", name: "Juan Castro", x: 0.72, y: 0.28, clusterId: 1),
      StudentPoint(id: "KL", name: "Karla Luna", x: 0.82, y: 0.12, clusterId: 1),
    ],
  ),
  VocationalCluster(
    id: 2,
    name: "Artes y diseño",
    insight: "Alta creatividad visual detectada. Podrían beneficiarse de un taller de portafolios artísticos.",
    color: const Color(0xFFD85A30),
    students: [
      StudentPoint(id: "DA", name: "Diana Arenas", x: 0.25, y: 0.75, clusterId: 2),
      StudentPoint(id: "ES", name: "Eduardo Solís", x: 0.3, y: 0.8, clusterId: 2),
      StudentPoint(id: "FR", name: "Fabiola Ruiz", x: 0.2, y: 0.7, clusterId: 2),
      StudentPoint(id: "GH", name: "Gael Hernández", x: 0.35, y: 0.85, clusterId: 2),
      StudentPoint(id: "IA", name: "Iván Aguilar", x: 0.18, y: 0.78, clusterId: 2),
      StudentPoint(id: "JO", name: "Jimena Ortíz", x: 0.28, y: 0.68, clusterId: 2),
      StudentPoint(id: "LS", name: "Lucía Silva", x: 0.22, y: 0.82, clusterId: 2),
    ],
  ),
  VocationalCluster(
    id: 3,
    name: "Ciencias de la salud",
    insight: "Interés marcado en el bienestar humano. Se sugiere plática con egresados de Medicina y Nutrición.",
    color: const Color(0xFFBA7517),
    students: [
      StudentPoint(id: "BC", name: "Beatriz Cano", x: 0.75, y: 0.75, clusterId: 3),
      StudentPoint(id: "CR", name: "César Ríos", x: 0.8, y: 0.8, clusterId: 3),
      StudentPoint(id: "DM", name: "Daniela Meza", x: 0.7, y: 0.7, clusterId: 3),
      StudentPoint(id: "ET", name: "Esteban Tello", x: 0.85, y: 0.85, clusterId: 3),
      StudentPoint(id: "FV", name: "Fernanda Vega", x: 0.68, y: 0.78, clusterId: 3),
      StudentPoint(id: "GP", name: "Gerardo Parra", x: 0.78, y: 0.68, clusterId: 3),
      StudentPoint(id: "HL", name: "Héctor Lara", x: 0.82, y: 0.72, clusterId: 3),
    ],
  ),
];

class VocationalMapScreen extends StatefulWidget {
  const VocationalMapScreen({super.key});

  @override
  State<VocationalMapScreen> createState() => _VocationalMapScreenState();
}

class _VocationalMapScreenState extends State<VocationalMapScreen> with SingleTickerProviderStateMixin {
  final TransformationController _transformationController = TransformationController();
  late AnimationController _animationController;
  
  StudentPoint? _selectedStudent;
  VocationalCluster? _selectedCluster;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
    setState(() {});
  }

  void _handleTap(TapUpDetails details, Size canvasSize) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(details.globalPosition);
    final tapPos = _transformationController.toScene(localOffset);
    
    StudentPoint? tappedStudent;
    double minDistance = 22.0;

    for (var cluster in sampleClusters) {
      for (var student in cluster.students) {
        final double px = student.x * canvasSize.width;
        final double py = student.y * canvasSize.height;
        final double distance = sqrt(pow(px - tapPos.dx, 2) + pow(py - tapPos.dy, 2));
        
        if (distance < minDistance) {
          tappedStudent = student;
          minDistance = distance;
        }
      }
    }

    setState(() {
      if (tappedStudent != null) {
        _selectedStudent = tappedStudent;
        _selectedCluster = sampleClusters.firstWhere((c) => c.id == tappedStudent!.clusterId);
      } else {
        _selectedStudent = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(),
      body: Column(
        children: [
          _buildLegend(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
                return InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 0.4,
                  maxScale: 6.0,
                  boundaryMargin: const EdgeInsets.all(200),
                  child: GestureDetector(
                    onTapUp: (details) => _handleTap(details, canvasSize),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: canvasSize,
                          painter: VocationalMapPainter(
                            clusters: sampleClusters,
                            animationValue: _animationController.value,
                            selectedStudent: _selectedStudent,
                            selectedCluster: _selectedCluster,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInfoPanel(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildHeader() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mapa vocacional',
            style: TextStyle(color: const Color(0xFF1D1B4B), fontSize: 17.sp, fontWeight: FontWeight.w600),
          ),
          Text(
            '6° semestre A  ·  28 alumnos  ·  4 clusters',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.fit_screen_rounded, color: Color(0xFF311B92)),
          onPressed: _resetZoom,
        ),
      ],
      shape: Border(bottom: BorderSide(color: Colors.grey.shade100)),
    );
  }

  Widget _buildLegend() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: sampleClusters.length,
        itemBuilder: (context, index) {
          final cluster = sampleClusters[index];
          final isSelected = _selectedCluster?.id == cluster.id;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedCluster = null;
                } else {
                  _selectedCluster = cluster;
                }
                _selectedStudent = null;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: cluster.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${cluster.name} (${cluster.students.length})',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isSelected ? cluster.color : Colors.grey.shade500,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoPanel() {
    final bool hasSelection = _selectedStudent != null || _selectedCluster != null;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      height: hasSelection ? 130.h : 0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
        boxShadow: [
          if (hasSelection)
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: _selectedStudent != null ? _buildStudentInfo() : _buildClusterInfo(),
      ),
    );
  }

  Widget _buildStudentInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: _selectedCluster?.color ?? Colors.grey,
          child: Text(
            _selectedStudent!.id,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_selectedStudent!.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              Text(_selectedCluster?.name ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp)),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              Text('Ver expediente', style: TextStyle(color: const Color(0xFF311B92), fontWeight: FontWeight.bold, fontSize: 13.sp)),
              const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF311B92)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClusterInfo() {
    if (_selectedCluster == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_selectedCluster!.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: _selectedCluster!.color)),
            Text('${_selectedCluster!.students.length} alumnos', style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp)),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          _selectedCluster!.insight,
          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700, height: 1.3),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// --- CUSTOM PAINTER ---

class VocationalMapPainter extends CustomPainter {
  final List<VocationalCluster> clusters;
  final double animationValue;
  final StudentPoint? selectedStudent;
  final VocationalCluster? selectedCluster;

  VocationalMapPainter({
    required this.clusters,
    required this.animationValue,
    this.selectedStudent,
    this.selectedCluster,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    _drawAxes(canvas, size);
    _drawLabels(canvas, size);

    // Animación para el radio de los puntos
    final double elasticScale = Curves.elasticOut.transform(animationValue);

    // CAPA 1: BLOB DEL CLUSTER
    for (var cluster in clusters) {
      final centroid = cluster.getCentroid();
      final offset = Offset(centroid.dx * size.width, centroid.dy * size.height);
      
      double maxDist = 0;
      for (var s in cluster.students) {
        final dist = sqrt(pow(s.x - centroid.dx, 2) + pow(s.y - centroid.dy, 2));
        if (dist > maxDist) maxDist = dist;
      }

      final double radius = (maxDist * size.width + 52) * animationValue;
      
      // Dibujar Blob (Fill)
      final fillPaint = Paint()
        ..color = cluster.color.withValues(alpha: 0.07)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(offset, radius, fillPaint);

      // Dibujar Borde Punteado
      final strokePaint = Paint()
        ..color = cluster.color.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      
      _drawDashedCircle(canvas, offset, radius, strokePaint);

      // CAPA 2: ETIQUETA DEL CLUSTER
      _drawClusterLabel(canvas, cluster, offset, cluster.color.withValues(alpha: 0.6));
    }

    // CAPA 3: PUNTOS DE ALUMNO
    for (var cluster in clusters) {
      for (var student in cluster.students) {
        final double px = student.x * size.width;
        final double py = student.y * size.height;
        final bool isSelected = selectedStudent == student;
        final double dotRadius = (isSelected ? 20.0 : 15.0) * elasticScale;

        final pos = Offset(px, py);

        // Sombra
        final shadowPaint = Paint()
          ..color = Colors.black.withValues(alpha: 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
        canvas.drawCircle(pos.translate(0, 2), dotRadius, shadowPaint);

        // Selección highlight
        if (isSelected) {
          final ringPaint = Paint()
            ..color = cluster.color.withValues(alpha: 0.2)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(pos, dotRadius + 6, ringPaint);
        }

        // Círculo principal
        final mainPaint = Paint()
          ..color = cluster.color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, dotRadius, mainPaint);

        // Borde blanco
        final borderPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawCircle(pos, dotRadius, borderPaint);

        // Iniciales
        final textPainter = TextPainter(
          text: TextSpan(
            text: student.id,
            style: TextStyle(
              color: Colors.white,
              fontSize: dotRadius * 0.6,
              fontWeight: FontWeight.w800,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, pos - Offset(textPainter.width / 2, textPainter.height / 2));
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF0F0F0)
      ..strokeWidth = 1.0;

    for (int i = 1; i < 6; i++) {
      double x = (size.width / 6) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      double y = (size.height / 6) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawAxes(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1.5;

    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
  }

  void _drawLabels(Canvas canvas, Size size) {
    const textStyle = TextStyle(color: Color(0xFFCCCCCC), fontSize: 9, fontWeight: FontWeight.w400);
    
    void drawLabel(String text, Offset pos, Alignment align) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      
      Offset finalPos = pos;
      if (align == Alignment.topLeft) finalPos = pos;
      if (align == Alignment.topRight) finalPos = Offset(pos.dx - tp.width, pos.dy);
      if (align == Alignment.bottomLeft) finalPos = Offset(pos.dx, pos.dy - tp.height);
      if (align == Alignment.bottomRight) finalPos = Offset(pos.dx - tp.width, pos.dy - tp.height);

      tp.paint(canvas, finalPos);
    }

    drawLabel("ALTO ANÁLISIS", const Offset(10, 10), Alignment.topLeft);
    drawLabel("ALTA INTERACCIÓN SOCIAL", Offset(size.width - 10, 10), Alignment.topRight);
    drawLabel("BAJA INTERACCIÓN SOCIAL", Offset(10, size.height - 10), Alignment.bottomLeft);
    drawLabel("BAJO ANÁLISIS", Offset(size.width - 10, size.height - 10), Alignment.bottomRight);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    const double dashWidth = 5.0;
    const double dashSpace = 4.0;
    final double circumference = 2 * pi * radius;
    final int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = (i * (dashWidth + dashSpace) / circumference) * 2 * pi;
      final double endAngle = startAngle + (dashWidth / circumference) * 2 * pi;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, endAngle - startAngle, false, paint);
    }
  }

  void _drawClusterLabel(Canvas canvas, VocationalCluster cluster, Offset centroid, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: cluster.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    
    tp.paint(canvas, centroid - Offset(tp.width / 2, 70));
  }

  @override
  bool shouldRepaint(covariant VocationalMapPainter oldDelegate) => true;
}
</file>

<file path="features/onboarding/data/datasources/mappers/onboarding_mapper.dart">
import '../../../domain/entities/onboarding_entity.dart';
import '../models/onboarding_model.dart';

class OnboardingMapper {
  static OnboardingEntity toEntity(OnboardingModel model) {
    return OnboardingEntity(
      title: model.title,
      description: model.description,
      image: model.image,
    );
  }

  static OnboardingModel toModel(OnboardingEntity entity) {
    return OnboardingModel(
      title: entity.title,
      description: entity.description,
      image: entity.image,
    );
  }
}
</file>

<file path="features/onboarding/data/datasources/models/onboarding_model.dart">
import '../../../domain/entities/onboarding_entity.dart';

class OnboardingModel extends OnboardingEntity {
  OnboardingModel({
    required super.title,
    required super.description,
    required super.image,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
    };
  }
}
</file>

<file path="features/onboarding/data/repositories/onboarding_repository_impl.dart">
import '../../domain/entities/onboarding_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  List<OnboardingEntity> getOnboardingData() {
    return [
      OnboardingEntity(
        title: 'Chatbot Vocacional',
        description:
        'Resuelve tus dudas sobre carreras, becas y universidades con ayuda inmediata y personalizada.',
        image: 'assets/images/onboarding1.png',
      ),
      OnboardingEntity(
        title: 'Carreras y Universidades',
        description:
        'Recibe recomendaciones según tus intereses y descubre opciones que sí van contigo.',
        image: 'assets/images/onboarding2.png',
      ),
      OnboardingEntity(
        title: 'Acompañamiento del Orientador',
        description:
        'No estás solo: recibe apoyo y seguimiento durante todo tu proceso vocacional.',
        image: 'assets/images/onboarding3.png',
      ),
    ];
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return false;
  }

  @override
  Future<void> setOnboardingCompleted() async {}
}
</file>

<file path="features/onboarding/domain/entities/onboarding_entity.dart">
class OnboardingEntity {
  final String title;
  final String description;
  final String image;

  OnboardingEntity({
    required this.title,
    required this.description,
    required this.image,
  });
}
</file>

<file path="features/onboarding/domain/repositories/onboarding_repository.dart">
import '../entities/onboarding_entity.dart';

abstract class OnboardingRepository {
  List<OnboardingEntity> getOnboardingData();
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted();
}
</file>

<file path="features/onboarding/domain/usecases/complete_onboarding_usecase.dart">
import '../repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository repository;

  CompleteOnboardingUseCase(this.repository);

  Future<void> call() {
    return repository.setOnboardingCompleted();
  }
}
</file>

<file path="features/onboarding/domain/usecases/get_onboarding_data.dart">
import '../entities/onboarding_entity.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingData {
  final OnboardingRepository repository;

  GetOnboardingData(this.repository);

  List<OnboardingEntity> call() {
    return repository.getOnboardingData();
  }
}
</file>

<file path="features/onboarding/presentation/components/onboarding_item.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_entity.dart';

class OnboardingItem extends StatelessWidget {
  final OnboardingEntity item;

  const OnboardingItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.42,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 25,
                  right: 20,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5D9).withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 25,
                  left: 15,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDE7F6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                Container(
                  width: size.width * 0.78,
                  height: size.height * 0.34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: Image.asset(
                      item.image,
                      fit: BoxFit.cover,
                      excludeFromSemantics: true,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 45),

          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1D1B4B),
              height: 1.1,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
</file>

<file path="features/onboarding/presentation/providers/onboarding_provider.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../../domain/usecases/get_onboarding_data.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';

class OnboardingProvider extends ChangeNotifier {
  final GetOnboardingData _getOnboardingData;
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  List<OnboardingEntity> _items = [];
  int _currentIndex = 0;
  bool _isCompleted = false;

  OnboardingProvider({
    required this._getOnboardingData,
    required this._completeOnboardingUseCase,
  });

  List<OnboardingEntity> get items {
    if (_items.isEmpty) {
      _items = _getOnboardingData();
    }
    return _items;
  }

  int get currentIndex => _currentIndex;

  bool get isCompleted => _isCompleted;

  bool get isLastPage => _currentIndex == items.length - 1;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _completeOnboardingUseCase();
    _isCompleted = true;
    notifyListeners();
  }
}
</file>

<file path="features/onboarding/presentation/screens/onboarding_screen.dart">
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/onboarding_item.dart';
import '../../domain/entities/onboarding_entity.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingEntity> _items = [
    OnboardingEntity(
      title: 'Chatbot Vocacional',
      description: 'Resuelve tus dudas sobre carreras, becas y universidades con ayuda inmediata.',
      image: 'assets/images/onboarding1.png',
    ),
    OnboardingEntity(
      title: 'Carreras y Universidades',
      description: 'Recibe recomendaciones según tus intereses y descubre opciones para ti.',
      image: 'assets/images/onboarding2.png',
    ),
    OnboardingEntity(
      title: 'Acompañamiento',
      description: 'No estás solo: recibe apoyo durante todo tu proceso vocacional.',
      image: 'assets/images/onboarding3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    context.go('/login');
  }

  void _nextPage() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF311B92);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _goToLogin,
                    child: const Text('Saltar', style: TextStyle(color: Color(0xFF1D1B4B), fontWeight: FontWeight.w700, fontSize: 18)),
                  ),
                  Row(
                    children: List.generate(_items.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 28 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? primaryPurple : const Color(0xFFD1D5DB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 70),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => OnboardingItem(item: _items[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Text(_currentPage < _items.length - 1 ? 'Continuar' : 'Comenzar', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
</file>

<file path="features/onboarding/presentation/screens/splash_screen.dart">
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();

    // Navegación segura Navigation 2.0
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        if (mounted) context.go('/onboarding');
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFF5F3FF)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                const Spacer(flex: 3),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200.w),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: ScaleTransition(
                        scale: _scale,
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF311B92).withValues(alpha: 0.05)),
                          child: Icon(Icons.explore_rounded, size: 90.sp, color: const Color(0xFF311B92)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text('Oriéntate+', style: TextStyle(fontSize: 42.sp, fontWeight: FontWeight.w900, color: const Color(0xFF1D1B4B), letterSpacing: -1.5)),
                const Spacer(flex: 2),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.2.sw),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: const LinearProgressIndicator(backgroundColor: Color(0xFFE0E7FF), valueColor: AlwaysStoppedAnimation(Color(0xFF311B92))),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            );
          },
        ),
      ),
    );
  }
}
</file>

<file path="features/student/data/datasources/mappers/student_mapper.dart">
import '../../../domain/entities/alumni_entity.dart';
import '../../../domain/entities/career_entity.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/entities/scholarship_entity.dart';
import '../../../domain/entities/student_profile_entity.dart';
import '../../../domain/entities/university_entity.dart';
import '../../../domain/entities/vocational_result_entity.dart';

import '../models/alumni_model.dart';
import '../models/career_model.dart';
import '../models/event_model.dart';
import '../models/scholarship_model.dart';
import '../models/student_profile_model.dart';
import '../models/university_model.dart';
import '../models/vocational_result_model.dart';

class StudentMapper {
  static StudentProfileEntity toProfileEntity(StudentProfileModel model) {
    return StudentProfileEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      profileImageUrl: model.profileImageUrl,
      groupName: model.groupName,
      groupCode: model.groupCode,
      subjectsLiked: model.subjectsLiked,
      subjectsDisliked: model.subjectsDisliked,
      interests: model.interests,
      skills: model.skills,
      needsScholarship: model.needsScholarship,
      studyAbroad: model.studyAbroad,
      vocationalClarity: model.vocationalClarity,
    );
  }

  static VocationalResultEntity toVocationalResultEntity(
      VocationalResultModel model,
      ) {
    return VocationalResultEntity(
      id: model.id,
      date: model.date,
      topCareer: model.topCareer,
      scores: model.scores,
    );
  }

  static CareerEntity toCareerEntity(CareerModel model) {
    return CareerEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      fields: model.fields,
    );
  }

  static UniversityEntity toUniversityEntity(UniversityModel model) {
    return UniversityEntity(
      id: model.id,
      name: model.name,
      location: model.location,
      logoUrl: model.logoUrl,
      availableCareers: model.availableCareers,
    );
  }

  static ScholarshipEntity toScholarshipEntity(ScholarshipModel model) {
    return ScholarshipEntity(
      id: model.id,
      title: model.title,
      provider: model.provider,
      description: model.description,
      amount: model.amount,
    );
  }

  static EventEntity toEventEntity(EventModel model) {
    return EventEntity(
      id: model.id,
      title: model.title,
      date: model.date,
      location: model.location,
      description: model.description,
    );
  }

  static AlumniEntity toAlumniEntity(AlumniModel model) {
    return AlumniEntity(
      id: model.id,
      name: model.name,
      career: model.career,
      university: model.university,
      currentJob: model.currentJob,
      profileImageUrl: model.profileImageUrl,
    );
  }
}
</file>

<file path="features/student/data/datasources/models/alumni_model.dart">
import '../../../domain/entities/alumni_entity.dart';

class AlumniModel extends AlumniEntity {
  AlumniModel({
    required super.id,
    required super.name,
    required super.career,
    required super.university,
    required super.currentJob,
    super.profileImageUrl,
  });

  factory AlumniModel.fromJson(Map<String, dynamic> json) {
    return AlumniModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      career: json['career'] ?? '',
      university: json['university'] ?? '',
      currentJob: json['currentJob'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'career': career,
      'university': university,
      'currentJob': currentJob,
      'profileImageUrl': profileImageUrl,
    };
  }
}
</file>

<file path="features/student/data/datasources/models/career_model.dart">
import '../../../domain/entities/career_entity.dart';

class CareerModel extends CareerEntity {
  CareerModel({
    required super.id,
    required super.name,
    required super.description,
    required super.fields,
  });

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    return CareerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      fields: List<String>.from(json['fields'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fields': fields,
    };
  }
}
</file>

<file path="features/student/data/datasources/models/event_model.dart">
import '../../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  EventModel({
    required super.id,
    required super.title,
    required super.date,
    required super.location,
    required super.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: DateTime.parse(json['date']),
      location: json['location'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
    };
  }
}
</file>

<file path="features/student/data/datasources/models/scholarship_model.dart">
import '../../../domain/entities/scholarship_entity.dart';

class ScholarshipModel extends ScholarshipEntity {
  ScholarshipModel({
    required super.id,
    required super.title,
    required super.provider,
    required super.description,
    super.amount,
  });

  factory ScholarshipModel.fromJson(Map<String, dynamic> json) {
    return ScholarshipModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      provider: json['provider'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'provider': provider,
      'description': description,
      'amount': amount,
    };
  }
}
</file>

<file path="features/student/data/datasources/models/student_profile_model.dart">
import '../../../domain/entities/student_profile_entity.dart';

class StudentProfileModel extends StudentProfileEntity {
  StudentProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.profileImageUrl,
    super.groupName,
    super.groupCode,
    super.subjectsLiked,
    super.subjectsDisliked,
    super.interests,
    super.skills,
    super.needsScholarship,
    super.studyAbroad,
    super.vocationalClarity,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    final student = _asMap(json['student']);
    final user = _asMap(json['user']);
    final profile = _asMap(json['profile']);
    final group = _asMap(json['group']);
    final schoolGroup = _asMap(json['schoolGroup']);

    final firstName = _str(
      json['firstName'] ??
          user['firstName'] ??
          student['firstName'] ??
          profile['firstName'],
    );

    final lastName = _str(
      json['lastName'] ??
          user['lastName'] ??
          student['lastName'] ??
          profile['lastName'],
    );

    final fullName = _str(
      json['name'] ??
          json['fullName'] ??
          json['studentName'] ??
          user['name'] ??
          user['fullName'] ??
          student['name'] ??
          student['fullName'] ??
          profile['name'] ??
          profile['fullName'],
    );

    final name = fullName.isNotEmpty
        ? fullName
        : '$firstName $lastName'.trim().isNotEmpty
        ? '$firstName $lastName'.trim()
        : 'Estudiante';

    return StudentProfileModel(
      id: _str(
        json['id'] ??
            json['studentId'] ??
            json['userId'] ??
            student['id'] ??
            user['id'] ??
            profile['id'],
      ),
      name: name,
      email: _str(
        json['email'] ??
            json['studentEmail'] ??
            user['email'] ??
            student['email'] ??
            profile['email'],
        fallback: 'Sin correo',
      ),
      profileImageUrl: _nullableStr(
        json['profileImageUrl'] ??
            json['avatarUrl'] ??
            json['photoUrl'] ??
            user['profileImageUrl'] ??
            user['avatarUrl'] ??
            user['photoUrl'] ??
            student['profileImageUrl'] ??
            profile['profileImageUrl'],
      ),
      groupName: _nullableStr(
        json['groupName'] ??
            json['group_name'] ??
            group['name'] ??
            group['groupName'] ??
            schoolGroup['name'],
      ),
      groupCode: _nullableStr(
        json['groupCode'] ??
            json['accessCode'] ??
            json['group_code'] ??
            group['accessCode'] ??
            group['code'] ??
            schoolGroup['accessCode'],
      ),
      subjectsLiked: _toStringList(
        json['subjectsLiked'] ??
            profile['subjectsLiked'] ??
            json['favoriteSubjects'],
      ),
      subjectsDisliked: _toStringList(
        json['subjectsDisliked'] ?? profile['subjectsDisliked'],
      ),
      interests: _toStringList(
        json['interests'] ??
            profile['interests'] ??
            student['interests'],
      ),
      skills: _toStringList(
        json['skills'] ??
            profile['skills'] ??
            student['skills'],
      ),
      needsScholarship: json['needsScholarship'] == true ||
          profile['needsScholarship'] == true,
      studyAbroad: json['studyAbroad'] == true || profile['studyAbroad'] == true,
      vocationalClarity: _toInt(
        json['vocationalClarity'] ??
            profile['vocationalClarity'] ??
            student['vocationalClarity'] ??
            json['clarity'],
        fallback: 1,
      ).clamp(1, 10),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectsLiked': subjectsLiked,
      'subjectsDisliked': subjectsDisliked,
      'interests': interests,
      'skills': skills,
      'needsScholarship': needsScholarship,
      'studyAbroad': studyAbroad,
      'vocationalClarity': vocationalClarity,
    };
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  static String _str(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  static String? _nullableStr(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
</file>

<file path="features/student/data/datasources/models/university_model.dart">
import '../../../domain/entities/university_entity.dart';

class UniversityModel extends UniversityEntity {
  UniversityModel({
    required super.id,
    required super.name,
    required super.location,
    super.logoUrl,
    required super.availableCareers,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      logoUrl: json['logoUrl'],
      availableCareers: List<String>.from(json['availableCareers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'logoUrl': logoUrl,
      'availableCareers': availableCareers,
    };
  }
}
</file>

<file path="features/student/data/datasources/models/vocational_result_model.dart">
import '../../../domain/entities/vocational_result_entity.dart';

class VocationalResultModel extends VocationalResultEntity {
  VocationalResultModel({
    required super.id,
    required super.date,
    required super.topCareer,
    required super.scores,
  });

  factory VocationalResultModel.fromJson(Map<String, dynamic> json) {
    // Manejo robusto de los puntajes para asegurar que sean double
    final Map<String, dynamic> rawScores = json['scores'] ?? {};
    final Map<String, double> processedScores = rawScores.map(
      (key, value) => MapEntry(key, (value is num) ? value.toDouble() : 0.0),
    );

    return VocationalResultModel(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      topCareer: json['topCareer'] ?? '',
      scores: processedScores,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'topCareer': topCareer,
      'scores': scores,
    };
  }
}
</file>

<file path="features/student/data/repositories/student_repository_impl.dart">
import 'package:flutter/material.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

import '../../domain/entities/alumni_entity.dart';
import '../../domain/entities/career_entity.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/scholarship_entity.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/entities/university_entity.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/repositories/student_repository.dart';

import '../datasources/models/student_profile_model.dart';
import '../datasources/models/vocational_result_model.dart';

class StudentRepositoryImpl implements StudentRepository {
  final IApi api;
  final UserService userService;

  StudentRepositoryImpl({
    required this.api,
    required this.userService,
  });

  @override
  Future<StudentProfileEntity> getProfile() async {
    final token = await userService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No hay token para obtener perfil');
    }

    final response = await api.getStudentProfile(token);

    debugPrint('XXX GET STUDENT PROFILE RESPONSE: $response');

    final dynamic data = response['data'] ?? response;

    if (data is Map<String, dynamic>) {
      return StudentProfileModel.fromJson(data);
    }

    if (data is Map) {
      return StudentProfileModel.fromJson(Map<String, dynamic>.from(data));
    }

    throw Exception('Formato inválido del perfil del estudiante');
  }

  @override
  Future<void> updateProfile(StudentProfileEntity profile) async {
    final token = await userService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No hay token para actualizar perfil');
    }

    final model = StudentProfileModel(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      profileImageUrl: profile.profileImageUrl,
      groupName: profile.groupName,
      groupCode: profile.groupCode,
      subjectsLiked: profile.subjectsLiked,
      subjectsDisliked: profile.subjectsDisliked,
      interests: profile.interests,
      skills: profile.skills,
      needsScholarship: profile.needsScholarship,
      studyAbroad: profile.studyAbroad,
      vocationalClarity: profile.vocationalClarity,
    );

    await api.updateStudentProfile(token, model.toJson());
  }

  @override
  Future<List<VocationalResultEntity>> getVocationalResults() async {
    final token = await userService.getToken();

    if (token == null || token.isEmpty) {
      return [];
    }

    final List<dynamic> data = await api.getGameResults(token);

    return data
        .map(
          (item) => VocationalResultModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  @override
  Future<List<CareerEntity>> getRecommendedCareers() async {
    return [];
  }

  @override
  Future<List<UniversityEntity>> getCompatibleUniversities() async {
    return [];
  }

  @override
  Future<void> saveFavorite(String id, String type) async {}

  @override
  Future<void> requestCounselorSupport(String message) async {}

  @override
  Future<List<ScholarshipEntity>> getScholarships() async {
    return [];
  }

  @override
  Future<List<EventEntity>> getEvents() async {
    return [];
  }

  @override
  Future<List<AlumniEntity>> getAlumni() async {
    return [];
  }
}
</file>

<file path="features/student/domain/entities/alumni_entity.dart">
class AlumniEntity {
  final String id;
  final String name;
  final String career;
  final String university;
  final String currentJob;
  final String? profileImageUrl;

  AlumniEntity({
    required this.id,
    required this.name,
    required this.career,
    required this.university,
    required this.currentJob,
    this.profileImageUrl,
  });
}
</file>

<file path="features/student/domain/entities/career_entity.dart">
class CareerEntity {
  final String id;
  final String name;
  final String description;
  final List<String> fields;

  CareerEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.fields,
  });
}
</file>

<file path="features/student/domain/entities/event_entity.dart">
class EventEntity {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final String description;

  EventEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
  });
}
</file>

<file path="features/student/domain/entities/scholarship_entity.dart">
class ScholarshipEntity {
  final String id;
  final String title;
  final String provider;
  final String description;
  final double? amount;

  ScholarshipEntity({
    required this.id,
    required this.title,
    required this.provider,
    required this.description,
    this.amount,
  });
}
</file>

<file path="features/student/domain/entities/student_profile_entity.dart">
class StudentProfileEntity {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;

  final String? groupName;
  final String? groupCode;

  final List<String> subjectsLiked;
  final List<String> subjectsDisliked;
  final List<String> interests;
  final List<String> skills;

  final bool needsScholarship;
  final bool studyAbroad;
  final int vocationalClarity;

  StudentProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.groupName,
    this.groupCode,
    this.subjectsLiked = const [],
    this.subjectsDisliked = const [],
    this.interests = const [],
    this.skills = const [],
    this.needsScholarship = false,
    this.studyAbroad = false,
    this.vocationalClarity = 1,
  });

  StudentProfileEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    String? groupName,
    String? groupCode,
    List<String>? subjectsLiked,
    List<String>? subjectsDisliked,
    List<String>? interests,
    List<String>? skills,
    bool? needsScholarship,
    bool? studyAbroad,
    int? vocationalClarity,
  }) {
    return StudentProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      groupName: groupName ?? this.groupName,
      groupCode: groupCode ?? this.groupCode,
      subjectsLiked: subjectsLiked ?? this.subjectsLiked,
      subjectsDisliked: subjectsDisliked ?? this.subjectsDisliked,
      interests: interests ?? this.interests,
      skills: skills ?? this.skills,
      needsScholarship: needsScholarship ?? this.needsScholarship,
      studyAbroad: studyAbroad ?? this.studyAbroad,
      vocationalClarity: vocationalClarity ?? this.vocationalClarity,
    );
  }
}
</file>

<file path="features/student/domain/entities/university_entity.dart">
class UniversityEntity {
  final String id;
  final String name;
  final String location;
  final String? logoUrl;
  final List<String> availableCareers;

  UniversityEntity({
    required this.id,
    required this.name,
    required this.location,
    this.logoUrl,
    required this.availableCareers,
  });
}
</file>

<file path="features/student/domain/entities/vocational_result_entity.dart">
class VocationalResultEntity {
  final String id;
  final String date;
  final String topCareer;
  final Map<String, double> scores;

  VocationalResultEntity({
    required this.id,
    required this.date,
    required this.topCareer,
    required this.scores,
  });
}
</file>

<file path="features/student/domain/repositories/student_repository.dart">
import '../entities/student_profile_entity.dart';
import '../entities/vocational_result_entity.dart';
import '../entities/career_entity.dart';
import '../entities/university_entity.dart';
import '../entities/scholarship_entity.dart';
import '../entities/event_entity.dart';
import '../entities/alumni_entity.dart';

abstract class StudentRepository {
  Future<StudentProfileEntity> getProfile();
  Future<void> updateProfile(StudentProfileEntity profile);
  Future<List<VocationalResultEntity>> getVocationalResults();
  Future<List<CareerEntity>> getRecommendedCareers();
  Future<List<UniversityEntity>> getCompatibleUniversities();
  Future<void> saveFavorite(String id, String type);
  Future<void> requestCounselorSupport(String message);
  Future<List<ScholarshipEntity>> getScholarships();
  Future<List<EventEntity>> getEvents();
  Future<List<AlumniEntity>> getAlumni();
}
</file>

<file path="features/student/domain/usecases/get_compatible_universities_usecase.dart">
import '../entities/university_entity.dart';
import '../repositories/student_repository.dart';

class GetCompatibleUniversitiesUseCase {
  final StudentRepository repository;

  GetCompatibleUniversitiesUseCase(this.repository);

  Future<List<UniversityEntity>> call() {
    return repository.getCompatibleUniversities();
  }
}
</file>

<file path="features/student/domain/usecases/get_recommended_careers_usecase.dart">
import '../entities/career_entity.dart';
import '../repositories/student_repository.dart';

class GetRecommendedCareersUseCase {
  final StudentRepository repository;

  GetRecommendedCareersUseCase(this.repository);

  Future<List<CareerEntity>> call() {
    return repository.getRecommendedCareers();
  }
}
</file>

<file path="features/student/domain/usecases/get_student_profile_usecase.dart">
import '../entities/student_profile_entity.dart';
import '../repositories/student_repository.dart';

class GetStudentProfileUseCase {
  final StudentRepository repository;

  GetStudentProfileUseCase(this.repository);

  Future<StudentProfileEntity> call() {
    return repository.getProfile();
  }
}
</file>

<file path="features/student/domain/usecases/get_vocational_results_usecase.dart">
import '../entities/vocational_result_entity.dart';
import '../repositories/student_repository.dart';

class GetVocationalResultsUseCase {
  final StudentRepository repository;

  GetVocationalResultsUseCase(this.repository);

  Future<List<VocationalResultEntity>> call() {
    return repository.getVocationalResults();
  }
}
</file>

<file path="features/student/domain/usecases/request_counselor_support_usecase.dart">
import '../repositories/student_repository.dart';

class RequestCounselorSupportUseCase {
  final StudentRepository repository;

  RequestCounselorSupportUseCase(this.repository);

  Future<void> call(String message) {
    return repository.requestCounselorSupport(message);
  }
}
</file>

<file path="features/student/domain/usecases/save_favorite_usecase.dart">
import '../repositories/student_repository.dart';

class SaveFavoriteUseCase {
  final StudentRepository repository;

  SaveFavoriteUseCase(this.repository);

  Future<void> call(String id, String type) {
    return repository.saveFavorite(id, type);
  }
}
</file>

<file path="features/student/domain/usecases/update_student_profile_usecase.dart">
import '../entities/student_profile_entity.dart';
import '../repositories/student_repository.dart';

class UpdateStudentProfileUseCase {
  final StudentRepository repository;

  UpdateStudentProfileUseCase(this.repository);

  Future<void> call(StudentProfileEntity profile) {
    return repository.updateProfile(profile);
  }
}
</file>

<file path="features/student/presentation/components/alumni_card.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/alumni_entity.dart';

class AlumniCard extends StatelessWidget {
  final AlumniEntity alumni;
  final VoidCallback onTap;

  const AlumniCard({
    super.key,
    required this.alumni,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: alumni.profileImageUrl != null 
            ? NetworkImage(alumni.profileImageUrl!) 
            : null,
          child: alumni.profileImageUrl == null ? const Icon(Icons.person) : null,
        ),
        title: Text(alumni.name),
        subtitle: Text('${alumni.career} @ ${alumni.university}'),
        onTap: onTap,
      ),
    );
  }
}
</file>

<file path="features/student/presentation/components/career_card.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/career_entity.dart';

class CareerCard extends StatelessWidget {
  final CareerEntity career;
  final VoidCallback onTap;

  const CareerCard({
    super.key, required this.career,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(career.name),
        subtitle: Text(career.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
</file>

<file path="features/student/presentation/components/event_card.dart">
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/event_entity.dart';

class EventCard extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.event),
        title: Text(event.title),
        subtitle: Text('${DateFormat('dd/MM/yyyy').format(event.date)} - ${event.location}'),
        onTap: onTap,
      ),
    );
  }
}
</file>

<file path="features/student/presentation/components/scholarship_card.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/scholarship_entity.dart';

class ScholarshipCard extends StatelessWidget {
  final ScholarshipEntity scholarship;
  final VoidCallback onTap;

  const ScholarshipCard({
    super.key,
    required this.scholarship,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(scholarship.title),
        subtitle: Text(scholarship.provider),
        trailing: scholarship.amount != null 
          ? Text('\$${scholarship.amount!.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
          : null,
        onTap: onTap,
      ),
    );
  }
}
</file>

<file path="features/student/presentation/components/student_progress_card.dart">
import 'package:flutter/material.dart';

class StudentProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final String nextStep;

  const StudentProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.nextStep,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Text('Siguiente paso: $nextStep', style: const TextStyle(color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }
}
</file>

<file path="features/student/presentation/components/university_card.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/university_entity.dart';

class UniversityCard extends StatelessWidget {
  final UniversityEntity university;
  final VoidCallback onTap;

  const UniversityCard({
    super.key,
    required this.university,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: university.logoUrl != null 
          ? Image.network(university.logoUrl!, width: 40, height: 40)
          : const Icon(Icons.account_balance, size: 40),
        title: Text(university.name),
        subtitle: Text(university.location),
        onTap: onTap,
      ),
    );
  }
}
</file>

<file path="features/student/presentation/providers/careers_provider.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/career_entity.dart';
import '../../domain/usecases/get_recommended_careers_usecase.dart';

class CareersProvider extends ChangeNotifier {
  final GetRecommendedCareersUseCase _getRecommendedCareersUseCase;

  List<CareerEntity> _careers = [];
  bool _isLoading = false;

  CareersProvider({required this._getRecommendedCareersUseCase});

  List<CareerEntity> get careers => _careers;
  bool get isLoading => _isLoading;

  Future<void> fetchRecommendedCareers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _careers = await _getRecommendedCareersUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
</file>

<file path="features/student/presentation/providers/favorites_provider.dart">
import 'package:flutter/material.dart';
import '../../domain/usecases/save_favorite_usecase.dart';

class FavoritesProvider extends ChangeNotifier {
  final SaveFavoriteUseCase _saveFavoriteUseCase;

  final List<String> _favoriteIds = [];
  bool _isLoading = false;

  FavoritesProvider({required this._saveFavoriteUseCase});

  List<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;

  Future<void> toggleFavorite(String id, String type) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _saveFavoriteUseCase(id, type);
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);
}
</file>

<file path="features/student/presentation/providers/student_home_provider.dart">
import 'package:flutter/material.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/usecases/get_student_profile_usecase.dart';
import '../../domain/usecases/get_vocational_results_usecase.dart';
import '../../../vocational_games/domain/usecases/get_available_games_usecase.dart';

class StudentHomeProvider extends ChangeNotifier {
  final GetStudentProfileUseCase _getProfileUseCase;
  final GetVocationalResultsUseCase _getResultsUseCase;
  final GetAvailableGamesUseCase _getGamesUseCase;
  final UserService _userService;
  final IApi _api;

  StudentHomeProvider({
    required this._getProfileUseCase,
    required this._getResultsUseCase,
    required this._getGamesUseCase,
    required this._userService,
    required this._api,
  });

  StudentProfileEntity? _profile;
  List<VocationalResultEntity> _results = [];
  List<dynamic> _availableGames = [];
  List<dynamic> _studentGroups = [];

  bool _isLoading = false;
  String? _errorMessage;

  StudentProfileEntity? get profile => _profile;
  List<VocationalResultEntity> get results => _results;
  List<dynamic> get availableGames => _availableGames;
  List<dynamic> get studentGroups => _studentGroups;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasGroup => _studentGroups.isNotEmpty;

  String get firstName {
    final name = _profile?.name.trim();

    if (name != null &&
        name.isNotEmpty &&
        name.toLowerCase() != 'estudiante') {
      return name.split(' ').first;
    }

    final email = _profile?.email.trim();

    if (email != null && email.isNotEmpty) {
      final beforeAt = email.split('@').first;
      if (beforeAt.isNotEmpty) {
        return beforeAt;
      }
    }

    return 'Estudiante';
  }

  Map<String, dynamic>? get currentGroup {
    if (_studentGroups.isEmpty) return null;

    final raw = _studentGroups.first;

    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);

    return null;
  }

  String get currentGroupName {
    final group = currentGroup;

    return group?['name']?.toString() ??
        group?['groupName']?.toString() ??
        'Grupo asignado';
  }

  String get currentGroupCode {
    final group = currentGroup;

    return group?['accessCode']?.toString() ??
        group?['access_code']?.toString() ??
        group?['code']?.toString() ??
        'Sin código';
  }

  String get groupDescription {
    if (!hasGroup) {
      return 'Aún no perteneces a un grupo. Ingresa el código que te dio tu orientador.';
    }

    return 'Grupo: $currentGroupName\nCódigo: $currentGroupCode';
  }

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _loadLocalUser();

      final remoteProfile = await _safeLoadProfile();
      if (remoteProfile != null) {
        _profile = remoteProfile;
      }

      final groups = await _safeLoadStudentGroups();
      _studentGroups = groups ?? [];

      final results = await _safeLoadResults();
      if (results != null) {
        _results = results;
      }

      final games = await _safeLoadGames();
      if (games != null) {
        _availableGames = games;
      }
    } catch (e) {
      debugPrint('XXX Error StudentHomeProvider: $e');
      _errorMessage = 'No se pudo cargar la información del alumno.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> joinGroupByCode(String accessCode) async {
    final code = accessCode.trim();

    if (code.isEmpty) {
      _errorMessage = 'Ingresa el código del grupo';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _userService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('No hay sesión activa');
      }

      await _api.joinGroup(token, code);

      _studentGroups = await _api.getStudentGroups(token);

      return true;
    } catch (e) {
      final message = e.toString();

      if (message.contains('Ya eres miembro')) {
        final token = await _userService.getToken();

        if (token != null && token.isNotEmpty) {
          _studentGroups = await _api.getStudentGroups(token);
        }

        return true;
      }

      debugPrint('XXX ERROR JOIN GROUP: $e');
      _errorMessage = message.replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadLocalUser() async {
    try {
      final localUser = await _userService.getUser();

      if (localUser != null && _profile == null) {
        _profile = StudentProfileEntity(
          id: localUser.id,
          name: _cleanName(localUser.name),
          email: localUser.email,
        );
      }
    } catch (e) {
      debugPrint('XXX Usuario local no cargado: $e');
    }
  }

  Future<StudentProfileEntity?> _safeLoadProfile() async {
    try {
      final profile = await _getProfileUseCase.call();

      if (profile.name.trim().isEmpty ||
          profile.name.trim().toLowerCase() == 'estudiante') {
        return profile.copyWith(
          name: _nameFromEmail(profile.email),
        );
      }

      return profile;
    } catch (e) {
      debugPrint('XXX Perfil remoto no cargado: $e');
      return null;
    }
  }

  Future<List<dynamic>?> _safeLoadStudentGroups() async {
    try {
      final token = await _userService.getToken();

      if (token == null || token.isEmpty) {
        return [];
      }

      return await _api.getStudentGroups(token);
    } catch (e) {
      debugPrint('XXX Grupos del alumno no cargados: $e');
      return [];
    }
  }

  Future<List<VocationalResultEntity>?> _safeLoadResults() async {
    try {
      return await _getResultsUseCase.call();
    } catch (e) {
      debugPrint('XXX Resultados no cargados: $e');
      return null;
    }
  }

  Future<List<dynamic>?> _safeLoadGames() async {
    try {
      return await _getGamesUseCase.call();
    } catch (e) {
      debugPrint('XXX Juegos no cargados: $e');
      return null;
    }
  }

  String _cleanName(String? value) {
    final name = value?.trim();

    if (name == null || name.isEmpty) {
      return 'Estudiante';
    }

    if (name.toLowerCase() == 'estudiante') {
      return 'Estudiante';
    }

    return name;
  }

  String _nameFromEmail(String email) {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty) {
      return 'Estudiante';
    }

    final beforeAt = cleanEmail.split('@').first;

    if (beforeAt.isEmpty) {
      return 'Estudiante';
    }

    return beforeAt;
  }
}
</file>

<file path="features/student/presentation/providers/student_profile_provider.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../../domain/usecases/get_student_profile_usecase.dart';
import '../../domain/usecases/update_student_profile_usecase.dart';

class StudentProfileProvider extends ChangeNotifier {
  final GetStudentProfileUseCase _getProfileUseCase;
  final UpdateStudentProfileUseCase _updateProfileUseCase;

  StudentProfileEntity? _profile;
  bool _isLoading = false;

  StudentProfileProvider({
    required this._getProfileUseCase,
    required this._updateProfileUseCase,
  });

  StudentProfileEntity? get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _getProfileUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(StudentProfileEntity newProfile) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _updateProfileUseCase(newProfile);
      _profile = newProfile;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
</file>

<file path="features/student/presentation/providers/student_results_provider.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/usecases/get_vocational_results_usecase.dart';

class StudentResultsProvider extends ChangeNotifier {
  final GetVocationalResultsUseCase _getResultsUseCase;

  List<VocationalResultEntity> _results = [];
  bool _isLoading = false;

  StudentResultsProvider({required this._getResultsUseCase});

  List<VocationalResultEntity> get results => _results;
  bool get isLoading => _isLoading;

  Future<void> fetchResults() async {
    _isLoading = true;
    notifyListeners();
    try {
      _results = await _getResultsUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
</file>

<file path="features/student/presentation/providers/universities_provider.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/university_entity.dart';
import '../../domain/usecases/get_compatible_universities_usecase.dart';

class UniversitiesProvider extends ChangeNotifier {
  final GetCompatibleUniversitiesUseCase _getCompatibleUniversitiesUseCase;

  List<UniversityEntity> _universities = [];
  bool _isLoading = false;

  UniversitiesProvider({required this._getCompatibleUniversitiesUseCase});

  List<UniversityEntity> get universities => _universities;
  bool get isLoading => _isLoading;

  Future<void> fetchCompatibleUniversities() async {
    _isLoading = true;
    notifyListeners();
    try {
      _universities = await _getCompatibleUniversitiesUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
</file>

<file path="features/student/presentation/screens/alumni_list_screen.dart">
import 'package:flutter/material.dart';

class AlumniListScreen extends StatelessWidget {
  const AlumniListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Casos de Éxito')),
      body: const Center(child: Text('Listado de egresados (Alumni)')),
    );
  }
}
</file>

<file path="features/student/presentation/screens/career_compare_screen.dart">
import 'package:flutter/material.dart';

class CareerCompareScreen extends StatelessWidget {
  const CareerCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comparar Carreras')),
      body: const Center(child: Text('Comparador de carreras')),
    );
  }
}
</file>

<file path="features/student/presentation/screens/career_detail_screen.dart">
import 'package:flutter/material.dart';

class CareerDetailScreen extends StatelessWidget {
  const CareerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Carrera')),
      body: const Center(child: Text('Detalle de la carrera seleccionada')),
    );
  }
}
</file>

<file path="features/student/presentation/screens/CareersScreen.dart">
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/careers_provider.dart';
import '../providers/favorites_provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

class CareersScreen extends StatefulWidget {
  const CareersScreen({super.key});

  @override
  State<CareersScreen> createState() => _CareersScreenState();
}

class _CareersScreenState extends State<CareersScreen> {
  static const Color primaryColor = Color(0xFF3B0A57);
  static const Color darkText = Color(0xFF1D1B4B);
  static const Color bgColor = Color(0xFFF8F9FE);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CareersProvider>().fetchRecommendedCareers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CareersProvider>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Carreras recomendadas',
          style: TextStyle(
            color: darkText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : ListView(
        padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 28.h),
        children: [
          Text(
            'Tu Futuro Te Espera',
            style: TextStyle(
              color: darkText,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Basado en tus pruebas vocacionales y perfil actual, estas son las opciones que mejor se alinean contigo.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12.sp,
              height: 1.3,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _searchBox(),
          SizedBox(height: 18.h),
          _statsRow(),
          SizedBox(height: 18.h),
          _careerCard(
            id: 'ia',
            area: 'Tecnología',
            title: 'Ingeniería en Inteligencia Artificial',
            percent: '98%',
            description:
            'Tu alto desempeño en lógica y matemáticas indica una afinidad fuerte con tecnología avanzada.',
            tags: [
              'Pensamiento analítico',
              'Resolución de problemas',
              'Interés tecnológico',
            ],
          ),
          _careerCard(
            id: 'psicologia',
            area: 'Sociales',
            title: 'Psicología Organizacional',
            percent: '85%',
            description:
            'Tus habilidades interpersonales y liderazgo sugieren potencial para gestionar talento humano.',
            tags: [
              'Empatía',
              'Liderazgo',
              'Comunicación asertiva',
            ],
          ),
          _careerCard(
            id: 'ux',
            area: 'Arte y Diseño',
            title: 'Diseño de Experiencia de Usuario (UX)',
            percent: '78%',
            description:
            'Combina creatividad visual con análisis para crear soluciones centradas en personas.',
            tags: [
              'Creatividad',
              'Atención al detalle',
              'Pensamiento crítico',
            ],
          ),
          _chatHelpCard(),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[500], size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por carrera o área...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          Icon(Icons.tune_rounded, color: Colors.grey[600], size: 20.sp),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _statBox(
            icon: Icons.track_changes_rounded,
            title: 'CLARIDAD',
            value: 'Alta Precisión',
            color: const Color(0xFF4285F4),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _statBox(
            icon: Icons.business_center_outlined,
            title: 'MERCADO',
            value: 'Demanda Creciente',
            color: const Color(0xFF9333EA),
          ),
        ),
      ],
    );
  }

  Widget _statBox({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 23.sp),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: darkText,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _careerCard({
    required String id,
    required String area,
    required String title,
    required String percent,
    required String description,
    required List<String> tags,
  }) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFavorite = favoritesProvider.isFavorite(id);

    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 5.h,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          SizedBox(height: 13.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  area,
                  style: TextStyle(
                    color: const Color(0xFF2563EB),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '$percent\nCOMPATIBILIDAD',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF2563EB),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              color: darkText,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFE0E7FF)),
            ),
            child: Text(
              '¿POR QUÉ ES PARA TI?\n$description',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 11.sp,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Perfil de ingreso clave:',
            style: TextStyle(
              color: darkText,
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: tags.map((tag) {
              return Chip(
                label: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                backgroundColor: const Color(0xFFF3F4F6),
                side: BorderSide.none,
              );
            }).toList(),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                  ),
                  child: const Text(
                    'Ver detalle  →',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              InkWell(
                onTap: () => favoritesProvider.toggleFavorite(id, 'career'),
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.25)),
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.redAccent : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatHelpCard() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [Color(0xFFE040FB), Color(0xFF4B5CFF)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Aún no estás seguro?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Habla con nuestro ChatBot vocacional para resolver dudas específicas sobre estas carreras.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11.sp,
              height: 1.3,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.chat.path),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                elevation: 0,
              ),
              child: const Text(
                'Consultar con IA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
</file>

<file path="features/student/presentation/screens/events_screen.dart">
import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Próximos Eventos')),
      body: const Center(child: Text('Calendario de eventos vocacionales')),
    );
  }
}
</file>

<file path="features/student/presentation/screens/favorites_screen.dart">
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body: const Center(child: Text('Carreras y universidades guardadas')),
    );
  }
}
</file>

<file path="features/student/presentation/screens/request_support_screen.dart">
import 'package:flutter/material.dart';

class RequestSupportScreen extends StatelessWidget {
  const RequestSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Apoyo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Escribe tu duda para un orientador profesional.'),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe en qué necesitas ayuda...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Enviar Solicitud'),
            ),
          ],
        ),
      ),
    );
  }
}
</file>

<file path="features/student/presentation/screens/scholarships_screen.dart">
import 'package:flutter/material.dart';

class ScholarshipsScreen extends StatelessWidget {
  const ScholarshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Becas Disponibles')),
      body: const Center(child: Text('Listado de becas')),
    );
  }
}
</file>

<file path="features/student/presentation/screens/student_home_screen.dart">
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:orientate/features/student/presentation/providers/student_home_provider.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);
  static const Color bgColor = Color(0xFFF8F9FE);

  final PageController _careerController = PageController(viewportFraction: 1);
  int _currentCareer = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StudentHomeProvider>().loadHomeData();
    });
  }

  @override
  void dispose() {
    _careerController.dispose();
    super.dispose();
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  void _showAccountOptions(StudentHomeProvider homeProvider) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    final profile = homeProvider.profile;

    final name = user?.name?.trim().isNotEmpty == true
        ? user!.name!
        : profile?.name ?? 'Estudiante';

    final email = user?.email.trim().isNotEmpty == true
        ? user!.email
        : profile?.email ?? 'Sin correo';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 28.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundColor: const Color(0xFFF0EAFE),
                      child: Icon(
                        Icons.person_rounded,
                        color: primaryColor,
                        size: 32.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información de registro',
                            style: TextStyle(
                              color: darkText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Datos de tu cuenta',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                _registrationInfoItem(
                  icon: Icons.badge_outlined,
                  label: 'Nombre',
                  value: name,
                ),
                _registrationInfoItem(
                  icon: Icons.email_outlined,
                  label: 'Correo',
                  value: email,
                ),
                _registrationInfoItem(
                  icon: Icons.school_outlined,
                  label: 'Tipo de cuenta',
                  value: 'Estudiante',
                ),
                _registrationInfoItem(
                  icon: Icons.groups_2_outlined,
                  label: 'Grupo escolar',
                  value: homeProvider.hasGroup
                      ? homeProvider.currentGroupName
                      : 'Sin grupo asignado',
                ),
                _registrationInfoItem(
                  icon: Icons.vpn_key_outlined,
                  label: 'Código de grupo',
                  value: homeProvider.hasGroup
                      ? homeProvider.currentGroupCode
                      : 'Sin código',
                ),
                SizedBox(height: 12.h),
                const Divider(),
                SizedBox(height: 8.h),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await authProvider.logout();
                    if (mounted) context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registrationInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: darkText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentHomeProvider>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Oriéntate+',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () => _showAccountOptions(provider),
          ),
        ],
      ),
      body: provider.isLoading && provider.profile == null
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _buildBody(provider),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00A6A6),
        elevation: 8,
        onPressed: () => context.push(AppRoutes.chat.path),
        child: const Icon(
          Icons.smart_toy_rounded,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBody(StudentHomeProvider provider) {
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: provider.loadHomeData,
      child: ListView(
        padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 26.h),
        children: [
          _buildGreeting(),
          SizedBox(height: 18.h),
          _buildExpoCard(),
          SizedBox(height: 16.h),
          _buildRecommendationsCard(),
          SizedBox(height: 16.h),
          _buildCareerCarousel(),
          SizedBox(height: 18.h),
          Text(
            'Accesos rápidos',
            style: TextStyle(
              color: darkText,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.85,
            children: [
              _quickAccessCard(
                icon: Icons.chat_bubble_outline,
                title: 'Mensajes',
                description: 'Habla con tu orientador',
                color: const Color(0xFF00A6A6),
                onTap: () => context.push(AppRoutes.chatContacts.path),
              ),
              _quickAccessCard(
                icon: Icons.school_outlined,
                title: 'Carreras',
                description: 'Explora opciones',
                color: const Color(0xFFE84A8A),
                onTap: () => _showSnack('Carreras próximamente'),
              ),
              _quickAccessCard(
                icon: Icons.account_balance_outlined,
                title: 'Universidades',
                description: 'Conoce instituciones',
                color: const Color(0xFF4285F4),
                onTap: () => _showSnack('Universidades próximamente'),
              ),
              _quickAccessCard(
                icon: Icons.event_outlined,
                title: 'Eventos',
                description: 'Ferias y actividades',
                color: const Color(0xFF00A6A6),
                onTap: () => _showSnack('Eventos próximamente'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡Hola, Estudiante! 👋',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w900,
            color: darkText,
            height: 1.05,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'Tu futuro comienza hoy.',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildExpoCard() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF24106B), Color(0xFF5D35F2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expo\nUniversidades',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Conoce carreras, becas y universidades compatibles con tu perfil.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12.sp,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 14.h),
                InkWell(
                  onTap: () => _showSnack('Expo universidades próximamente'),
                  borderRadius: BorderRadius.circular(18.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 9.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Explorar expo',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: primaryColor,
                          size: 17.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 88.w,
            height: 88.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_rounded,
              color: Colors.white,
              size: 52.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4D8),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: const Color(0xFFFFB000),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recomendaciones para ti',
                      style: TextStyle(
                        color: darkText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Acciones sugeridas para avanzar en tu camino.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _recommendationItem(
            icon: Icons.school_outlined,
            title: 'Carreras sugeridas',
            text: 'Descubre opciones según tus resultados vocacionales.',
            color: const Color(0xFFE84A8A),
          ),
          SizedBox(height: 10.h),
          _recommendationItem(
            icon: Icons.account_balance_outlined,
            title: 'Universidades compatibles',
            text: 'Encuentra instituciones que ofrecen carreras relacionadas.',
            color: const Color(0xFF4285F4),
          ),
        ],
      ),
    );
  }

  Widget _recommendationItem({
    required IconData icon,
    required String title,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: color, size: 25.sp),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: darkText,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10.5.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_right_rounded,
              color: color,
              size: 25.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerCarousel() {
    final items = [
      _CareerSlide(
        image: 'assets/images/recomendacion1.jpg',
        percent: '95% compatible',
        title: 'Ingeniería en Inteligencia Artificial',
        tags: '#Tech  #Futuro',
      ),
      _CareerSlide(
        image: 'assets/images/recomendacion2.jpg',
        percent: '88% compatible',
        title: 'Diseño de Experiencia Usuario (UX)',
        tags: '#Creativo  #Digital',
      ),
      _CareerSlide(
        image: 'assets/images/recomendacion3.jpg',
        percent: '82% compatible',
        title: 'Ingeniería en Software',
        tags: '#Código  #Innovación',
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 150.h,
          child: PageView.builder(
            controller: _careerController,
            itemCount: items.length,
            onPageChanged: (index) {
              setState(() {
                _currentCareer = index;
              });
            },
            itemBuilder: (context, index) => _careerCard(items[index]),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: _currentCareer == index ? 18.w : 7.w,
              height: 7.h,
              decoration: BoxDecoration(
                color:
                _currentCareer == index ? primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _careerCard(_CareerSlide item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              item.image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF311B92), Color(0xFF4285F4)],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 14.h,
            left: 14.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                item.percent,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 15.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  item.tags,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAccessCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(icon, color: color, size: 25.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: darkText,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10.sp,
                      height: 1.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      currentIndex: 0,
      selectedFontSize: 10.sp,
      unselectedFontSize: 10.sp,
      onTap: (index) {
        if (index == 1) context.push(AppRoutes.games.path);
        if (index == 2) context.push(AppRoutes.vocationalResults.path);
        if (index == 3) context.push(AppRoutes.studentProfile.path);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_esports_outlined),
          label: 'Minijuegos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          label: 'Resultados',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }
}

class _CareerSlide {
  final String image;
  final String percent;
  final String title;
  final String tags;

  _CareerSlide({
    required this.image,
    required this.percent,
    required this.title,
    required this.tags,
  });
}
</file>

<file path="features/student/presentation/screens/student_profile_screen.dart">
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:orientate/features/student/presentation/providers/student_profile_provider.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StudentProfileProvider>().fetchProfile();
    });
  }

  void _showPickImageOptions(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<StudentProfileProvider>();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.blue),
                ),
                title: const Text('Elegir de la galería', 
                  style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(context);
                  final success = await authProvider.updateAvatarFromGallery();
                  if (success) profileProvider.fetchProfile();
                },
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.purple),
                ),
                title: const Text('Tomar una foto', 
                  style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(context);
                  final success = await authProvider.updateAvatarFromCamera();
                  if (success) profileProvider.fetchProfile();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProfileProvider>();
    final authProvider = context.watch<AuthProvider>();
    final profile = provider.profile;
    
    final String? avatarUrl = authProvider.user?.avatarUrl ?? profile?.profileImageUrl;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Perfil Vocacional',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: provider.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : profile == null
              ? _buildEmptyState(provider)
              : Stack(
                  children: [
                    RefreshIndicator(
                      color: primaryColor,
                      onRefresh: provider.fetchProfile,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            Center(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => _showPickImageOptions(context),
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 55.r,
                                          backgroundColor: const Color(0xFFF3F4F6),
                                          backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                                              ? NetworkImage(avatarUrl)
                                              : null,
                                          child: avatarUrl == null || avatarUrl.isEmpty
                                              ? Icon(Icons.person, size: 60.sp, color: Colors.grey[400])
                                              : null,
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                            child: Icon(Icons.camera_alt, color: Colors.white, size: 16.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    profile.name.isNotEmpty ? profile.name : 'Estudiante',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: darkText),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    _subtitle(profile.groupName),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 32.h),
                            _buildSectionHeader(Icons.book_outlined, 'Materias favoritas'),
                            SizedBox(height: 12.h),
                            _buildChipList(profile.subjectsLiked, const Color(0xFFE3F2FD), Colors.blue, 'Sin materias registradas'),
                            SizedBox(height: 24.h),
                            _buildSectionHeader(Icons.block_outlined, 'Materias que no te gustan'),
                            SizedBox(height: 12.h),
                            _buildChipList(profile.subjectsDisliked, const Color(0xFFFFEBEE), Colors.redAccent, 'Sin materias registradas'),
                            SizedBox(height: 24.h),
                            _buildSectionHeader(Icons.favorite_border, 'Intereses'),
                            SizedBox(height: 12.h),
                            _buildChipList(profile.interests, const Color(0xFFF3E5F5), Colors.purple, 'Sin intereses registrados'),
                            SizedBox(height: 24.h),
                            _buildSectionHeader(Icons.lightbulb_outline, 'Habilidades'),
                            SizedBox(height: 12.h),
                            _buildChipList(profile.skills, const Color(0xFFE8F5E9), Colors.green, 'Sin habilidades registradas'),
                            SizedBox(height: 32.h),
                            Row(
                              children: [
                                Expanded(child: _buildInfoBox(Icons.school_outlined, 'BECA', profile.needsScholarship ? 'Sí necesita' : 'No necesita', Colors.purple)),
                                SizedBox(width: 16.w),
                                Expanded(child: _buildInfoBox(Icons.flight_takeoff, 'EXTRANJERO', profile.studyAbroad ? 'Le interesa' : 'No indicado', Colors.blue)),
                              ],
                            ),
                            SizedBox(height: 32.h),
                            _buildVocationalClarity(profile.vocationalClarity),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                    if (authProvider.isLoading)
                      Container(
                        color: Colors.black26,
                        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                      ),
                  ],
                ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  String _subtitle(String? groupName) {
    if (groupName != null && groupName.trim().isNotEmpty) {
      return 'Estudiante • $groupName';
    }
    return 'Estudiante • Sin grupo asignado';
  }

  Widget _buildEmptyState(StudentProfileProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, size: 60.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text('No se pudo cargar tu perfil', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: darkText)),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: provider.fetchProfile,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: primaryColor),
        SizedBox(width: 8.w),
        Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: darkText)),
      ],
    );
  }

  Widget _buildChipList(List<String> items, Color bgColor, Color textColor, String emptyText) {
    if (items.isEmpty) {
      return Text(emptyText, style: TextStyle(color: Colors.grey[500], fontSize: 13.sp));
    }
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: items.map((item) {
        return Chip(
          label: Text(item, style: TextStyle(color: textColor, fontSize: 12.sp, fontWeight: FontWeight.w600)),
          backgroundColor: bgColor,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        );
      }).toList(),
    );
  }

  Widget _buildInfoBox(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22.sp),
          SizedBox(height: 8.h),
          Text(label, style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold, color: Colors.grey[600])),
          SizedBox(height: 4.h),
          Text(value, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: darkText)),
        ],
      ),
    );
  }

  Widget _buildVocationalClarity(int clarity) {
    final value = (clarity.clamp(1, 10)) / 10;
    String label = 'Baja';
    if (clarity >= 7) label = 'Alta';
    if (clarity >= 4 && clarity < 7) label = 'Media';

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2E1A47),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Claridad vocacional', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8.r)),
                child: Text(label, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(value: value, minHeight: 12.h, backgroundColor: Colors.white24, color: Colors.white),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1', style: TextStyle(color: Colors.white70, fontSize: 11.sp)),
              Text('$clarity / 10', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              Text('10', style: TextStyle(color: Colors.white70, fontSize: 11.sp)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      currentIndex: 1,
      selectedFontSize: 10.sp,
      unselectedFontSize: 10.sp,
      onTap: (index) {
        switch (index) {
          case 0: context.go(AppRoutes.home.path); break;
          case 1: break;
          case 2: context.push(AppRoutes.games.path); break;
          case 3: context.push(AppRoutes.vocationalResults.path); break;
          case 4: break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.psychology_outlined), label: 'Perfil'),
        BottomNavigationBarItem(icon: Icon(Icons.sports_esports_outlined), label: 'Minijuegos'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Resultados'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Cuenta'),
      ],
    );
  }
}
</file>

<file path="features/student/presentation/screens/universities_screen.dart">
import 'package:flutter/material.dart';

class UniversitiesScreen extends StatelessWidget {
  const UniversitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades')),
      body: const Center(child: Text('Listado de universidades')),
    );
  }
}
</file>

<file path="features/student/presentation/screens/university_detail_screen.dart">
import 'package:flutter/material.dart';

class UniversityDetailScreen extends StatelessWidget {
  const UniversityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Universidad')),
      body: const Center(child: Text('Detalle de la universidad seleccionada')),
    );
  }
}
</file>

<file path="features/student/presentation/screens/vocational_results_screen.dart">
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:orientate/features/student/presentation/providers/student_results_provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

class VocationalResultsScreen extends StatefulWidget {
  const VocationalResultsScreen({super.key});

  @override
  State<VocationalResultsScreen> createState() =>
      _VocationalResultsScreenState();
}

class _VocationalResultsScreenState extends State<VocationalResultsScreen> {
  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);
  static const Color bgColor = Color(0xFFF8F9FE);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StudentResultsProvider>().fetchResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentResultsProvider>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Tus Resultados',
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w900,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
        color: primaryColor,
        onRefresh: provider.fetchResults,
        child: ListView(
          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 28.h),
          children: [
            _buildMainResultCard(provider),
            SizedBox(height: 22.h),
            _buildSectionHeader(
              title: 'Fortalezas Detectadas',
              action: 'Ver todas',
            ),
            SizedBox(height: 12.h),
            _strengthItem(
              icon: Icons.psychology_outlined,
              title: 'Pensamiento Lógico',
              text:
              'Capacidad excepcional para resolver problemas complejos mediante el análisis.',
              color: const Color(0xFF4285F4),
            ),
            SizedBox(height: 10.h),
            _strengthItem(
              icon: Icons.groups_2_outlined,
              title: 'Colaboración',
              text:
              'Habilidad natural para trabajar en equipos multidisciplinarios con éxito.',
              color: const Color(0xFF00A6A6),
            ),
            SizedBox(height: 10.h),
            _strengthItem(
              icon: Icons.workspace_premium_outlined,
              title: 'Atención al Detalle',
              text:
              'Alta precisión en tareas técnicas y metodológicas.',
              color: const Color(0xFF6A4CFF),
            ),
            SizedBox(height: 24.h),
            Text(
              'Intereses Principales',
              style: TextStyle(
                color: darkText,
                fontSize: 17.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 12.h),
            _buildInterestChips(),
            SizedBox(height: 26.h),
            _buildClarityCard(),
            SizedBox(height: 28.h),
            _buildCareersButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainResultCard(StudentResultsProvider provider) {
    final hasResult = provider.results.isNotEmpty;
    final topCareer = hasResult && provider.results.first.topCareer.isNotEmpty
        ? provider.results.first.topCareer
        : 'Ingeniería y STEM';

    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE040FB),
            Color(0xFF7C4DFF),
            Color(0xFF4B5CFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C4DFF).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 82.w,
            height: 82.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: Icon(
              Icons.track_changes_rounded,
              color: Colors.white,
              size: 42.sp,
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Resultado Principal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            topCareer,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tu perfil destaca por habilidades analíticas y pensamiento sistemático.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13.sp,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 22.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COMPATIBILIDAD',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '94%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 31.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String action,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: darkText,
            fontSize: 17.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        Text(
          '$action  ›',
          style: TextStyle(
            color: const Color(0xFF2563EB),
            fontSize: 11.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _strengthItem({
    required IconData icon,
    required String title,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: color, size: 23.sp),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: darkText,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10.5.sp,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChips() {
    final interests = [
      _InterestChip(
        icon: Icons.bolt_rounded,
        label: 'Tecnología',
        bg: const Color(0xFFEFF6FF),
        color: const Color(0xFF2563EB),
      ),
      _InterestChip(
        icon: Icons.data_object_rounded,
        label: 'Matemáticas',
        bg: const Color(0xFFF3E8FF),
        color: const Color(0xFF9333EA),
      ),
      _InterestChip(
        icon: Icons.emoji_events_outlined,
        label: 'Liderazgo',
        bg: const Color(0xFFFFF7ED),
        color: const Color(0xFFF97316),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: interests
            .map(
              (item) => Container(
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: item.bg,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              children: [
                Icon(item.icon, color: item.color, size: 17.sp),
                SizedBox(width: 6.w),
                Text(
                  item.label,
                  style: TextStyle(
                    color: item.color,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildClarityCard() {
    const clarity = 0.85;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.star_border_rounded,
                color: darkText,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Claridad Vocacional',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '85%',
                style: TextStyle(
                  color: const Color(0xFF2563EB),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: clarity,
              minHeight: 9.h,
              backgroundColor: const Color(0xFFF3E8FF),
              color: primaryColor,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _clarityLabel('EXPLORANDO'),
              _clarityLabel('DEFINIDO'),
              _clarityLabel('SEGURO'),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              '¡Excelente! Tus respuestas muestran una dirección muy clara hacia carreras técnicas. Estás listo para el siguiente paso.',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 11.sp,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _clarityLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 8.sp,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildCareersButton() {
    return SizedBox(
      width: double.infinity,
      height: 58.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          elevation: 0,
        ),
        onPressed: () => context.push(AppRoutes.careers.path),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ver carreras recomendadas',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: 12.w),
            Icon(Icons.arrow_forward_rounded, size: 22.sp),
          ],
        ),
      ),
    );
  }
}

class _InterestChip {
  final IconData icon;
  final String label;
  final Color bg;
  final Color color;

  _InterestChip({
    required this.icon,
    required this.label,
    required this.bg,
    required this.color,
  });
}
</file>

<file path="features/student/presentation/screens/vocational_route_screen.dart">
import 'package:flutter/material.dart';

class VocationalRouteScreen extends StatelessWidget {
  const VocationalRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Ruta Vocacional')),
      body: const Center(child: Text('Visualización del camino vocacional personalizado')),
    );
  }
}
</file>

<file path="features/university/data/datasources/mappers/university_mapper.dart">
import '../../../domain/entities/university_profile_entity.dart';
import '../../../domain/entities/university_career_entity.dart';
import '../models/university_profile_model.dart';
import '../models/university_career_model.dart';

class UniversityMapper {
  static UniversityProfileEntity toProfileEntity(UniversityProfileModel model) {
    return UniversityProfileEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      location: model.location,
      logoUrl: model.logoUrl,
      website: model.website,
    );
  }

  static UniversityCareerEntity toCareerEntity(UniversityCareerModel model) {
    return UniversityCareerEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      duration: model.duration,
      cost: model.cost,
    );
  }

  static UniversityCareerModel fromCareerEntity(UniversityCareerEntity entity) {
    return UniversityCareerModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      duration: entity.duration,
      cost: entity.cost,
    );
  }
}
</file>

<file path="features/university/data/datasources/models/university_career_model.dart">
import '../../../domain/entities/university_career_entity.dart';

class UniversityCareerModel extends UniversityCareerEntity {
  UniversityCareerModel({
    required super.id,
    required super.name,
    required super.description,
    required super.duration,
    required super.cost,
  });

  factory UniversityCareerModel.fromJson(Map<String, dynamic> json) {
    return UniversityCareerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'cost': cost,
    };
  }
}
</file>

<file path="features/university/data/datasources/models/university_profile_model.dart">
import '../../../domain/entities/university_profile_entity.dart';

class UniversityProfileModel extends UniversityProfileEntity {
  UniversityProfileModel({
    required super.id,
    required super.name,
    required super.description,
    required super.location,
    super.logoUrl,
    super.website,
  });

  factory UniversityProfileModel.fromJson(Map<String, dynamic> json) {
    return UniversityProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      logoUrl: json['logoUrl'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'logoUrl': logoUrl,
      'website': website,
    };
  }
}
</file>

<file path="features/university/data/repositories/university_repository_impl.dart">
import '../../domain/entities/university_profile_entity.dart';
import '../../domain/entities/university_career_entity.dart';
import '../../domain/repositories/university_repository.dart';

class UniversityRepositoryImpl implements UniversityRepository {
  @override
  Future<UniversityProfileEntity> getProfile() async {
    // TODO: Implement actual data fetch
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile(UniversityProfileEntity profile) async {
    // TODO: Implement update
  }

  @override
  Future<List<UniversityCareerEntity>> getCareers() async {
    return [];
  }

  @override
  Future<void> addCareer(UniversityCareerEntity career) async {
    // TODO: Implement add
  }

  @override
  Future<void> deleteCareer(String careerId) async {
    // TODO: Implement delete
  }
}
</file>

<file path="features/university/domain/entities/university_career_entity.dart">
class UniversityCareerEntity {
  final String id;
  final String name;
  final String description;
  final String duration;
  final double cost;

  UniversityCareerEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.cost,
  });
}
</file>

<file path="features/university/domain/entities/university_profile_entity.dart">
class UniversityProfileEntity {
  final String id;
  final String name;
  final String description;
  final String location;
  final String? logoUrl;
  final String? website;

  UniversityProfileEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.logoUrl,
    this.website,
  });
}
</file>

<file path="features/university/domain/repositories/university_repository.dart">
import '../entities/university_profile_entity.dart';
import '../entities/university_career_entity.dart';

abstract class UniversityRepository {
  Future<UniversityProfileEntity> getProfile();
  Future<void> updateProfile(UniversityProfileEntity profile);
  Future<List<UniversityCareerEntity>> getCareers();
  Future<void> addCareer(UniversityCareerEntity career);
  Future<void> deleteCareer(String careerId);
}
</file>

<file path="features/university/domain/usecases/get_university_profile_usecase.dart">
import '../entities/university_profile_entity.dart';
import '../repositories/university_repository.dart';

class GetUniversityProfileUseCase {
  final UniversityRepository repository;

  GetUniversityProfileUseCase(this.repository);

  Future<UniversityProfileEntity> call() {
    return repository.getProfile();
  }
}
</file>

<file path="features/university/domain/usecases/manage_careers_usecase.dart">
import '../entities/university_career_entity.dart';
import '../repositories/university_repository.dart';

class ManageCareersUseCase {
  final UniversityRepository repository;

  ManageCareersUseCase(this.repository);

  Future<List<UniversityCareerEntity>> getCareers() => repository.getCareers();
  Future<void> addCareer(UniversityCareerEntity career) => repository.addCareer(career);
  Future<void> deleteCareer(String id) => repository.deleteCareer(id);
}
</file>

<file path="features/university/presentation/components/university_career_card.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/university_career_entity.dart';

class UniversityCareerCard extends StatelessWidget {
  final UniversityCareerEntity career;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UniversityCareerCard({
    super.key,
    required this.career,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(career.name),
        subtitle: Text('Duración: ${career.duration} • Costo: \$${career.cost.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
</file>

<file path="features/university/presentation/providers/university_provider.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/university_profile_entity.dart';
import '../../domain/entities/university_career_entity.dart';
import '../../domain/usecases/get_university_profile_usecase.dart';
import '../../domain/usecases/manage_careers_usecase.dart';

class UniversityProvider extends ChangeNotifier {
  final GetUniversityProfileUseCase _getProfileUseCase;
  final ManageCareersUseCase _manageCareersUseCase;

  UniversityProfileEntity? _profile;
  List<UniversityCareerEntity> _careers = [];
  bool _isLoading = false;

  UniversityProvider({
    required this._getProfileUseCase,
    required this._manageCareersUseCase,
  });

  UniversityProfileEntity? get profile => _profile;
  List<UniversityCareerEntity> get careers => _careers;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _getProfileUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCareers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _careers = await _manageCareersUseCase.getCareers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCareer(UniversityCareerEntity career) async {
    await _manageCareersUseCase.addCareer(career);
    await fetchCareers();
  }
}
</file>

<file path="features/university/presentation/screens/manage_careers_screen.dart">
import 'package:flutter/material.dart';

class ManageCareersScreen extends StatelessWidget {
  const ManageCareersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestionar Carreras')),
      body: const Center(child: Text('Lista de carreras de la universidad')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
</file>

<file path="features/university/presentation/screens/university_home_screen.dart">
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';

class UniversityHomeScreen extends StatelessWidget {
  const UniversityHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Universidad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(context),
          const SizedBox(height: 24),
          const Text('Acciones Rápidas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.add_business),
            title: const Text('Gestionar Carreras'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/university-careers'),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Publicar Evento'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.campaign),
            title: const Text('Ver Interesados'),
            subtitle: const Text('Estudiantes que guardaron tu universidad'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.account_balance, size: 40)),
            const SizedBox(height: 12),
            const Text('Nombre de la Universidad', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Campus Principal', style: TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Carreras', '24'),
                _buildStat('Eventos', '3'),
                _buildStat('Prospectos', '150'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
</file>

<file path="features/vocational_games/data/datasources/mappers/game_mapper.dart">
import '../../../domain/entities/game_entity.dart';
import '../../../domain/entities/game_result_entity.dart';
import '../models/game_model.dart';
import '../models/game_result_model.dart';

class GameMapper {
  static GameEntity toEntity(GameModel model) {
    return GameEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      imageUrl: model.imageUrl,
      type: model.type,
    );
  }

  static GameResultModel fromResultEntity(GameResultEntity entity) {
    return GameResultModel(
      gameId: entity.gameId,
      score: entity.score,
      completedAt: entity.completedAt,
      feedback: entity.feedback,
    );
  }
}
</file>

<file path="features/vocational_games/data/datasources/models/game_model.dart">
import '../../../domain/entities/game_entity.dart';

class GameModel extends GameEntity {
  GameModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.type,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
    };
  }
}
</file>

<file path="features/vocational_games/data/datasources/models/game_question_model.dart">
import '../../../domain/entities/game_question_entity.dart';

class GameQuestionModel extends GameQuestionEntity {
  GameQuestionModel({
    required super.id,
    required super.text,
    required super.options,
  });

  factory GameQuestionModel.fromJson(Map<String, dynamic> json) {
    return GameQuestionModel(
      id: (json['id'] ?? '').toString(),
      text: (json['text'] ?? json['question'] ?? '').toString(),
      options: _options(json['options']),
    );
  }

  static List<GameQuestionOptionEntity> _options(dynamic value) {
    if (value is List) {
      return value.map((e) {
        final map = Map<String, dynamic>.from(e);
        return GameQuestionOptionEntity(
          id: (map['id'] ?? '').toString(),
          text: (map['text'] ?? '').toString(),
          weights: Map<String, dynamic>.from(map['weights'] ?? {}),
        );
      }).toList();
    }
    return [];
  }
}
</file>

<file path="features/vocational_games/data/datasources/models/game_result_model.dart">
import '../../../domain/entities/game_result_entity.dart';

class GameResultModel extends GameResultEntity {
  GameResultModel({
    required super.gameId,
    required super.score,
    required super.completedAt,
    required super.feedback,
  });

  factory GameResultModel.fromJson(Map<String, dynamic> json) {
    return GameResultModel(
      gameId: json['gameId'] ?? '',
      score: json['score'] ?? 0,
      completedAt: DateTime.parse(json['completedAt']),
      feedback: Map<String, dynamic>.from(json['feedback'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'score': score,
      'completedAt': completedAt.toIso8601String(),
      'feedback': feedback,
    };
  }
}
</file>

<file path="features/vocational_games/data/repositories/vocational_games_repository_impl.dart">
import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../../domain/entities/game_result_entity.dart';
import '../../domain/repositories/vocational_games_repository.dart';

import '../datasources/models/game_model.dart';
import '../datasources/models/game_question_model.dart';

class VocationalGamesRepositoryImpl implements VocationalGamesRepository {
  final IApi api;
  final UserService userService;

  VocationalGamesRepositoryImpl({
    required this.api,
    required this.userService,
  });

  @override
  Future<List<GameEntity>> getAvailableGames() async {
    final data = await api.getGames();

    return data
        .map((item) => GameModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> startGame(String gameId) async {
    final token = await userService.getToken();
    return api.startGame(token ?? '', gameId);
  }

  @override
  Future<List<GameQuestionEntity>> getGameQuestions(String gameId) async {
    final token = await userService.getToken();

    final data = await api.getGameQuestions(token ?? '', gameId);

    return data
        .map((item) => GameQuestionModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<void> sendAnswer(String gameId, Map<String, dynamic> answerData) async {
    final token = await userService.getToken();
    await api.sendAnswer(token ?? '', gameId, answerData);
  }

  @override
  Future<Map<String, dynamic>> finishGame(String gameId, String sessionId) async {
    final token = await userService.getToken();
    return api.finishGame(token ?? '', gameId, sessionId);
  }

  @override
  Future<List<dynamic>> getGameHistory() async {
    final token = await userService.getToken();
    return api.getGameResults(token ?? '');
  }

  @override
  Future<void> submitGameResult(GameResultEntity result) async {}
}
</file>

<file path="features/vocational_games/domain/entities/game_entity.dart">
class GameEntity {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String type; // e.g., 'quiz', 'simulation', 'puzzle'

  GameEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
  });
}
</file>

<file path="features/vocational_games/domain/entities/game_question_entity.dart">
class GameQuestionEntity {
  final String id;
  final String text;
  final List<GameQuestionOptionEntity> options;

  GameQuestionEntity({
    required this.id,
    required this.text,
    required this.options,
  });
}

class GameQuestionOptionEntity {
  final String id;
  final String text;
  final Map<String, dynamic> weights;

  GameQuestionOptionEntity({
    required this.id,
    required this.text,
    required this.weights,
  });
}
</file>

<file path="features/vocational_games/domain/entities/game_result_entity.dart">
class GameResultEntity {
  final String gameId;
  final int score;
  final DateTime completedAt;
  final Map<String, dynamic> feedback;

  GameResultEntity({
    required this.gameId,
    required this.score,
    required this.completedAt,
    required this.feedback,
  });
}
</file>

<file path="features/vocational_games/domain/repositories/vocational_games_repository.dart">
import '../entities/game_entity.dart';
import '../entities/game_result_entity.dart';
import '../entities/game_question_entity.dart';

abstract class VocationalGamesRepository {
  Future<List<GameEntity>> getAvailableGames();
  Future<Map<String, dynamic>> startGame(String gameId);
  Future<List<GameQuestionEntity>> getGameQuestions(String gameId);
  Future<void> sendAnswer(String gameId, Map<String, dynamic> answerData);
  Future<Map<String, dynamic>> finishGame(String gameId, String sessionId);
  Future<List<dynamic>> getGameHistory();
  Future<void> submitGameResult(GameResultEntity result);
}
</file>

<file path="features/vocational_games/domain/usecases/finish_game_usecase.dart">
import '../repositories/vocational_games_repository.dart';

class FinishGameUseCase {
  final VocationalGamesRepository repository;

  FinishGameUseCase(this.repository);

  Future<Map<String, dynamic>> call(String gameId, String sessionId) {
    return repository.finishGame(gameId, sessionId);
  }
}
</file>

<file path="features/vocational_games/domain/usecases/get_available_games_usecase.dart">
import '../entities/game_entity.dart';
import '../repositories/vocational_games_repository.dart';

class GetAvailableGamesUseCase {
  final VocationalGamesRepository repository;

  GetAvailableGamesUseCase(this.repository);

  Future<List<GameEntity>> call() {
    return repository.getAvailableGames();
  }
}
</file>

<file path="features/vocational_games/domain/usecases/get_game_questions_usecase.dart">
import '../entities/game_question_entity.dart';
import '../repositories/vocational_games_repository.dart';

class GetGameQuestionsUseCase {
  final VocationalGamesRepository repository;

  GetGameQuestionsUseCase(this.repository);

  Future<List<GameQuestionEntity>> call(String gameId) {
    return repository.getGameQuestions(gameId);
  }
}
</file>

<file path="features/vocational_games/domain/usecases/send_game_answer_usecase.dart">
import '../repositories/vocational_games_repository.dart';

class SendGameAnswerUseCase {
  final VocationalGamesRepository repository;

  SendGameAnswerUseCase(this.repository);

  Future<void> call(String gameId, Map<String, dynamic> answerData) {
    return repository.sendAnswer(gameId, answerData);
  }
}
</file>

<file path="features/vocational_games/domain/usecases/start_game_usecase.dart">
import '../repositories/vocational_games_repository.dart';

class StartGameUseCase {
  final VocationalGamesRepository repository;

  StartGameUseCase(this.repository);

  Future<Map<String, dynamic>> call(String gameId) {
    return repository.startGame(gameId);
  }
}
</file>

<file path="features/vocational_games/domain/usecases/submit_game_result_usecase.dart">
import '../entities/game_result_entity.dart';
import '../repositories/vocational_games_repository.dart';

class SubmitGameResultUseCase {
  final VocationalGamesRepository repository;

  SubmitGameResultUseCase(this.repository);

  Future<void> call(GameResultEntity result) {
    return repository.submitGameResult(result);
  }
}
</file>

<file path="features/vocational_games/presentation/components/game_card.dart">
import 'package:flutter/material.dart';
import '../../domain/entities/game_entity.dart';

class GameCard extends StatelessWidget {
  final GameEntity game;
  final VoidCallback onTap;

  const GameCard({super.key, required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.blue.withValues(alpha: 0.1),
                width: double.infinity,
                child: const Icon(Icons.videogame_asset, size: 50, color: Colors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    game.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
</file>

<file path="features/vocational_games/presentation/providers/games_provider.dart">
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../../domain/usecases/get_available_games_usecase.dart';
import '../../domain/usecases/get_game_questions_usecase.dart';
import '../../domain/usecases/start_game_usecase.dart';
import '../../domain/usecases/send_game_answer_usecase.dart';
import '../../domain/usecases/finish_game_usecase.dart';

enum VocationalCategory {
  calculo,
  fisico,
  biologico,
  mecanico,
  social,
  literario,
  persuasivo,
  artistico,
  musical,
}

class VocationalMiniGame {
  final VocationalCategory category;
  final String title;
  final String description;
  final IconData icon;
  final List<GameQuestionEntity> questions;

  VocationalMiniGame({
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.questions,
  });

  String get statusKey => category.name;
}

enum MiniGameStatus {
  completed,
  inProgress,
  notStarted,
}

class GamesProvider extends ChangeNotifier {
  final GetAvailableGamesUseCase _getGamesUseCase;
  final GetGameQuestionsUseCase _getQuestionsUseCase;
  final StartGameUseCase _startGameUseCase;
  final SendGameAnswerUseCase _sendAnswerUseCase;
  final FinishGameUseCase _finishGameUseCase;

  GamesProvider({
    required this._getGamesUseCase,
    required this._getQuestionsUseCase,
    required this._startGameUseCase,
    required this._sendAnswerUseCase,
    required this._finishGameUseCase,
  });

  List<GameEntity> _games = [];
  List<GameQuestionEntity> _questions = [];
  List<VocationalMiniGame> _miniGames = [];

  bool _isLoading = false;
  bool _isLoadingQuestions = false;

  String? _sessionId;
  String? _errorMessage;
  GameEntity? _activeGame;

  int _savedIndex = 0;
  Map<String, dynamic> _lastBackendResult = {};
  final Map<String, MiniGameStatus> _miniGameStatus = {};

  List<GameEntity> get games => _games;
  List<GameQuestionEntity> get questions => _questions;
  List<VocationalMiniGame> get miniGames => _miniGames;

  bool get isLoading => _isLoading;
  bool get isLoadingQuestions => _isLoadingQuestions;

  String? get sessionId => _sessionId;
  String? get errorMessage => _errorMessage;
  GameEntity? get activeGame => _activeGame;

  int get savedIndex => _savedIndex;
  Map<String, dynamic> get lastBackendResult => _lastBackendResult;
  Map<String, MiniGameStatus> get miniGameStatus => _miniGameStatus;

  MiniGameStatus getMiniGameStatus(String miniGameKey) {
    return _miniGameStatus[miniGameKey] ?? MiniGameStatus.notStarted;
  }

  Future<void> loadMiniGameStatus(String miniGameKey) async {
    final prefs = await SharedPreferences.getInstance();
    final isCompleted = prefs.getBool('game_completed_$miniGameKey') ?? false;
    final savedSession = prefs.getString('game_session_$miniGameKey');
    final savedIndex = prefs.getInt('game_index_$miniGameKey') ?? 0;

    if (isCompleted) {
      _miniGameStatus[miniGameKey] = MiniGameStatus.completed;
    } else if ((savedSession != null && savedSession.isNotEmpty) ||
        savedIndex > 0) {
      _miniGameStatus[miniGameKey] = MiniGameStatus.inProgress;
    } else {
      _miniGameStatus[miniGameKey] = MiniGameStatus.notStarted;
    }

    notifyListeners();
  }

  Future<void> loadAllMiniGameStatus() async {
    final prefs = await SharedPreferences.getInstance();

    for (final miniGame in _miniGames) {
      final key = miniGame.statusKey;
      final isCompleted = prefs.getBool('game_completed_$key') ?? false;
      final savedSession = prefs.getString('game_session_$key');
      final savedIndex = prefs.getInt('game_index_$key') ?? 0;

      if (isCompleted) {
        _miniGameStatus[key] = MiniGameStatus.completed;
      } else if ((savedSession != null && savedSession.isNotEmpty) ||
          savedIndex > 0) {
        _miniGameStatus[key] = MiniGameStatus.inProgress;
      } else {
        _miniGameStatus[key] = MiniGameStatus.notStarted;
      }
    }

    notifyListeners();
  }

  Future<void> fetchGames() async {
    _isLoading = true;
    _errorMessage = null;
    _miniGames = [];
    notifyListeners();

    try {
      _games = await _getGamesUseCase();

      if (_games.isNotEmpty) {
        await prepareMiniGames(_games.first);
      }
    } catch (e) {
      _errorMessage = 'No se pudieron cargar los minijuegos.';
      debugPrint('Error fetchGames: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> prepareMiniGames(GameEntity game) async {
    _isLoadingQuestions = true;
    _errorMessage = null;
    _activeGame = game;
    _questions = [];
    _miniGames = [];
    notifyListeners();

    try {
      final allQuestions = await _getQuestionsUseCase(game.id);

      if (allQuestions.isEmpty) {
        _errorMessage = 'Este juego no tiene preguntas disponibles.';
        return;
      }

      final grouped = <VocationalCategory, List<GameQuestionEntity>>{};

      for (final question in allQuestions) {
        final category = detectCategory(question.text);
        grouped.putIfAbsent(category, () => []);
        grouped[category]!.add(question);
      }

      _miniGames = grouped.entries
          .where((entry) => entry.value.isNotEmpty)
          .map(
            (entry) => VocationalMiniGame(
          category: entry.key,
          title: _categoryTitle(entry.key),
          description: _categoryDescription(entry.key),
          icon: _categoryIcon(entry.key),
          questions: entry.value,
        ),
      )
          .toList();

      _miniGames.sort((a, b) => a.title.compareTo(b.title));

      await loadAllMiniGameStatus();
    } catch (e) {
      _errorMessage = 'No se pudieron dividir las preguntas por categoría.';
      debugPrint('Error prepareMiniGames: $e');
    } finally {
      _isLoadingQuestions = false;
      notifyListeners();
    }
  }

  Future<void> startSessionIfNeeded(
      String gameId, {
        String? statusKey,
      }) async {
    if (_sessionId != null && _sessionId!.isNotEmpty) return;

    final key = statusKey ?? gameId;
    final prefs = await SharedPreferences.getInstance();

    final savedSession = prefs.getString('game_session_$key');
    final savedQuestionIndex = prefs.getInt('game_index_$key') ?? 0;
    final isCompleted = prefs.getBool('game_completed_$key') ?? false;

    if (isCompleted) {
      _miniGameStatus[key] = MiniGameStatus.completed;
      _savedIndex = 0;
      notifyListeners();
      return;
    }

    if (savedSession != null && savedSession.isNotEmpty) {
      _sessionId = savedSession;
      _savedIndex = savedQuestionIndex;
      _miniGameStatus[key] = MiniGameStatus.inProgress;
      notifyListeners();
      return;
    }

    final startResponse = await _startGameUseCase(gameId);

    _sessionId = startResponse['sessionId']?.toString() ??
        startResponse['data']?['sessionId']?.toString() ??
        startResponse['data']?['id']?.toString() ??
        startResponse['id']?.toString();

    if (_sessionId != null && _sessionId!.isNotEmpty) {
      await prefs.setString('game_session_$key', _sessionId!);
      await prefs.setBool('game_completed_$key', false);
      _miniGameStatus[key] = MiniGameStatus.inProgress;
    } else {
      _miniGameStatus[key] = MiniGameStatus.notStarted;
    }

    _savedIndex = savedQuestionIndex;
    notifyListeners();
  }

  Future<void> selectMiniGame(VocationalMiniGame miniGame) async {
    final prefs = await SharedPreferences.getInstance();
    final key = miniGame.statusKey;

    _questions = miniGame.questions;
    _savedIndex = prefs.getInt('game_index_$key') ?? 0;

    notifyListeners();
  }

  Future<void> saveProgress({
    required String gameId,
    required int currentIndex,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('game_index_$gameId', currentIndex);
    await prefs.setBool('game_completed_$gameId', false);

    _miniGameStatus[gameId] = MiniGameStatus.inProgress;
    notifyListeners();
  }

  Future<void> sendAnswer({
    required String gameId,
    required String questionId,
    required String optionId,
    required String answer,
    required Map<String, dynamic> weights,
    required int currentIndex,
    String? progressKey,
  }) async {
    final key = progressKey ?? gameId;

    await startSessionIfNeeded(gameId, statusKey: key);

    await _sendAnswerUseCase(gameId, {
      'sessionId': _sessionId,
      'questionId': questionId,
      'selectedOptionId': optionId,
      'rawData': {
        'answerText': answer,
        'weights': weights,
      },
    });

    await saveProgress(
      gameId: key,
      currentIndex: currentIndex,
    );
  }

  Future<Map<String, dynamic>> finishGame(
      String gameId, {
        String? statusKey,
      }) async {
    final key = statusKey ?? gameId;

    await startSessionIfNeeded(gameId, statusKey: key);

    if (_sessionId == null || _sessionId!.isEmpty) {
      return {};
    }

    final result = await _finishGameUseCase(gameId, _sessionId!);

    debugPrint('XXX FINISH GAME RESPONSE: $result');

    final data = _asMap(result['data'] ?? result);
    final backendResult = _asMap(data['result'] ?? data['results'] ?? data);

    _lastBackendResult = backendResult;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('game_session_$key');
    await prefs.remove('game_index_$key');
    await prefs.setBool('game_completed_$key', true);

    _sessionId = null;
    _savedIndex = 0;
    _miniGameStatus[key] = MiniGameStatus.completed;

    notifyListeners();

    return backendResult;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  void clearQuestions() {
    _questions = [];
    _errorMessage = null;
    notifyListeners();
  }

  void clearAllGameData() {
    _questions = [];
    _miniGames = [];
    _sessionId = null;
    _activeGame = null;
    _errorMessage = null;
    _savedIndex = 0;
    _lastBackendResult = {};
    _miniGameStatus.clear();
    notifyListeners();
  }

  VocationalCategory detectCategory(String raw) {
    final text = raw.toLowerCase();

    if (_has(text, [
      'calcular',
      'aritmética',
      'aritmetica',
      'numérico',
      'numerico',
      'porcentajes',
      'logaritmos',
      'matemáticos',
      'matematicos',
      'área',
      'area',
      'grados',
      'radios',
      'mecanizaciones',
      'regla de cálculo',
    ])) {
      return VocationalCategory.calculo;
    }

    if (_has(text, [
      'eclipse',
      'telescopio',
      'estrellas',
      'observatorio',
      'energía atómica',
      'energia atomica',
      'rocas',
      'espectro',
      'luz',
      'combustión',
      'combustion',
      'científica',
      'cientifica',
    ])) {
      return VocationalCategory.fisico;
    }

    if (_has(text, [
      'sangre',
      'plantas',
      'abejas',
      'insectos',
      'hormigas',
      'organismos',
      'acuario',
      'oxígeno',
      'oxigeno',
      'primeros auxilios',
      'operación médica',
    ])) {
      return VocationalCategory.biologico;
    }

    if (_has(text, [
      'licuadora',
      'máquina',
      'maquina',
      'taladro',
      'reparar',
      'soldar',
      'reloj',
      'eléctrico',
      'electrico',
      'torno',
      'muebles',
      'televisión',
      'television',
    ])) {
      return VocationalCategory.mecanico;
    }

    if (_has(text, [
      'ayudar',
      'orfelinatos',
      'consejero',
      'niños',
      'ninos',
      'ciegos',
      'escuchar',
      'servir',
      'personas de escasos recursos',
      'hermanos menores',
    ])) {
      return VocationalCategory.social;
    }

    if (_has(text, [
      'escribir',
      'cuentos',
      'novelas',
      'literatura',
      'biblioteca',
      'periódico',
      'periodico',
      'cartas',
      'clásicos',
      'clasicos',
      'reseñas',
      'artículos',
      'articulos',
    ])) {
      return VocationalCategory.literario;
    }

    if (_has(text, [
      'debates',
      'argumentos',
      'convencer',
      'políticos',
      'politicos',
      'defender',
      'líder',
      'lider',
      'dirigir',
      'producto',
      'público',
      'publico',
      'candidatos',
      'punto de vista',
      'campañas',
      'campanas',
    ])) {
      return VocationalCategory.persuasivo;
    }

    if (_has(text, [
      'pintar',
      'óleo',
      'oleo',
      'arte',
      'dibujar',
      'mosaicos',
      'decoración',
      'decoracion',
      'paisajes',
      'tapices',
      'escenarios',
      'pinturas',
      'diseños',
      'disenos',
    ])) {
      return VocationalCategory.artistico;
    }

    if (_has(text, [
      'música',
      'musica',
      'concierto',
      'instrumento',
      'coral',
      'compositor',
      'discos',
      'leer música',
      'leer musica',
      'músico',
      'musico',
    ])) {
      return VocationalCategory.musical;
    }

    return VocationalCategory.artistico;
  }

  bool _has(String text, List<String> words) {
    return words.any((word) => text.contains(word));
  }

  String _categoryTitle(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.calculo:
        return 'Juego de lógica y cálculo';
      case VocationalCategory.fisico:
        return 'Juego científico físico';
      case VocationalCategory.biologico:
        return 'Juego biológico';
      case VocationalCategory.mecanico:
        return 'Juego mecánico';
      case VocationalCategory.social:
        return 'Juego de servicio social';
      case VocationalCategory.literario:
        return 'Juego literario';
      case VocationalCategory.persuasivo:
        return 'Juego persuasivo';
      case VocationalCategory.artistico:
        return 'Juego artístico';
      case VocationalCategory.musical:
        return 'Juego musical';
    }
  }

  String _categoryDescription(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.calculo:
        return 'Retos con números y razonamiento lógico.';
      case VocationalCategory.fisico:
        return 'Explora fenómenos naturales, luz, estrellas y energía.';
      case VocationalCategory.biologico:
        return 'Actividades sobre vida, plantas, salud y laboratorio.';
      case VocationalCategory.mecanico:
        return 'Reparar, armar, instalar y usar herramientas.';
      case VocationalCategory.social:
        return 'Ayudar, escuchar y acompañar a otras personas.';
      case VocationalCategory.literario:
        return 'Lectura, escritura y expresión de ideas.';
      case VocationalCategory.persuasivo:
        return 'Debatir, convencer, liderar y defender ideas.';
      case VocationalCategory.artistico:
        return 'Pintura, dibujo, diseño y creatividad visual.';
      case VocationalCategory.musical:
        return 'Música, instrumentos, conciertos y composición.';
    }
  }

  IconData _categoryIcon(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.calculo:
        return Icons.calculate_outlined;
      case VocationalCategory.fisico:
        return Icons.public_outlined;
      case VocationalCategory.biologico:
        return Icons.biotech_outlined;
      case VocationalCategory.mecanico:
        return Icons.build_outlined;
      case VocationalCategory.social:
        return Icons.volunteer_activism_outlined;
      case VocationalCategory.literario:
        return Icons.menu_book_outlined;
      case VocationalCategory.persuasivo:
        return Icons.campaign_outlined;
      case VocationalCategory.artistico:
        return Icons.palette_outlined;
      case VocationalCategory.musical:
        return Icons.music_note_outlined;
    }
  }
}
</file>

<file path="features/vocational_games/presentation/screens/game_detail_screen.dart">
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../providers/games_provider.dart';
import 'game_result_screen.dart';

class GameDetailScreen extends StatefulWidget {
  final GameEntity game;
  final String miniGameKey;

  const GameDetailScreen({
    super.key,
    required this.game,
    required this.miniGameKey,
  });

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen>
    with TickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);

  int _currentIndex = 0;
  int _secondsLeft = 60;

  Timer? _timer;

  bool _isSending = false;
  bool _showSuccess = false;
  bool _isStartingSession = true;

  GameQuestionOptionEntity? _selectedOption;

  late AnimationController _sceneController;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();

    _sceneController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    Future.microtask(() async {
      final provider = context.read<GamesProvider>();

      await provider.startSessionIfNeeded(
        widget.game.id,
        statusKey: widget.miniGameKey,
      );

      if (!mounted) return;

      if (provider.questions.isNotEmpty) {
        final saved = provider.savedIndex;

        setState(() {
          _currentIndex = saved < provider.questions.length ? saved : 0;
          _isStartingSession = false;
        });

        _startTimer();
      } else {
        setState(() {
          _isStartingSession = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sceneController.dispose();
    _successController.dispose();

    try {
      context.read<GamesProvider>().clearQuestions();
    } catch (_) {}

    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _secondsLeft = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_secondsLeft <= 1) {
        timer.cancel();
        _autoAnswer();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  Future<void> _autoAnswer() async {
    final provider = context.read<GamesProvider>();

    if (_isSending || provider.questions.isEmpty) return;

    final question = provider.questions[_currentIndex];

    if (question.options.isEmpty) return;

    final option = question.options.length >= 3
        ? question.options[2]
        : question.options.first;

    await _selectAnswer(option);
  }

  Future<void> _selectAnswer(GameQuestionOptionEntity option) async {
    if (_isSending) return;

    final provider = context.read<GamesProvider>();

    if (provider.questions.isEmpty) return;

    final question = provider.questions[_currentIndex];

    _timer?.cancel();

    setState(() {
      _isSending = true;
      _selectedOption = option;
      _showSuccess = true;
    });

    _successController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 850));

    try {
      await provider.sendAnswer(
        gameId: widget.game.id,
        questionId: question.id,
        optionId: option.id,
        answer: option.text,
        weights: option.weights,
        currentIndex: _currentIndex + 1,
        progressKey: widget.miniGameKey,
      );

      if (_currentIndex < provider.questions.length - 1) {
        if (!mounted) return;

        setState(() {
          _currentIndex++;
          _selectedOption = null;
          _isSending = false;
          _showSuccess = false;
        });

        _sceneController.forward(from: 0);
        _startTimer();
      } else {
        final result = await provider.finishGame(
          widget.game.id,
          statusKey: widget.miniGameKey,
        );

        if (!mounted) return;

        _showFinalResultScreen(result);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSending = false;
        _showSuccess = false;
        _selectedOption = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'No se pudo guardar la respuesta.',
          ),
        ),
      );

      _startTimer();
    }
  }

  void _showFinalResultScreen(Map<String, dynamic> result) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameResultScreen(result: result),
      ),
    );
  }

  Future<void> _exitGame() async {
    final provider = context.read<GamesProvider>();

    await provider.saveProgress(
      gameId: widget.miniGameKey,
      currentIndex: _currentIndex,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GamesProvider>();

    return WillPopScope(
      onWillPop: () async {
        await _exitGame();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            widget.game.title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: _exitGame,
          ),
        ),
        body: _isStartingSession
            ? const Center(
          child: CircularProgressIndicator(color: primaryColor),
        )
            : provider.questions.isEmpty
            ? const Center(
          child: Text('No hay retos disponibles.'),
        )
            : _buildGame(provider),
      ),
    );
  }

  Widget _buildGame(GamesProvider provider) {
    final question = provider.questions[_currentIndex];
    final scene = _detectScene(question.text);
    final isBinary = question.options.length == 2;

    if (_showSuccess && _selectedOption != null) {
      return _buildSuccessScene(scene, _selectedOption!.text);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
        child: Column(
          children: [
            _buildHeader(provider.questions.length),
            const SizedBox(height: 22),
            Text(
              _formatQuestion(question.text, isBinary),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
                color: darkText,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isBinary
                  ? 'Arrastra tu respuesta'
                  : 'Arrastra la ficha a tu nivel de interés',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedBuilder(
                animation: _sceneController,
                builder: (_, _) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: _sceneGradient(scene),
                    ),
                    child: CustomPaint(
                      painter: _InteractiveScenePainter(
                        scene: scene,
                        progress: _sceneController.value,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            _buildDragToken(),
            const SizedBox(height: 12),
            isBinary
                ? _buildBinaryTargets(question)
                : _buildLikertTargets(question),
            const SizedBox(height: 10),
            Text(
              'Responde rápido con tu primera impresión.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int total) {
    final progress = (_currentIndex + 1) / total;

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Reto ${_currentIndex + 1} de $total',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: primaryColor,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '00:${_secondsLeft.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            color: primaryColor,
            backgroundColor: Colors.grey[200],
          ),
        ),
      ],
    );
  }

  Widget _buildDragToken() {
    return Draggable<int>(
      data: 1,
      feedback: Material(
        color: Colors.transparent,
        child: _token(size: 70, dragging: true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.25,
        child: _token(size: 64),
      ),
      child: _token(size: 64),
    );
  }

  Widget _token({
    required double size,
    bool dragging = false,
  }) {
    return AnimatedScale(
      scale: dragging ? 1.12 : 1,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.touch_app,
          color: Colors.white,
          size: 34,
        ),
      ),
    );
  }

  Widget _buildBinaryTargets(GameQuestionEntity question) {
    return Row(
      children: List.generate(question.options.length, (index) {
        final option = question.options[index];
        final positive = index == 0;

        return Expanded(
          child: DragTarget<int>(
            onWillAcceptWithDetails: (_) => !_isSending,
            onAcceptWithDetails: (_) => _selectAnswer(option),
            builder: (context, candidateData, rejectedData) {
              final hover = candidateData.isNotEmpty;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                height: hover ? 154 : 140,
                margin: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  color: hover
                      ? (positive ? Colors.green : Colors.red)
                      .withValues(alpha: 0.20)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: positive ? Colors.green : Colors.red,
                    width: hover ? 4 : 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      positive ? Icons.check_circle : Icons.cancel,
                      color: positive ? Colors.green : Colors.red,
                      size: hover ? 62 : 52,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      option.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: darkText,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildLikertTargets(GameQuestionEntity question) {
    final icons = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
    ];

    final colors = [
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.lightGreen,
      Colors.green,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: List.generate(question.options.length, (index) {
          final option = question.options[index];
          final color = colors[index.clamp(0, colors.length - 1)];
          final icon = icons[index.clamp(0, icons.length - 1)];

          return Expanded(
            child: DragTarget<int>(
              onWillAcceptWithDetails: (_) => !_isSending,
              onAcceptWithDetails: (_) => _selectAnswer(option),
              builder: (context, candidateData, rejectedData) {
                final hover = candidateData.isNotEmpty;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: hover ? color.withValues(alpha: 0.18) : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: hover ? color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      CircleAvatar(
                        radius: hover ? 29 : 25,
                        backgroundColor: color.withValues(alpha: 0.18),
                        child: Icon(
                          icon,
                          color: color,
                          size: hover ? 34 : 30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 31,
                        child: Text(
                          option.text,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSuccessScene(_SceneType scene, String answer) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            _buildHeader(context.read<GamesProvider>().questions.length),
            const SizedBox(height: 30),
            const Text(
              '¡Genial!',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: darkText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tu elección: $answer',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedBuilder(
                animation: _successController,
                builder: (_, _) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      gradient: _sceneGradient(scene),
                    ),
                    child: CustomPaint(
                      painter: _SuccessScenePainter(
                        progress: _successController.value,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Continuamos...',
              style: TextStyle(
                color: primaryColor,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatQuestion(String text, bool binary) {
    if (!binary) return text;

    final clean = text.trim();

    if (clean.isEmpty || clean.startsWith('¿')) {
      return clean;
    }

    return '¿Te gusta ${clean[0].toLowerCase()}${clean.substring(1)}?';
  }

  _SceneType _detectScene(String raw) {
    final text = raw.toLowerCase();

    if (_has(text, ['música', 'musica', 'concierto', 'instrumento'])) {
      return _SceneType.music;
    }

    if (_has(text, ['licuadora', 'máquina', 'maquina', 'taladro', 'reparar'])) {
      return _SceneType.mechanic;
    }

    if (_has(text, ['pintar', 'arte', 'dibujar', 'mosaicos'])) {
      return _SceneType.art;
    }

    if (_has(text, ['eclipse', 'telescopio', 'estrellas', 'observatorio'])) {
      return _SceneType.space;
    }

    if (_has(text, ['sangre', 'plantas', 'abejas', 'insectos'])) {
      return _SceneType.bio;
    }

    if (_has(text, [
      'calcular',
      'numérico',
      'numerico',
      'porcentajes',
      'matemáticos',
      'matematicos',
    ])) {
      return _SceneType.math;
    }

    if (_has(text, ['escribir', 'cuentos', 'novelas', 'literatura'])) {
      return _SceneType.literary;
    }

    if (_has(text, ['ayudar', 'orfelinatos', 'consejero', 'escuchar'])) {
      return _SceneType.social;
    }

    if (_has(text, ['debates', 'convencer', 'defender', 'líder', 'lider'])) {
      return _SceneType.persuasive;
    }

    return _SceneType.general;
  }

  bool _has(String text, List<String> words) {
    return words.any((word) => text.contains(word));
  }

  LinearGradient _sceneGradient(_SceneType scene) {
    switch (scene) {
      case _SceneType.music:
        return const LinearGradient(
          colors: [Color(0xFFFFF7E8), Color(0xFFFFD36E)],
        );
      case _SceneType.mechanic:
        return const LinearGradient(
          colors: [Color(0xFFFFF1E9), Color(0xFFE7F0FF)],
        );
      case _SceneType.art:
        return const LinearGradient(
          colors: [Color(0xFFE6F7FF), Color(0xFFFFF4D8)],
        );
      case _SceneType.space:
        return const LinearGradient(
          colors: [Color(0xFFEAE8FF), Color(0xFF1D1B4B)],
        );
      case _SceneType.bio:
        return const LinearGradient(
          colors: [Color(0xFFE8FFF2), Color(0xFFC7F2D4)],
        );
      case _SceneType.math:
        return const LinearGradient(
          colors: [Color(0xFFEDEAFF), Color(0xFFD9F0FF)],
        );
      case _SceneType.literary:
        return const LinearGradient(
          colors: [Color(0xFFFFF4E8), Color(0xFFE8D2B8)],
        );
      case _SceneType.social:
        return const LinearGradient(
          colors: [Color(0xFFFFEAF2), Color(0xFFFFD4E5)],
        );
      case _SceneType.persuasive:
        return const LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFFB74D)],
        );
      case _SceneType.general:
        return const LinearGradient(
          colors: [Color(0xFFEDEAFF), Color(0xFFF8F9FE)],
        );
    }
  }
}

enum _SceneType {
  music,
  mechanic,
  art,
  space,
  bio,
  math,
  literary,
  social,
  persuasive,
  general,
}

class _InteractiveScenePainter extends CustomPainter {
  final _SceneType scene;
  final double progress;

  _InteractiveScenePainter({
    required this.scene,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final t = sin(progress * pi * 2);

    final paint = Paint()..color = Colors.white.withValues(alpha: 0.32);

    canvas.drawCircle(
      Offset(size.width * .22, size.height * .18),
      60,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * .82, size.height * .25),
      42,
      paint,
    );

    switch (scene) {
      case _SceneType.music:
        _emoji(canvas, '🎵', center + Offset(0, t * 10), 110);
        break;
      case _SceneType.mechanic:
        _emoji(canvas, '⚙️', center + Offset(0, t * 10), 110);
        break;
      case _SceneType.art:
        _emoji(canvas, '🎨', center + Offset(0, t * 10), 110);
        break;
      case _SceneType.space:
        _emoji(canvas, '🪐', center + Offset(0, t * 10), 110);
        break;
      case _SceneType.bio:
        _emoji(canvas, '🧬', center + Offset(0, t * 10), 110);
        break;
      case _SceneType.math:
        _emoji(canvas, '🧮', center + Offset(0, t * 10), 110);
        break;
      case _SceneType.literary:
        _emoji(canvas, '📖', center + Offset(0, t * 10), 110);
        break;
      case _SceneType.social:
        _emoji(canvas, '🤝', center + Offset(0, t * 10), 110);
        break;
      case _SceneType.persuasive:
        _emoji(canvas, '📢', center + Offset(0, t * 10), 110);
        break;
      case _SceneType.general:
        _emoji(canvas, '🎯', center + Offset(0, t * 10), 110);
        break;
    }
  }

  void _emoji(
      Canvas canvas,
      String text,
      Offset pos,
      double size,
      ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: size),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(
        pos.dx - tp.width / 2,
        pos.dy - tp.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _InteractiveScenePainter oldDelegate) {
    return true;
  }
}

class _SuccessScenePainter extends CustomPainter {
  final double progress;

  _SuccessScenePainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = 40 + (progress * 80);

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    final tp = TextPainter(
      text: const TextSpan(
        text: '✅',
        style: TextStyle(fontSize: 110),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(
        center.dx - tp.width / 2,
        center.dy - tp.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _SuccessScenePainter oldDelegate) {
    return true;
  }
}
</file>

<file path="features/vocational_games/presentation/screens/game_result_screen.dart">
import 'package:flutter/material.dart';

class GameResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const GameResultScreen({
    super.key,
    required this.result,
  });

  static const Color primaryColor = Color(0xFF4B1D7A);
  static const Color purple = Color(0xFF7B2FF7);

  @override
  Widget build(BuildContext context) {
    final scores = _extractScores(result);
    final top = scores.isNotEmpty ? scores.entries.first : null;

    final title = top == null
        ? 'Resultado Vocacional'
        : _resultTitle(top.key.toString());

    final percentage = top == null ? 0 : _normalizePercent(top.value);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tus Resultados',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _buildHeroCard(title, percentage),
          const SizedBox(height: 18),
          _buildSectionTitle('Fortalezas Detectadas', 'Ver todas >'),
          const SizedBox(height: 10),
          _strengthCard(
            icon: Icons.psychology_outlined,
            title: 'Pensamiento Lógico',
            text: 'Capacidad para organizar ideas y resolver problemas.',
          ),
          _strengthCard(
            icon: Icons.groups_outlined,
            title: 'Colaboración',
            text: 'Habilidad natural para trabajar en equipo.',
          ),
          _strengthCard(
            icon: Icons.assignment_turned_in_outlined,
            title: 'Atención al Detalle',
            text: 'Alta precisión en tareas técnicas y metodológicas.',
          ),
          const SizedBox(height: 18),
          const Text(
            'Intereses Principales',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: scores.entries.take(4).map((entry) {
              return _interestChip(entry.key.toString());
            }).toList(),
          ),
          const SizedBox(height: 18),
          _clarityCard(percentage),
          const SizedBox(height: 22),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Ver carreras recomendadas  ›',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(String title, int percentage) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFD946EF), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white24,
            child: Icon(Icons.track_changes, color: Colors.white, size: 38),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Resultado Principal',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu perfil destaca por habilidades, intereses y pensamiento vocacional.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'COMPATIBILIDAD\n$percentage%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.4,
                    ),
                  ),
                ),
                const Icon(Icons.track_changes, color: Colors.white, size: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String action) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: purple,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _strengthCard({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFEFF6FF),
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _interestChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _cleanName(text),
        style: const TextStyle(
          color: purple,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _clarityCard(int percentage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_border, color: primaryColor),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Claridad Vocacional',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              color: primaryColor,
              backgroundColor: const Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '¡Excelente! Tus respuestas muestran una dirección muy clara hacia áreas relacionadas con este perfil.',
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _extractScores(Map<String, dynamic> result) {
    final scores = result['scores'] ?? result['score'] ?? result;

    if (scores is Map && scores.isNotEmpty) {
      final map = Map<String, dynamic>.from(scores);

      final entries = map.entries.toList()
        ..sort((a, b) {
          final av = int.tryParse(a.value.toString()) ?? 0;
          final bv = int.tryParse(b.value.toString()) ?? 0;
          return bv.compareTo(av);
        });

      return Map.fromEntries(entries);
    }

    return {};
  }

  int _normalizePercent(dynamic value) {
    final number = int.tryParse(value.toString()) ?? 0;
    if (number > 100) return 100;
    if (number < 0) return 0;
    return number;
  }

  String _resultTitle(String key) {
    final clean = _cleanName(key);

    if (clean.contains('SERVICIO') || clean.contains('SOCIAL')) {
      return 'Servicio Social y Humanidades';
    }

    if (clean.contains('PERSUASIVO')) {
      return 'Liderazgo y Comunicación';
    }

    if (clean.contains('MUSICAL')) {
      return 'Arte Musical';
    }

    if (clean.contains('CALCULO')) {
      return 'Ingeniería y STEM';
    }

    return clean;
  }

  String _cleanName(String text) {
    return text
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .toUpperCase();
  }
}
</file>

<file path="features/vocational_games/presentation/screens/games_list_screen.dart">
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../providers/games_provider.dart';
import 'game_detail_screen.dart';

class GamesListScreen extends StatefulWidget {
  const GamesListScreen({super.key});

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GamesProvider>().fetchGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GamesProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Minijuegos vocacionales',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: provider.fetchGames,
        child: provider.isLoading || provider.isLoadingQuestions
            ? const Center(child: CircularProgressIndicator(color: primaryColor))
            : provider.miniGames.isEmpty
            ? _buildEmpty(provider)
            : ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Elige tu aventura\nvocacional',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: darkText,
                height: 1.1,
              ),
            ).animate().fadeIn().slideX(begin: -0.15),
            const SizedBox(height: 12),
            Text(
              'Cada área se juega diferente según el tipo de interés.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.35,
              ),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 24),
            ...provider.miniGames.asMap().entries.map(
                  (entry) => _buildMiniGameCard(
                provider,
                entry.value,
                entry.key,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(GamesProvider provider) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 160),
        const Icon(Icons.sports_esports_outlined, size: 70, color: Colors.grey),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'No hay minijuegos disponibles.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: provider.fetchGames,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Reintentar'),
        ),
      ],
    );
  }

  Widget _buildMiniGameCard(
      GamesProvider provider,
      VocationalMiniGame miniGame,
      int index,
      ) {
    final data = _gameVisual(miniGame.category);
    final activeGame = provider.activeGame;
    final status = provider.getMiniGameStatus(miniGame.statusKey);
    final progress = (miniGame.questions.length / 20).clamp(0.1, 1.0);

    return GestureDetector(
      onTap: () async {
        if (activeGame == null) return;

        await provider.selectMiniGame(miniGame);

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameDetailScreen(
              game: activeGame,
              miniGameKey: miniGame.statusKey,
            ),
          ),
        );
      },
      child: Container(
        height: 315,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: data.mainColor.withValues(alpha: 0.38),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  data.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _fallbackGradient(data),
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.62),
                        Colors.black.withValues(alpha: 0.28),
                        Colors.black.withValues(alpha: 0.42),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.bottomRight,
                      radius: 1.0,
                      colors: [
                        data.mainColor.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 20,
                top: 24,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: data.mainColor.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.45),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: data.neonColor.withValues(alpha: 0.45),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: Icon(
                    data.icon,
                    color: Colors.white,
                    size: 46,
                  ),
                ),
              ),

              Positioned(
                left: 122,
                right: 18,
                top: 24,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shadowText(
                        data.label,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                      const SizedBox(height: 6),
                      _shadowText(
                        miniGame.title,
                        fontSize: 23,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      _shadowText(
                        miniGame.description,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        maxLines: 2,
                        color: Colors.white.withValues(alpha: 0.94),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 24,
                bottom: 96,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 37,
                        lineWidth: 8,
                        percent: progress.toDouble(),
                        progressColor: data.neonColor,
                        backgroundColor: Colors.white.withValues(alpha: 0.28),
                        center: Text(
                          '${miniGame.questions.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 8),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _shadowText(
                        '${miniGame.questions.length} retos\ndisponibles',
                        fontSize: 18,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 24,
                right: 24,
                bottom: 22,
                child: Row(
                  children: [
                    Expanded(child: _buildStatusButton(status)),
                    const SizedBox(width: 14),
                    _buildPlayButton(
                      data: data,
                      completed: status == MiniGameStatus.completed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(delay: (index * 90).ms)
          .slideY(begin: 0.18, curve: Curves.easeOutBack),
    );
  }

  Widget _shadowText(
      String text, {
        required double fontSize,
        Color color = Colors.white,
        FontWeight fontWeight = FontWeight.w900,
        double letterSpacing = 0,
        int maxLines = 1,
      }) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: 1.12,
        shadows: const [
          Shadow(
            color: Colors.black,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _fallbackGradient(_GameVisual data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildStatusButton(MiniGameStatus status) {
    String text;
    IconData icon;

    switch (status) {
      case MiniGameStatus.completed:
        text = 'Completado';
        icon = Icons.check_circle;
        break;
      case MiniGameStatus.inProgress:
        text = 'En progreso';
        icon = Icons.timelapse;
        break;
      case MiniGameStatus.notStarted:
        text = 'Sin iniciar';
        icon = Icons.radio_button_unchecked;
        break;
    }

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.65),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(color: Colors.black, blurRadius: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton({
    required _GameVisual data,
    required bool completed,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      decoration: BoxDecoration(
        color: data.neonColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: data.neonColor.withValues(alpha: 0.75),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            completed ? 'Ver' : 'Jugar',
            style: TextStyle(
              color: data.buttonTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.play_arrow_rounded,
            color: data.buttonTextColor,
            size: 24,
          ),
        ],
      ),
    );
  }

  _GameVisual _gameVisual(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.musical:
        return _GameVisual(
          label: 'MÚSICA',
          icon: Icons.music_note,
          mainColor: const Color(0xFF7C3AED),
          neonColor: const Color(0xFFE9D5FF),
          buttonTextColor: const Color(0xFF581C87),
          gradient: const [Color(0xFF160A3A), Color(0xFF7C3AED)],
          imagePath: 'assets/images/musical.jpg',
        );

      case VocationalCategory.biologico:
        return _GameVisual(
          label: 'BIOLOGÍA',
          icon: Icons.eco,
          mainColor: const Color(0xFF16A34A),
          neonColor: const Color(0xFF86EFAC),
          buttonTextColor: const Color(0xFF14532D),
          gradient: const [Color(0xFF052E16), Color(0xFF059669)],
          imagePath: 'assets/images/biologico.jpg',
        );

      case VocationalCategory.mecanico:
        return _GameVisual(
          label: 'MECÁNICO',
          icon: Icons.build,
          mainColor: const Color(0xFF0284C7),
          neonColor: const Color(0xFFBAE6FD),
          buttonTextColor: const Color(0xFF0C4A6E),
          gradient: const [Color(0xFF0F172A), Color(0xFF0369A1)],
          imagePath: 'assets/images/mecanico.jpg',
        );

      case VocationalCategory.artistico:
        return _GameVisual(
          label: 'ARTE',
          icon: Icons.palette,
          mainColor: const Color(0xFFF97316),
          neonColor: const Color(0xFFFED7AA),
          buttonTextColor: const Color(0xFF7C2D12),
          gradient: const [Color(0xFF7C2D12), Color(0xFFF97316)],
          imagePath: 'assets/images/artistico.jpg',
        );

      case VocationalCategory.calculo:
        return _GameVisual(
          label: 'LÓGICA',
          icon: Icons.calculate,
          mainColor: const Color(0xFF4F46E5),
          neonColor: const Color(0xFFC7D2FE),
          buttonTextColor: const Color(0xFF312E81),
          gradient: const [Color(0xFF111827), Color(0xFF4338CA)],
          imagePath: 'assets/images/logica.jpg',
        );

      case VocationalCategory.fisico:
        return _GameVisual(
          label: 'CIENCIA FÍSICA',
          icon: Icons.auto_awesome,
          mainColor: const Color(0xFF6D28D9),
          neonColor: const Color(0xFFC4B5FD),
          buttonTextColor: const Color(0xFF4C1D95),
          gradient: const [Color(0xFF10103A), Color(0xFF6D28D9)],
          imagePath: 'assets/images/cientifico.jpg',
        );

      case VocationalCategory.social:
        return _GameVisual(
          label: 'SERVICIO',
          icon: Icons.volunteer_activism,
          mainColor: const Color(0xFFDB2777),
          neonColor: const Color(0xFFFBCFE8),
          buttonTextColor: const Color(0xFF831843),
          gradient: const [Color(0xFF831843), Color(0xFFDB2777)],
          imagePath: 'assets/images/serviciosocial.jpg',
        );

      case VocationalCategory.literario:
        return _GameVisual(
          label: 'LECTURA',
          icon: Icons.menu_book,
          mainColor: const Color(0xFFA16207),
          neonColor: const Color(0xFFFDE68A),
          buttonTextColor: const Color(0xFF713F12),
          gradient: const [Color(0xFF422006), Color(0xFF92400E)],
          imagePath: 'assets/images/literario.jpg',
        );

      case VocationalCategory.persuasivo:
        return _GameVisual(
          label: 'LIDERAZGO',
          icon: Icons.campaign,
          mainColor: const Color(0xFFF97316),
          neonColor: const Color(0xFFFED7AA),
          buttonTextColor: const Color(0xFF7C2D12),
          gradient: const [Color(0xFF7C2D12), Color(0xFFEA580C)],
          imagePath: 'assets/images/persuasivo.jpg',
        );
    }
  }
}

class _GameVisual {
  final String label;
  final IconData icon;
  final Color mainColor;
  final Color neonColor;
  final Color buttonTextColor;
  final List<Color> gradient;
  final String imagePath;

  _GameVisual({
    required this.label,
    required this.icon,
    required this.mainColor,
    required this.neonColor,
    required this.buttonTextColor,
    required this.gradient,
    required this.imagePath,
  });
}
</file>

<file path="shared/theme/theme.dart">
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF311B92),
        primary: const Color(0xFF311B92),
        secondary: const Color(0xFF9B51E0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF1D1B4B),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Color(0xFF1D1B4B)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF311B92),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF311B92), width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
</file>

<file path="app.dart">
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'core/routes/app_router.dart';
import 'shared/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicialización de ScreenUtil para adaptabilidad de fuentes y tamaños
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Tamaño base de diseño (iPhone X/11/12/13/14)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Oriéntate+',
          theme: AppTheme.lightTheme,
          
          // Configuración de GoRouter (Enrutado 2.0)
          routerConfig: appRouter,
          
          // Configuración de Responsive Framework para breakpoints profesionales
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
        );
      },
    );
  }
}
</file>

<file path="main.dart">
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:orientate/app.dart';
import 'package:orientate/core/di/injection_container.dart' as di;

import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/chatbot/presentation/providers/chat_provider.dart';
import 'features/counselor/presentation/providers/counselor_provider.dart';
import 'features/student/presentation/providers/student_home_provider.dart';
import 'features/student/presentation/providers/student_profile_provider.dart';
import 'features/student/presentation/providers/student_results_provider.dart';
import 'features/vocational_games/presentation/providers/games_provider.dart';
import 'features/chat/presentation/providers/chat_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: 'assets/.env');
  } catch (_) {}

  await di.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<CounselorProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<StudentHomeProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<StudentProfileProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<StudentResultsProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<GamesProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ChatProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ChatbotProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}
</file>

</files>
