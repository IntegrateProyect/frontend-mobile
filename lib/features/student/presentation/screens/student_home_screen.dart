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

  final PageController _careerController = PageController(viewportFraction: 1);
  int _currentCareer = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StudentHomeProvider>().loadHomeData();
    });
  }

  @override
  void dispose() {
    _careerController.dispose();
    super.dispose();
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  void _showAccountOptions(StudentHomeProvider homeProvider) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    final profile = homeProvider.profile;

    final name = user?.name?.trim().isNotEmpty == true
        ? user!.name!
        : profile?.name ?? 'Estudiante';

    final email = user?.email.trim().isNotEmpty == true
        ? user!.email
        : profile?.email ?? 'Sin correo';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 28.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
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
                        color: primaryColor,
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
                              color: darkText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
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
                _registrationInfoItem(
                  icon: Icons.badge_outlined,
                  label: 'Nombre',
                  value: name,
                ),
                _registrationInfoItem(
                  icon: Icons.email_outlined,
                  label: 'Correo',
                  value: email,
                ),
                _registrationInfoItem(
                  icon: Icons.school_outlined,
                  label: 'Tipo de cuenta',
                  value: 'Estudiante',
                ),
                _registrationInfoItem(
                  icon: Icons.groups_2_outlined,
                  label: 'Grupo escolar',
                  value: homeProvider.hasGroup
                      ? homeProvider.currentGroupName
                      : 'Sin grupo asignado',
                ),
                _registrationInfoItem(
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
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await authProvider.logout();
                    if (mounted) context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registrationInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 22.sp),
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
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: darkText,
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
            onPressed: () => _showAccountOptions(provider),
          ),
        ],
      ),
      body: provider.isLoading && provider.profile == null
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _buildBody(provider),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00A6A6),
        elevation: 8,
        onPressed: () => context.push(AppRoutes.chat.path),
        child: const Icon(
          Icons.smart_toy_rounded,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBody(StudentHomeProvider provider) {
    return RefreshIndicator(
      color: primaryColor,
      onRefresh: provider.loadHomeData,
      child: ListView(
        padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 26.h),
        children: [
          _buildGreeting(),
          SizedBox(height: 18.h),
          _buildExpoCard(),
          SizedBox(height: 16.h),
          _buildRecommendationsCard(),
          SizedBox(height: 16.h),
          _buildCareerCarousel(),
          SizedBox(height: 18.h),
          Text(
            'Accesos rápidos',
            style: TextStyle(
              color: darkText,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.85,
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

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡Hola, Estudiante! 👋',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w900,
            color: darkText,
            height: 1.05,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'Tu futuro comienza hoy.',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildExpoCard() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF24106B), Color(0xFF5D35F2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
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
                  'Expo\nUniversidades',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Conoce carreras, becas y universidades compatibles con tu perfil.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12.sp,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 14.h),
                InkWell(
                  onTap: () => _showSnack('Expo universidades próximamente'),
                  borderRadius: BorderRadius.circular(18.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 9.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Explorar expo',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: primaryColor,
                          size: 17.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 88.w,
            height: 88.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_rounded,
              color: Colors.white,
              size: 52.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4D8),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: const Color(0xFFFFB000),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recomendaciones para ti',
                      style: TextStyle(
                        color: darkText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Acciones sugeridas para avanzar en tu camino.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _recommendationItem(
            icon: Icons.school_outlined,
            title: 'Carreras sugeridas',
            text: 'Descubre opciones según tus resultados vocacionales.',
            color: const Color(0xFFE84A8A),
          ),
          SizedBox(height: 10.h),
          _recommendationItem(
            icon: Icons.account_balance_outlined,
            title: 'Universidades compatibles',
            text: 'Encuentra instituciones que ofrecen carreras relacionadas.',
            color: const Color(0xFF4285F4),
          ),
        ],
      ),
    );
  }

  Widget _recommendationItem({
    required IconData icon,
    required String title,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: color, size: 25.sp),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: darkText,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10.5.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_right_rounded,
              color: color,
              size: 25.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerCarousel() {
    final items = [
      _CareerSlide(
        image: 'assets/images/recomendacion1.jpg',
        percent: '95% compatible',
        title: 'Ingeniería en Inteligencia Artificial',
        tags: '#Tech  #Futuro',
      ),
      _CareerSlide(
        image: 'assets/images/recomendacion2.jpg',
        percent: '88% compatible',
        title: 'Diseño de Experiencia Usuario (UX)',
        tags: '#Creativo  #Digital',
      ),
      _CareerSlide(
        image: 'assets/images/recomendacion3.jpg',
        percent: '82% compatible',
        title: 'Ingeniería en Software',
        tags: '#Código  #Innovación',
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 150.h,
          child: PageView.builder(
            controller: _careerController,
            itemCount: items.length,
            onPageChanged: (index) {
              setState(() {
                _currentCareer = index;
              });
            },
            itemBuilder: (context, index) => _careerCard(items[index]),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: _currentCareer == index ? 18.w : 7.w,
              height: 7.h,
              decoration: BoxDecoration(
                color:
                _currentCareer == index ? primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _careerCard(_CareerSlide item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              item.image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF311B92), Color(0xFF4285F4)],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 14.h,
            left: 14.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                item.percent,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 15.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  item.tags,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 11.sp,
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

  Widget _quickAccessCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(icon, color: color, size: 25.sp),
            ),
            SizedBox(width: 10.w),
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
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10.sp,
                      height: 1.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
              size: 22.sp,
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
        if (index == 1) context.push(AppRoutes.games.path);
        if (index == 2) context.push(AppRoutes.vocationalResults.path);
        if (index == 3) context.push(AppRoutes.studentProfile.path);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
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

class _CareerSlide {
  final String image;
  final String percent;
  final String title;
  final String tags;

  _CareerSlide({
    required this.image,
    required this.percent,
    required this.title,
    required this.tags,
  });
}