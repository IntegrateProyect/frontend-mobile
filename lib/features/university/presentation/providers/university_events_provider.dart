import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/university_event_entity.dart';
import '../../domain/usecases/get_university_events_usecase.dart';
import '../../domain/usecases/create_university_event_usecase.dart';
import '../../domain/usecases/update_university_event_usecase.dart';
import '../../domain/usecases/delete_university_event_usecase.dart';
import '../../domain/usecases/upload_event_image_usecase.dart';

class UniversityEventsProvider extends ChangeNotifier {
  final GetUniversityEventsUseCase _getEventsUseCase;
  final CreateUniversityEventUseCase _createEventUseCase;
  final UpdateUniversityEventUseCase _updateEventUseCase;
  final DeleteUniversityEventUseCase _deleteEventUseCase;
  final UploadEventImageUseCase _uploadImageUseCase;

  List<UniversityEventEntity> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  // --- Form State ---
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedCareerId;
  XFile? imageFile;
  bool isSubmitting = false;

  UniversityEventsProvider({
    required GetUniversityEventsUseCase getEventsUseCase,
    required CreateUniversityEventUseCase createEventUseCase,
    required UpdateUniversityEventUseCase updateEventUseCase,
    required DeleteUniversityEventUseCase deleteEventUseCase,
    required UploadEventImageUseCase uploadImageUseCase,
  })  : _getEventsUseCase = getEventsUseCase,
        _createEventUseCase = createEventUseCase,
        _updateEventUseCase = updateEventUseCase,
        _deleteEventUseCase = deleteEventUseCase,
        _uploadImageUseCase = uploadImageUseCase;

  List<UniversityEventEntity> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void setEventImage(XFile? file) {
    imageFile = file;
    notifyListeners();
  }

  void setEventDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }

  void setEventTime(TimeOfDay? time) {
    selectedTime = time;
    notifyListeners();
  }

  void setEventCareerId(String? careerId) {
    selectedCareerId = careerId;
    notifyListeners();
  }

  void resetForm({UniversityEventEntity? event}) {
    if (event != null) {
      titleController.text = event.title;
      descController.text = event.description;
      locationController.text = event.location;
      selectedDate = event.date;
      selectedTime = TimeOfDay.fromDateTime(event.date);
      selectedCareerId = event.careerId;
    } else {
      titleController.clear();
      descController.clear();
      locationController.clear();
      selectedDate = null;
      selectedTime = null;
      selectedCareerId = null;
    }
    imageFile = null;
    isSubmitting = false;
    notifyListeners();
  }

  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _events = await _getEventsUseCase();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitForm({String? id, String? existingImageUrl}) async {
    isSubmitting = true;
    _errorMessage = null;
    notifyListeners();
    try {
      Uint8List? imageBytes;
      String? contentType;

      if (imageFile != null) {
        imageBytes = await imageFile!.readAsBytes();
        contentType = imageFile!.name.endsWith('.png') ? 'image/png' : 'image/jpeg';
      }

      final now = DateTime.now();
      final date = selectedDate ?? now.add(const Duration(days: 1));
      final time = selectedTime ?? const TimeOfDay(hour: 10, minute: 0);

      final finalDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      String? imageUrl = existingImageUrl;
      if (imageBytes != null && contentType != null) {
        imageUrl = await _uploadImageUseCase(imageBytes, contentType);
      }

      final event = UniversityEventEntity(
        id: id ?? '',
        title: titleController.text.trim(),
        description: descController.text.trim(),
        date: finalDateTime,
        location: locationController.text.trim(),
        careerId: selectedCareerId,
        imageUrl: imageUrl,
      );

      if (id == null) {
        await _createEventUseCase(event);
      } else {
        await _updateEventUseCase(event);
      }
      await fetchEvents();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _deleteEventUseCase(eventId);
      await fetchEvents();
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
