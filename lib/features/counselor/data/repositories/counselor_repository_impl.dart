import 'package:flutter/foundation.dart';

import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

import '../../../auth/data/datasources/mappers/auth_mapper.dart';
import '../../../student/domain/entities/student_profile_entity.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/counselor_profile_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../../domain/repositories/counselor_repository.dart';

import '../datasources/models/appointment_model.dart';
import '../datasources/models/student_consultation_model.dart';

class CounselorRepositoryImpl implements CounselorRepository {
  final IApi api;
  final UserService userService;

  CounselorRepositoryImpl({
    required this.api,
    required this.userService,
  });

  // =========================================================
  // TOKEN
  // =========================================================

  Future<String> _getToken() async {
    final String? token = await userService.getToken();

    if (token == null || token.trim().isEmpty) {
      throw Exception('No hay una sesión activa');
    }

    return token.trim();
  }

  // =========================================================
  // PERFIL DEL ORIENTADOR
  // =========================================================

  @override
  Future<CounselorProfileEntity> getProfile() async {
    final userModel = await userService.getUser();

    if (userModel == null) {
      throw Exception(
        'No se encontró la sesión del orientador',
      );
    }

    final user = AuthMapper.toEntity(userModel);

    return CounselorProfileEntity(
      id: user.id,
      name: _cleanText(
        user.name,
        fallback: 'Orientador',
      ),
      email: _cleanText(
        user.email,
        fallback: 'Sin correo',
      ),
      institution: 'Institución no especificada',
      profileImageUrl: user.effectivePhotoUrl,
    );
  }

  // =========================================================
  // GRUPOS
  // =========================================================

  @override
  Future<List<dynamic>> getGroups() async {
    final String token = await _getToken();

    final List<dynamic> groups = await api.getGroups(
      token,
    );

    debugPrint(
      'GRUPOS DEL ORIENTADOR: $groups',
    );

    return groups;
  }

  @override
  Future<Map<String, dynamic>> getGroupDetails(
      String groupId,
      ) async {
    final String token = await _getToken();

    return api.getGroupDetail(
      token,
      groupId,
    );
  }

  @override
  Future<Map<String, dynamic>> createGroup(
      String name,
      String? accessCode,
      ) async {
    final String token = await _getToken();

    final Map<String, dynamic> body = {
      'name': name.trim(),
    };

    final String cleanAccessCode =
        accessCode?.trim() ?? '';

    if (cleanAccessCode.isNotEmpty) {
      body['accessCode'] = cleanAccessCode;
    }

    return api.createGroup(
      token,
      body,
    );
  }

  @override
  Future<Map<String, dynamic>> updateGroup(
      String groupId, {
        String? name,
        String? accessCode,
      }) async {
    final String token = await _getToken();

    final Map<String, dynamic> body = {};

    final String cleanName = name?.trim() ?? '';
    final String cleanCode =
        accessCode?.trim() ?? '';

    if (cleanName.isNotEmpty) {
      body['name'] = cleanName;
    }

    if (cleanCode.isNotEmpty) {
      body['accessCode'] = cleanCode;
    }

    return api.updateGroup(
      token,
      groupId,
      body,
    );
  }

  // =========================================================
  // ALUMNOS DE UN GRUPO
  // =========================================================

  @override
  Future<List<StudentProfileEntity>> getGroupStudents(
      String groupId,
      ) async {
    final String token = await _getToken();

    final List<dynamic> response =
    await api.getGroupStudents(
      token,
      groupId,
    );

    debugPrint(
      '==============================================',
    );
    debugPrint(
      'RESPUESTA ORIGINAL DE ALUMNOS DEL GRUPO:',
    );
    debugPrint(
      response.toString(),
    );
    debugPrint(
      '==============================================',
    );

    final List<StudentProfileEntity> students = [];

    for (final dynamic item in response) {
      if (item is! Map) {
        debugPrint(
          'Elemento ignorado porque no es un Map: $item',
        );
        continue;
      }

      final Map<String, dynamic> studentData =
      Map<String, dynamic>.from(item);

      final String studentId =
      _extractStudentId(studentData);

      if (studentId.isEmpty) {
        debugPrint(
          'ALUMNO IGNORADO: no contiene un ID válido. '
              'Datos recibidos: $studentData',
        );
        continue;
      }

      String name =
      _extractStudentName(studentData);

      String email =
      _extractStudentEmail(studentData);

      String? imageUrl =
      _extractStudentImage(studentData);

      Map<String, dynamic> completeProfile = {};

      /*
       * El endpoint del grupo puede devolver solamente
       * studentId, userId o un objeto de membresía.
       *
       * Cuando no trae nombre o correo se consulta
       * el expediente del alumno.
       */
      if (name.isEmpty || email.isEmpty) {
        try {
          final Map<String, dynamic> fileResponse =
          await api.getStudentFile(
            token,
            studentId,
          );

          debugPrint(
            'EXPEDIENTE CONSULTADO PARA $studentId:',
          );
          debugPrint(
            fileResponse.toString(),
          );

          completeProfile =
              _extractStudentProfile(fileResponse);

          if (name.isEmpty) {
            name = _extractStudentName(
              completeProfile,
            );
          }

          if (email.isEmpty) {
            email = _extractStudentEmail(
              completeProfile,
            );
          }

          imageUrl ??= _extractStudentImage(
            completeProfile,
          );
        } catch (error) {
          debugPrint(
            'NO SE PUDO COMPLETAR EL ALUMNO '
                '$studentId: $error',
          );
        }
      }

      /*
       * También revisamos el correo para crear un nombre
       * temporal más útil cuando el backend no envía name.
       */
      if (name.isEmpty &&
          email.isNotEmpty &&
          email.contains('@')) {
        name = _nameFromEmail(email);
      }

      final List<Map<String, dynamic>> sources = [
        studentData,
        completeProfile,
      ];

      final StudentProfileEntity student =
      StudentProfileEntity(
        id: studentId,
        name: name.isNotEmpty
            ? name
            : 'Alumno sin nombre',
        email: email.isNotEmpty
            ? email
            : 'Correo no disponible',
        profileImageUrl: imageUrl,
        groupName: _firstValueFromMaps(
          sources,
          const [
            'groupName',
            'group_name',
          ],
        ),
        groupCode: _firstValueFromMaps(
          sources,
          const [
            'groupCode',
            'group_code',
            'accessCode',
            'access_code',
          ],
        ),
        subjectsLiked: _firstListFromMaps(
          sources,
          const [
            'subjectsLiked',
            'subjects_liked',
          ],
        ),
        subjectsDisliked: _firstListFromMaps(
          sources,
          const [
            'subjectsDisliked',
            'subjects_disliked',
          ],
        ),
        interests: _firstListFromMaps(
          sources,
          const [
            'interests',
          ],
        ),
        skills: _firstListFromMaps(
          sources,
          const [
            'skills',
          ],
        ),
        needsScholarship: _firstBoolFromMaps(
          sources,
          const [
            'needsScholarship',
            'needs_scholarship',
          ],
        ),
        studyAbroad: _firstBoolFromMaps(
          sources,
          const [
            'studyAbroad',
            'study_abroad',
          ],
        ),
        vocationalClarity: _firstIntFromMaps(
          sources,
          const [
            'vocationalClarity',
            'vocational_clarity',
          ],
          fallback: 1,
        ),
      );

      students.add(student);

      debugPrint(
        'ALUMNO FINAL MAPEADO: '
            'id=${student.id} | '
            'nombre=${student.name} | '
            'correo=${student.email}',
      );
    }

    return _removeDuplicatedStudents(
      students,
    );
  }

  // =========================================================
  // TODOS LOS ALUMNOS DEL ORIENTADOR
  // =========================================================

  @override
  Future<List<StudentProfileEntity>> getStudents() async {
    final String token = await _getToken();

    /*
     * Primero se intenta consultar el endpoint general.
     */
    try {
      final List<dynamic> response =
      await api.getCounselorStudents(
        token,
      );

      if (response.isNotEmpty) {
        final List<StudentProfileEntity> students = [];

        for (final dynamic item in response) {
          if (item is! Map) {
            continue;
          }

          final Map<String, dynamic> data =
          Map<String, dynamic>.from(item);

          final String studentId =
          _extractStudentId(data);

          if (studentId.isEmpty) {
            continue;
          }

          String name =
          _extractStudentName(data);

          String email =
          _extractStudentEmail(data);

          if (name.isEmpty &&
              email.isNotEmpty &&
              email.contains('@')) {
            name = _nameFromEmail(email);
          }

          students.add(
            StudentProfileEntity(
              id: studentId,
              name: name.isNotEmpty
                  ? name
                  : 'Alumno sin nombre',
              email: email.isNotEmpty
                  ? email
                  : 'Correo no disponible',
              profileImageUrl:
              _extractStudentImage(data),
            ),
          );
        }

        if (students.isNotEmpty) {
          return _removeDuplicatedStudents(
            students,
          );
        }
      }
    } catch (error) {
      debugPrint(
        'El endpoint general de alumnos '
            'no está disponible: $error',
      );
    }

    /*
     * Si el endpoint general falla o está vacío,
     * se recorren todos los grupos.
     */
    final List<dynamic> groups =
    await api.getGroups(token);

    final List<StudentProfileEntity> allStudents = [];

    for (final dynamic item in groups) {
      if (item is! Map) {
        continue;
      }

      final Map<String, dynamic> group =
      Map<String, dynamic>.from(item);

      final String groupId = _firstString([
        group['id'],
        group['groupId'],
        group['group_id'],
      ]) ??
          '';

      if (groupId.isEmpty) {
        continue;
      }

      try {
        final List<StudentProfileEntity> groupStudents =
        await getGroupStudents(
          groupId,
        );

        allStudents.addAll(
          groupStudents,
        );
      } catch (error) {
        debugPrint(
          'No fue posible cargar alumnos '
              'del grupo $groupId: $error',
        );
      }
    }

    return _removeDuplicatedStudents(
      allStudents,
    );
  }

  // =========================================================
  // EXPEDIENTE
  // =========================================================

  @override
  Future<Map<String, dynamic>> getStudentFile(
      String studentId,
      ) async {
    final String token = await _getToken();

    return api.getStudentFile(
      token,
      studentId,
    );
  }

  // =========================================================
  // SESIONES
  // =========================================================

  @override
  Future<void> registerSession(
      String studentId,
      Map<String, dynamic> sessionData,
      ) async {
    final String token = await _getToken();

    await api.registerSession(
      token,
      studentId,
      sessionData,
    );
  }

  // =========================================================
  // TAREAS
  // =========================================================

  @override
  Future<void> assignTask(
      Map<String, dynamic> taskData,
      ) async {
    final String token = await _getToken();

    await api.createTask(
      token,
      taskData,
    );
  }

  // =========================================================
  // SOLICITUD DE APOYO
  // =========================================================

  @override
  Future<void> requestSupport(
      String message,
      ) async {
    final String token = await _getToken();

    await api.requestCounselorSupport(
      token,
      message,
    );
  }

  // =========================================================
  // CONSULTAS
  // =========================================================

  @override
  Future<List<StudentConsultationEntity>>
  getConsultations() async {
    final String token = await _getToken();

    final List<dynamic> response =
    await api.getConsultations(
      token,
    );

    return response
        .whereType<Map>()
        .map(
          (dynamic item) =>
          StudentConsultationModel.fromJson(
            Map<String, dynamic>.from(
              item as Map,
            ),
          ),
    )
        .toList();
  }

  @override
  Future<void> respondToConsultation(
      String consultationId,
      String response,
      ) async {
    /*
     * Pendiente de conectar cuando exista
     * el endpoint para responder consultas.
     */
  }

  // =========================================================
  // ESTADÍSTICAS
  // =========================================================

  @override
  Future<Map<String, dynamic>> getStats() async {
    final String token = await _getToken();

    return api.getCounselorStats(
      token,
    );
  }

  // =========================================================
  // CITAS
  // =========================================================

  @override
  Future<List<AppointmentEntity>>
  getAppointments() async {
    return getCounselorAppointments();
  }

  @override
  Future<List<AppointmentEntity>>
  getCounselorAppointments() async {
    final String token = await _getToken();

    final List<dynamic> response =
    await api.getCounselorAppointments(
      token,
    );

    return response
        .whereType<Map>()
        .map(
          (dynamic item) =>
          AppointmentModel.fromJson(
            Map<String, dynamic>.from(
              item as Map,
            ),
          ),
    )
        .toList();
  }

  @override
  Future<void> scheduleAppointment(
      String studentId,
      DateTime date,
      String motive,
      ) async {
    final String token = await _getToken();

    await api.counselorScheduleAppointment(
      token,
      {
        'studentId': studentId,
        'sessionDate': date.toIso8601String(),
        'motive': motive.trim(),
      },
    );
  }

  // =========================================================
  // MAPEO DEL ALUMNO
  // =========================================================

  String _extractStudentId(
      Map<String, dynamic> data,
      ) {
    final Map<String, dynamic> rootData =
    _mapValue(data['data']);

    final Map<String, dynamic> student =
    _firstMap([
      data['student'],
      rootData['student'],
    ]);

    final Map<String, dynamic> user =
    _firstMap([
      data['user'],
      rootData['user'],
      student['user'],
    ]);

    /*
     * Se prioriza studentId o userId porque el campo id
     * puede pertenecer a la membresía del grupo.
     */
    return _firstString([
      data['studentId'],
      data['student_id'],
      rootData['studentId'],
      rootData['student_id'],
      data['userId'],
      data['user_id'],
      rootData['userId'],
      rootData['user_id'],
      student['studentId'],
      student['student_id'],
      student['userId'],
      student['user_id'],
      user['id'],
      user['userId'],
      student['id'],
      data['id'],
      data['_id'],
    ]) ??
        '';
  }

  String _extractStudentName(
      Map<String, dynamic> data,
      ) {
    final List<Map<String, dynamic>> sources =
    _studentSources(data);

    String name = _firstValueFromMaps(
      sources,
      const [
        'name',
        'fullName',
        'full_name',
        'studentName',
        'student_name',
        'displayName',
        'display_name',
        'nombre',
        'nombreCompleto',
        'nombre_completo',
      ],
    ) ??
        '';

    if (name.isNotEmpty &&
        !_isInvalidName(name)) {
      return _cleanWhitespace(name);
    }

    final String firstName =
        _firstValueFromMaps(
          sources,
          const [
            'firstName',
            'first_name',
            'givenName',
            'given_name',
            'nombre',
          ],
        ) ??
            '';

    final String lastName =
        _firstValueFromMaps(
          sources,
          const [
            'lastName',
            'last_name',
            'familyName',
            'family_name',
            'apellido',
            'apellidos',
          ],
        ) ??
            '';

    name = '$firstName $lastName'.trim();

    if (_isInvalidName(name)) {
      return '';
    }

    return _cleanWhitespace(name);
  }

  String _extractStudentEmail(
      Map<String, dynamic> data,
      ) {
    final List<Map<String, dynamic>> sources =
    _studentSources(data);

    return _firstValueFromMaps(
      sources,
      const [
        'email',
        'studentEmail',
        'student_email',
        'emailAddress',
        'email_address',
        'correo',
      ],
    ) ??
        '';
  }

  String? _extractStudentImage(
      Map<String, dynamic> data,
      ) {
    final List<Map<String, dynamic>> sources =
    _studentSources(data);

    return _firstValueFromMaps(
      sources,
      const [
        'profileImageUrl',
        'profile_image_url',
        'avatarUrl',
        'avatar_url',
        'photoUrl',
        'photo_url',
        'imageUrl',
        'image_url',
      ],
    );
  }

  List<Map<String, dynamic>> _studentSources(
      Map<String, dynamic> root,
      ) {
    final Map<String, dynamic> data =
    _mapValue(root['data']);

    final Map<String, dynamic> student =
    _firstMap([
      root['student'],
      data['student'],
      root['studentProfile'],
      data['studentProfile'],
      root['student_profile'],
      data['student_profile'],
    ]);

    final Map<String, dynamic> user =
    _firstMap([
      root['user'],
      data['user'],
      student['user'],
    ]);

    final Map<String, dynamic> profile =
    _firstMap([
      root['profile'],
      data['profile'],
      student['profile'],
      user['profile'],
      root['vocationalProfile'],
      data['vocationalProfile'],
    ]);

    return [
      root,
      data,
      student,
      user,
      profile,
    ];
  }

  Map<String, dynamic> _extractStudentProfile(
      Map<String, dynamic> response,
      ) {
    Map<String, dynamic> current =
    Map<String, dynamic>.from(response);

    if (current['data'] is Map) {
      current = {
        ...current,
        ...Map<String, dynamic>.from(
          current['data'] as Map,
        ),
      };
    }

    if (current['student'] is Map) {
      current = {
        ...current,
        ...Map<String, dynamic>.from(
          current['student'] as Map,
        ),
      };
    }

    if (current['user'] is Map) {
      current = {
        ...current,
        ...Map<String, dynamic>.from(
          current['user'] as Map,
        ),
      };
    }

    if (current['profile'] is Map) {
      current = {
        ...current,
        ...Map<String, dynamic>.from(
          current['profile'] as Map,
        ),
      };
    }

    return current;
  }

  // =========================================================
  // HELPERS
  // =========================================================

  Map<String, dynamic> _mapValue(
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

  Map<String, dynamic> _firstMap(
      Iterable<dynamic> values,
      ) {
    for (final dynamic value in values) {
      if (value is Map<String, dynamic>) {
        return value;
      }

      if (value is Map) {
        return Map<String, dynamic>.from(
          value,
        );
      }
    }

    return <String, dynamic>{};
  }

  String? _firstString(
      Iterable<dynamic> values,
      ) {
    for (final dynamic value in values) {
      final String text =
          value?.toString().trim() ?? '';

      if (text.isNotEmpty &&
          text.toLowerCase() != 'null' &&
          text.toLowerCase() != 'undefined') {
        return text;
      }
    }

    return null;
  }

  String? _firstValueFromMaps(
      List<Map<String, dynamic>> maps,
      List<String> keys,
      ) {
    for (final Map<String, dynamic> map in maps) {
      for (final String key in keys) {
        final String text =
            map[key]?.toString().trim() ?? '';

        if (text.isNotEmpty &&
            text.toLowerCase() != 'null' &&
            text.toLowerCase() != 'undefined') {
          return text;
        }
      }
    }

    return null;
  }

  List<String> _firstListFromMaps(
      List<Map<String, dynamic>> maps,
      List<String> keys,
      ) {
    for (final Map<String, dynamic> map in maps) {
      for (final String key in keys) {
        final dynamic value = map[key];

        if (value is List) {
          return value
              .map((dynamic item) {
            if (item is Map) {
              return _firstString([
                item['name'],
                item['title'],
                item['label'],
                item['value'],
              ]) ??
                  '';
            }

            return item?.toString().trim() ?? '';
          })
              .where(
                (String item) => item.isNotEmpty,
          )
              .toList();
        }
      }
    }

    return <String>[];
  }

  bool _firstBoolFromMaps(
      List<Map<String, dynamic>> maps,
      List<String> keys,
      ) {
    for (final Map<String, dynamic> map in maps) {
      for (final String key in keys) {
        final dynamic value = map[key];

        if (value is bool) {
          return value;
        }

        if (value is num) {
          return value != 0;
        }

        final String normalized =
            value?.toString().trim().toLowerCase() ??
                '';

        if (normalized == 'true' ||
            normalized == '1' ||
            normalized == 'yes' ||
            normalized == 'si' ||
            normalized == 'sí') {
          return true;
        }
      }
    }

    return false;
  }

  int _firstIntFromMaps(
      List<Map<String, dynamic>> maps,
      List<String> keys, {
        required int fallback,
      }) {
    for (final Map<String, dynamic> map in maps) {
      for (final String key in keys) {
        final dynamic value = map[key];

        if (value is int) {
          return value;
        }

        if (value is num) {
          return value.toInt();
        }

        final int? parsed = int.tryParse(
          value?.toString() ?? '',
        );

        if (parsed != null) {
          return parsed;
        }
      }
    }

    return fallback;
  }

  List<StudentProfileEntity>
  _removeDuplicatedStudents(
      List<StudentProfileEntity> students,
      ) {
    final Map<String, StudentProfileEntity> unique =
    <String, StudentProfileEntity>{};

    for (final StudentProfileEntity student
    in students) {
      final String id = student.id.trim();

      final String email =
      student.email.trim().toLowerCase();

      final String key = id.isNotEmpty
          ? id
          : email;

      if (key.isNotEmpty) {
        unique[key] = student;
      }
    }

    return unique.values.toList();
  }

  String _nameFromEmail(
      String email,
      ) {
    final String username =
    email.split('@').first.trim();

    if (username.isEmpty) {
      return '';
    }

    final String separated = username
        .replaceAll(RegExp(r'[._\-]+'), ' ')
        .replaceAll(RegExp(r'\d+'), '')
        .trim();

    if (separated.isEmpty) {
      return username;
    }

    return separated
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .map(
          (String part) =>
      '${part[0].toUpperCase()}'
          '${part.substring(1).toLowerCase()}',
    )
        .join(' ');
  }

  bool _isInvalidName(
      String? value,
      ) {
    final String normalized = value
        ?.trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ') ??
        '';

    const Set<String> invalidNames = {
      '',
      'null',
      'undefined',
      'sin',
      'sin nombre',
      'alumno',
      'alumno sin nombre',
      'estudiante',
      'usuario',
    };

    return invalidNames.contains(
      normalized,
    );
  }

  String _cleanWhitespace(
      String value,
      ) {
    return value
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  String _cleanText(
      String? value, {
        required String fallback,
      }) {
    final String text = value?.trim() ?? '';

    return text.isNotEmpty
        ? text
        : fallback;
  }
}