import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/university_profile_entity.dart';
import '../../domain/entities/university_career_entity.dart';
import '../../domain/entities/university_event_entity.dart';
import '../../domain/entities/university_announcement_entity.dart';
import '../../domain/entities/university_alumni_entity.dart';
import '../../domain/usecases/get_university_profile_usecase.dart';
import '../../domain/usecases/manage_careers_usecase.dart';
import '../../domain/usecases/get_university_alumni_usecase.dart';
import '../../domain/usecases/create_university_alumni_usecase.dart';
import '../../domain/usecases/update_university_alumni_usecase.dart';
import '../../domain/usecases/delete_university_alumni_usecase.dart';

class UniversityProvider extends ChangeNotifier {
  final GetUniversityProfileUseCase _getProfileUseCase;
  final ManageCareersUseCase _manageCareersUseCase;
  final GetUniversityAlumniUseCase _getAlumniUseCase;
  final CreateUniversityAlumniUseCase _createAlumniUseCase;
  final UpdateUniversityAlumniUseCase _updateAlumniUseCase;
  final DeleteUniversityAlumniUseCase _deleteAlumniUseCase;

  UniversityProfileEntity? _profile;
  List<UniversityCareerEntity> _careers = [];
  List<UniversityCareerEntity> _catalogCareers = [];
  List<UniversityEventEntity> _events = [];
  List<UniversityAnnouncementEntity> _announcements = [];
  List<UniversityAlumniEntity> _alumni = [];
  
  bool _isLoading = false;
  String? _errorMessage;

  // --- Form State: Announcements ---
  final annTitleController = TextEditingController();
  final annDescController = TextEditingController();
  String annSelectedCategory = 'General';
  bool isSubmittingAnn = false;

  // --- Form State: Events ---
  final eventTitleController = TextEditingController();
  final eventDescController = TextEditingController();
  final eventLocationController = TextEditingController();
  DateTime? eventSelectedDate;
  TimeOfDay? eventSelectedTime;
  String? eventSelectedCareerId;
  XFile? eventImageFile;
  bool isSubmittingEvent = false;

  // --- Form State: Alumni ---
  final alumniNameController = TextEditingController();
  final alumniEmailController = TextEditingController();
  final alumniPasswordController = TextEditingController();
  final alumniJobController = TextEditingController();
  final alumniCompanyController = TextEditingController();
  final alumniGraduationYearController = TextEditingController();
  final alumniExperienceController = TextEditingController();
  final alumniLinkedinController = TextEditingController();
  String? alumniSelectedCareerId;
  bool isSubmittingAlumni = false;

  UniversityProvider({
    required GetUniversityProfileUseCase getProfileUseCase,
    required ManageCareersUseCase manageCareersUseCase,
    required GetUniversityAlumniUseCase getAlumniUseCase,
    required CreateUniversityAlumniUseCase createAlumniUseCase,
    required UpdateUniversityAlumniUseCase updateAlumniUseCase,
    required DeleteUniversityAlumniUseCase deleteAlumniUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _manageCareersUseCase = manageCareersUseCase,
        _getAlumniUseCase = getAlumniUseCase,
        _createAlumniUseCase = createAlumniUseCase,
        _updateAlumniUseCase = updateAlumniUseCase,
        _deleteAlumniUseCase = deleteAlumniUseCase;

  UniversityProfileEntity? get profile => _profile;
  List<UniversityCareerEntity> get careers => _careers;
  List<UniversityCareerEntity> get catalogCareers => _catalogCareers;
  List<UniversityEventEntity> get events => _events;
  List<UniversityAnnouncementEntity> get announcements => _announcements;
  List<UniversityAlumniEntity> get alumni => _alumni;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _cleanError(Object e) {
    return e.toString().replaceFirst('Exception: ', '').trim();
  }

  @override
  void dispose() {
    annTitleController.dispose();
    annDescController.dispose();
    eventTitleController.dispose();
    eventDescController.dispose();
    eventLocationController.dispose();
    alumniNameController.dispose();
    alumniEmailController.dispose();
    alumniPasswordController.dispose();
    alumniJobController.dispose();
    alumniCompanyController.dispose();
    alumniGraduationYearController.dispose();
    alumniExperienceController.dispose();
    alumniLinkedinController.dispose();
    super.dispose();
  }

  // --- ANUNCIOS LOGIC ---
  void setAnnCategory(String category) {
    annSelectedCategory = category;
    notifyListeners();
  }

  void resetAnnForm({UniversityAnnouncementEntity? announcement}) {
    if (announcement != null) {
      annTitleController.text = announcement.title;
      annDescController.text = announcement.description;
      annSelectedCategory = announcement.category;
    } else {
      annTitleController.clear();
      annDescController.clear();
      annSelectedCategory = 'General';
    }
    isSubmittingAnn = false;
    notifyListeners();
  }

  Future<void> submitAnnForm({String? id}) async {
    isSubmittingAnn = true;
    _errorMessage = null;
    notifyListeners();
    try {
      if (id == null) {
        final newAnnouncement = UniversityAnnouncementEntity(
          id: '',
          title: annTitleController.text.trim(),
          description: annDescController.text.trim(),
          category: annSelectedCategory,
        );
        await _getProfileUseCase.repository.createAnnouncement(newAnnouncement);
      } else {
        final updatedAnnouncement = UniversityAnnouncementEntity(
          id: id,
          title: annTitleController.text.trim(),
          description: annDescController.text.trim(),
          category: annSelectedCategory,
        );
        await _getProfileUseCase.repository.updateAnnouncement(updatedAnnouncement);
      }
      await fetchAnnouncements();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      isSubmittingAnn = false;
      notifyListeners();
    }
  }

  // --- EVENTOS LOGIC ---
  void setEventImage(XFile? file) {
    eventImageFile = file;
    notifyListeners();
  }

  void setEventDate(DateTime? date) {
    eventSelectedDate = date;
    notifyListeners();
  }

  void setEventTime(TimeOfDay? time) {
    eventSelectedTime = time;
    notifyListeners();
  }

  void setEventCareerId(String? careerId) {
    eventSelectedCareerId = careerId;
    notifyListeners();
  }

  void resetEventForm({UniversityEventEntity? event}) {
    if (event != null) {
      eventTitleController.text = event.title;
      eventDescController.text = event.description;
      eventLocationController.text = event.location;
      eventSelectedDate = event.date;
      eventSelectedTime = TimeOfDay.fromDateTime(event.date);
      eventSelectedCareerId = event.careerId;
    } else {
      eventTitleController.clear();
      eventDescController.clear();
      eventLocationController.clear();
      eventSelectedDate = null;
      eventSelectedTime = null;
      eventSelectedCareerId = null;
    }
    eventImageFile = null;
    isSubmittingEvent = false;
    notifyListeners();
  }

  Future<void> submitEventForm({String? id, String? existingImageUrl}) async {
    isSubmittingEvent = true;
    _errorMessage = null;
    notifyListeners();
    try {
      Uint8List? imageBytes;
      String? contentType;

      if (eventImageFile != null) {
        imageBytes = await eventImageFile!.readAsBytes();
        contentType = eventImageFile!.name.endsWith('.png') ? 'image/png' : 'image/jpeg';
      }

      final finalDateTime = DateTime(
        eventSelectedDate!.year,
        eventSelectedDate!.month,
        eventSelectedDate!.day,
        eventSelectedTime!.hour,
        eventSelectedTime!.minute,
      );

      if (id == null) {
        String? imageUrl;
        if (imageBytes != null && contentType != null) {
          imageUrl = await _getProfileUseCase.repository.uploadEventImage(imageBytes, contentType);
        }

        final newEvent = UniversityEventEntity(
          id: '',
          title: eventTitleController.text.trim(),
          description: eventDescController.text.trim(),
          date: finalDateTime,
          location: eventLocationController.text.trim(),
          careerId: eventSelectedCareerId,
          imageUrl: imageUrl,
        );
        await _getProfileUseCase.repository.createEvent(newEvent);
      } else {
        String? imageUrl = existingImageUrl;
        if (imageBytes != null && contentType != null) {
          imageUrl = await _getProfileUseCase.repository.uploadEventImage(imageBytes, contentType);
        }

        final updatedEvent = UniversityEventEntity(
          id: id,
          title: eventTitleController.text.trim(),
          description: eventDescController.text.trim(),
          date: finalDateTime,
          location: eventLocationController.text.trim(),
          careerId: eventSelectedCareerId,
          imageUrl: imageUrl,
        );
        await _getProfileUseCase.repository.updateEvent(updatedEvent);
      }
      await fetchEvents();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      isSubmittingEvent = false;
      notifyListeners();
    }
  }

  // --- ALUMNI LOGIC ---
  void setAlumniCareerId(String? careerId) {
    alumniSelectedCareerId = careerId;
    notifyListeners();
  }

  void resetAlumniForm({UniversityAlumniEntity? alumni}) {
    if (alumni != null) {
      alumniNameController.text = alumni.name;
      alumniEmailController.text = alumni.email;
      alumniPasswordController.clear();
      alumniJobController.text = alumni.currentJob;
      alumniCompanyController.text = alumni.company;
      alumniGraduationYearController.text = alumni.graduationYear.toString();
      alumniExperienceController.text = alumni.experienceSummary ?? '';
      alumniLinkedinController.text = alumni.linkedinUrl ?? '';
      alumniSelectedCareerId = alumni.careerId;
    } else {
      alumniNameController.clear();
      alumniEmailController.clear();
      alumniPasswordController.clear();
      alumniJobController.clear();
      alumniCompanyController.clear();
      alumniGraduationYearController.clear();
      alumniExperienceController.clear();
      alumniLinkedinController.clear();
      alumniSelectedCareerId = null;
    }
    isSubmittingAlumni = false;
    notifyListeners();
  }

  Future<void> submitAlumniForm({String? id}) async {
    isSubmittingAlumni = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = {
        'name': alumniNameController.text.trim(),
        'email': alumniEmailController.text.trim(),
        'careerId': alumniSelectedCareerId,
        'graduationYear': int.tryParse(alumniGraduationYearController.text.trim()) ?? 0,
        'currentJob': alumniJobController.text.trim(),
        'company': alumniCompanyController.text.trim(),
        'experienceSummary': alumniExperienceController.text.trim(),
        'linkedinUrl': alumniLinkedinController.text.trim(),
      };

      if (id == null) {
        data['password'] = alumniPasswordController.text.trim();
        await _createAlumniUseCase(data);
      } else {
        await _updateAlumniUseCase(id, data);
      }
      await fetchAlumni();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      isSubmittingAlumni = false;
      notifyListeners();
    }
  }

  Future<void> fetchAlumni() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _alumni = await _getAlumniUseCase();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
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
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- VERIFICATION LOGIC ---
  Future<Map<String, dynamic>> claimUniversity(String cct, String rfc) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      return await _getProfileUseCase.repository.claimUniversity(cct, rfc);
    } catch (e) {
      _errorMessage = _cleanError(e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- GENERAL FETCHING ---
  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _profile = await _getProfileUseCase();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCareers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _careers = await _manageCareersUseCase.getCareers();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCareer(UniversityCareerEntity career) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _manageCareersUseCase.addCareer(career);
      await fetchCareers();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCareer(String careerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _manageCareersUseCase.deleteCareer(careerId);
      await fetchCareers();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCatalogCareers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _catalogCareers = await _getProfileUseCase.repository.getCatalogCareers();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _events = await _getProfileUseCase.repository.getEvents();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _getProfileUseCase.repository.deleteEvent(eventId);
      await fetchEvents();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _announcements = await _getProfileUseCase.repository.getAnnouncements();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAnnouncement(String announcementId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _getProfileUseCase.repository.deleteAnnouncement(announcementId);
      await fetchAnnouncements();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
