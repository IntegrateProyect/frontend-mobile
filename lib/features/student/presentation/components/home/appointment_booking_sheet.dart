import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../providers/student_home_provider.dart';
import '../common/student_ui_colors.dart';

class AppointmentBookingSheet extends StatefulWidget {
  const AppointmentBookingSheet({super.key});

  @override
  State<AppointmentBookingSheet> createState() =>
      _AppointmentBookingSheetState();
}

class _AppointmentBookingSheetState
    extends State<AppointmentBookingSheet> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;

  final TextEditingController _motiveController =
  TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _motiveController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final motive = _motiveController.text.trim();

    if (_selectedDay == null ||
        _selectedTime == null ||
        motive.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
        ),
      );
      return;
    }

    final sessionDate = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (!sessionDate.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La fecha y hora deben ser futuras'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final provider = context.read<StudentHomeProvider>();

    final success = await provider.scheduleAppointment(
      sessionDate,
      motive,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cita agendada con éxito'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'Error al agendar la cita',
          ),
        ),
      );
    }
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: 'Selecciona la hora de la cita',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (selectedTime == null || !mounted) return;

    setState(() {
      _selectedTime = selectedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.85.sh,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Agendar cita',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,

                    // Se cambió darkBlue porque no existe.
                    color: StudentUiColors.primary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(
                        const Duration(days: 90),
                      ),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarStyle: const CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: StudentUiColors.primary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: StudentUiColors.teal,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Selecciona la hora',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: StudentUiColors.primary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    InkWell(
                      onTap: _selectTime,
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: StudentUiColors.primary,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                _selectedTime == null
                                    ? 'Seleccionar hora'
                                    : _selectedTime!.format(context),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: _selectedTime == null
                                      ? Colors.grey.shade600
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Motivo de la cita',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: StudentUiColors.primary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: _motiveController,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText:
                        'Ejemplo: Revisión de resultados vocacionales',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: StudentUiColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed:
                        _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          StudentUiColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                          StudentUiColors.primary
                              .withValues(alpha: 0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12.r),
                          ),
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child:
                          const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                            : Text(
                          'Confirmar cita',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showAppointmentBookingSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const AppointmentBookingSheet(),
  );
}