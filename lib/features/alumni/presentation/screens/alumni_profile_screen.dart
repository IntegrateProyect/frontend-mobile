import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../components/alumni_header.dart';
import '../components/alumni_info_tile.dart';

class AlumniProfileScreen extends StatelessWidget {
  const AlumniProfileScreen({super.key});

  static const Color primaryColor = Color(0xFF311B92);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          const AlumniHeader(
            name: 'Carlos Mendoza',
            subtitle: 'Ingeniería de Software • Egresado',
            isVerified: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  _buildStatsRow(),
                  SizedBox(height: 32.h),
                  _buildProfileCard(),
                  SizedBox(height: 32.h),
                  _buildActions(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('12', 'Historias'),
        _buildStatItem('4.5k', 'Vistas'),
        _buildStatItem('156', 'Impacto'),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información Profesional',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1D1B4B),
            ),
          ),
          SizedBox(height: 16.h),
          const AlumniInfoTile(
            icon: Icons.work_outline_rounded,
            label: 'Puesto Actual',
            value: 'Senior Developer en Google',
          ),
          const AlumniInfoTile(
            icon: Icons.business_outlined,
            label: 'Empresa',
            value: 'Google Cloud Platform',
          ),
          const AlumniInfoTile(
            icon: Icons.history_edu_rounded,
            label: 'Generación',
            value: '2015 - 2020',
          ),
          const AlumniInfoTile(
            icon: Icons.email_outlined,
            label: 'Contacto',
            value: 'carlos.m@google.com',
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: Size.fromHeight(56.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            elevation: 0,
          ),
          child: Text('Editar Perfil', 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
        ),
        SizedBox(height: 12.h),
        TextButton(
          onPressed: () {},
          child: Text(
            'Cerrar Sesión',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
