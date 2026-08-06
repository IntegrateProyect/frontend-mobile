import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/common/student_bottom_navigation_bar.dart';
import '../components/common/student_ui_colors.dart';
import '../providers/student_appointments_provider.dart';
import '../../../counselor/domain/entities/appointment_entity.dart';

class StudentAgendaScreen extends StatefulWidget {
  const StudentAgendaScreen({super.key});

  @override
  State<StudentAgendaScreen> createState() => _StudentAgendaScreenState();
}

class _StudentAgendaScreenState extends State<StudentAgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    Future.microtask(() {
      if (mounted) {
        context.read<StudentAppointmentsProvider>().loadAppointments();
      }
    });
  }

  List<AppointmentEntity> _getEventsForDay(DateTime day, List<AppointmentEntity> appointments) {
    return appointments.where((apt) => isSameDay(apt.sessionDate, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentAppointmentsProvider>();
    final appointments = provider.appointments;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1020) : StudentUiColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F1020) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        title: Text(
          'Mi Agenda',
          style: TextStyle(
            color: isDark ? Colors.white : StudentUiColors.darkText,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: isDark ? const Color(0xFF1E1F38) : Colors.white,
              child: TableCalendar(
                locale: 'es_ES',
                firstDay: DateTime.now().subtract(const Duration(days: 30)),
                lastDay: DateTime.now().add(const Duration(days: 90)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) => _getEventsForDay(day, appointments),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  weekendTextStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                  outsideTextStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black26),
                  todayTextStyle: TextStyle(color: isDark ? Colors.black : Colors.white),
                  todayDecoration: const BoxDecoration(color: StudentUiColors.teal, shape: BoxShape.circle),
                  selectedDecoration: const BoxDecoration(color: StudentUiColors.primary, shape: BoxShape.circle),
                  markerDecoration: const BoxDecoration(color: StudentUiColors.pink, shape: BoxShape.circle),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: isDark ? Colors.white : Colors.black),
                  rightChevronIcon: Icon(Icons.chevron_right, color: isDark ? Colors.white : Colors.black),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                  weekendStyle: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Tu orientador agenda y gestiona estas citas.',
                      style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            provider.isLoading && appointments.isEmpty
                ? const Center(child: CircularProgressIndicator(color: StudentUiColors.primary))
                : _buildAppointmentList(_getEventsForDay(_selectedDay!, appointments)),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      bottomNavigationBar: const StudentBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildAppointmentList(List<AppointmentEntity> dayAppointments) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (dayAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Icon(Icons.event_busy, size: 60.sp, color: isDark ? Colors.white24 : Colors.grey[300]),
            SizedBox(height: 16.h),
            Text(
              'No hay citas para este día',
              style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey[500], fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: dayAppointments.length,
      itemBuilder: (context, index) {
        final apt = dayAppointments[index];
        final timeStr = DateFormat('hh:mm a').format(apt.sessionDate);

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1F38) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: isDark ? Border.all(color: const Color(0xFF2E305C)) : null,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isDark ? StudentUiColors.primary.withOpacity(0.2) : StudentUiColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  timeStr,
                  style: TextStyle(
                    color: isDark ? const Color(0xFFB59AFF) : StudentUiColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apt.motive,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: isDark ? Colors.white : StudentUiColors.darkText,
                      ),
                    ),
                    Text(
                      'Estado: ${apt.status}',
                      style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey[600], fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
