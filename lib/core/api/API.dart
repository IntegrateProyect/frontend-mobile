import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'IApi.dart';
import '../utils/handlers.dart';

class API implements IApi {
  static final String _baseUrl = (
      dotenv.env['API_URL'] ??
          'https://orientate-backend.shop/api/v1'
  ).replaceFirst(
    RegExp(r'/$'),
    '',
  );

  Map<String, String> getHeaders([
    String? token,
  ]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null &&
        token.trim().isNotEmpty) {
      headers['Authorization'] =
      'Bearer ${token.trim()}';
    }

    return headers;
  }

  Uri _buildUri(
      String path, {
        Map<String, String>? queryParameters,
      }) {
    final normalizedPath = path.startsWith('/')
        ? path
        : '/$path';

    final uri = Uri.parse(
      '$_baseUrl$normalizedPath',
    );

    if (queryParameters == null ||
        queryParameters.isEmpty) {
      return uri;
    }

    return uri.replace(
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> _request({
    required String method,
    required String path,
    String? token,
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Object? logData,
  }) async {
    final uri = _buildUri(
      path,
      queryParameters: queryParameters,
    );

    final url = uri.toString();

    try {
      ApiLogger.request(
        method,
        url,
        logData ??
            body ??
            queryParameters ??
            <String, dynamic>{},
      );

      final encodedBody =
      body == null ? null : jsonEncode(body);

      late final http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(
            uri,
            headers: getHeaders(token),
          );
          break;

        case 'POST':
          response = await http.post(
            uri,
            headers: getHeaders(token),
            body: encodedBody,
          );
          break;

        case 'PUT':
          response = await http.put(
            uri,
            headers: getHeaders(token),
            body: encodedBody,
          );
          break;

        case 'PATCH':
          response = await http.patch(
            uri,
            headers: getHeaders(token),
            body: encodedBody,
          );
          break;

        case 'DELETE':
          response = await http.delete(
            uri,
            headers: getHeaders(token),
            body: encodedBody,
          );
          break;

        default:
          throw UnsupportedError(
            'Método HTTP no soportado: $method',
          );
      }

      final dynamic result =
      processResponse(response);

      ApiLogger.response(
        method,
        url,
        result,
      );

      return result;
    } catch (error) {
      ApiLogger.error(
        method,
        url,
        error,
      );

      rethrow;
    }
  }

  Map<String, dynamic> _asMap(
      dynamic value,
      ) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(
        value,
      );
    }

    return <String, dynamic>{};
  }

  List<dynamic> _asList(
      dynamic value, {
        List<String> keys =
        const <String>['data'],
      }) {
    if (value is List) {
      return List<dynamic>.from(value);
    }

    if (value is Map) {
      final map = Map<String, dynamic>.from(
        value,
      );

      for (final key in keys) {
        final possibleList = map[key];

        if (possibleList is List) {
          return List<dynamic>.from(
            possibleList,
          );
        }
      }

      final data = map['data'];

      if (data is Map) {
        final dataMap =
        Map<String, dynamic>.from(data);

        for (final key in keys) {
          final possibleList = dataMap[key];

          if (possibleList is List) {
            return List<dynamic>.from(
              possibleList,
            );
          }
        }
      }
    }

    return <dynamic>[];
  }

  Map<String, dynamic> _mapFromData(
      dynamic value,
      ) {
    final root = _asMap(value);
    final data = root['data'];

    if (data is Map) {
      return Map<String, dynamic>.from(
        data,
      );
    }

    return root;
  }

  // ==========================================================
  // AUTENTICACIÓN
  // ==========================================================

  @override
  Future<Map<String, dynamic>>
  checkAuthHealth() async {
    final result = await _request(
      method: 'GET',
      path: '/auth/health',
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {
    final uri = _buildUri('/auth/login');
    final url = uri.toString();

    try {
      ApiLogger.request(
        'POST',
        url,
        {
          'email': email,
          'password': '[HIDDEN]',
        },
      );

      final response = await http.post(
        uri,
        headers: getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final dynamic decoded =
      processResponse(response);

      final result = _asMap(decoded);

      final authorizationHeader =
      response.headers['authorization'];

      final alternativeToken =
      response.headers['x-auth-token'];

      String? headerToken;

      if (authorizationHeader != null &&
          authorizationHeader.isNotEmpty) {
        if (authorizationHeader
            .startsWith('Bearer ')) {
          headerToken =
              authorizationHeader.substring(7);
        } else {
          headerToken = authorizationHeader;
        }
      }

      headerToken ??= alternativeToken;

      if (headerToken != null &&
          headerToken.trim().isNotEmpty) {
        result['token'] = headerToken.trim();
      }

      ApiLogger.response(
        'POST',
        url,
        result,
      );

      return result;
    } catch (error) {
      ApiLogger.error(
        'POST',
        url,
        error,
      );

      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> register(
      Map<String, dynamic> data,
      ) async {
    final safeLogData =
    Map<String, dynamic>.from(data);

    if (safeLogData.containsKey('password')) {
      safeLogData['password'] = '[HIDDEN]';
    }

    if (safeLogData.containsKey(
      'confirmPassword',
    )) {
      safeLogData['confirmPassword'] =
      '[HIDDEN]';
    }

    final result = await _request(
      method: 'POST',
      path: '/auth/register',
      body: data,
      logData: safeLogData,
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> getMe(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/auth/me',
      token: token,
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> updateProfile(
      String token,
      Map<String, dynamic> data,
      ) async {
    final result = await _request(
      method: 'PATCH',
      path: '/auth/me',
      token: token,
      body: data,
    );

    return _asMap(result);
  }

  @override
  Future<void> logout(
      String token,
      ) async {
    await _request(
      method: 'POST',
      path: '/auth/logout',
      token: token,
    );
  }

  @override
  Future<Map<String, dynamic>>
  recoverPassword(
      String email,
      ) async {
    final result = await _request(
      method: 'POST',
      path: '/auth/recover-password',
      body: {
        'email': email,
      },
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>>
  resetPassword(
      String token,
      String newPassword,
      ) async {
    final result = await _request(
      method: 'POST',
      path: '/auth/reset-password',
      body: {
        'token': token,
        'newPassword': newPassword,
      },
      logData: {
        'token': '[HIDDEN]',
        'newPassword': '[HIDDEN]',
      },
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> getRoles(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/auth/roles',
      token: token,
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>>
  updateUserRole(
      String token,
      String userId,
      String roleName,
      ) async {
    final result = await _request(
      method: 'PATCH',
      path: '/auth/users/$userId/role',
      token: token,
      body: {
        'roleName': roleName,
      },
    );

    return _asMap(result);
  }

  // ==========================================================
  // AVATAR Y AWS S3
  // ==========================================================

  @override
  Future<Map<String, dynamic>>
  getAvatarUploadUrl(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path:
      '/auth/users/avatar-upload-url',
      token: token,
    );

    return _asMap(result);
  }

  @override
  Future<void> uploadImageToS3(
      String uploadUrl,
      Uint8List imageBytes,
      ) async {
    try {
      final response = await http.put(
        Uri.parse(uploadUrl),
        headers: const {
          'Content-Type': 'image/jpeg',
        },
        body: imageBytes,
      );

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          'Error subiendo imagen a S3. '
              'Código: ${response.statusCode}. '
              'Respuesta: ${response.body}',
        );
      }
    } catch (error) {
      ApiLogger.error(
        'PUT',
        uploadUrl,
        error,
      );

      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>>
  updateAvatarInBackend(
      String token,
      String avatarUrl,
      ) async {
    final result = await _request(
      method: 'PUT',
      path: '/auth/users/avatar',
      token: token,
      body: {
        'avatarUrl': avatarUrl,
      },
    );

    return _asMap(result);
  }

  // ==========================================================
  // ADMINISTRADOR
  // ==========================================================

  @override
  Future<Map<String, dynamic>>
  getAdminStats(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/admin/stats',
      token: token,
    );

    return _mapFromData(result);
  }

  @override
  Future<List<dynamic>> getAllUsers(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/admin/users',
      token: token,
    );

    return _asList(
      result,
      keys: const [
        'data',
        'users',
      ],
    );
  }

  @override
  Future<Map<String, dynamic>>
  toggleUserStatus(
      String token,
      String userId,
      bool isActive,
      ) async {
    final result = await _request(
      method: 'PATCH',
      path: '/admin/users/$userId/status',
      token: token,
      body: {
        'isActive': isActive,
      },
    );

    return _asMap(result);
  }

  @override
  Future<void> deleteUser(
      String token,
      String userId,
      ) async {
    await _request(
      method: 'DELETE',
      path: '/admin/users/$userId',
      token: token,
    );
  }

  // ==========================================================
  // ESTUDIANTES
  // ==========================================================

  @override
  Future<Map<String, dynamic>>
  checkStudentsHealth() async {
    final result = await _request(
      method: 'GET',
      path: '/students/health',
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>>
  createStudentProfile(
      String token,
      Map<String, dynamic> data,
      ) async {
    final result = await _request(
      method: 'POST',
      path: '/students/profile',
      token: token,
      body: data,
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>>
  getStudentProfile(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/students/profile',
      token: token,
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>>
  updateStudentProfile(
      String token,
      Map<String, dynamic> data,
      ) async {
    final result = await _request(
      method: 'PATCH',
      path: '/students/profile',
      token: token,
      body: data,
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> joinGroup(
      String token,
      String accessCode,
      ) async {
    final result = await _request(
      method: 'POST',
      path: '/students/join-group',
      token: token,
      body: {
        'accessCode': accessCode,
      },
    );

    return _asMap(result);
  }

  @override
  Future<List<dynamic>> getStudentGroups(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/students/groups',
      token: token,
    );

    return _asList(
      result,
      keys: const [
        'data',
        'groups',
      ],
    );
  }

  @override
  Future<Map<String, dynamic>> requestCounselorSupport(String token, String message) async {
    final result = await _request(
      method: 'POST',
      path: '/students/request-support',
      token: token,
      body: {
        'message': message,
      },
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> getStudentCounselor(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/students/counselor',
      token: token,
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> scheduleAppointment(String token, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'POST',
      path: '/students/appointments',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  @override
  Future<List<dynamic>> getStudentAppointments(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/students/appointments',
      token: token,
    );
    return _asList(result);
  }

  // ==========================================================
  // ORIENTADORES
  // ==========================================================

  @override
  Future<Map<String, dynamic>> createGroup(
      String token,
      Map<String, dynamic> data,
      ) async {
    final result = await _request(
      method: 'POST',
      path: '/counselors/groups',
      token: token,
      body: data,
    );

    return _asMap(result);
  }

  @override
  Future<List<dynamic>> getGroups(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/counselors/groups',
      token: token,
    );

    return _asList(
      result,
      keys: const [
        'data',
        'groups',
      ],
    );
  }

  @override
  Future<Map<String, dynamic>>
  getGroupDetail(
      String token,
      String groupId,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/counselors/groups/$groupId',
      token: token,
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>>
  updateGroup(
      String token,
      String groupId,
      Map<String, dynamic> data,
      ) async {
    final result = await _request(
      method: 'PUT',
      path: '/counselors/groups/$groupId',
      token: token,
      body: data,
    );

    return _asMap(result);
  }

  @override
  Future<List<dynamic>> getGroupStudents(
      String token,
      String groupId,
      ) async {
    final result = await _request(
      method: 'GET',
      path:
      '/counselors/groups/$groupId/students',
      token: token,
    );

    return _asList(
      result,
      keys: const [
        'data',
        'students',
      ],
    );
  }

  @override
  Future<Map<String, dynamic>>
  getStudentFile(
      String token,
      String studentId,
      ) async {
    final result = await _request(
      method: 'GET',
      path:
      '/counselors/students/$studentId/file',
      token: token,
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>>
  registerSession(
      String token,
      String studentId,
      Map<String, dynamic> data,
      ) async {
    final result = await _request(
      method: 'POST',
      path:
      '/counselors/students/$studentId/sessions',
      token: token,
      body: data,
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> createTask(
      String token,
      Map<String, dynamic> data,
      ) async {
    final result = await _request(
      method: 'POST',
      path: '/counselors/tasks',
      token: token,
      body: data,
    );

    return _asMap(result);
  }

  @override
  Future<List<dynamic>>
  getCounselorStudents(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/counselors/students',
      token: token,
    );

    return _asList(
      result,
      keys: const [
        'data',
        'students',
      ],
    );
  }

  @override
  Future<List<dynamic>> getConsultations(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/counselors/consultations',
      token: token,
    );

    return _asList(
      result,
      keys: const [
        'data',
        'consultations',
      ],
    );
  }

  @override
  Future<Map<String, dynamic>>
  getCounselorStats(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/counselors/stats',
      token: token,
    );

    return _mapFromData(result);
  }

  @override
  Future<List<dynamic>> getCounselorAppointments(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/counselors/appointments',
      token: token,
    );
    return _asList(result);
  }

  @override
  Future<Map<String, dynamic>> counselorScheduleAppointment(String token, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'POST',
      path: '/counselors/appointments',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  // ==========================================================
  // SERVICIO DE ALUMNI (EGRESADOS)
  // ==========================================================

  @override
  Future<Map<String, dynamic>> getAlumniProfile(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/alumni/profile',
      token: token,
    );
    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> updateAlumniProfile(String token, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'POST',
      path: '/alumni/profile',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  @override
  Future<List<dynamic>> getSuccessStories(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/alumni/stories',
      token: token,
    );
    return _asList(result);
  }

  @override
  Future<Map<String, dynamic>> shareSuccessStory(String token, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'POST',
      path: '/alumni/stories',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  @override
  Future<List<dynamic>> getPendingSuccessStories(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/university/stories/pending',
      token: token,
    );
    return _asList(result);
  }

  @override
  Future<Map<String, dynamic>> approveSuccessStory(String token, String storyId) async {
    final result = await _request(
      method: 'POST',
      path: '/university/stories/$storyId/approve',
      token: token,
    );
    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> rejectSuccessStory(String token, String storyId) async {
    final result = await _request(
      method: 'POST',
      path: '/university/stories/$storyId/reject',
      token: token,
    );
    return _asMap(result);
  }

  // ==========================================================
  // CHAT
  // ==========================================================

  @override
  Future<Map<String, dynamic>>
  getChatHistory(
      String token,
      String partnerId, {
        int limit = 50,
        int offset = 0,
      }) async {
    final safeLimit =
    limit.clamp(1, 100).toInt();

    final safeOffset =
    offset < 0 ? 0 : offset;

    final result = await _request(
      method: 'GET',
      path: '/chat/history/$partnerId',
      token: token,
      queryParameters: {
        'limit': safeLimit.toString(),
        'offset': safeOffset.toString(),
      },
    );

    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>>
  getChatContacts(
      String token,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/chat/contacts',
      token: token,
    );

    return _asMap(result);
  }

  // ==========================================================
  // MINIJUEGOS VOCACIONALES
  // ==========================================================

  @override
  Future<Map<String, dynamic>>
  checkGamesHealth() async {
    final result = await _request(
      method: 'GET',
      path: '/games/health',
    );

    return _asMap(result);
  }

  @override
  Future<List<dynamic>> getGames() async {
    final result = await _request(
      method: 'GET',
      path: '/games',
    );

    return _asList(
      result,
      keys: const [
        'data',
        'games',
      ],
    );
  }

  @override
  Future<Map<String, dynamic>>
  getGameDetail(
      String token,
      String gameId,
      ) async {
    final result = await _request(
      method: 'GET',
      path: '/games/$gameId',
      token: token,
    );

    return _asMap(result);
  }

  @override
  Future<List<dynamic>>
  getGameQuestions(
      String token,
      String gameId,
      ) async {
    final detail = await getGameDetail(
      token,
      gameId,
    );

    final dynamic detailData =
        detail['data'] ?? detail;

    if (detailData is Map) {
      final map =
      Map<String, dynamic>.from(
        detailData,
      );

      final questions = map['questions'];

      if (questions is List) {
        return List<dynamic>.from(
          questions,
        );
      }
    }

    return <dynamic>[];
  }

  @override
  Future<Map<String, dynamic>> startGame(
      String token,
      String gameId,
      ) async {
    final result = await _request(
      method: 'POST',
      path: '/games/$gameId/start',
      token: token,
    );

    return _asMap(result);
  }

  @override
  Future<void> sendAnswer(
      String token,
      String gameId,
      Map<String, dynamic> data,
      ) async {
    /*
     * Es importante procesar la respuesta.
     * Antes solamente se ejecutaba el POST y un error
     * 400/401/500 podía pasar sin ser detectado.
     */
    await _request(
      method: 'POST',
      path: '/games/$gameId/answers',
      token: token,
      body: data,
    );
  }

  @override
  Future<Map<String, dynamic>> finishGame(
      String gameId,
      String token,
      String sessionId,
    ) async {
    final result = await _request(
      method: 'POST',
      path: '/games/$gameId/finish',
      token: token,
      body: {
        'sessionId': sessionId,
      },
    );

    return _asMap(result);
  }

  @override
  Future<List<dynamic>> getGameResults(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/games/students/results',
      token: token,
    );

    return _asList(
      result,
      keys: const [
        'data',
        'results',
      ],
    );
  }

  // ==========================================================
  // CATÁLOGO DE UNIVERSIDADES
  // ==========================================================

  @override
  Future<Map<String, dynamic>>
  getCatalogUniversities(
      String token, {
        int page = 1,
        int limit = 20,
        String search = '',
      }) async {
    final safePage = page < 1 ? 1 : page;

    final safeLimit =
    limit.clamp(1, 100).toInt();

    final cleanSearch = search.trim();

    final queryParameters =
    <String, String>{
      'page': safePage.toString(),
      'limit': safeLimit.toString(),
    };

    if (cleanSearch.isNotEmpty) {
      queryParameters['search'] =
          cleanSearch;
    }

    final result = await _request(
      method: 'GET',
      path: '/catalog/universities',
      token: token,
      queryParameters: queryParameters,
    );

    final mappedResult = _asMap(result);

    if (mappedResult.isEmpty &&
        result is! Map) {
      throw FormatException(
        'El catálogo de universidades '
            'devolvió un formato inválido.',
      );
    }

    return mappedResult;
  }

  // ==========================================================
  // SERVICIO DE UNIVERSIDADES (REPRESENTANTE)
  // ==========================================================

  @override
  Future<List<dynamic>> getCatalogCareers(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/catalog/careers',
      token: token,
    );
    return _asList(result, keys: const ['data']);
  }

  @override
  Future<List<dynamic>> getAvailableCatalogCareers(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/catalog/universities/available-careers',
      token: token,
    );
    return _asList(result, keys: const ['data']);
  }

  @override
  Future<Map<String, dynamic>> createCustomUniversityCareer(String token, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'POST',
      path: '/catalog/universities/careers/custom',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> claimUniversity(String token, {required String cct, required String rfc}) async {
    final result = await _request(
      method: 'POST',
      path: '/auth/universities/claim',
      token: token,
      body: {
        'cct': cct,
        'rfc': rfc,
      },
    );
    return _asMap(result);
  }

  @override
  Future<List<dynamic>> getUniversityCareers(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/catalog/universities/careers',
      token: token,
    );
    return _asList(result, keys: const ['data']);
  }

  @override
  Future<Map<String, dynamic>> addUniversityCareer(String token, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'POST',
      path: '/catalog/universities/careers',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  @override
  Future<void> updateUniversityCareer(String token, String careerId, Map<String, dynamic> data) async {
    await _request(
      method: 'PUT',
      path: '/catalog/universities/careers/$careerId',
      token: token,
      body: data,
    );
  }

  @override
  Future<void> deleteUniversityCareer(String token, String careerId) async {
    await _request(
      method: 'DELETE',
      path: '/catalog/universities/careers/$careerId',
      token: token,
    );
  }

  @override
  Future<Map<String, dynamic>> getEventPresignedUrl(String token, {required String contentType}) async {
    final result = await _request(
      method: 'POST',
      path: '/catalog/universities/events/presigned-url',
      token: token,
      body: {
        'contentType': contentType,
      },
    );
    return _asMap(result);
  }

  @override
  Future<List<dynamic>> getUniversityEvents(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/catalog/universities/events',
      token: token,
    );
    return _asList(result, keys: const ['data']);
  }

  @override
  Future<Map<String, dynamic>> createUniversityEvent(String token, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'POST',
      path: '/catalog/universities/events',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> updateUniversityEvent(String token, String eventId, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'PUT',
      path: '/catalog/universities/events/$eventId',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  @override
  Future<void> deleteUniversityEvent(String token, String eventId) async {
    await _request(
      method: 'DELETE',
      path: '/catalog/universities/events/$eventId',
      token: token,
    );
  }

  // --- 📢 ANUNCIOS / CONVOCATORIAS ---
  @override
  Future<List<dynamic>> getUniversityAnnouncements(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/catalog/universities/announcements',
      token: token,
    );
    return _asList(result, keys: const ['data']);
  }

  @override
  Future<Map<String, dynamic>> createUniversityAnnouncement(String token, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'POST',
      path: '/catalog/universities/announcements',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> updateUniversityAnnouncement(String token, String announcementId, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'PUT',
      path: '/catalog/universities/announcements/$announcementId',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  @override
  Future<void> deleteUniversityAnnouncement(String token, String announcementId) async {
    await _request(
      method: 'DELETE',
      path: '/catalog/universities/announcements/$announcementId',
      token: token,
    );
  }

  // --- 🎓 GESTIÓN DE EGRESADOS (ALUMNI) ---
  @override
  Future<List<dynamic>> getUniversityAlumni(String token) async {
    final result = await _request(
      method: 'GET',
      path: '/university/alumni',
      token: token,
    );
    return _asList(result, keys: const ['data']);
  }

  @override
  Future<Map<String, dynamic>> createUniversityAlumni(String token, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'POST',
      path: '/university/alumni',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  @override
  Future<Map<String, dynamic>> updateUniversityAlumni(String token, String alumniId, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'PUT',
      path: '/university/alumni/$alumniId',
      token: token,
      body: data,
    );
    return _asMap(result);
  }

  @override
  Future<void> deleteUniversityAlumni(String token, String alumniId) async {
    await _request(
      method: 'DELETE',
      path: '/university/alumni/$alumniId',
      token: token,
    );
  }

  @override
  Future<Map<String, dynamic>> createPaymentPreference(String token, Map<String, dynamic> data) async {
    final result = await _request(
      method: 'POST',
      path: '/payments/preference',
      token: token,
      body: data,
    );
    return _asMap(result);
  }
}
