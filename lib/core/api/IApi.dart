import 'dart:typed_data';

abstract class IApi {
  // --- 🔐 SERVICIO DE AUTENTICACIÓN ---
  Future<Map<String, dynamic>> checkAuthHealth();
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(Map<String, dynamic> data);
  Future<Map<String, dynamic>> getMe(String token);
  Future<Map<String, dynamic>> updateProfile(String token, Map<String, dynamic> data);
  Future<void> logout(String token);
  Future<Map<String, dynamic>> recoverPassword(String email);
  Future<Map<String, dynamic>> resetPassword(String token, String newPassword);
  Future<Map<String, dynamic>> getRoles(String token);
  Future<Map<String, dynamic>> updateUserRole(String token, String userId, String roleName);

  // --- 🖼️ SERVICIO DE AVATAR (AWS S3) ---
  Future<Map<String, dynamic>> getAvatarUploadUrl(String token);
  Future<void> uploadImageToS3(String uploadUrl, Uint8List imageBytes);
  Future<Map<String, dynamic>> updateAvatarInBackend(String token, String avatarUrl);

  // --- 👑 SERVICIO DE ADMINISTRADOR ---
  Future<Map<String, dynamic>> getAdminStats(String token);
  Future<List<dynamic>> getAllUsers(String token);
  Future<Map<String, dynamic>> toggleUserStatus(String token, String userId, bool isActive);
  Future<void> deleteUser(String token, String userId);

  // --- 🎓 SERVICIO DE ESTUDIANTES ---
  Future<Map<String, dynamic>> checkStudentsHealth();
  Future<Map<String, dynamic>> createStudentProfile(String token, Map<String, dynamic> data);
  Future<Map<String, dynamic>> getStudentProfile(String token);
  Future<Map<String, dynamic>> updateStudentProfile(String token, Map<String, dynamic> data);
  Future<Map<String, dynamic>> joinGroup(String token, String accessCode);
  Future<List<dynamic>> getStudentGroups(String token);
  Future<Map<String, dynamic>> requestCounselorSupport(String token, String message);
  Future<Map<String, dynamic>> getStudentCounselor(String token);

  // --- 📅 CITAS (STUDENT) ---
  Future<Map<String, dynamic>> scheduleAppointment(String token, Map<String, dynamic> data);
  Future<List<dynamic>> getStudentAppointments(String token);

  // --- 🎓 SERVICIO DE ORIENTADORES ---
  Future<Map<String, dynamic>> createGroup(String token, Map<String, dynamic> data);
  Future<List<dynamic>> getGroups(String token);
  Future<Map<String, dynamic>> getGroupDetail(String token, String groupId);
  Future<Map<String, dynamic>> updateGroup(String token, String groupId, Map<String, dynamic> data);
  Future<List<dynamic>> getGroupStudents(String token, String groupId);
  Future<Map<String, dynamic>> getStudentFile(String token, String studentId);
  Future<Map<String, dynamic>> registerSession(String token, String studentId, Map<String, dynamic> data);
  Future<Map<String, dynamic>> createTask(String token, Map<String, dynamic> data);
  Future<List<dynamic>> getCounselorStudents(String token);
  Future<List<dynamic>> getConsultations(String token);
  Future<Map<String, dynamic>> getCounselorStats(String token);

  // --- 📅 CITAS (COUNSELOR) ---
  Future<List<dynamic>> getCounselorAppointments(String token);
  Future<Map<String, dynamic>> counselorScheduleAppointment(String token, Map<String, dynamic> data);

  // --- 🎓 SERVICIO DE ALUMNI (EGRESADOS) ---
  Future<Map<String, dynamic>> getAlumniProfile(String token);
  Future<Map<String, dynamic>> updateAlumniProfile(String token, Map<String, dynamic> data);
  Future<List<dynamic>> getSuccessStories(String token);
  Future<Map<String, dynamic>> shareSuccessStory(String token, Map<String, dynamic> data);

  // --- 💬 SERVICIO DE CHAT ---
  Future<Map<String, dynamic>> getChatHistory(String token, String partnerId, {int limit = 50, int offset = 0});
  Future<Map<String, dynamic>> getChatContacts(String token);

  // --- 🎮 SERVICIO DE MINIJUEGOS ---
  Future<Map<String, dynamic>> checkGamesHealth();
  Future<List<dynamic>> getGames();
  Future<Map<String, dynamic>> getGameDetail(String token, String gameId);
  Future<List<dynamic>> getGameQuestions(String token, String gameId);
  Future<Map<String, dynamic>> getCatalogUniversities(String token, {int page = 1, int limit = 20, String search = ''});
  Future<Map<String, dynamic>> startGame(String token, String gameId);
  Future<void> sendAnswer(String token, String gameId, Map<String, dynamic> data);
  Future<Map<String, dynamic>> finishGame(String gameId, String token, String sessionId);
  Future<List<dynamic>> getGameResults(String token);

  // --- 🎓 SERVICIO DE UNIVERSIDADES (REPRESENTANTE) ---
  Future<List<dynamic>> getCatalogCareers(String token);
  Future<List<dynamic>> getAvailableCatalogCareers(String token);
  Future<Map<String, dynamic>> createCustomUniversityCareer(String token, Map<String, dynamic> data);
  Future<Map<String, dynamic>> claimUniversity(String token, {required String cct, required String rfc});
  Future<List<dynamic>> getUniversityCareers(String token);
  Future<Map<String, dynamic>> addUniversityCareer(String token, Map<String, dynamic> data);
  Future<void> updateUniversityCareer(String token, String careerId, Map<String, dynamic> data);
  Future<void> deleteUniversityCareer(String token, String careerId);
  Future<Map<String, dynamic>> getEventPresignedUrl(String token, {required String contentType});
  Future<List<dynamic>> getUniversityEvents(String token);
  Future<Map<String, dynamic>> createUniversityEvent(String token, Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateUniversityEvent(String token, String eventId, Map<String, dynamic> data);
  Future<void> deleteUniversityEvent(String token, String eventId);

  // Anuncios / Convocatorias
  Future<List<dynamic>> getUniversityAnnouncements(String token);
  Future<Map<String, dynamic>> createUniversityAnnouncement(String token, Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateUniversityAnnouncement(String token, String announcementId, Map<String, dynamic> data);
  Future<void> deleteUniversityAnnouncement(String token, String announcementId);

  // Gestión de Egresados (Alumni)
  Future<List<dynamic>> getUniversityAlumni(String token);
  Future<Map<String, dynamic>> createUniversityAlumni(String token, Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateUniversityAlumni(String token, String alumniId, Map<String, dynamic> data);
  Future<void> deleteUniversityAlumni(String token, String alumniId);

  // University Story Moderation
  Future<List<dynamic>> getPendingSuccessStories(String token);
  Future<Map<String, dynamic>> approveSuccessStory(String token, String storyId);
  Future<Map<String, dynamic>> rejectSuccessStory(String token, String storyId);

  // --- 💳 SERVICIO DE PAGOS ---
  Future<Map<String, dynamic>> createPaymentPreference(String token, Map<String, dynamic> data);
}
