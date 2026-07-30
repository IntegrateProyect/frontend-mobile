import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/AppRoutes.dart';
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
            tooltip: 'Enviar mensaje',
            onPressed: () {
              context.push(
                AppRoutes.realChat.path,
                extra: {
                  'contactId': widget.studentId,
                  'contactName': widget.studentName,
                },
              );
            },
            icon: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: _primary,
            ),
          ),
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
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52.h,
                  child: ElevatedButton.icon(
                    onPressed: () => showCounselorBookingSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _primary,
                      elevation: 0,
                      side: const BorderSide(color: _primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    icon: const Icon(Icons.event_available_rounded),
                    label: const Text(
                      'Cita',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(
                        AppRoutes.realChat.path,
                        extra: {
                          'contactId': widget.studentId,
                          'contactName': widget.studentName,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    icon: const Icon(Icons.chat_bubble_rounded),
                    label: const Text(
                      'Enviar mensaje',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ],
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
          _ParentsCard(
            profile: file.profile,
            studentId: widget.studentId,
            studentName: widget.studentName,
          ),
          SizedBox(height: 20.h),
          _VocationalResultsSection(
            riasec: file.riasec,
            recommendations: file.recommendations,
          ),
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
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11.sp,
                  ),
                ),
                Text(
                  'ID: $studentId',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
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

    return _buildAlertContent(alert, color, title);
  }

  Widget _buildAlertContent(StudentAlertEntity alert, Color color, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 11.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: color.withValues(alpha: 0.13)),
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
                  color: color.withValues(alpha: 0.65),
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
            style: TextStyle(color: color.withValues(alpha: 0.85)),
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

class _VocationalResultsSection extends StatelessWidget {
  final Map<String, dynamic>? riasec;
  final List<dynamic>? recommendations;

  const _VocationalResultsSection({
    required this.riasec,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    final hasRiasec = riasec != null && riasec!.isNotEmpty;
    final hasRecs = recommendations != null && recommendations!.isNotEmpty;

    if (!hasRiasec) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19.r),
          border: Border.all(color: const Color(0xFFECECF3)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              color: Colors.amber.shade700,
              size: 40.sp,
            ),
            SizedBox(height: 10.h),
            Text(
              'Aún sin resultados vocacionales',
              style: TextStyle(
                color: const Color(0xFF1D1B4B),
                fontWeight: FontWeight.w900,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'El estudiante todavía no completa sus pruebas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      );
    }

    // Determine dominant trait from riasec scores
    String dominantTrait = 'Desconocido';
    double maxScore = -1.0;
    
    riasec!.forEach((key, value) {
      final double score = value is num ? value.toDouble() : double.tryParse('$value') ?? 0.0;
      if (score > maxScore) {
        maxScore = score;
        dominantTrait = key;
      }
    });

    final traitLabels = {
      'R': 'Realista (Taller / Técnico)',
      'I': 'Investigador (Científico / Laboratorio)',
      'A': 'Artístico (Diseño / Estudio)',
      'S': 'Social (Servicio / Consultorio)',
      'E': 'Emprendedor (Persuasivo / Negocios)',
      'C': 'Convencional (Organización / Oficina)',
      'MECANICO': 'Mecánico / Taller (Realista)',
      'CIENTIFICO_FISICO': 'Científico Físico (Investigador)',
      'CIENTIFICO_BIOLOGICO': 'Científico Biológico (Investigador)',
      'CALCULO': 'Cálculo y Análisis (Investigador/Convencional)',
      'SERVICIO_SOCIAL': 'Servicio Social / Humanidades (Social)',
      'LITERARIO': 'Literario / Humanidades (Artístico/Social)',
      'PERSUASIVO': 'Persuasivo / Liderazgo (Emprendedor)',
      'ARTISTICO': 'Artístico y Creativo (Artístico)',
      'MUSICAL': 'Musical y Sonoro (Artístico)'
    };

    final String traitName = traitLabels[dominantTrait.toUpperCase()] ?? dominantTrait;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Dominant Trait Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFE040FB),
                Color(0xFF7C4DFF),
                Color(0xFF4B5CFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C4DFF).withOpacity(0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology_rounded,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Perfil Vocacional Dominante',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                traitName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 20.h),
        
        // 2. Recommended Careers list
        if (hasRecs) ...[
          Text(
            'Carreras sugeridas',
            style: TextStyle(
              color: const Color(0xFF1D1B4B),
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          ...recommendations!.asMap().entries.map((entry) {
            final int index = entry.key + 1;
            final dynamic rec = entry.value;
            final String name = rec['careerName'] ?? rec['name'] ?? 'Carrera';
            final String? uni = rec['universityName'];
            final double score = rec['score'] is num ? rec['score'].toDouble() : 0.0;
            
            return Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFECECF3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: const Color(0xFF7C4DFF).withOpacity(0.1),
                    child: Text(
                      '$index',
                      style: TextStyle(
                        color: const Color(0xFF7C4DFF),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: const Color(0xFF1D1B4B),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (uni != null && uni.trim().isNotEmpty) ...[
                          SizedBox(height: 3.h),
                          Text(
                            uni,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                        SizedBox(height: 8.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: LinearProgressIndicator(
                            value: score.clamp(0.0, 1.0),
                            minHeight: 5.h,
                            backgroundColor: const Color(0xFFEDE9FE),
                            color: const Color(0xFF7C4DFF),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${(score.clamp(0.0, 1.0) * 100).round()}% de compatibilidad',
                          style: TextStyle(
                            color: const Color(0xFF7C4DFF),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 20.h),
        ],
      ],
    );
  }
}

class _ParentsCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  final String studentId;
  final String studentName;

  const _ParentsCard({
    required this.profile,
    required this.studentId,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    final String? email1 = profile['parentEmail1'] ?? profile['parent_email_1'];
    final String? email2 = profile['parentEmail2'] ?? profile['parent_email_2'];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: const Color(0xFFECECF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.family_restroom_rounded, color: Color(0xFF311B92)),
                  SizedBox(width: 8.w),
                  Text(
                    'Contacto de Padres / Familia',
                    style: TextStyle(
                      color: const Color(0xFF1D1B4B),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _showEditParentsDialog(context, email1, email2),
                icon: const Icon(Icons.edit_rounded, color: Color(0xFF311B92), size: 20),
                visualDensity: VisualDensity.compact,
                tooltip: 'Editar correos',
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _buildParentEmailRow('Padre / Tutor 1:', email1),
          SizedBox(height: 8.h),
          _buildParentEmailRow('Padre / Tutor 2:', email2),
          if ((email1 != null && email1.trim().isNotEmpty) || (email2 != null && email2.trim().isNotEmpty)) ...[
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: ElevatedButton.icon(
                onPressed: () => _showSendReportDialog(context, email1, email2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF311B92),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: const Icon(Icons.send_rounded, size: 16),
                label: Text(
                  'Enviar reporte vocacional',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildParentEmailRow(String label, String? email) {
    final bool hasEmail = email != null && email.trim().isNotEmpty;
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            hasEmail ? email : 'No registrado',
            style: TextStyle(
              color: hasEmail ? const Color(0xFF1D1B4B) : Colors.grey.shade400,
              fontSize: 12.sp,
              fontWeight: hasEmail ? FontWeight.w800 : FontWeight.w600,
              fontStyle: hasEmail ? FontStyle.normal : FontStyle.italic,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showEditParentsDialog(BuildContext context, String? email1, String? email2) {
    final formKey = GlobalKey<FormState>();
    final controller1 = TextEditingController(text: email1);
    final controller2 = TextEditingController(text: email2);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (builderCtx, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            title: Row(
              children: [
                const Icon(Icons.family_restroom_rounded, color: Color(0xFF311B92)),
                SizedBox(width: 8.w),
                const Text('Contacto de Padres', style: TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Registra hasta dos direcciones de correo para enviar los reportes del alumno.',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: controller1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo Padre / Tutor 1',
                        labelStyle: const TextStyle(color: Color(0xFF311B92)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(color: Color(0xFF311B92), width: 2),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF311B92)),
                      ),
                      validator: (val) {
                        if (val != null && val.trim().isNotEmpty) {
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                            return 'Ingresa un correo electrónico válido.';
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: controller2,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo Padre / Tutor 2',
                        labelStyle: const TextStyle(color: Color(0xFF311B92)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(color: Color(0xFF311B92), width: 2),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF311B92)),
                      ),
                      validator: (val) {
                        if (val != null && val.trim().isNotEmpty) {
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                            return 'Ingresa un correo electrónico válido.';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(dialogCtx);
                    
                    BuildContext? loadingCtx;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) {
                        loadingCtx = ctx;
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF311B92)));
                      },
                    );

                    final success = await context.read<CounselorProvider>().updateStudentParents(
                      studentId,
                      controller1.text.trim().isEmpty ? null : controller1.text.trim(),
                      controller2.text.trim().isEmpty ? null : controller2.text.trim(),
                    );

                    if (loadingCtx != null && loadingCtx!.mounted) {
                      Navigator.pop(loadingCtx!);
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? 'Contactos actualizados correctamente.'
                              : 'Error al actualizar contactos.'),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF311B92),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSendReportDialog(BuildContext context, String? email1, String? email2) {
    bool target1 = email1 != null && email1.trim().isNotEmpty;
    bool target2 = email2 != null && email2.trim().isNotEmpty;
    String format = 'pdf';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (builderCtx, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            title: Row(
              children: [
                const Icon(Icons.send_rounded, color: Color(0xFF311B92)),
                SizedBox(width: 8.w),
                const Text('Compartir Reporte', style: TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecciona los destinatarios y el formato del reporte vocacional de $studentName.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Enviar a:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: const Color(0xFF1D1B4B)),
                ),
                if (email1 != null && email1.trim().isNotEmpty)
                  CheckboxListTile(
                    title: Text(email1, style: TextStyle(fontSize: 12.sp)),
                    value: target1,
                    onChanged: (val) {
                      setDialogState(() {
                        target1 = val ?? false;
                      });
                    },
                    activeColor: const Color(0xFF311B92),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                if (email2 != null && email2.trim().isNotEmpty)
                  CheckboxListTile(
                    title: Text(email2, style: TextStyle(fontSize: 12.sp)),
                    value: target2,
                    onChanged: (val) {
                      setDialogState(() {
                        target2 = val ?? false;
                      });
                    },
                    activeColor: const Color(0xFF311B92),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                SizedBox(height: 10.h),
                Text(
                  'Formato:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: const Color(0xFF1D1B4B)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('PDF (Email)', style: TextStyle(fontSize: 12.sp)),
                        value: 'pdf',
                        groupValue: format,
                        onChanged: (val) {
                          setDialogState(() {
                            format = val!;
                          });
                        },
                        activeColor: const Color(0xFF311B92),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('CSV (Excel)', style: TextStyle(fontSize: 12.sp)),
                        value: 'csv',
                        groupValue: format,
                        onChanged: (val) {
                          setDialogState(() {
                            format = val!;
                          });
                        },
                        activeColor: const Color(0xFF311B92),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: (!target1 && !target2)
                    ? null
                    : () async {
                        Navigator.pop(dialogCtx);
                        
                        BuildContext? loadingCtx;
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) {
                            loadingCtx = ctx;
                            return const Center(child: CircularProgressIndicator(color: Color(0xFF311B92)));
                          },
                        );

                        final List<String> emails = [];
                        if (target1 && email1 != null) emails.add(email1);
                        if (target2 && email2 != null) emails.add(email2);

                        final success = await context.read<CounselorProvider>().sendStudentReport(
                          studentId,
                          emails,
                          format,
                        );

                        if (loadingCtx != null && loadingCtx!.mounted) {
                          Navigator.pop(loadingCtx!);
                        }

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success
                                  ? 'Reporte enviado exitosamente.'
                                  : 'Error al enviar el reporte vocacional.'),
                              backgroundColor: success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF311B92),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                child: const Text('Enviar'),
              ),
            ],
          );
        },
      ),
    );
  }
}
