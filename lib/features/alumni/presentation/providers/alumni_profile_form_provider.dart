import 'package:flutter/material.dart';
import '../../domain/entities/alumni_profile_entity.dart';
import '../../domain/usecases/get_alumni_profile_usecase.dart';
import '../../domain/usecases/update_alumni_profile_usecase.dart';

class AlumniProfileFormProvider extends ChangeNotifier {
  final GetAlumniProfileUseCase getProfileUseCase;
  final UpdateAlumniProfileUseCase updateProfileUseCase;

  AlumniProfileFormProvider({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  });

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final yearController = TextEditingController();
  final majorController = TextEditingController();
  final companyController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  AlumniProfileEntity? _profile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AlumniProfileEntity? get profile => _profile;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    yearController.dispose();
    majorController.dispose();
    companyController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _profile = await getProfileUseCase();
      if (_profile != null) {
        nameController.text = _profile!.name;
        emailController.text = _profile!.email;
        yearController.text = _profile!.graduationYear.toString();
        majorController.text = _profile!.degree;
        companyController.text = _profile!.company;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final newProfile = AlumniProfileEntity(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        graduationYear: int.tryParse(yearController.text.trim()) ?? 0,
        degree: majorController.text.trim(),
        company: companyController.text.trim(),
      );
      
      await updateProfileUseCase(newProfile);
      _profile = newProfile;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
