import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/student_alert_entity.dart';
import '../components/home/counselor_appointment_booking_sheet.dart';
import '../providers/counselor_provider.dart';


class StudentFileScreen extends StatefulWidget {
  final String studentId;
  final String studentName;

  const StudentFileScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<StudentFileScreen> createState() => _StudentFileScreenState();
}

class _StudentFileScreenState extends State<StudentFileScreen> {
  static const Color _primary = Color(0xFF311B92);
  static const Color _darkText = Color(0xFF1D1B4B);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CounselorProvider>().loadStudentFile(widget.studentId);
      }
    });
  }

  @override
  void dispose() {
    context.read<CounselorProvider>().clearCurrentStudentFile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounselorProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _darkText,
          ),
        ),
        title: Text(
          'Expediente',
          style: TextStyle(
            color: _darkText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: provider.isLoadingFile
                ? null
                : () => provider.loadStudentFile(widget.studentId),
            icon: const Icon(
              Icons.refresh_rounded,
              color: _primary,
            ),
          ),
        ],
      ),
      body: _buildBody(provider),
      bottomNavigationBar: provider.currentStudentFile == null
          ? null
          : SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
          child: SizedBox(
            height: 52.h,
            child: ElevatedButton.icon(
              onPressed: () => showCounselorBookingSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              icon: const Icon(Icons.event_available_rounded),
              label: const Text(
                'Agendar sesión de asesoría',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CounselorProvider provider) {
    if (provider.isLoadingFile) {
      return const Center(
        child: CircularProgressIndicator(color: _primary),
      );
    }

    if (provider.currentStudentFile == null) {
      return _ErrorState(
        message: provider.errorMessage ??
            'No fue posible cargar el expediente.',
        onRetry: () => provider.loadStudentFile(widget.studentId),
      );
    }

    final file = provider.currentStudentFile!;
    return RefreshIndicator(
      color: _primary,
      onRefresh: () => provider.loadStudentFile(widget.studentId),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 110.h),
        children: [
          _StudentHeader(
            studentName: widget.studentName,
            studentId: widget.studentId,
            email: _text(
              file.profile['email'] ??
                  file.profile['user']?['email'],
              fallback: 'Correo no disponible',
            ),
          ),
          SizedBox(height: 20.h),
          _sectionTitle('Información vocacional'),
          SizedBox(height: 10.h),
          _ProfileCard(profile: file.profile),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _CounterCard(
                  icon: Icons.assignment_outlined,
                  label: 'Tareas',
                  value: file.tasks.length,
                  color: const Color(0xFF1597D4),
                ),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: _CounterCard(
                  icon: Icons.history_rounded,
                  label: 'Sesiones',
                  value: file.sessions.length,
                  color: const Color(0xFF7B2CBF),
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          _sectionTitle('Alertas y seguimiento'),
          SizedBox(height: 10.h),
          AlertsSection(
            alerts: file.alerts,
            onSchedule: () => showCounselorBookingSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: _darkText,
        fontSize: 17.sp,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  static String _text(dynamic value, {required String fallback}) {
    final text = (value ?? '').toString().trim();
    return text.isEmpty ? fallback : text;
  }
}

class _StudentHeader extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String email;

  const _StudentHeader({
    required this.studentName,
    required this.studentId,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final name =
    studentName.trim().isEmpty ? 'Alumno sin nombre' : studentName.trim();
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF311B92), Color(0xFF5B3FC4)],
        ),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 31.r,
            backgroundColor: Colors.white,
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: const Color(0xFF311B92),
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 11.sp,
                  ),
                ),
                Text(
                  'ID: $studentId',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.6),
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final clarity = _percentage(profile['vocationalClarity']);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19.r),
        border: Border.all(color: const Color(0xFFECECF3)),
      ),
      child: Column(
        children: [
          _row('Claridad vocacional', '$clarity%'),
          const Divider(),
          _row(
            'Requiere beca',
            profile['needsScholarship'] == true ? 'Sí' : 'No',
          ),
          const Divider(),
          _row(
            'Interés en estudiar fuera',
            profile['studyAbroad'] == true ? 'Sí' : 'No',
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1D1B4B),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  int _percentage(dynamic value) {
    final number =
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
    if (number <= 1) return (number * 100).round().clamp(0, 100);
    if (number <= 10) return (number * 10).round().clamp(0, 100);
    return number.round().clamp(0, 100);
  }
}

class _CounterCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _CounterCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 9.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value',
                style: TextStyle(
                  color: const Color(0xFF1D1B4B),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AlertsSection extends StatelessWidget {
  final List<StudentAlertEntity> alerts;
  final VoidCallback onSchedule;

  const AlertsSection({
    super.key,
    required this.alerts,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(22.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19.r),
        ),
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.green.shade400,
              size: 43.sp,
            ),
            SizedBox(height: 9.h),
            const Text(
              'Sin alertas pendientes',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      );
    }

    return Column(
      children: alerts
          .map(
            (alert) => AlertCard(
          alert: alert,
          onSchedule: onSchedule,
        ),
      )
          .toList(),
    );
  }
}

class AlertCard extends StatelessWidget {
  final StudentAlertEntity alert;
  final VoidCallback onSchedule;

  const AlertCard({
    super.key,
    required this.alert,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final high = alert.alertType == AlertType.highIndecision;
    final scholarship = alert.alertType == AlertType.scholarshipNeed;
    final color = high
        ? Colors.red.shade800
        : scholarship
        ? Colors.orange.shade800
        : Colors.blue.shade800;
    final title = high
        ? 'Alta indecisión'
        : scholarship
        ? 'Necesidad de beca'
        : 'Seguimiento necesario';

    return Container(
      margin: EdgeInsets.only(bottom: 11.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: color.withOpacity(.07),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: color.withOpacity(.13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: color),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(alert.createdAt.toLocal()),
                style: TextStyle(
                  color: color.withOpacity(.65),
                  fontSize: 9.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            alert.details.trim().isEmpty
                ? 'Este alumno requiere seguimiento.'
                : alert.details,
            style: TextStyle(color: color.withOpacity(.85)),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              icon: const Icon(Icons.event_available_rounded),
              label: const Text('Agendar asesoría'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 58.sp,
            ),
            SizedBox(height: 14.h),
            Text(
              'No se pudo cargar el expediente',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 7.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            SizedBox(height: 18.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}