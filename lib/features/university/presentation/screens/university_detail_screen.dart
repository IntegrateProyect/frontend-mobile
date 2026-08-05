import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/university_entity.dart';
import '../../../student/presentation/components/common/student_ui_colors.dart';

class UniversityDetailScreen extends StatelessWidget {
  final UniversityEntity university;

  const UniversityDetailScreen({
    super.key,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(),
                  SizedBox(height: 32.h),
                  const Text(
                    'Oferta Académica',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildCareersList(),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      backgroundColor: StudentUiColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (university.logoUrl != null && university.logoUrl!.isNotEmpty)
              Image.network(
                university.logoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: StudentUiColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.account_balance, size: 80, color: Colors.white),
                ),
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [StudentUiColors.primary, Color(0xFF5B3FC4)],
                  ),
                ),
                child: const Icon(Icons.account_balance, size: 80, color: Colors.white54),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                university.name,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color: StudentUiColors.darkText,
                ),
              ),
            ),
            if (university.isRegistered)
              Container(
                margin: EdgeInsets.only(left: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFFFEDD5)),
                ),
                child: Text(
                  'RENOES',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(Icons.location_on_rounded, size: 18.sp, color: StudentUiColors.primary),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                university.location,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCareersList() {
    if (university.careers.isEmpty) {
      return const Center(child: Text('No hay carreras disponibles.'));
    }

    final currencyFormat = NumberFormat.simpleCurrency(decimalDigits: 0);

    return Column(
      children: university.careers.map((career) {
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: ListTile(
            title: Text(career.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(career.modality.isEmpty ? 'Presencial' : career.modality),
            trailing: Text(
              career.costApprox != null 
                ? currencyFormat.format(career.costApprox)
                : 'Consultar costo',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: StudentUiColors.primary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
