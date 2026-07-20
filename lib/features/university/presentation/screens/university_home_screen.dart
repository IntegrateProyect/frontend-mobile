import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../components/university_bottom_navigation_bar.dart';

class UniversityHomeScreen extends StatelessWidget {
  const UniversityHomeScreen({super.key});

  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  // --- MOCK DATA PARA MAQUETACIÓN ---
  static const List<Map<String, String>> _mockAlumni = [
    {
      'name': 'Juan Pérez',
      'job': 'Lead Software Engineer',
      'company': 'Google',
      'year': '2023',
    },
    {
      'name': 'María González',
      'job': 'Senior UX Designer',
      'company': 'Microsoft',
      'year': '2022',
    },
    {
      'name': 'Carlos Ruiz',
      'job': 'Data Scientist',
      'company': 'Amazon',
      'year': '2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final String status = user?.verificationStatus ?? 'UNVERIFIED';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstitutionalHeader(status),
            if (status == 'UNVERIFIED') ...[
              SizedBox(height: 14.h),
              _buildVerificationBanner(context),
            ],
            SizedBox(height: 22.h),
            _buildSectionHeader('Resumen de Alcance'),
            SizedBox(height: 10.h),
            _buildReachSummary(),
            SizedBox(height: 22.h),
            _buildSectionHeader(
              'Egresados Destacados', 
              actionLabel: 'Ver todos', 
              onAction: () => context.push(AppRoutes.manageAlumni.path)
            ),
            SizedBox(height: 10.h),
            _buildAlumniCarousel(),
            SizedBox(height: 22.h),
            _buildSectionHeader('Próximos Eventos'),
            SizedBox(height: 10.h),
            _buildUpcomingEventCard(),
            SizedBox(height: 22.h),
            _buildSectionHeader('Gestión Institucional'),
            SizedBox(height: 10.h),
            _buildManagementGrid(context),
            SizedBox(height: 30.h),
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
            fontSize: 16.sp, 
            fontWeight: FontWeight.w900, 
            color: _accentColor,
            letterSpacing: -0.5,
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
            child: Text(actionLabel, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.sp)),
          ),
      ],
    );
  }

  Widget _buildInstitutionalHeader(String status) {
    final bool isVerified = status == 'VERIFIED';
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.08), 
              borderRadius: BorderRadius.circular(14.r)
            ),
            child: const Icon(Icons.account_balance_rounded, color: _primaryColor, size: 28),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Universidad Tecnológica de Oaxaca', 
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: _accentColor, height: 1.2)
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: isVerified ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isVerified ? Icons.verified_rounded : Icons.info_outline_rounded, 
                        size: 12.sp, 
                        color: isVerified ? Colors.green[800] : Colors.amber[900]
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        isVerified ? 'VERIFICADO' : 'UNVERIFIED', 
                        style: TextStyle(
                          fontSize: 9.sp, 
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF311B92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8.w),
              Text(
                'Impulsa tu presencia', 
                style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w900)
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'Solicita tu verificación RENOES para destacar ante los aspirantes.',
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11.sp, height: 1.3)
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.universityVerification.path),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                foregroundColor: _primaryColor,
                elevation: 0, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                padding: EdgeInsets.zero,
              ),
              child: Text('Solicitar Verificación', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.sp)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReachSummary() {
    return Row(
      children: [
        Expanded(child: _buildKpiCard('245', 'Aspirantes', Icons.people_alt_rounded, const Color(0xFF8B5CF6))),
        SizedBox(width: 10.w),
        Expanded(child: _buildKpiCard('12', 'Carreras', Icons.school_rounded, const Color(0xFF3B82F6))),
        SizedBox(width: 10.w),
        Expanded(child: _buildKpiCard('4', 'Eventos', Icons.event_available_rounded, const Color(0xFF10B981))),
      ],
    );
  }

  Widget _buildKpiCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16.sp),
          ),
          SizedBox(height: 8.h),
          Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: _accentColor)),
          Text(label, style: TextStyle(fontSize: 9.sp, color: Colors.grey[500], fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildAlumniCarousel() {
    return SizedBox(
      height: 140.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _mockAlumni.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final alumni = _mockAlumni[index];
          return Container(
            width: 210.w,
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: _primaryColor.withOpacity(0.08),
                      child: Text(
                        alumni['name']![0], 
                        style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 12.sp)
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alumni['name']!, 
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900, color: _accentColor),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('Clase ${alumni['year']}', 
                            style: TextStyle(fontSize: 9.sp, color: Colors.grey[400], fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  alumni['job']!, 
                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: _accentColor), 
                  maxLines: 1, overflow: TextOverflow.ellipsis
                ),
                Text(
                  alumni['company']!, 
                  style: TextStyle(fontSize: 10.sp, color: _primaryColor, fontWeight: FontWeight.w900)
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingEventCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(14.r)),
            child: const Icon(Icons.event_note_rounded, color: Color(0xFF16A34A), size: 22),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feria Vocacional e Ingenierías 2026', 
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900, color: _accentColor, height: 1.2)
                ),
                SizedBox(height: 2.h),
                Text(
                  '25 de Julio, 2026 — 10:00 AM', 
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[500], fontWeight: FontWeight.w600)
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people_alt_outlined, size: 11, color: Color(0xFF16A34A)),
                      SizedBox(width: 4.w),
                      Text(
                        '38 Aspirantes confirmados', 
                        style: TextStyle(fontSize: 9.sp, color: const Color(0xFF15803D), fontWeight: FontWeight.w800)
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
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
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
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20.r), 
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10.r)),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            const Spacer(),
            Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900, color: _accentColor)),
            SizedBox(height: 2.h),
            Text(
              subtitle, 
              style: TextStyle(fontSize: 9.sp, color: Colors.grey[400], fontWeight: FontWeight.w700, height: 1.1),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
