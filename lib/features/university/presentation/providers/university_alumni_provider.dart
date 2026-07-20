import 'package:flutter/material.dart';
import '../../domain/entities/university_alumni_entity.dart';
import '../../domain/usecases/get_university_alumni_usecase.dart';
import '../../domain/usecases/create_university_alumni_usecase.dart';
import '../../domain/usecases/update_university_alumni_usecase.dart';
import '../../domain/usecases/delete_university_alumni_usecase.dart';

class UniversityAlumniProvider extends ChangeNotifier {
  final GetUniversityAlumniUseCase _getAlumniUseCase;
  final CreateUniversityAlumniUseCase _createAlumniUseCase;
  final UpdateUniversityAlumniUseCase _updateAlumniUseCase;
  final DeleteUniversityAlumniUseCase _deleteAlumniUseCase;

  List<UniversityAlumniEntity> _alumni = [];
  bool _isLoading = false;
  String? _errorMessage;

  // --- Form State ---
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final jobController = TextEditingController();
  final companyController = TextEditingController();
  final graduationYearController = TextEditingController();
  final experienceController = TextEditingController();
  final linkedinController = TextEditingController();
  String? selectedCareerId;
  bool isSubmitting = false;

  UniversityAlumniProvider({
    required GetUniversityAlumniUseCase getAlumniUseCase,
    required CreateUniversityAlumniUseCase createAlumniUseCase,
    required UpdateUniversityAlumniUseCase updateAlumniUseCase,
    required DeleteUniversityAlumniUseCase deleteAlumniUseCase,
  })  : _getAlumniUseCase = getAlumniUseCase,
        _createAlumniUseCase = createAlumniUseCase,
        _updateAlumniUseCase = updateAlumniUseCase,
        _deleteAlumniUseCase = deleteAlumniUseCase;

  List<UniversityAlumniEntity> get alumni => _alumni;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    jobController.dispose();
    companyController.dispose();
    graduationYearController.dispose();
    experienceController.dispose();
    linkedinController.dispose();
    super.dispose();
  }

  void setCareerId(String? careerId) {
    selectedCareerId = careerId;
    notifyListeners();
  }

  void resetForm({UniversityAlumniEntity? alumni}) {
    if (alumni != null) {
      nameController.text = alumni.name;
      emailController.text = alumni.email;
      passwordController.clear();
      jobController.text = alumni.currentJob;
      companyController.text = alumni.company;
      graduationYearController.text = alumni.graduationYear.toString();
      experienceController.text = alumni.experienceSummary ?? '';
      linkedinController.text = alumni.linkedinUrl ?? '';
      selectedCareerId = alumni.careerId;
    } else {
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      jobController.clear();
      companyController.clear();
      graduationYearController.clear();
      experienceController.clear();
      linkedinController.clear();
      selectedCareerId = null;
    }
    isSubmitting = false;
    notifyListeners();
  }

  Future<void> fetchAlumni() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _alumni = await _getAlumniUseCase();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitForm({String? id}) async {
    isSubmitting = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'careerId': selectedCareerId,
        'graduationYear': int.tryParse(graduationYearController.text.trim()) ?? 0,
        'currentJob': jobController.text.trim(),
        'company': companyController.text.trim(),
        'experienceSummary': experienceController.text.trim(),
        'linkedinUrl': linkedinController.text.trim(),
      };

      if (id == null) {
        data['password'] = passwordController.text.trim();
        await _createAlumniUseCase(data);
      } else {
        await _updateAlumniUseCase(id, data);
      }
      await fetchAlumni();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> deleteAlumni(String alumniId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _deleteAlumniUseCase(alumniId);
      await fetchAlumni();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
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
