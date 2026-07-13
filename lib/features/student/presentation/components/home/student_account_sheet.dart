import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/features/student/presentation/providers/student_home_provider.dart';

import '../common/student_ui_colors.dart';

Future<void> showStudentAccountSheet({
  required BuildContext context,
  required StudentHomeProvider homeProvider,
  required AuthProvider authProvider,
}) async {
  final user = authProvider.user;
  final profile = homeProvider.profile;

  final userName = user?.name?.trim();
  final userEmail = user?.email.trim();

  final String name = userName != null && userName.isNotEmpty
      ? userName
      : profile?.name ?? 'Estudiante';

  final String email = userEmail != null && userEmail.isNotEmpty
      ? userEmail
      : profile?.email ?? 'Sin correo';

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          24.w,
          16.h,
          24.w,
          28.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.r),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),

                SizedBox(height: 22.h),

                Row(
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundColor: const Color(0xFFF0EAFE),
                      child: Icon(
                        Icons.person_rounded,
                        color: StudentUiColors.primary,
                        size: 32.sp,
                      ),
                    ),

                    SizedBox(width: 14.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información de registro',
                            style: TextStyle(
                              color: StudentUiColors.darkText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Datos de tu cuenta',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 22.h),

                _AccountInformationItem(
                  icon: Icons.badge_outlined,
                  label: 'Nombre',
                  value: name,
                ),

                _AccountInformationItem(
                  icon: Icons.email_outlined,
                  label: 'Correo',
                  value: email,
                ),

                const _AccountInformationItem(
                  icon: Icons.school_outlined,
                  label: 'Tipo de cuenta',
                  value: 'Estudiante',
                ),

                _AccountInformationItem(
                  icon: Icons.groups_2_outlined,
                  label: 'Grupo escolar',
                  value: homeProvider.hasGroup
                      ? homeProvider.currentGroupName
                      : 'Sin grupo asignado',
                ),

                _AccountInformationItem(
                  icon: Icons.vpn_key_outlined,
                  label: 'Código de grupo',
                  value: homeProvider.hasGroup
                      ? homeProvider.currentGroupCode
                      : 'Sin código',
                ),

                SizedBox(height: 12.h),

                const Divider(),

                SizedBox(height: 8.h),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();

                    await authProvider.logout();

                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _AccountInformationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AccountInformationItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: StudentUiColors.background,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: StudentUiColors.primary,
            size: 22.sp,
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: StudentUiColors.darkText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
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