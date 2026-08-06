import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../components/home/availability_editor_sheet.dart';
import '../components/home/counselor_appointment_booking_sheet.dart';
import '../components/home/counselor_home_app_bar.dart';
import '../components/home/counselor_home_tab_view.dart';
import '../components/home/counselor_groups_tab_view.dart';
import '../components/home/counselor_agenda_tab_view.dart';
import '../components/home/counselor_home_shared_widgets.dart';
import '../providers/counselor_provider.dart';

class CounselorHomeScreen extends StatefulWidget {
  const CounselorHomeScreen({super.key});

  @override
  State<CounselorHomeScreen> createState() => _CounselorHomeScreenState();
}

class _CounselorHomeScreenState extends State<CounselorHomeScreen> {
  static const _primary = Color(0xFF311B92);
  static const _dark = Color(0xFF17164A);
  static const _background = Color(0xFFF6F7FC);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<CounselorProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounselorProvider>();
    return Scaffold(
      backgroundColor: _background,
      appBar: CounselorHomeAppBar(
        pendingNotifications: _getPendingCount(provider),
        onNotificationsPressed: () => _showNotifications(provider),
      ),
      body: _body(provider),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  int _getPendingCount(CounselorProvider provider) {
    return provider.consultations.where((item) {
      final status = item.status.toLowerCase().trim();
      return status != 'responded' && status != 'resolved';
    }).length;
  }

  Widget _body(CounselorProvider provider) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (provider.state == CounselorState.loading &&
        provider.groups.isEmpty &&
        provider.students.isEmpty &&
        provider.appointments.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: _primary),
      );
    }

    if (provider.state == CounselorState.error &&
        provider.groups.isEmpty &&
        provider.students.isEmpty &&
        provider.appointments.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
              SizedBox(height: 16.h),
              Text(
                provider.errorMessage ?? 'Ocurrió un error al cargar los datos del panel',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () => provider.loadDashboardData(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final upcoming = _upcoming(provider.appointments);

    return IndexedStack(
      index: _selectedIndex >= 0 && _selectedIndex <= 2 ? _selectedIndex : 0,
      children: [
        CounselorHomeTabView(
          provider: provider,
          nextAppointment: upcoming.isEmpty ? null : upcoming.first,
          pendingConsultations: _getPendingConsultations(provider),
          nextAppointmentStudentName: upcoming.isEmpty
              ? ''
              : _studentName(provider, upcoming.first.studentId),
          todayAppointmentsCount: _todayCount(provider.appointments),
          onNewGroup: _showCreateGroupDialog,
          onNewAppointment: () => showCounselorBookingSheet(context),
          onEditAvailability: () => showAvailabilityEditorSheet(context),
          onNotificationsPressed: () => _showNotifications(provider),
          onViewAgenda: () => setState(() => _selectedIndex = 2),
          onViewGroups: () => setState(() => _selectedIndex = 1),
          onViewStudents: () => context.push(AppRoutes.counselorStudents.path),
          onStudentFileTap: (id, name) => context.push(
            AppRoutes.studentFile.path,
            extra: {'studentId': id, 'studentName': name},
          ),
        ),
        CounselorGroupsTabView(
          provider: provider,
          onNewGroup: _showCreateGroupDialog,
          onEditGroup: _showEditGroupDialog,
          onDeleteGroup: _confirmDeleteGroup,
          onViewGroupStudents: (id, name) => context.push(
            AppRoutes.groupStudents.path,
            extra: {'groupId': id, 'groupName': name},
          ),
        ),
        CounselorAgendaTabView(
          provider: provider,
          onNewAppointment: () => showCounselorBookingSheet(context),
          onEditAvailability: () => showAvailabilityEditorSheet(context),
          getStudentName: (id) => _studentName(provider, id),
        ),
      ],
    );
  }

  List<StudentConsultationEntity> _getPendingConsultations(
      CounselorProvider provider) {
    return provider.consultations.where((item) {
      final status = item.status.toLowerCase().trim();
      return status != 'responded' && status != 'resolved';
    }).toList();
  }

  Widget _bottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: _primary,
      unselectedItemColor: Colors.grey.shade600,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w800,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      elevation: 8,
      onTap: (index) {
        if (index == 3) {
          context.push(AppRoutes.counselorProfile.path);
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups_outlined),
          activeIcon: Icon(Icons.groups_rounded),
          label: 'Grupos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month_rounded),
          label: 'Agenda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Perfil',
        ),
      ],
    );
  }

  Future<void> _showCreateGroupDialog() async {
    final name = TextEditingController();
    final code = TextEditingController();
    final save = await _groupDialog(
      title: 'Crear grupo',
      action: 'Crear',
      name: name,
      code: code,
    );
    if (save == true && mounted) {
      final ok = await context.read<CounselorProvider>().createGroup(
            name.text,
            code.text,
          );
      if (mounted) _resultMessage(ok, 'Grupo creado correctamente.');
    }
    name.dispose();
    code.dispose();
  }

  Future<void> _showEditGroupDialog(Map<String, dynamic> group) async {
    final name = TextEditingController(text: '${group['name'] ?? ''}');
    final code = TextEditingController(
      text:
          '${group['accessCode'] ?? group['access_code'] ?? group['code'] ?? ''}',
    );
    final save = await _groupDialog(
      title: 'Editar grupo',
      action: 'Guardar',
      name: name,
      code: code,
    );
    if (save == true && mounted) {
      final ok = await context.read<CounselorProvider>().updateGroup(
            '${group['id'] ?? ''}',
            name: name.text,
            accessCode: code.text,
          );
      if (mounted) _resultMessage(ok, 'Grupo actualizado correctamente.');
    }
    name.dispose();
    code.dispose();
  }

  Future<bool?> _groupDialog({
    required String title,
    required String action,
    required TextEditingController name,
    required TextEditingController code,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Nombre del grupo',
                prefixIcon: Icon(Icons.groups_outlined),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: code,
              decoration: const InputDecoration(
                labelText: 'Código de acceso',
                prefixIcon: Icon(Icons.key_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (name.text.trim().isEmpty) return;
              Navigator.pop(dialogContext, true);
            },
            child: Text(action),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteGroup(String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.redAccent,
          size: 38,
        ),
        title: const Text('Eliminar grupo'),
        content: Text(
          '¿Deseas eliminar “$name”? Las cuentas de los alumnos se conservarán.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final ok = await context.read<CounselorProvider>().deleteGroup(id);
      if (mounted) _resultMessage(ok, 'Grupo eliminado correctamente.');
    }
  }

  void _resultMessage(bool success, String successMessage) {
    final provider = context.read<CounselorProvider>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? successMessage
              : provider.errorMessage ?? 'No se pudo completar la acción.',
        ),
        backgroundColor: success ? const Color(0xFF159947) : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showNotifications(CounselorProvider provider) {
    final pending = _getPendingConsultations(provider);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notificaciones',
                style: TextStyle(
                  color: _dark,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 14.h),
              if (pending.isEmpty)
                const CounselorEmptyFocusCard(
                  icon: Icons.notifications_none_rounded,
                  color: Color(0xFF159947),
                  title: 'Sin pendientes',
                  subtitle: 'No tienes notificaciones nuevas.',
                )
              else
                ...pending.take(5).map(
                      (item) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFFF4E5),
                          child: Icon(
                            Icons.priority_high_rounded,
                            color: Color(0xFFE18400),
                          ),
                        ),
                        title: Text(item.studentName.isNotEmpty
                            ? item.studentName
                            : _studentName(provider, item.studentId)),
                        subtitle: Text(
                          item.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  List<AppointmentEntity> _upcoming(List<AppointmentEntity> values) {
    final result = values
        .where(
          (item) =>
              item.sessionDate.toLocal().isAfter(DateTime.now()) &&
              item.status.toUpperCase() != 'CANCELLED',
        )
        .toList()
      ..sort((a, b) => a.sessionDate.compareTo(b.sessionDate));
    return result;
  }

  int _todayCount(List<AppointmentEntity> values) {
    final now = DateTime.now();
    return values.where((item) {
      final date = item.sessionDate.toLocal();
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).length;
  }

  String _studentName(CounselorProvider provider, String studentId) {
    for (final student in provider.students) {
      if (student.id == studentId) {
        return student.name.trim().isEmpty ? 'Alumno' : student.name.trim();
      }
    }
    return 'Alumno';
  }
}
