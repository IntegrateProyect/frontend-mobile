import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/counselor_provider.dart';
import '../../domain/entities/student_alert_entity.dart';

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
  static const Color primaryColor = Color(0xFF311B92);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CounselorProvider>().loadStudentFile(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounselorProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Expediente del Alumno',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: provider.isLoadingFile
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : provider.errorMessage != null && provider.currentStudentFile == null
              ? _buildErrorView(provider)
              : _buildContent(provider),
    );
  }

  Widget _buildErrorView(CounselorProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.redAccent),
          SizedBox(height: 16.h),
          Text(
            'Error al cargar el expediente',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
            child: Text(
              provider.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => provider.loadStudentFile(widget.studentId),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(CounselorProvider provider) {
    final file = provider.currentStudentFile;
    if (file == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentHeader(),
          SizedBox(height: 24.h),
          _buildProfileSection(file.profile),
          SizedBox(height: 24.h),
          AlertsSection(alerts: file.alerts),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildStudentHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30.r,
          backgroundColor: primaryColor.withOpacity(0.1),
          child: Text(
            widget.studentName.isNotEmpty ? widget.studentName[0].toUpperCase() : '?',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 24.sp),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.studentName,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: const Color(0xFF1D1B4B)),
              ),
              Text(
                'ID: ${widget.studentId}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(Map<String, dynamic> profile) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información General', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          SizedBox(height: 12.h),
          _buildInfoRow('Claridad Vocacional', '${(profile['vocationalClarity'] ?? 0) * 10}%'),
          _buildInfoRow('Requiere Beca', profile['needsScholarship'] == true ? 'Sí' : 'No'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class AlertsSection extends StatelessWidget {
  final List<StudentAlertEntity> alerts;

  const AlertsSection({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alertas del Alumno',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D1B4B)),
        ),
        SizedBox(height: 12.h),
        if (alerts.isEmpty)
          Container(
            padding: EdgeInsets.all(24.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green[300], size: 48.sp),
                SizedBox(height: 12.h),
                Text(
                  'Sin alertas pendientes',
                  style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        else
          ...alerts.map((alert) => AlertCard(alert: alert)),
      ],
    );
  }
}

class AlertCard extends StatelessWidget {
  final StudentAlertEntity alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final isHighIndecision = alert.alertType == AlertType.highIndecision;
    
    final Color cardColor = isHighIndecision 
        ? const Color(0xFFFFEBEE) // Rojo suave
        : const Color(0xFFFFF8E1); // Amarillo suave
        
    final Color textColor = isHighIndecision 
        ? Colors.red[900]! 
        : Colors.orange[900]!;

    final IconData icon = isHighIndecision ? Icons.warning_rounded : Icons.info_rounded;
    final String title = isHighIndecision ? 'Alta Indecisión' : 'Necesidad de Beca';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: textColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 16.sp),
              ),
              const Spacer(),
              Text(
                DateFormat('dd/MM/yyyy').format(alert.createdAt),
                style: TextStyle(fontSize: 11.sp, color: textColor.withOpacity(0.7)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            alert.details,
            style: TextStyle(fontSize: 13.sp, color: textColor.withOpacity(0.8)),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Acción para agendar sesión
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: textColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: const Text('Agendar Sesión de Asesoría'),
            ),
          ),
        ],
      ),
    );
  }
}
