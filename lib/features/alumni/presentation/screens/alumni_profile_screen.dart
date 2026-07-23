import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../components/alumni_header.dart';
import '../components/alumni_info_tile.dart';
import '../providers/alumni_home_provider.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';

class AlumniProfileScreen extends StatelessWidget {
  const AlumniProfileScreen({super.key});

  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlumniHomeProvider>();
    final profile = provider.profile;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          AlumniHeader(
            name: profile?.name ?? 'Egresado',
            subtitle: '${profile?.degree ?? 'Carrera'} • Egresado',
            isVerified: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(24.r),
              child: Column(
                children: [
                  _buildStatsRow(),
                  SizedBox(height: 28.h),
                  _buildProfileCard(profile),
                  SizedBox(height: 32.h),
                  _buildActions(context),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('12', 'Historias'),
          _buildDivider(),
          _buildStatItem('4.5k', 'Vistas'),
          _buildDivider(),
          _buildStatItem('156', 'Impacto'),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(width: 1, height: 30.h, color: const Color(0xFFF1F5F9));

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: _primaryColor, letterSpacing: -0.5),
        ),
        Text(
          label.toUpperCase(),
          style: TextStyle(fontSize: 10.sp, color: Colors.grey[400], fontWeight: FontWeight.w800, letterSpacing: 1.0),
        ),
      ],
    );
  }

  Widget _buildProfileCard(dynamic profile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información Profesional',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: _accentColor, letterSpacing: -0.5),
          ),
          SizedBox(height: 20.h),
          AlumniInfoTile(
            icon: Icons.work_outline_rounded,
            label: 'Puesto Actual',
            value: profile?.currentJob ?? 'No especificado',
          ),
          _buildItemDivider(),
          AlumniInfoTile(
            icon: Icons.business_outlined,
            label: 'Empresa',
            value: profile?.company ?? 'No especificada',
          ),
          _buildItemDivider(),
          AlumniInfoTile(
            icon: Icons.history_edu_rounded,
            label: 'Año de Graduación',
            value: profile?.graduationYear?.toString() ?? 'N/A',
          ),
          _buildItemDivider(),
          AlumniInfoTile(
            icon: Icons.email_outlined,
            label: 'Contacto Institucional',
            value: profile?.email ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildItemDivider() => Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Divider(color: const Color(0xFFF8FAFF), thickness: 1.5),
  );

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(color: _primaryColor.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              minimumSize: Size.fromHeight(56.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              elevation: 0,
            ),
            child: Text('Editar mi Perfil', 
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp, letterSpacing: 0.2)),
          ),
        ),
        SizedBox(height: 16.h),
        TextButton(
          onPressed: () async {
            await context.read<AuthProvider>().logout();
            if (context.mounted) context.go('/login');
          },
          child: Text(
            'Cerrar Sesión',
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}
