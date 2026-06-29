import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../providers/student_home_provider.dart';
import '../../../../core/routes/AppRoutes.dart';

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

  void _showJoinGroupDialog(StudentHomeProvider provider) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isJoining = false;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text('Unirme a grupo'),
              content: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Código del grupo',
                  hintText: 'Ej. INV-69941',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isJoining
                      ? null
                      : () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isJoining
                      ? null
                      : () async {
                    setStateDialog(() {
                      isJoining = true;
                    });

                    final success =
                    await provider.joinGroupByCode(controller.text);

                    if (!mounted) return;

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Te uniste al grupo correctamente'
                              : provider.errorMessage ??
                              'No se pudo unir al grupo',
                        ),
                      ),
                    );
                  },
                  child: isJoining
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Unirme'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showGroupDetailsDialog(StudentHomeProvider provider) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.groups_2_outlined,
                color: Color(0xFF311B92),
              ),
              SizedBox(width: 8),
              Text('Mi grupo escolar'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nombre del grupo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                provider.currentGroupName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Código',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                provider.currentGroupCode,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF311B92),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _handleGroupTap(StudentHomeProvider provider) {
    if (provider.hasGroup) {
      _showGroupDetailsDialog(provider);
    } else {
      _showJoinGroupDialog(provider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentHomeProvider>();
    final profile = provider.profile;

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
            fontSize: 22.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.grey[700]),
            onPressed: () {},
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: CircleAvatar(
              radius: 19.r,
              backgroundColor: Colors.grey[200],
              backgroundImage: profile?.profileImageUrl != null &&
                  profile!.profileImageUrl!.isNotEmpty
                  ? NetworkImage(profile.profileImageUrl!)
                  : null,
              child: profile?.profileImageUrl == null ||
                  profile!.profileImageUrl!.isEmpty
                  ? Icon(Icons.person, color: Colors.grey[500])
                  : null,
            ),
          ),
        ],
      ),
      body: _buildBody(provider),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBody(StudentHomeProvider provider) {
    if (provider.isLoading && provider.profile == null) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    final totalGames = provider.availableGames.length;
    final totalResults = provider.results.length;

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: provider.loadHomeData,
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 28.h),
        children: [
          _buildHero(provider),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _buildMiniStat(
                  icon: Icons.sports_esports_outlined,
                  value: '$totalGames',
                  label: 'Juegos',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildMiniStat(
                  icon: Icons.bar_chart_rounded,
                  value: '$totalResults',
                  label: 'Resultados',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(22.r),
                  onTap: () => _handleGroupTap(provider),
                  child: _buildMiniStat(
                    icon: Icons.groups_2_outlined,
                    value: provider.hasGroup ? 'Sí' : 'No',
                    label: 'Grupo',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          Text(
            'Accesos rápidos',
            style: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w900,
              color: darkText,
            ),
          ),
          SizedBox(height: 14.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 1.08,
            children: [
              _buildActionTile(
                icon: Icons.psychology_outlined,
                title: 'Perfil',
                description: 'Edita tus intereses',
                color: const Color(0xFF6A4CFF),
                onTap: () => context.push(AppRoutes.studentProfile.path),
              ),
              _buildActionTile(
                icon: Icons.extension_outlined,
                title: 'Minijuegos',
                description: 'Descubre áreas',
                color: const Color(0xFF00A6A6),
                onTap: () => context.push(AppRoutes.games.path),
              ),
              _buildActionTile(
                icon: Icons.groups_2_outlined,
                title: 'Grupo',
                description: provider.hasGroup ? 'Ver grupo' : 'Unirme',
                color: const Color(0xFFFF8A00),
                onTap: () => _handleGroupTap(provider),
              ),
              _buildActionTile(
                icon: Icons.insights_outlined,
                title: 'Resultados',
                description: 'Ver avances',
                color: const Color(0xFFE84A8A),
                onTap: () => context.push(AppRoutes.vocationalResults.path),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          _buildWideCard(
            title: provider.hasGroup ? 'Grupo escolar' : 'Únete a tu grupo',
            description: provider.groupDescription,
            icon: Icons.school_outlined,
            buttonText: provider.hasGroup ? 'Ver grupo' : 'Ingresar código',
            onTap: () => _handleGroupTap(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(StudentHomeProvider provider) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF311B92), Color(0xFF6A4CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
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
                  '¡Hola, ${provider.firstName}! 👋',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.08,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Continúa tu orientación vocacional y descubre qué áreas van contigo.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.88),
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.games.path),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Text(
                      'Empezar ahora',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 14.w),
          Container(
            width: 82.w,
            height: 82.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rocket_launch_outlined,
              color: Colors.white,
              size: 42.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 25.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: darkText,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(26.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: color, size: 27.sp),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w900,
                color: darkText,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideCard({
    required String title,
    required String description,
    required IconData icon,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Row(
        children: [
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F0FF),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(icon, color: primaryColor, size: 30.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: darkText,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[700],
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: onTap,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
      selectedFontSize: 12.sp,
      unselectedFontSize: 12.sp,
      onTap: (index) {
        if (index == 1) context.push(AppRoutes.studentProfile.path);
        if (index == 2) context.push(AppRoutes.games.path);
        if (index == 3) context.push(AppRoutes.vocationalResults.path);
        if (index == 4) context.push(AppRoutes.studentProfile.path);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.psychology_outlined),
          label: 'Perfil',
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
          icon: Icon(Icons.account_circle_outlined),
          label: 'Cuenta',
        ),
      ],
    );
  }
}