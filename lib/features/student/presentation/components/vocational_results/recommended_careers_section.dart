import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/careers_provider.dart';
import '../common/student_ui_colors.dart';
import 'recommended_career_card.dart';
import 'recommendation_error_state.dart';
import 'recommendations_empty_state.dart';

class RecommendedCareersSection extends StatelessWidget {
  final CareersProvider provider;

  const RecommendedCareersSection({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark ? const Color(0xFF2E305C) : const Color(0xFFE8E6F2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carreras recomendadas',
                      style: TextStyle(
                        color: isDark ? Colors.white : StudentUiColors.darkText,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Ordenadas según tus resultados y factores personales.',
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey[600],
                        fontSize: 11.sp,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (provider.hasCareers)
                IconButton(
                  tooltip: 'Actualizar recomendaciones',
                  onPressed: provider.refresh,
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: isDark ? const Color(0xFFB59AFF) : StudentUiColors.primary,
                  ),
                ),
            ],
          ),
          SizedBox(height: 18.h),
          if (provider.isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 28.h),
              child: const Center(
                child: CircularProgressIndicator(
                  color: StudentUiColors.primary,
                ),
              ),
            )
          else if (provider.errorMessage != null)
            RecommendationErrorState(
              errorMessage: provider.errorMessage!,
              onRetry: () {
                provider.fetchRecommendedCareers(
                  topN: 5,
                  force: true,
                );
              },
            )
          else if (provider.careers.isEmpty)
            RecommendationsEmptyState(
              onGenerate: () {
                provider.fetchRecommendedCareers(
                  topN: 5,
                  force: true,
                );
              },
            )
          else
            ...provider.careers.asMap().entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key == provider.careers.length - 1 ? 0 : 12.h,
                    ),
                    child: RecommendedCareerCard(
                      position: entry.key + 1,
                      career: entry.value,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
