import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../student/domain/entities/student_profile_entity.dart';
import '../../../domain/entities/availability_slot_entity.dart';
import '../../providers/counselor_provider.dart';

class CounselorAppointmentBookingSheet
    extends StatefulWidget {
  const CounselorAppointmentBookingSheet({
    super.key,
  });

  @override
  State<CounselorAppointmentBookingSheet>
  createState() {
    return _CounselorAppointmentBookingSheetState();
  }
}

class _CounselorAppointmentBookingSheetState
    extends State<CounselorAppointmentBookingSheet> {
  static const Color _primaryColor =
  Color(0xFF311B92);

  static const Color _darkText =
  Color(0xFF1D1B4B);

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;
  StudentProfileEntity? _selectedStudent;

  final TextEditingController
  _motiveController =
  TextEditingController();

  final TextEditingController
  _searchController =
  TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _motiveController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_selectedStudent == null) {
      _showMessage(
        'Selecciona un alumno.',
      );

      return;
    }

    if (_selectedDay == null) {
      _showMessage(
        'Selecciona la fecha de la cita.',
      );

      return;
    }

    if (_selectedTime == null) {
      _showMessage(
        'Selecciona la hora de la cita.',
      );

      return;
    }

    final String motive =
    _motiveController.text.trim();

    if (motive.isEmpty) {
      _showMessage(
        'Ingresa el motivo de la cita.',
      );

      return;
    }

    final DateTime sessionDate = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (!sessionDate.isAfter(DateTime.now())) {
      _showMessage(
        'La fecha y hora deben ser futuras.',
      );

      return;
    }

    final CounselorProvider provider =
    context.read<CounselorProvider>();

    if (provider.availability.isEmpty) {
      _showMessage(
        'Primero configura tu horario de disponibilidad.',
      );

      return;
    }

    if (!provider.isInsideAvailability(
      sessionDate,
    )) {
      _showMessage(
        'La fecha y hora están fuera de tu disponibilidad.',
      );

      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final bool success =
    await provider.scheduleAppointment(
      _selectedStudent!.id,
      sessionDate,
      motive,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (!success) {
      _showMessage(
        provider.errorMessage ??
            'No fue posible agendar la cita.',
        isError: true,
      );

      return;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Cita agendada exitosamente.',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? Colors.redAccent
              : _darkText,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final CounselorProvider provider =
    context.watch<CounselorProvider>();

    final String search =
    _searchController.text
        .trim()
        .toLowerCase();

    final List<StudentProfileEntity>
    filteredStudents =
    provider.students.where((student) {
      final String name =
      student.name.toLowerCase();

      final String email =
      student.email.toLowerCase();

      return search.isEmpty ||
          name.contains(search) ||
          email.contains(search);
    }).toList();

    final List<AvailabilitySlotEntity>
    dayAvailability =
    _selectedDay == null
        ? <AvailabilitySlotEntity>[]
        : provider.availabilityForDate(
      _selectedDay!,
    );

    return SafeArea(
      top: false,
      child: Container(
        height: 0.92.sh,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FE),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.r),
          ),
        ),
        child: Column(
          children: [
            _buildHandle(),
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20.w,
                  4.h,
                  20.w,
                  28.h,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildStepTitle(
                      number: '1',
                      title: 'Selecciona al alumno',
                    ),
                    SizedBox(height: 12.h),
                    _buildStudentSearch(),
                    SizedBox(height: 10.h),
                    _buildStudentsList(
                      filteredStudents,
                    ),
                    SizedBox(height: 24.h),
                    _buildStepTitle(
                      number: '2',
                      title: 'Selecciona la fecha',
                    ),
                    SizedBox(height: 8.h),
                    _buildCalendar(),
                    SizedBox(height: 12.h),
                    _buildDayAvailability(
                      dayAvailability,
                    ),
                    SizedBox(height: 12.h),
                    _buildTimeSelector(
                      dayAvailability,
                    ),
                    SizedBox(height: 24.h),
                    _buildStepTitle(
                      number: '3',
                      title: 'Escribe el motivo',
                    ),
                    SizedBox(height: 12.h),
                    _buildMotiveField(),
                    SizedBox(height: 28.h),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Container(
        width: 44.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        16.h,
        10.w,
        14.h,
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: const Icon(
              Icons.event_available_rounded,
              color: _primaryColor,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Programar cita',
                  style: TextStyle(
                    color: _darkText,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Agenda una sesión de orientación.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Cerrar',
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTitle({
    required String number,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: _primaryColor,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            color: _darkText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentSearch() {
    return TextField(
      controller: _searchController,
      onChanged: (_) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Buscar por nombre o correo',
        prefixIcon: const Icon(
          Icons.search_rounded,
        ),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
          onPressed: () {
            _searchController.clear();
            setState(() {});
          },
          icon: const Icon(
            Icons.close_rounded,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildStudentsList(
      List<StudentProfileEntity> students,
      ) {
    return Container(
      height: 170.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFECECF3),
        ),
      ),
      child: students.isEmpty
          ? Center(
        child: Text(
          'No se encontraron alumnos.',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      )
          : ListView.separated(
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
        ),
        itemCount: students.length,
        separatorBuilder: (_, __) {
          return Divider(
            height: 1,
            indent: 60.w,
            color: Colors.grey.shade100,
          );
        },
        itemBuilder: (context, index) {
          final StudentProfileEntity student =
          students[index];

          final bool selected =
              _selectedStudent?.id ==
                  student.id;

          final String name =
          student.name.trim().isEmpty
              ? 'Alumno sin nombre'
              : student.name.trim();

          final String initial =
          name.substring(0, 1).toUpperCase();

          return ListTile(
            selected: selected,
            selectedTileColor:
            _primaryColor.withOpacity(0.05),
            onTap: () {
              setState(() {
                _selectedStudent = student;
              });
            },
            leading: CircleAvatar(
              backgroundColor:
              _primaryColor.withOpacity(0.1),
              child: Text(
                initial,
                style: const TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            title: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              student.email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: selected
                ? const Icon(
              Icons.check_circle_rounded,
              color: _primaryColor,
            )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: const Color(0xFFECECF3),
        ),
      ),
      child: TableCalendar(
        locale: 'es_MX',
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(
          const Duration(days: 120),
        ),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(
            _selectedDay,
            day,
          );
        },
        onDaySelected: (selected, focused) {
          setState(() {
            _selectedDay = selected;
            _focusedDay = focused;
            _selectedTime = null;
          });
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: _primaryColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Color(0xFFE4DDF8),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDayAvailability(
      List<AvailabilitySlotEntity> slots,
      ) {
    if (_selectedDay == null) {
      return const SizedBox.shrink();
    }

    if (slots.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(13.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4E5),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Colors.orange,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'No tienes disponibilidad para este día.',
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F1),
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: Colors.green,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Wrap(
              spacing: 7.w,
              runSpacing: 7.h,
              children: slots.map((slot) {
                return Chip(
                  label: Text(
                    '${slot.startTime} – ${slot.endTime}',
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(
      List<AvailabilitySlotEntity> availability,
      ) {
    final times = _availableTimes(availability);

    if (_selectedDay == null || times.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Text(
          _selectedDay == null
              ? 'Primero selecciona una fecha.'
              : 'No hay horas disponibles para este día.',
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFFECECF3)),
      ),
      child: Wrap(
        spacing: 9.w,
        runSpacing: 9.h,
        children: times.map((time) {
          final selected = _selectedTime?.hour == time.hour &&
              _selectedTime?.minute == time.minute;
          return ChoiceChip(
            selected: selected,
            label: Text(time.format(context)),
            selectedColor: _primaryColor.withOpacity(.14),
            side: BorderSide(
              color: selected
                  ? _primaryColor
                  : const Color(0xFFE2E2EA),
            ),
            onSelected: (_) {
              setState(() => _selectedTime = time);
            },
          );
        }).toList(),
      ),
    );
  }

  List<TimeOfDay> _availableTimes(
      List<AvailabilitySlotEntity> availability,
      ) {
    if (_selectedDay == null) return [];

    final result = <TimeOfDay>[];
    final now = DateTime.now();

    for (final slot in availability) {
      final start = _minutes(slot.startTime);
      final end = _minutes(slot.endTime);
      if (start < 0 || end <= start) continue;

      for (int value = start;
      value + 60 <= end;
      value += 60) {
        final candidate = DateTime(
          _selectedDay!.year,
          _selectedDay!.month,
          _selectedDay!.day,
          value ~/ 60,
          value % 60,
        );

        if (!candidate.isAfter(now)) continue;

        result.add(
          TimeOfDay(
            hour: candidate.hour,
            minute: candidate.minute,
          ),
        );
      }
    }

    return result;
  }

  int _minutes(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return -1;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return -1;
    return hour * 60 + minute;
  }

  Widget _buildMotiveField() {
    return TextField(
      controller: _motiveController,
      maxLines: 3,
      maxLength: 250,
      textCapitalization:
      TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText:
        'Ej. Revisión de resultados vocacionales',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton.icon(
        onPressed:
        _isSubmitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
          _primaryColor.withOpacity(0.45),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        icon: _isSubmitting
            ? SizedBox(
          width: 20.w,
          height: 20.w,
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Icon(
          Icons.event_available_rounded,
        ),
        label: Text(
          _isSubmitting
              ? 'Agendando...'
              : 'Confirmar y agendar',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

void showCounselorBookingSheet(
    BuildContext context,
    ) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return const CounselorAppointmentBookingSheet();
    },
  );
}