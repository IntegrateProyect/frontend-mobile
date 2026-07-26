import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/features/counselor/presentation/providers/counselor_provider.dart';

class CounselorProfileScreen extends StatelessWidget {
  const CounselorProfileScreen({super.key});

  static const Color _primary = Color(0xFF311B92);
  static const Color _darkText = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    final counselor = context.watch<CounselorProvider>();
    final auth = context.watch<AuthProvider>();
    final profile = counselor.profile;
    final user = auth.user;
    final name = profile?.name ?? user?.name ?? 'Orientador';
    final email = profile?.email ?? user?.email ?? 'Sin correo';
    final institution =
        profile?.institution ?? 'Institución no especificada';
    final avatar = user?.effectivePhotoUrl ?? profile?.profileImageUrl;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _darkText,
          ),
        ),
        title: Text(
          'Mi perfil',
          style: TextStyle(
            color: _darkText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF311B92), Color(0xFF5B3FC4)],
                ),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 47.r,
                    backgroundColor: Colors.white,
                    backgroundImage: avatar != null && avatar.isNotEmpty
                        ? NetworkImage(avatar)
                        : null,
                    child: avatar == null || avatar.isEmpty
                        ? Icon(
                      Icons.person_rounded,
                      color: _primary,
                      size: 48.sp,
                    )
                        : null,
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Orientador vocacional',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.8),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Información de la cuenta',
              style: TextStyle(
                color: _darkText,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 12.h),
            _InfoTile(
              icon: Icons.email_outlined,
              label: 'Correo',
              value: email,
            ),
            _InfoTile(
              icon: Icons.school_outlined,
              label: 'Institución',
              value: institution,
            ),
            const _InfoTile(
              icon: Icons.badge_outlined,
              label: 'Rol',
              value: 'Orientador',
            ),
            SizedBox(height: 20.h),
            OutlinedButton.icon(
              onPressed: () => _confirmLogout(context, auth),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                minimumSize: Size.fromHeight(54.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(
      BuildContext context,
      AuthProvider auth,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text(
          '¿Deseas cerrar tu sesión en Oriéntate+?',
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
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await auth.logout();
    if (context.mounted) context.go('/login');
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 11.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: const Color(0xFFECECF3)),
      ),
      child: Row(
        children: [
          Container(
            width: 43.w,
            height: 43.w,
            decoration: BoxDecoration(
              color: CounselorProfileScreen._primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              icon,
              color: CounselorProfileScreen._primary,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CounselorProfileScreen._darkText,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
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