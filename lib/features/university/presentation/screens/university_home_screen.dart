import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../providers/university_careers_provider.dart';
import '../providers/university_events_provider.dart';
import '../providers/university_alumni_provider.dart';
import '../components/university_bottom_navigation_bar.dart';

class UniversityHomeScreen extends StatefulWidget {
  const UniversityHomeScreen({super.key});

  @override
  State<UniversityHomeScreen> createState() => _UniversityHomeScreenState();
}

class _UniversityHomeScreenState extends State<UniversityHomeScreen> {
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<UniversityCareersProvider>().fetchCareers();
        context.read<UniversityEventsProvider>().fetchEvents();
        context.read<UniversityAlumniProvider>().fetchAlumni();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final String universityName = (user?.universityName != null && user!.universityName!.isNotEmpty)
        ? user.universityName!
        : (user?.name ?? 'Universidad Registrada');
    final String status = user?.verificationStatus ?? 'UNVERIFIED';

    final careersProvider = context.watch<UniversityCareersProvider>();
    final eventsProvider = context.watch<UniversityEventsProvider>();
    final alumniProvider = context.watch<UniversityAlumniProvider>();

    final int careersCount = careersProvider.careers.length;
    final int eventsCount = eventsProvider.events.length;
    final int alumniCount = alumniProvider.alumni.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 50.h,
        title: Text(
          'Dashboard Universidad',
          style: TextStyle(
            color: _accentColor,
            fontWeight: FontWeight.w900,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
            ),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) context.go('/login');
            },
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstitutionalHeader(universityName, status),
            if (status == 'UNVERIFIED') ...[
              SizedBox(height: 12.h),
              _buildVerificationBanner(context),
            ],
            SizedBox(height: 18.h),
            _buildSectionHeader('Resumen de Alcance'),
            SizedBox(height: 8.h),
            _buildReachSummary(alumniCount, careersCount, eventsCount),
            SizedBox(height: 18.h),
            _buildSectionHeader(
              'Egresados Destacados', 
              actionLabel: 'Ver todos', 
              onAction: () => context.push(AppRoutes.manageAlumni.path)
            ),
            SizedBox(height: 8.h),
            _buildAlumniCarousel(alumniProvider),
            SizedBox(height: 18.h),
            _buildSectionHeader('Próximos Eventos'),
            SizedBox(height: 8.h),
            _buildUpcomingEventCard(context, eventsProvider),
            SizedBox(height: 18.h),
            _buildSectionHeader('Gestión Institucional'),
            SizedBox(height: 8.h),
            _buildManagementGrid(context),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      bottomNavigationBar: const UniversityBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildSectionHeader(String title, {String? actionLabel, VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp, 
            fontWeight: FontWeight.w900, 
            color: _accentColor,
            letterSpacing: -0.4,
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: _primaryColor,
            ),
            child: Text(actionLabel, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.sp)),
          ),
      ],
    );
  }

  Widget _buildInstitutionalHeader(String universityName, String status) {
    final bool isVerified = status == 'VERIFIED';
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02), 
            blurRadius: 8, 
            offset: const Offset(0, 2)
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.06), 
              borderRadius: BorderRadius.circular(12.r)
            ),
            child: const Icon(Icons.account_balance_rounded, color: _primaryColor, size: 24),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  universityName, 
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: _accentColor, height: 1.1)
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isVerified ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isVerified ? Icons.verified_rounded : Icons.info_outline_rounded, 
                        size: 11.sp, 
                        color: isVerified ? Colors.green[800] : Colors.amber[900]
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        isVerified ? 'VERIFICADO' : 'UNVERIFIED', 
                        style: TextStyle(
                          fontSize: 8.5.sp, 
                          fontWeight: FontWeight.w900, 
                          color: isVerified ? Colors.green[800] : Colors.amber[900]
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF311B92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars_rounded, color: Colors.white, size: 16),
              SizedBox(width: 6.w),
              Text(
                'Impulsa tu presencia', 
                style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w900)
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Solicita tu verificación RENOES para destacar ante los aspirantes.',
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11.sp, height: 1.2)
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            height: 34.h,
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.universityVerification.path),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                foregroundColor: _primaryColor,
                elevation: 0, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.zero,
              ),
              child: Text('Solicitar Verificación', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.sp)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReachSummary(int alumniCount, int careersCount, int eventsCount) {
    return Row(
      children: [
        Expanded(child: _buildKpiCard(alumniCount.toString(), 'Egresados', Icons.people_alt_rounded, const Color(0xFF8B5CF6))),
        SizedBox(width: 8.w),
        Expanded(child: _buildKpiCard(careersCount.toString(), 'Carreras', Icons.school_rounded, const Color(0xFF3B82F6))),
        SizedBox(width: 8.w),
        Expanded(child: _buildKpiCard(eventsCount.toString(), 'Eventos', Icons.event_available_rounded, const Color(0xFF10B981))),
      ],
    );
  }

  Widget _buildKpiCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 14.sp),
          ),
          SizedBox(height: 8.h),
          Text(value, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: _accentColor)),
          Text(label, style: TextStyle(fontSize: 8.5.sp, color: Colors.grey[500], fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildAlumniCarousel(UniversityAlumniProvider alumniProvider) {
    if (alumniProvider.isLoading) {
      return SizedBox(
        height: 100.h,
        child: const Center(child: CircularProgressIndicator(color: _primaryColor)),
      );
    }

    final alumniList = alumniProvider.alumni;

    if (alumniList.isEmpty) {
      return Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            Icon(Icons.badge_outlined, color: Colors.purple.shade200, size: 24),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sin egresados registrados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp)),
                  Text('Registra a tus egresados destacados.', style: TextStyle(color: Colors.grey, fontSize: 9.5.sp)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: alumniList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final alumni = alumniList[index];
          final String name = alumni.name.isNotEmpty ? alumni.name : 'Egresado';
          final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'E';

          return Container(
            width: 190.w,
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: _primaryColor.withOpacity(0.08),
                      child: Text(
                        initial, 
                        style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 11.sp)
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, 
                            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w900, color: _accentColor),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('Clase ${alumni.graduationYear}', 
                            style: TextStyle(fontSize: 8.5.sp, color: Colors.grey[400], fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  alumni.currentJob, 
                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w800, color: _accentColor), 
                  maxLines: 1, overflow: TextOverflow.ellipsis
                ),
                Text(
                  alumni.company, 
                  style: TextStyle(fontSize: 9.sp, color: _primaryColor, fontWeight: FontWeight.w900)
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingEventCard(BuildContext context, UniversityEventsProvider eventsProvider) {
    if (eventsProvider.isLoading) {
      return SizedBox(
        height: 60.h,
        child: const Center(child: CircularProgressIndicator(color: _primaryColor)),
      );
    }

    final events = eventsProvider.events;

    if (events.isEmpty) {
      return Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            const Icon(Icons.event_busy_rounded, color: Colors.grey, size: 24),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sin eventos programados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp)),
                  Text('Publica ferias para conectar.', style: TextStyle(color: Colors.grey, fontSize: 9.5.sp)),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.manageEvents.path),
              style: TextButton.styleFrom(
                foregroundColor: _primaryColor,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
              ),
              child: Text('Crear', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
    }

    final upcomingEvent = events.first;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(12.r)),
            child: const Icon(Icons.event_note_rounded, color: Color(0xFF16A34A), size: 20),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  upcomingEvent.title, 
                  style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w900, color: _accentColor, height: 1.1)
                ),
                SizedBox(height: 2.h),
                Text(
                  '${upcomingEvent.date.day}/${upcomingEvent.date.month}/${upcomingEvent.date.year}', 
                  style: TextStyle(fontSize: 10.5.sp, color: Colors.grey[500], fontWeight: FontWeight.w600)
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.event_available_outlined, size: 10, color: Color(0xFF16A34A)),
                      SizedBox(width: 4.w),
                      Text(
                        'Evento Publicado', 
                        style: TextStyle(fontSize: 8.5.sp, color: const Color(0xFF15803D), fontWeight: FontWeight.w800)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.3,
      children: [
        _buildActionCard(context, 'Oferta Académica', 'Gestionar carreras', Icons.school, AppRoutes.manageCareers.path, const Color(0xFFF0FDF4), Colors.green),
        _buildActionCard(context, 'Eventos', 'Publicar ferias', Icons.calendar_month, AppRoutes.manageEvents.path, const Color(0xFFEFF6FF), Colors.blue),
        _buildActionCard(context, 'Anuncios', 'Comunicados/Becas', Icons.campaign, AppRoutes.manageAnnouncements.path, const Color(0xFFFFF7ED), Colors.orange),
        _buildActionCard(context, 'Egresados', 'Administrar graduados', Icons.card_membership, AppRoutes.manageAlumni.path, const Color(0xFFFAF5FF), Colors.purple),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, String path, Color bg, Color iconColor) {
    return InkWell(
      onTap: () => context.push(path),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(16.r), 
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8.r)),
              child: Icon(icon, color: iconColor, size: 18.sp),
            ),
            const Spacer(),
            Text(title, style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w900, color: _accentColor, height: 1.1)),
            SizedBox(height: 2.h),
            Text(
              subtitle, 
              style: TextStyle(fontSize: 8.5.sp, color: Colors.grey[400], fontWeight: FontWeight.w700, height: 1.05),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
