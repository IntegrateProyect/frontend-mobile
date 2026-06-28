import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../providers/student_profile_provider.dart';
import '../../../../core/routes/AppRoutes.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StudentProfileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProfileProvider>();
    final profile = provider.profile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Perfil Vocacional',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: provider.isLoading && profile == null
          ? const Center(
        child: CircularProgressIndicator(color: primaryColor),
      )
          : profile == null
          ? _buildEmptyState(provider)
          : RefreshIndicator(
        color: primaryColor,
        onRefresh: provider.fetchProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: profile.profileImageUrl != null &&
                              profile.profileImageUrl!.isNotEmpty
                              ? NetworkImage(profile.profileImageUrl!)
                              : null,
                          child: profile.profileImageUrl == null ||
                              profile.profileImageUrl!.isEmpty
                              ? Icon(
                            Icons.person,
                            size: 52.sp,
                            color: Colors.grey[500],
                          )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(5.w),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4285F4),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      profile.name.isNotEmpty ? profile.name : 'Estudiante',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: darkText,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _subtitle(profile.groupName),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              _buildSectionHeader(Icons.book_outlined, 'Materias favoritas'),
              SizedBox(height: 12.h),
              _buildChipList(
                profile.subjectsLiked,
                const Color(0xFFE3F2FD),
                Colors.blue,
                'Sin materias registradas',
              ),

              SizedBox(height: 24.h),

              _buildSectionHeader(Icons.block_outlined, 'Materias que no te gustan'),
              SizedBox(height: 12.h),
              _buildChipList(
                profile.subjectsDisliked,
                const Color(0xFFFFEBEE),
                Colors.redAccent,
                'Sin materias registradas',
              ),

              SizedBox(height: 24.h),

              _buildSectionHeader(Icons.favorite_border, 'Intereses'),
              SizedBox(height: 12.h),
              _buildChipList(
                profile.interests,
                const Color(0xFFF3E5F5),
                Colors.purple,
                'Sin intereses registrados',
              ),

              SizedBox(height: 24.h),

              _buildSectionHeader(Icons.lightbulb_outline, 'Habilidades'),
              SizedBox(height: 12.h),
              _buildChipList(
                profile.skills,
                const Color(0xFFE8F5E9),
                Colors.green,
                'Sin habilidades registradas',
              ),

              SizedBox(height: 32.h),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoBox(
                      Icons.school_outlined,
                      'BECA',
                      profile.needsScholarship ? 'Sí necesita' : 'No necesita',
                      Colors.purple,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildInfoBox(
                      Icons.flight_takeoff,
                      'EXTRANJERO',
                      profile.studyAbroad ? 'Le interesa' : 'No indicado',
                      Colors.blue,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              _buildVocationalClarity(profile.vocationalClarity),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  String _subtitle(String? groupName) {
    if (groupName != null && groupName.trim().isNotEmpty) {
      return 'Estudiante • $groupName';
    }
    return 'Estudiante • Sin grupo asignado';
  }

  Widget _buildEmptyState(StudentProfileProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, size: 60.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No se pudo cargar tu perfil',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: provider.fetchProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: primaryColor),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
      ],
    );
  }

  Widget _buildChipList(
      List<String> items,
      Color bgColor,
      Color textColor,
      String emptyText,
      ) {
    if (items.isEmpty) {
      return Text(
        emptyText,
        style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
      );
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: items.map((item) {
        return Chip(
          label: Text(
            item,
            style: TextStyle(
              color: textColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: bgColor,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoBox(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22.sp),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVocationalClarity(int clarity) {
    final value = (clarity.clamp(1, 10)) / 10;

    String label = 'Baja';
    if (clarity >= 7) label = 'Alta';
    if (clarity >= 4 && clarity < 7) label = 'Media';

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2E1A47),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Claridad vocacional',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 12.h,
              backgroundColor: Colors.white24,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1',
                style: TextStyle(color: Colors.white70, fontSize: 11.sp),
              ),
              Text(
                '$clarity / 10',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '10',
                style: TextStyle(color: Colors.white70, fontSize: 11.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      currentIndex: 1,
      selectedFontSize: 10.sp,
      unselectedFontSize: 10.sp,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go(AppRoutes.home.path);
            break;
          case 1:
            break;
          case 2:
            context.push(AppRoutes.games.path);
            break;
          case 3:
            context.push(AppRoutes.vocationalResults.path);
            break;
          case 4:
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.psychology_outlined), label: 'Perfil'),
        BottomNavigationBarItem(icon: Icon(Icons.sports_esports_outlined), label: 'Minijuegos'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Resultados'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Cuenta'),
      ],
    );
  }
}