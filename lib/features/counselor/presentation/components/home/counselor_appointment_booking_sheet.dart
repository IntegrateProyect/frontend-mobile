import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../student/domain/entities/student_profile_entity.dart';
import '../../providers/counselor_provider.dart';

class CounselorAppointmentBookingSheet extends StatefulWidget {
  const CounselorAppointmentBookingSheet({super.key});

  @override
  State<CounselorAppointmentBookingSheet> createState() => _CounselorAppointmentBookingSheetState();
}

class _CounselorAppointmentBookingSheetState extends State<CounselorAppointmentBookingSheet> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;
  StudentProfileEntity? _selectedStudent;
  final TextEditingController _motiveController = TextEditingController();
  String _searchQuery = '';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _motiveController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedStudent == null || _selectedDay == null || _selectedTime == null || _motiveController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa todos los campos')));
      return;
    }

    final sessionDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day, _selectedTime!.hour, _selectedTime!.minute);

    setState(() => _isSubmitting = true);
    try {
      await context.read<CounselorProvider>().scheduleAppointment(_selectedStudent!.id, sessionDate, _motiveController.text);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cita agendada exitosamente'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounselorProvider>();
    final filteredStudents = provider.students.where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    const primaryColor = Color(0xFF311B92);

    return Container(
      height: 0.9.sh,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32.r))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Programar Cita', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: const Color(0xFF1D1B4B))),
          SizedBox(height: 20.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Seleccionar Alumno', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  SizedBox(height: 10.h),
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Buscar alumno...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 150.h,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(12.r)),
                    child: ListView.builder(
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final s = filteredStudents[index];
                        final isSelected = _selectedStudent?.id == s.id;
                        return ListTile(
                          onTap: () => setState(() => _selectedStudent = s),
                          leading: CircleAvatar(radius: 15.r, child: Text(s.name[0])),
                          title: Text(s.name, style: TextStyle(fontSize: 13.sp, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          trailing: isSelected ? const Icon(Icons.check_circle, color: primaryColor) : null,
                          selected: isSelected,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text('2. Fecha y Hora', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 60)),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (sel, foc) => setState(() { _selectedDay = sel; _focusedDay = foc; }),
                    calendarStyle: const CalendarStyle(selectedDecoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle)),
                    headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                  ),
                  SizedBox(height: 12.h),
                  InkWell(
                    onTap: () async {
                      final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (t != null) setState(() => _selectedTime = t);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12.r)),
                      child: Row(children: [const Icon(Icons.access_time, color: primaryColor), SizedBox(width: 12.w), Text(_selectedTime == null ? 'Seleccionar hora' : _selectedTime!.format(context))]),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text('3. Motivo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: _motiveController,
                    decoration: InputDecoration(hintText: 'Ej: Revisión de resultados...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
                    maxLines: 2,
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))),
                      child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirmar y Agendar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
void showCounselorBookingSheet(BuildContext context) {
  showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => const CounselorAppointmentBookingSheet());
}
