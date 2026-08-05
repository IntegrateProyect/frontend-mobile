import '../entities/student_profile_entity.dart';

abstract class ProfileRepository {
  Future<StudentProfileEntity> getProfile();
  Future<void> updateProfile(StudentProfileEntity profile);
}
