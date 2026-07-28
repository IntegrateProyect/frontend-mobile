import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/availability_slot_entity.dart';
import '../../providers/counselor_provider.dart';

class AvailabilityEditorSheet extends StatefulWidget {
  const AvailabilityEditorSheet({super.key});

  @override
  State<AvailabilityEditorSheet> createState() =>
      _AvailabilityEditorSheetState();
}

class _AvailabilityEditorSheetState
    extends State<AvailabilityEditorSheet> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _darkText = Color(0xFF17164A);
  static const Color _backgroundColor = Color(0xFFF6F7FC);

  static const Map<int, String> _weekDays = {
    1: 'Lunes',
    2: 'Martes',
    3: 'Miércoles',
    4: 'Jueves',
    5: 'Viernes',
  };

  final Map<int, _DaySchedule> _schedule = {};

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeSchedule();
  }

  void _initializeSchedule() {
    final provider = context.read<CounselorProvider>();
    final availability = provider.availability;

    for (final entry in _weekDays.entries) {
      final daySlots = availability.where((slot) {
        return slot.dayOfWeek == entry.key;
      }).toList();

      if (daySlots.isNotEmpty) {
        final slot = daySlots.first;

        _schedule[entry.key] = _DaySchedule(
          enabled: true,
          startTime: _parseTime(slot.startTime),
          endTime: _parseTime(slot.endTime),
        );
      } else {
        _schedule[entry.key] = _DaySchedule(
          enabled: false,
          startTime: const TimeOfDay(
            hour: 8,
            minute: 0,
          ),
          endTime: const TimeOfDay(
            hour: 14,
            minute: 0,
          ),
        );
      }
    }
  }

  Future<void> _selectTime(
      int day, {
        required bool selectingStartTime,
      }) async {
    final daySchedule = _schedule[day];

    if (daySchedule == null) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: selectingStartTime
          ? daySchedule.startTime
          : daySchedule.endTime,
      helpText: selectingStartTime
          ? 'Seleccionar hora de entrada'
          : 'Seleccionar hora de salida',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _darkText,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null || !mounted) return;

    setState(() {
      if (selectingStartTime) {
        daySchedule.startTime = selectedTime;
      } else {
        daySchedule.endTime = selectedTime;
      }
    });
  }

  void _copyMondaySchedule() {
    final monday = _schedule[1];

    if (monday == null) return;

    setState(() {
      for (int day = 1; day <= 5; day++) {
        final schedule = _schedule[day];

        if (schedule == null) continue;

        schedule
          ..enabled = monday.enabled
          ..startTime = monday.startTime
          ..endTime = monday.endTime;
      }
    });

    _showMessage(
      'El horario del lunes se copió a toda la semana.',
    );
  }

  Future<void> _saveAvailability() async {
    final slots = <AvailabilitySlotEntity>[];

    for (final entry in _schedule.entries) {
      final day = entry.key;
      final schedule = entry.value;

      if (!schedule.enabled) continue;

      final startMinutes =
          schedule.startTime.hour * 60 +
              schedule.startTime.minute;

      final endMinutes =
          schedule.endTime.hour * 60 +
              schedule.endTime.minute;

      if (startMinutes >= endMinutes) {
        _showMessage(
          'En ${_weekDays[day]} la hora de salida debe ser posterior a la hora de entrada.',
          isError: true,
        );
        return;
      }

      slots.add(
        AvailabilitySlotEntity(
          dayOfWeek: day,
          startTime: _formatTime(schedule.startTime),
          endTime: _formatTime(schedule.endTime),
        ),
      );
    }

    if (slots.isEmpty) {
      _showMessage(
        'Activa por lo menos un día de atención.',
        isError: true,
      );
      return;
    }

    setState(() => _isSaving = true);

    final provider = context.read<CounselorProvider>();

    try {
      final success = await provider.saveAvailability(slots);

      if (!mounted) return;

      if (!success) {
        _showMessage(
          provider.errorMessage ??
              'No fue posible guardar el horario.',
          isError: true,
        );
        return;
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Horario semanal guardado correctamente.',
          ),
          backgroundColor: Color(0xFF159947),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        'Error al guardar el horario: $error',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 0.90.sh,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.r),
          ),
        ),
        child: Column(
          children: [
            _buildDragIndicator(),
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  18.w,
                  4.h,
                  18.w,
                  20.h,
                ),
                children: [
                  _buildInformationCard(),
                  SizedBox(height: 14.h),
                  ..._weekDays.entries.map((entry) {
                    return _buildDayCard(
                      day: entry.key,
                      dayName: entry.value,
                    );
                  }),
                ],
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDragIndicator() {
    return Padding(
      padding: EdgeInsets.only(top: 11.h),
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
        17.h,
        12.w,
        12.h,
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: _primaryColor,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Horario semanal',
                  style: TextStyle(
                    color: _darkText,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Configura tu atención de lunes a viernes.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10.5.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Cerrar',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close_rounded,
              color: _darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(17.r),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: _primaryColor,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Configura el lunes y copia el mismo horario al resto de la semana.',
              style: TextStyle(
                color: _darkText,
                fontSize: 10.5.sp,
                height: 1.35,
              ),
            ),
          ),
          TextButton(
            onPressed: _copyMondaySchedule,
            child: const Text(
              'Copiar',
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard({
    required int day,
    required String dayName,
  }) {
    final schedule = _schedule[day]!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: EdgeInsets.only(bottom: 11.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: schedule.enabled
              ? _primaryColor.withOpacity(0.25)
              : const Color(0xFFECECF3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: schedule.enabled
                      ? _primaryColor.withOpacity(0.10)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    dayName.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                      color: schedule.enabled
                          ? _primaryColor
                          : Colors.grey.shade500,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayName,
                      style: TextStyle(
                        color: _darkText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      schedule.enabled
                          ? 'Disponible para recibir citas'
                          : 'No disponible',
                      style: TextStyle(
                        color: schedule.enabled
                            ? const Color(0xFF159947)
                            : Colors.grey.shade500,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: schedule.enabled,
                activeColor: _primaryColor,
                onChanged: (enabled) {
                  setState(() {
                    schedule.enabled = enabled;
                  });
                },
              ),
            ],
          ),
          if (schedule.enabled) ...[
            SizedBox(height: 13.h),
            Row(
              children: [
                Expanded(
                  child: _buildTimeButton(
                    label: 'Entrada',
                    icon: Icons.login_rounded,
                    time: schedule.startTime,
                    onTap: () {
                      _selectTime(
                        day,
                        selectingStartTime: true,
                      );
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildTimeButton(
                    label: 'Salida',
                    icon: Icons.logout_rounded,
                    time: schedule.endTime,
                    onTap: () {
                      _selectTime(
                        day,
                        selectingStartTime: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeButton({
    required String label,
    required IconData icon,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF6F4FC),
      borderRadius: BorderRadius.circular(13.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 11.w,
            vertical: 11.h,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: _primaryColor,
                size: 18.sp,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 8.5.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      time.format(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _darkText,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        18.w,
        12.h,
        18.w,
        16.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFECECF3),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54.h,
        child: ElevatedButton.icon(
          onPressed: _isSaving
              ? null
              : _saveAvailability,
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
          icon: _isSaving
              ? SizedBox(
            width: 20.w,
            height: 20.w,
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : const Icon(Icons.save_outlined),
          label: Text(
            _isSaving
                ? 'Guardando...'
                : 'Guardar horario',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? Colors.redAccent
              : const Color(0xFF159947),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  static String _formatTime(TimeOfDay value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  static TimeOfDay _parseTime(String value) {
    final parts = value.split(':');

    return TimeOfDay(
      hour: int.tryParse(parts.first) ?? 8,
      minute: parts.length > 1
          ? int.tryParse(parts[1]) ?? 0
          : 0,
    );
  }
}

class _DaySchedule {
  bool enabled;
  TimeOfDay startTime;
  TimeOfDay endTime;

  _DaySchedule({
    required this.enabled,
    required this.startTime,
    required this.endTime,
  });
}

void showAvailabilityEditorSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return const AvailabilityEditorSheet();
    },
  );
}