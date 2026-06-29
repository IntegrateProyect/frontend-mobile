import 'dart:convert';

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

      token ??= response.headers['x-auth-token'] ??
          response.headers['X-Auth-Token'];

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
  Future<Map<String, dynamic>> getChatHistory(String token, String partnerId,
      {int limit = 50, int offset = 0}) async {
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

      final data = result is Map && result['data'] != null
          ? result['data']
          : result;

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
