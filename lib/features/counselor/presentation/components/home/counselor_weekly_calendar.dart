import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/availability_slot_entity.dart';
import 'appointment_detail_sheet.dart';

class CounselorWeeklyCalendar extends StatefulWidget {
  final List<AppointmentEntity> appointments;
  final List<AvailabilitySlotEntity> availability;
  final String Function(String studentId) studentName;
  final VoidCallback onSchedule;

  const CounselorWeeklyCalendar({
    super.key,
    required this.appointments,
    required this.availability,
    required this.studentName,
    required this.onSchedule,
  });

  @override
  State<CounselorWeeklyCalendar> createState() =>
      _CounselorWeeklyCalendarState();
}

class _CounselorWeeklyCalendarState
    extends State<CounselorWeeklyCalendar> {
  static const _primary = Color(0xFF311B92);
  static const _dark = Color(0xFF17164A);
  late DateTime _weekStart;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _weekStart = _mondayOf(DateTime.now());
    _selectedDay = _initialDay();
  }

  DateTime _initialDay() {
    final today = DateTime.now();
    if (today.weekday >= 1 && today.weekday <= 5) {
      return DateTime(today.year, today.month, today.day);
    }
    return _mondayOf(today);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final days = List.generate(
      5,
      (index) => _weekStart.add(Duration(days: index)),
    );
    final selectedAppointments = widget.appointments.where((item) {
      return _sameDay(item.sessionDate.toLocal(), _selectedDay) &&
          item.status.toUpperCase() != 'CANCELLED';
    }).toList()
      ..sort((a, b) => a.sessionDate.compareTo(b.sessionDate));
    final apiDay = _selectedDay.weekday;
    final selectedSlots = widget.availability
        .where((slot) => slot.dayOfWeek == apiDay)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _weekHeader(),
        SizedBox(height: 12.h),
        Row(
          children: days
              .map((day) => Expanded(child: _dayButton(day)))
              .toList(),
        ),
        SizedBox(height: 18.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 13.h,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1F38) : Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: isDark ? const Color(0xFF2E305C) : const Color(0xFFECECF3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: isDark ? _primary.withOpacity(.18) : _primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: const Icon(
                  Icons.today_rounded,
                  color: _primary,
                ),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: Text(
                  _selectedDateLabel(_selectedDay),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : _dark,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 11.h),
        if (selectedSlots.isEmpty)
          _availabilityMessage()
        else
          ...selectedSlots.map(_availabilityCard),
        SizedBox(height: 15.h),
        Text(
          'Citas del día',
          style: TextStyle(
            color: isDark ? Colors.white : _dark,
            fontSize: 15.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 9.h),
        if (selectedAppointments.isEmpty)
          _emptyAppointments()
        else
          ...selectedAppointments.map(_appointmentCard),
      ],
    );
  }

  Widget _weekHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final end = _weekStart.add(const Duration(days: 4));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: isDark ? const Color(0xFF2E305C) : const Color(0xFFECECF3)),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Semana anterior',
            onPressed: () {
              setState(() {
                _weekStart =
                    _weekStart.subtract(const Duration(days: 7));
                _selectedDay = _weekStart;
              });
            },
            icon: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white : null),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Semana laboral',
                  style: TextStyle(
                    color: isDark ? Colors.white : _dark,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${DateFormat('d MMM', 'es_MX').format(_weekStart)}'
                      ' – ${DateFormat('d MMM', 'es_MX').format(end)}',
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 9.5.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Semana siguiente',
            onPressed: () {
              setState(() {
                _weekStart = _weekStart.add(const Duration(days: 7));
                _selectedDay = _weekStart;
              });
            },
            icon: Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white : null),
          ),
        ],
      ),
    );
  }

  Widget _dayButton(DateTime day) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selected = _sameDay(day, _selectedDay);
    final today = _sameDay(day, DateTime.now());
    final count = widget.appointments.where((item) {
      return _sameDay(item.sessionDate.toLocal(), day) &&
          item.status.toUpperCase() != 'CANCELLED';
    }).length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: InkWell(
        onTap: () => setState(() => _selectedDay = day),
        borderRadius: BorderRadius.circular(15.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: EdgeInsets.symmetric(vertical: 11.h),
          decoration: BoxDecoration(
            color: selected
                ? _primary
                : today
                ? _primary.withOpacity(.08)
                : (isDark ? const Color(0xFF1E1F38) : Colors.white),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: selected
                  ? _primary
                  : (isDark ? const Color(0xFF2E305C) : const Color(0xFFECECF3)),
            ),
          ),
          child: Column(
            children: [
              Text(
                DateFormat('E', 'es_MX')
                    .format(day)
                    .substring(0, 2)
                    .toUpperCase(),
                style: TextStyle(
                  color: selected ? Colors.white70 : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                '${day.day}',
                style: TextStyle(
                  color: selected ? Colors.white : (isDark ? Colors.white : _dark),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                width: 7.w,
                height: 7.w,
                decoration: BoxDecoration(
                  color: count > 0
                      ? selected
                      ? Colors.white
                      : const Color(0xFFF59E0B)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _availabilityCard(AvailabilitySlotEntity slot) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162E1C) : const Color(0xFFEFF8F1),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: isDark ? const Color(0xFF1B4F29) : const Color(0xFFCDEBD5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: Color(0xFF159947),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Disponible de ${_displayTime(slot.startTime)} '
                  'a ${_displayTime(slot.endTime)}',
              style: TextStyle(
                color: isDark ? const Color(0xFF4EE27D) : const Color(0xFF116B35),
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _availabilityMessage() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D251D) : const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(15.r),
        border: isDark ? Border.all(color: const Color(0xFF5C4729)) : null,
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFFE18400)),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'No hay disponibilidad configurada para este día.',
              style: TextStyle(color: isDark ? Colors.grey.shade300 : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentCard(AppointmentEntity appointment) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final local = appointment.sessionDate.toLocal();
    final sName = widget.studentName(appointment.studentId);
    
    return Container(
      margin: EdgeInsets.only(bottom: 9.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: isDark ? const Color(0xFF2E305C) : const Color(0xFFECECF3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showAppointmentDetailSheet(context, appointment, sName),
          borderRadius: BorderRadius.circular(17.r),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              children: [
                Container(
                  width: 61.w,
                  padding: EdgeInsets.symmetric(vertical: 11.h),
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(.08),
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('hh:mm').format(local),
                        style: TextStyle(
                          color: isDark ? const Color(0xFFB59AFF) : _primary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        DateFormat('a').format(local),
                        style: TextStyle(
                          color: isDark ? const Color(0xFFB59AFF) : _primary,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.white : _dark,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        appointment.motive.trim().isEmpty
                            ? 'Sesión de orientación'
                            : appointment.motive,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          fontSize: 10.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.white30 : Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyAppointments() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: isDark ? const Color(0xFF2E305C) : const Color(0xFFECECF3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
            size: 36.sp,
          ),
          SizedBox(height: 7.h),
          Text(
            'No hay citas para este día',
            style: TextStyle(
              color: isDark ? Colors.white70 : _dark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  static DateTime _mondayOf(DateTime date) {
    final clean = DateTime(date.year, date.month, date.day);
    return clean.subtract(Duration(days: clean.weekday - 1));
  }

  static bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String _selectedDateLabel(DateTime date) {
    const days = <String>[
      '',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    const months = <String>[
      '',
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${days[date.weekday]} ${date.day} de ${months[date.month]}';
  }

  static String _displayTime(String value) {
    final parts = value.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute =
        parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}
