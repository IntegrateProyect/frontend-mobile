import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../university/domain/entities/university_entity.dart';
import '../components/common/student_ui_colors.dart';

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
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 24.h,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(),
                  SizedBox(height: 32.h),
                  _buildSectionTitle(
                    'Oferta académica',
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

  Widget _buildSliverAppBar(
      BuildContext context,
      ) {
    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      backgroundColor:
      StudentUiColors.primary,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          // StackPosition no existe.
          // El valor correcto es StackFit.expand.
          fit: StackFit.expand,
          children: [
            if (university.logoUrl != null &&
                university.logoUrl!
                    .trim()
                    .isNotEmpty)
              Image.network(
                university.logoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return _buildDefaultHeader();
                },
              )
            else
              _buildDefaultHeader(),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin:
                  Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(
                      0.60,
                    ),
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

  Widget _buildDefaultHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            StudentUiColors.primary,
            Color(0xFF5B3FC4),
          ],
        ),
      ),
      child: const Icon(
        Icons.account_balance,
        size: 80,
        color: Colors.white54,
      ),
    );
  }

  Widget _buildMainInfo() {
    final String location =
    university.location.trim().isEmpty
        ? 'Ubicación no disponible'
        : university.location.trim();

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                university.name.trim().isEmpty
                    ? 'Universidad sin nombre'
                    : university.name.trim(),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color:
                  StudentUiColors.darkText,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            _buildStatusBadge(),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 18.sp,
              color: StudentUiColors.primary,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                location,
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

  Widget _buildStatusBadge() {
    final bool isRegistered =
        university.isRegistered;

    final Color foregroundColor =
    isRegistered
        ? const Color(0xFF15803D)
        : const Color(0xFFC2410C);

    final Color backgroundColor =
    isRegistered
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFFFF7ED);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
        BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRegistered
                ? Icons.verified_rounded
                : Icons.inventory_2_outlined,
            color: foregroundColor,
            size: 13.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            isRegistered
                ? 'ORIENTATE+'
                : 'RENOES',
            style: TextStyle(
              color: foregroundColor,
              fontSize: 9.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
      String title,
      ) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w800,
        color: StudentUiColors.darkText,
      ),
    );
  }

  Widget _buildCareersList() {
    if (university.careers.isNotEmpty) {
      return Column(
        children: university.careers
            .map(_buildCareerCard)
            .toList(),
      );
    }

    if (university
        .availableCareers.isNotEmpty) {
      return Column(
        children: university
            .availableCareers
            .map(_buildLegacyCareerCard)
            .toList(),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius:
        BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Text(
          'No se encontraron carreras disponibles en este momento.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildCareerCard(
      UniversityCareerEntity career,
      ) {
    final NumberFormat currencyFormat =
    NumberFormat.currency(
      symbol: r'$',
      decimalDigits: 0,
    );

    final String modality =
    career.modality.trim().isEmpty
        ? 'Modalidad no disponible'
        : career.modality.trim();

    final String duration =
    career.duration.trim().isEmpty
        ? 'Duración no disponible'
        : career.duration.trim();

    final String description =
    career.description.trim().isEmpty
        ? 'Sin descripción disponible.'
        : career.description.trim();

    return Container(
      margin: EdgeInsets.only(
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18.r),
        border: Border.all(
          color: const Color(0xFFEDEEF4),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          // ExpansionTile utiliza tilePadding.
          // contentPadding pertenece a ListTile.
          tilePadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          leading: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color:
              const Color(0xFFF0EFFF),
              borderRadius:
              BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: StudentUiColors.primary,
            ),
          ),
          title: Text(
            career.name.trim().isEmpty
                ? 'Carrera sin nombre'
                : career.name.trim(),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: StudentUiColors.darkText,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(
              top: 6.h,
            ),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: [
                _badge(modality),
                _badge(duration),
              ],
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                16.w,
                0,
                16.w,
                16.h,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  SizedBox(height: 8.h),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),

                  if (career.location
                      .trim()
                      .isNotEmpty) ...[
                    SizedBox(height: 14.h),
                    _buildCareerInformation(
                      icon:
                      Icons.location_on_outlined,
                      label: 'Ubicación',
                      value:
                      career.location.trim(),
                    ),
                  ],

                  if (career.admissionDates
                      .trim()
                      .isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    _buildCareerInformation(
                      icon:
                      Icons.event_available_outlined,
                      label:
                      'Fechas de admisión',
                      value: career
                          .admissionDates
                          .trim(),
                    ),
                  ],

                  SizedBox(height: 16.h),

                  Wrap(
                    spacing: 12.w,
                    runSpacing: 10.h,
                    crossAxisAlignment:
                    WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding:
                        EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF5F3FF,
                          ),
                          borderRadius:
                          BorderRadius.circular(
                            12.r,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              'Costo aproximado',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color:
                                Colors.grey[600],
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              career.costApprox ==
                                  null
                                  ? 'No disponible'
                                  : currencyFormat
                                  .format(
                                career
                                    .costApprox,
                              ),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight:
                                FontWeight.w900,
                                color:
                                StudentUiColors
                                    .primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (career
                          .scholarshipAvailable)
                        Container(
                          padding:
                          EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                            const Color(
                              0xFFDCFCE7,
                            ),
                            borderRadius:
                            BorderRadius.circular(
                              12.r,
                            ),
                          ),
                          child: Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.stars_rounded,
                                size: 15.sp,
                                color:
                                const Color(
                                  0xFF15803D,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'Beca disponible',
                                style: TextStyle(
                                  color:
                                  const Color(
                                    0xFF15803D,
                                  ),
                                  fontSize: 10.sp,
                                  fontWeight:
                                  FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegacyCareerCard(
      String careerName,
      ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: 12.h,
      ),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFEDEEF4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color:
              const Color(0xFFF0EFFF),
              borderRadius:
              BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: StudentUiColors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              careerName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color:
                StudentUiColors.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerInformation({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17.sp,
          color: StudentUiColors.primary,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 11.sp,
                height: 1.3,
              ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _badge(
      String label,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius:
        BorderRadius.circular(7.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.grey[600],
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}