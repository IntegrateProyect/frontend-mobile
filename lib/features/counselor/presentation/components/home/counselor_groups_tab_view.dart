import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/counselor_provider.dart';
import 'counselor_home_shared_widgets.dart';

class CounselorGroupsTabView extends StatelessWidget {
  final CounselorProvider provider;
  final VoidCallback onNewGroup;
  final Function(Map<String, dynamic> group) onEditGroup;
  final Function(String id, String name) onDeleteGroup;
  final Function(String id, String name) onViewGroupStudents;

  const CounselorGroupsTabView({
    super.key,
    required this.provider,
    required this.onNewGroup,
    required this.onEditGroup,
    required this.onDeleteGroup,
    required this.onViewGroupStudents,
  });

  static const _primary = Color(0xFF311B92);
  static const _secondary = Color(0xFF6847D6);
  static const _dark = Color(0xFF17164A);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: _primary,
      onRefresh: provider.loadDashboardData,
      child: ListView(
        key: const PageStorageKey<String>('counselor-groups-tab'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 30.h),
        children: [
          _header(),
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
            CounselorEmptyFocusCard(
              icon: Icons.group_add_outlined,
              color: _primary,
              title: 'Crea tu primer grupo',
              subtitle: 'Comparte el código para que tus alumnos puedan unirse.',
              button: 'Crear',
              onTap: onNewGroup,
            )
          else
            ...provider.groups.whereType<Map>().map(
                  (raw) => _groupCard(Map<String, dynamic>.from(raw)),
                ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
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
            '${provider.groups.length} ${provider.groups.length == 1 ? 'grupo registrado' : 'grupos registrados'}',
            style: TextStyle(
              color: Colors.white.withOpacity(.8),
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onNewGroup,
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
    );
  }

  Widget _groupCard(Map<String, dynamic> group) {
    final id = '${group['id'] ?? ''}';
    final name = '${group['name'] ?? 'Grupo sin nombre'}';
    final code = '${group['accessCode'] ?? group['access_code'] ?? group['code'] ?? '---'}';
    final count = int.tryParse('${group['studentCount'] ?? group['studentsCount'] ?? group['membersCount'] ?? 0}') ?? 0;

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
                        CounselorSmallTag(icon: Icons.key_rounded, text: code, primaryColor: _primary),
                        SizedBox(width: 7.w),
                        CounselorSmallTag(
                          icon: Icons.person_outline_rounded,
                          text: '$count alumnos',
                          primaryColor: _primary,
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
                  onPressed: () => onViewGroupStudents(id, name),
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
                  onPressed: () => onEditGroup(group),
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
                  onPressed: () => onDeleteGroup(id, name),
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
}
