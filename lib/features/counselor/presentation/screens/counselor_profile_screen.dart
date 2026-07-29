import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/shared/theme/theme_provider.dart';

class CounselorProfileScreen extends StatelessWidget {
  const CounselorProfileScreen({super.key});

  static const Color _primary = Color(0xFF311B92);
  static const Color _purple = Color(0xFF6542D8);
  static const Color _danger = Color(0xFFFF525D);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final user = authProvider.user;

    final String rawName = user?.name ?? '';
    final String rawEmail = user?.email ?? '';

    final String name = rawName.trim().isNotEmpty
        ? rawName.trim()
        : 'Orientador';

    final String email = rawEmail.trim().isNotEmpty
        ? rawEmail.trim()
        : 'Sin correo';

    final String? avatarUrl = user?.effectivePhotoUrl;
    final bool hasAvatar =
        avatarUrl != null && avatarUrl.trim().isNotEmpty;

    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDark
        ? const Color(0xFF0F1020)
        : const Color(0xFFF7F8FE);

    final Color cardColor = isDark
        ? const Color(0xFF1A1B2E)
        : Colors.white;

    final Color titleColor = isDark
        ? Colors.white
        : const Color(0xFF151440);

    final Color secondaryColor = isDark
        ? const Color(0xFFB8B8C8)
        : const Color(0xFF90909A);

    final Color borderColor = isDark
        ? const Color(0xFF303149)
        : const Color(0xFFE8E8F0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildTopBar(
                context: context,
                titleColor: titleColor,
                secondaryColor: secondaryColor,
                isDark: isDark,
              ),
            ),

            SliverToBoxAdapter(
              child: _buildProfileCard(
                name: name,
                email: email,
                avatarUrl: hasAvatar ? avatarUrl : null,
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                20.w,
                28.h,
                20.w,
                36.h,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildSectionTitle(
                      title: 'Información personal',
                      subtitle: 'Datos asociados con tu cuenta',
                      titleColor: titleColor,
                      secondaryColor: secondaryColor,
                    ),

                    SizedBox(height: 14.h),

                    _buildInformationCard(
                      email: email,
                      isDark: isDark,
                      cardColor: cardColor,
                      titleColor: titleColor,
                      secondaryColor: secondaryColor,
                      borderColor: borderColor,
                    ),

                    SizedBox(height: 30.h),

                    _buildSectionTitle(
                      title: 'Configuración',
                      subtitle: 'Personaliza tu experiencia',
                      titleColor: titleColor,
                      secondaryColor: secondaryColor,
                    ),

                    SizedBox(height: 14.h),

                    _buildConfigurationCard(
                      context: context,
                      themeProvider: themeProvider,
                      isDark: isDark,
                      cardColor: cardColor,
                      titleColor: titleColor,
                      secondaryColor: secondaryColor,
                      borderColor: borderColor,
                    ),

                    SizedBox(height: 28.h),

                    _buildLogoutButton(
                      context: context,
                      authProvider: authProvider,
                    ),

                    SizedBox(height: 28.h),

                    Text(
                      'Oriéntate+ · Orientación vocacional',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar({
    required BuildContext context,
    required Color titleColor,
    required Color secondaryColor,
    required bool isDark,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        14.w,
        8.h,
        20.w,
        14.h,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
            color: titleColor,
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? const Color(0xFF1A1B2E)
                  : const Color(0xFFF0EFF9),
              minimumSize: Size(50.w, 50.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi perfil',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  'Cuenta del orientador',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard({
    required String name,
    required String email,
    required String? avatarUrl,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            _primary,
            _purple,
          ],
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.20),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 98.w,
                height: 98.w,
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFF0EEFA),
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl == null
                      ? Icon(
                    Icons.person_rounded,
                    color: _primary,
                    size: 49.sp,
                  )
                      : null,
                ),
              ),

              Positioned(
                right: 1,
                bottom: 2,
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF20B26B),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 20.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 11.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    'ORIENTADOR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                SizedBox(height: 11.h),

                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                SizedBox(height: 7.h),

                Row(
                  children: [
                    Icon(
                      Icons.mail_outline_rounded,
                      color: Colors.white70,
                      size: 16.sp,
                    ),

                    SizedBox(width: 7.w),

                    Expanded(
                      child: Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.sp,
                        ),
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

  Widget _buildSectionTitle({
    required String title,
    required String subtitle,
    required Color titleColor,
    required Color secondaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          subtitle,
          style: TextStyle(
            color: secondaryColor,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildInformationCard({
    required String email,
    required bool isDark,
    required Color cardColor,
    required Color titleColor,
    required Color secondaryColor,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          _buildInformationRow(
            icon: Icons.mail_outline_rounded,
            iconColor: const Color(0xFF159BC7),
            iconBackground: isDark
                ? const Color(0xFF123543)
                : const Color(0xFFE8F7FC),
            label: 'Correo electrónico',
            value: email,
            titleColor: titleColor,
            secondaryColor: secondaryColor,
          ),

          Divider(
            height: 1,
            indent: 78.w,
            color: borderColor,
          ),

          _buildInformationRow(
            icon: Icons.badge_outlined,
            iconColor: isDark
                ? const Color(0xFFB59AFF)
                : _primary,
            iconBackground: isDark
                ? const Color(0xFF282443)
                : const Color(0xFFF0EEFA),
            label: 'Tipo de cuenta',
            value: 'Orientador vocacional',
            titleColor: titleColor,
            secondaryColor: secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInformationRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String label,
    required String value,
    required Color titleColor,
    required Color secondaryColor,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          _buildIconBox(
            icon: icon,
            iconColor: iconColor,
            backgroundColor: iconBackground,
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 10.sp,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 13.sp,
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

  Widget _buildConfigurationCard({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required bool isDark,
    required Color cardColor,
    required Color titleColor,
    required Color secondaryColor,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                _buildIconBox(
                  icon: themeProvider.isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  iconColor: isDark
                      ? const Color(0xFFB59AFF)
                      : _primary,
                  backgroundColor: isDark
                      ? const Color(0xFF282443)
                      : const Color(0xFFF0EEFA),
                ),

                SizedBox(width: 14.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Modo oscuro',
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        themeProvider.isDarkMode
                            ? 'Tema oscuro activado'
                            : 'Tema claro activado',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                Switch.adaptive(
                  value: themeProvider.isDarkMode,
                  onChanged: themeProvider.setDarkMode,
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            indent: 78.w,
            color: borderColor,
          ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showHelpDialog(context),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    _buildIconBox(
                      icon: Icons.help_outline_rounded,
                      iconColor: const Color(0xFF159BC7),
                      backgroundColor: isDark
                          ? const Color(0xFF123543)
                          : const Color(0xFFE8F7FC),
                    ),

                    SizedBox(width: 14.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ayuda y soporte',
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            'Información sobre Oriéntate+',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Icon(
                      Icons.chevron_right_rounded,
                      color: secondaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBox({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 24.sp,
      ),
    );
  }

  Widget _buildLogoutButton({
    required BuildContext context,
    required AuthProvider authProvider,
  }) {
    return OutlinedButton.icon(
      onPressed: () => _confirmLogout(
        context,
        authProvider,
      ),
      icon: const Icon(Icons.logout_rounded),
      label: const Text('Cerrar sesión'),
      style: OutlinedButton.styleFrom(
        foregroundColor: _danger,
        side: const BorderSide(
          color: _danger,
        ),
        minimumSize: Size.fromHeight(58.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Future<void> _showHelpDialog(
      BuildContext context,
      ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ayuda y soporte'),
          content: const Text(
            'Si necesitas ayuda con tu cuenta, agenda o grupos, '
                'comunícate con el administrador de Oriéntate+.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmLogout(
      BuildContext context,
      AuthProvider authProvider,
      ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text(
            '¿Deseas cerrar tu sesión en Oriéntate+?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _danger,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await authProvider.logout();

    if (context.mounted) {
      context.go('/login');
    }
  }
}