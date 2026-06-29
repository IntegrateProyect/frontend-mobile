import '../../features/auth/data/datasources/models/user_model.dart';
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