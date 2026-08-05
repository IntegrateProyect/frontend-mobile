import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/vocational_result_entity.dart';
import '../common/student_ui_colors.dart';
import 'riasec_score_row.dart';

class RiasecOverviewCard extends StatelessWidget {
  final VocationalResultEntity result;

  const RiasecOverviewCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final scores = <MapEntry<String, double>>[];

    for (final letter in const [
      'R',
      'I',
      'A',
      'S',
      'E',
      'C',
    ]) {
      scores.add(
        MapEntry(
          letter,
          _normalizeScore(result.scores[letter] ?? 0),
        ),
      );
    }

    final rankedScores =
        List<MapEntry<String, double>>.from(scores)
          ..sort((a, b) => b.value.compareTo(a.value));

    final dominant = rankedScores
        .take(3)
        .map((item) => item.key)
        .join('');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFE8E6F2),
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
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6D28D9),
                      Color(0xFF4338CA),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: const Icon(
                  Icons.radar_rounded,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tus resultados vocacionales',
                      style: TextStyle(
                        color: StudentUiColors.darkText,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Puntuaciones reales obtenidas en tus actividades.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11.sp,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              if (dominant.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 11.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1ECFF),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    dominant,
                    style: TextStyle(
                      color: StudentUiColors.primary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 22.h),
          ...scores.map(
            (item) => RiasecScoreRow(
              letter: item.key,
              score: item.value,
            ),
          ),
        ],
      ),
    );
  }

  double _normalizeScore(dynamic value) {
    final raw = value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '') ?? 0;

    if (raw > 1 && raw <= 100) {
      return (raw / 100)
          .clamp(0.0, 1.0)
          .toDouble();
    }

    return raw.clamp(0.0, 1.0).toDouble();
  }
}
