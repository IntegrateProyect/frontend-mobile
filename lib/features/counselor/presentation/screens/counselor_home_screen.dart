import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../components/home/availability_editor_sheet.dart';
import '../components/home/counselor_appointment_booking_sheet.dart';
import '../providers/counselor_provider.dart';

class CounselorHomeScreen extends StatefulWidget {
  const CounselorHomeScreen({super.key});

  @override
  State<CounselorHomeScreen> createState() => _CounselorHomeScreenState();
}

class _CounselorHomeScreenState extends State<CounselorHomeScreen> {
  static const _primary = Color(0xFF311B92);
  static const _secondary = Color(0xFF6847D6);
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
      appBar: _appBar(provider),
      body: _body(provider),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  PreferredSizeWidget _appBar(CounselorProvider provider) {
    final pending = provider.consultations.where((item) {
      final status = item.status.toLowerCase().trim();
      return status != 'responded' && status != 'resolved';
    }).length;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 68.h,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      titleSpacing: 20.w,
      title: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_primary, _secondary],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.explore_rounded,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            'Oriéntate+',
            style: TextStyle(
              color: _dark,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -.4,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Notificaciones',
          onPressed: () => _showNotifications(provider),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: _dark,
              ),
              if (pending > 0)
                Positioned(
                  right: -5,
                  top: -5,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 17,
                      minHeight: 17,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      pending > 9 ? '9+' : '$pending',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  Widget _body(CounselorProvider provider) {
    if (provider.isLoading &&
        provider.groups.isEmpty &&
        provider.students.isEmpty &&
        provider.appointments.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: _primary),
      );
    }

    return IndexedStack(
      index: _selectedIndex >= 0 && _selectedIndex <= 2
          ? _selectedIndex
          : 0,
      children: [
        _homeTab(provider),
        _groupsTab(provider),
        _agendaTab(provider),
      ],
    );
  }

  Widget _homeTab(CounselorProvider provider) {
    final upcoming = _upcoming(provider.appointments);
    final next = upcoming.isEmpty ? null : upcoming.first;
    final pending = provider.consultations.where((item) {
      final status = item.status.toLowerCase().trim();
      return status != 'responded' && status != 'resolved';
    }).toList();

    return RefreshIndicator(
      color: _primary,
      onRefresh: provider.loadDashboardData,
      child: ListView(
        key: const PageStorageKey<String>('counselor-home-tab'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 32.h),
        children: [
          _hero(provider),
          SizedBox(height: 18.h),
          _quickActions(),
          SizedBox(height: 25.h),
          _sectionHeader(
            title: 'Resumen',
            subtitle: 'Actividad de tus grupos',
          ),
          SizedBox(height: 12.h),
          _metrics(provider, pending.length),
          SizedBox(height: 25.h),
          _sectionHeader(
            title: 'Tu día',
            subtitle: DateFormat(
              "EEEE d 'de' MMMM",
              'es_MX',
            ).format(DateTime.now()),
          ),
          SizedBox(height: 12.h),
          _nextAppointment(provider, next),
          SizedBox(height: 25.h),
          _sectionHeader(
            title: 'Seguimiento prioritario',
            subtitle: pending.isEmpty
                ? 'No hay casos pendientes'
                : '${pending.length} ${pending.length == 1 ? 'alumno requiere' : 'alumnos requieren'} atención',
          ),
          SizedBox(height: 12.h),
          _priorityList(provider, pending),
        ],
      ),
    );
  }

  Widget _hero(CounselorProvider provider) {
    final name = provider.profile?.name.trim() ?? '';
    final firstName =
    name.isEmpty ? 'orientador' : name.split(RegExp(r'\s+')).first;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primary, _secondary],
        ),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(.22),
            blurRadius: 24,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, $firstName 👋',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'Acompaña, organiza y da seguimiento a tus estudiantes.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.82),
                    fontSize: 11.5.sp,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 11.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.14),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.groups_2_outlined,
                        color: Colors.white,
                        size: 17,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${provider.totalStudentsCount} alumnos activos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 14.w),
          Container(
            width: 76.w,
            height: 76.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.14),
              borderRadius: BorderRadius.circular(23.r),
              border: Border.all(
                color: Colors.white.withOpacity(.18),
              ),
            ),
            child: Icon(
              Icons.assignment_turned_in_rounded,
              color: Colors.white,
              size: 39.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            icon: Icons.add_rounded,
            label: 'Nuevo grupo',
            color: _primary,
            onTap: _showCreateGroupDialog,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _actionButton(
            icon: Icons.event_available_rounded,
            label: 'Nueva cita',
            color: const Color(0xFF1597D4),
            onTap: () => showCounselorBookingSheet(context),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _actionButton(
            icon: Icons.schedule_rounded,
            label: 'Horario',
            color: const Color(0xFF159947),
            onTap: () => showAvailabilityEditorSheet(context),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.r),
            border: Border.all(color: color.withOpacity(.1)),
          ),
          child: Column(
            children: [
              Container(
                width: 37.w,
                height: 37.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 21.sp),
              ),
              SizedBox(height: 7.h),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: _dark,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metrics(CounselorProvider provider, int pending) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFFECECF3)),
      ),
      child: Row(
        children: [
          _metric(
            value: provider.totalStudentsCount,
            label: 'Alumnos',
            icon: Icons.people_alt_outlined,
            color: const Color(0xFF1597D4),
            onTap: () => context.push(AppRoutes.counselorStudents.path),
          ),
          _metricDivider(),
          _metric(
            value: provider.groupsCount,
            label: 'Grupos',
            icon: Icons.groups_2_outlined,
            color: const Color(0xFF9C27B0),
            onTap: () => setState(() => _selectedIndex = 1),
          ),
          _metricDivider(),
          _metric(
            value: _todayCount(provider.appointments),
            label: 'Citas hoy',
            icon: Icons.event_outlined,
            color: _primary,
            onTap: () => setState(() => _selectedIndex = 2),
          ),
          _metricDivider(),
          _metric(
            value: pending,
            label: 'Pendientes',
            icon: Icons.notifications_active_outlined,
            color: const Color(0xFFF59E0B),
            onTap: () => _showNotifications(provider),
          ),
        ],
      ),
    );
  }

  Widget _metric({
    required int value,
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Column(
              children: [
                Icon(icon, color: color, size: 21.sp),
                SizedBox(height: 5.h),
                Text(
                  '$value',
                  style: TextStyle(
                    color: _dark,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 8.5.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _metricDivider() => Container(
    width: 1,
    height: 53.h,
    color: const Color(0xFFECECF3),
  );

  Widget _nextAppointment(
      CounselorProvider provider,
      AppointmentEntity? appointment,
      ) {
    if (appointment == null) {
      return _emptyFocusCard(
        icon: Icons.edit_calendar_outlined,
        color: _primary,
        title: 'Tu agenda está libre',
        subtitle: 'Programa una sesión con uno de tus alumnos.',
        button: 'Agendar cita',
        onTap: () => showCounselorBookingSheet(context),
      );
    }

    final student = _studentName(provider, appointment.studentId);
    final date = DateFormat(
      "EEEE d 'de' MMMM · hh:mm a",
      'es_MX',
    ).format(appointment.sessionDate.toLocal());

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(color: _primary.withOpacity(.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: _primary.withOpacity(.09),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Icon(
              Icons.event_available_rounded,
              color: _primary,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Próxima cita',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  student,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _dark,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  appointment.motive,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _selectedIndex = 2),
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }

  Widget _priorityList(
      CounselorProvider provider,
      List<StudentConsultationEntity> pending,
      ) {
    if (pending.isEmpty) {
      return _emptyFocusCard(
        icon: Icons.verified_rounded,
        color: const Color(0xFF159947),
        title: 'Todo está al día',
        subtitle: 'No hay alumnos que requieran atención inmediata.',
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(color: const Color(0xFFECECF3)),
      ),
      child: Column(
        children: List.generate(
          pending.take(3).length,
              (index) {
            final item = pending[index];
            final name = _consultationName(provider, item);
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    context.push(
                      AppRoutes.studentFile.path,
                      extra: {
                        'studentId': item.studentId,
                        'studentName': name,
                      },
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFFFF4E5),
                    child: const Icon(
                      Icons.priority_high_rounded,
                      color: Color(0xFFE18400),
                    ),
                  ),
                  title: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _dark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    item.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
                if (index < pending.take(3).length - 1)
                  const Divider(height: 1, indent: 70),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _emptyFocusCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    String? button,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(color: color.withOpacity(.13)),
      ),
      child: Row(
        children: [
          Container(
            width: 49.w,
            height: 49.w,
            decoration: BoxDecoration(
              color: color.withOpacity(.09),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _dark,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10.5.sp,
                  ),
                ),
              ],
            ),
          ),
          if (button != null)
            TextButton(
              onPressed: onTap,
              child: Text(button),
            ),
        ],
      ),
    );
  }

  Widget _groupsTab(CounselorProvider provider) {
    return RefreshIndicator(
      color: _primary,
      onRefresh: provider.loadDashboardData,
      child: ListView(
        key: const PageStorageKey<String>('counselor-groups-tab'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 30.h),
        children: [
          Container(
            padding: EdgeInsets.all(19.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_primary, _secondary],
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mis grupos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${provider.groups.length} '
                      '${provider.groups.length == 1 ? 'grupo registrado' : 'grupos registrados'}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showCreateGroupDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _primary,
                      elevation: 0,
                      minimumSize: Size.fromHeight(47.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text(
                      'Crear nuevo grupo',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 22.h),
          Text(
            'Grupos activos',
            style: TextStyle(
              color: _dark,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Administra los grupos y consulta a sus alumnos.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 10.5.sp,
            ),
          ),
          SizedBox(height: 13.h),
          if (provider.groups.isEmpty)
            _emptyFocusCard(
              icon: Icons.group_add_outlined,
              color: _primary,
              title: 'Crea tu primer grupo',
              subtitle:
              'Comparte el código para que tus alumnos puedan unirse.',
              button: 'Crear',
              onTap: _showCreateGroupDialog,
            )
          else
            ...provider.groups.whereType<Map>().map(
                  (raw) => _groupCard(
                Map<String, dynamic>.from(raw),
              ),
            ),
        ],
      ),
    );
  }

  Widget _groupCard(Map<String, dynamic> group) {
    final id = '${group['id'] ?? ''}';
    final name = '${group['name'] ?? 'Grupo sin nombre'}';
    final code =
        '${group['accessCode'] ?? group['access_code'] ?? group['code'] ?? '---'}';
    final count = int.tryParse(
      '${group['studentCount'] ?? group['studentsCount'] ?? group['membersCount'] ?? 0}',
    ) ??
        0;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(color: const Color(0xFFECECF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.025),
            blurRadius: 14,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_primary, _secondary],
                  ),
                  borderRadius: BorderRadius.circular(17.r),
                ),
                child: const Icon(
                  Icons.groups_2_rounded,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _dark,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Row(
                      children: [
                        _smallTag(Icons.key_rounded, code),
                        SizedBox(width: 7.w),
                        _smallTag(
                          Icons.person_outline_rounded,
                          '$count alumnos',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Divider(height: 1, color: Colors.grey.shade100),
          SizedBox(height: 11.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: id.isEmpty
                      ? null
                      : () => context.push(
                    AppRoutes.groupStudents.path,
                    extra: {
                      'groupId': id,
                      'groupName': name,
                    },
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: const Icon(Icons.people_outline_rounded, size: 18),
                  label: const Text(
                    'Ver alumnos',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showEditGroupDialog(group),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primary,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Icon(Icons.edit_outlined, size: 20),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: id.isEmpty
                      ? null
                      : () => _confirmDeleteGroup(id, name),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Color(0xFFFFCDD2)),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallTag(IconData icon, String text) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F0FA),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12.sp, color: _primary),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _primary,
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _agendaTab(CounselorProvider provider) {
    final appointments = List<AppointmentEntity>.from(
      provider.appointments,
    )..sort((a, b) => a.sessionDate.compareTo(b.sessionDate));

    return RefreshIndicator(
      color: _primary,
      onRefresh: provider.loadDashboardData,
      child: ListView(
        key: const PageStorageKey<String>('counselor-agenda-tab'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 30.h),
        children: [
          _pageHeader(
            title: 'Agenda',
            subtitle: '${appointments.length} citas registradas',
            button: 'Nueva cita',
            icon: Icons.add_rounded,
            onTap: () => showCounselorBookingSheet(context),
          ),
          SizedBox(height: 12.h),
          OutlinedButton.icon(
            onPressed: () => showAvailabilityEditorSheet(context),
            icon: const Icon(Icons.schedule_rounded),
            label: Text(
              provider.availability.isEmpty
                  ? 'Configurar disponibilidad'
                  : '${provider.availability.length} bloques disponibles',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: _primary,
              minimumSize: Size.fromHeight(48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          if (appointments.isEmpty)
            _emptyFocusCard(
              icon: Icons.event_busy_outlined,
              color: _primary,
              title: 'No hay citas programadas',
              subtitle: 'Crea una cita para comenzar a organizar tu agenda.',
              button: 'Agendar',
              onTap: () => showCounselorBookingSheet(context),
            )
          else
            ...appointments.map(
                  (item) => _appointmentCard(provider, item),
            ),
        ],
      ),
    );
  }

  Widget _appointmentCard(
      CounselorProvider provider,
      AppointmentEntity appointment,
      ) {
    final name = _studentName(provider, appointment.studentId);
    final date = appointment.sessionDate.toLocal();
    return Container(
      margin: EdgeInsets.only(bottom: 11.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19.r),
        border: Border.all(color: const Color(0xFFECECF3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 55.w,
            decoration: BoxDecoration(
              color: _primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd').format(date),
                  style: TextStyle(
                    color: _primary,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  DateFormat('MMM', 'es_MX').format(date).toUpperCase(),
                  style: TextStyle(
                    color: _primary,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _dark,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  appointment.motive,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10.5.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: _primary,
                      size: 14,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      DateFormat('hh:mm a').format(date),
                      style: TextStyle(
                        color: _primary,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageHeader({
    required String title,
    required String subtitle,
    required String button,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _dark,
            fontSize: 23.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 10.5.sp,
          ),
        ),
        SizedBox(height: 13.h),
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton.icon(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            icon: Icon(icon),
            label: Text(
              button,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: _dark,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 9.5.sp,
          ),
        ),
      ],
    );
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
    final pending = provider.consultations.where((item) {
      final status = item.status.toLowerCase().trim();
      return status != 'responded' && status != 'resolved';
    }).toList();

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
                _emptyFocusCard(
                  icon: Icons.notifications_none_rounded,
                  color: const Color(0xFF159947),
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
                    title: Text(_consultationName(provider, item)),
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

  String _consultationName(
      CounselorProvider provider,
      StudentConsultationEntity item,
      ) {
    if (item.studentName.trim().isNotEmpty) return item.studentName.trim();
    return _studentName(provider, item.studentId);
  }
}