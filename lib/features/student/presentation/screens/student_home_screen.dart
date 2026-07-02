import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:orientate/features/student/presentation/providers/student_home_provider.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);
  static const Color bgColor = Color(0xFFF8F9FE);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StudentHomeProvider>().loadHomeData();
    });
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAccountOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 28.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
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
            SizedBox(height: 18.h),
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('Mi cuenta'),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.studentProfile.path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () async {
                Navigator.pop(context);
                final authProvider = context.read<AuthProvider>();
                await authProvider.logout();
                if (mounted) context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentHomeProvider>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Oriéntate+',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: _showAccountOptions,
          ),
        ],
      ),
      body: provider.isLoading && provider.profile == null
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _buildBody(provider),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBody(StudentHomeProvider provider) {
    final name = provider.firstName.trim().isNotEmpty
        ? provider.firstName
        : 'Estudiante';

    final totalResults = provider.results.length;
    final totalGames = provider.availableGames.length;

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: provider.loadHomeData,
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 28.h),
        children: [
          _buildGreeting(name, provider),
          SizedBox(height: 18.h),

          _buildProgressCard(provider),
          SizedBox(height: 22.h),

          Row(
            children: [
              Expanded(
                child: _smallResumeCard(
                  icon: Icons.sports_esports_outlined,
                  value: '$totalGames',
                  label: 'Juegos',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _smallResumeCard(
                  icon: Icons.bar_chart_rounded,
                  value: '$totalResults',
                  label: 'Resultados',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _smallResumeCard(
                  icon: Icons.groups_2_outlined,
                  value: provider.hasGroup ? 'Sí' : 'No',
                  label: 'Grupo',
                ),
              ),
            ],
          ),

          SizedBox(height: 26.h),

          Text(
            'Accesos rápidos',
            style: TextStyle(
              color: darkText,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),

          SizedBox(height: 14.h),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 1.45,
            children: [
              _quickAccessCard(
                icon: Icons.chat_bubble_outline,
                title: 'Mensajes',
                description: 'Habla con tu orientador',
                color: const Color(0xFF00A6A6),
                onTap: () => context.push(AppRoutes.chatContacts.path),
              ),
              _quickAccessCard(
                icon: Icons.school_outlined,
                title: 'Carreras',
                description: 'Explora opciones',
                color: const Color(0xFFE84A8A),
                onTap: () => _showSnack('Carreras próximamente'),
              ),
              _quickAccessCard(
                icon: Icons.account_balance_outlined,
                title: 'Universidades',
                description: 'Conoce instituciones',
                color: const Color(0xFF4285F4),
                onTap: () => _showSnack('Universidades próximamente'),
              ),
              _quickAccessCard(
                icon: Icons.event_outlined,
                title: 'Eventos',
                description: 'Ferias y actividades',
                color: const Color(0xFF00A6A6),
                onTap: () => _showSnack('Eventos próximamente'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(String name, StudentHomeProvider provider) {
    final profile = provider.profile;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, $name! 👋',
                style: TextStyle(
                  fontSize: 27.sp,
                  fontWeight: FontWeight.w900,
                  color: darkText,
                  height: 1.05,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Tu futuro comienza hoy.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: _showAccountOptions,
          child: CircleAvatar(
            radius: 30.r,
            backgroundColor: const Color(0xFFF0EAFE),
            backgroundImage: profile?.profileImageUrl != null &&
                profile!.profileImageUrl!.isNotEmpty
                ? NetworkImage(profile.profileImageUrl!)
                : null,
            child: profile?.profileImageUrl == null ||
                profile!.profileImageUrl!.isEmpty
                ? Icon(Icons.person, color: primaryColor, size: 34.sp)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(StudentHomeProvider provider) {
    final results = provider.results.length;
    final percent = results <= 0
        ? 0.10
        : results >= 8
        ? 0.65
        : (results / 12).clamp(0.10, 0.65);

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFEDEAFB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5.w,
            height: 125.h,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tu Camino\nVocacional',
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w900,
                    color: darkText,
                    height: 1.0,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Completa el test de habilidades para desbloquear nuevas recomendaciones.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.games.path),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 11.h,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      'Continuar ahora',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 82.w,
            height: 82.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 9,
                  backgroundColor: const Color(0xFFEDEAFB),
                  color: primaryColor,
                ),
                Text(
                  '${(percent * 100).round()}%',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 15.sp,
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

  Widget _smallResumeCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: darkText,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAccessCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.13),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: color, size: 26.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: darkText,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11.sp,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      currentIndex: 0,
      selectedFontSize: 10.sp,
      unselectedFontSize: 10.sp,
      onTap: (index) {
        if (index == 1) context.push(AppRoutes.chat.path);
        if (index == 2) context.push(AppRoutes.games.path);
        if (index == 3) context.push(AppRoutes.vocationalResults.path);
        if (index == 4) context.push(AppRoutes.studentProfile.path);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy_outlined),
          label: 'Asistente IA',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_esports_outlined),
          label: 'Minijuegos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          label: 'Resultados',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }
}