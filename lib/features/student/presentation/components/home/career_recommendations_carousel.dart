import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../common/student_ui_colors.dart';
import '../../providers/student_announcements_provider.dart';
import '../../../../university/domain/entities/university_announcement_entity.dart';

class CareerRecommendationsCarousel extends StatefulWidget {
  const CareerRecommendationsCarousel({super.key});

  @override
  State<CareerRecommendationsCarousel> createState() =>
      _CareerRecommendationsCarouselState();
}

class _CareerRecommendationsCarouselState
    extends State<CareerRecommendationsCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAnnouncementDetails(BuildContext context, UniversityAnnouncementEntity announcement) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1A1B2E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (ctx) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: Image.network(
                    announcement.imageUrl!,
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF311B92).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      announcement.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFF311B92),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                announcement.title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF1D1B4B),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                announcement.description,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.6,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentAnnouncementsProvider>();
    final announcements = provider.announcements;
    final hasAnnouncements = announcements.isNotEmpty;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anuncios y Convocatorias',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : StudentUiColors.darkText,
          ),
        ),
        SizedBox(height: 12.h),
        if (!hasAnnouncements)
          const _EmptyAnnouncementsCard()
        else ...[
          SizedBox(
            height: 150.h,
            child: PageView.builder(
              controller: _controller,
              itemCount: announcements.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return GestureDetector(
                  onTap: () => _showAnnouncementDetails(context, announcement),
                  child: _AnnouncementSlide(announcement: announcement),
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              announcements.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: _currentIndex == index ? 18.w : 7.w,
                height: 7.h,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? StudentUiColors.primary
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AnnouncementSlide extends StatelessWidget {
  final UniversityAnnouncementEntity announcement;

  const _AnnouncementSlide({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: (announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty)
                ? Image.network(
                    announcement.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildGradientBackground(),
                  )
                : _buildGradientBackground(),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.10),
                    Colors.black.withOpacity(0.80),
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
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF311B92).withOpacity(0.85),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                announcement.category.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                ),
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
                  announcement.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  announcement.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
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

  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF311B92),
            Color(0xFF1D1B4B),
          ],
        ),
      ),
    );
  }
}

class _EmptyAnnouncementsCard extends StatelessWidget {
  const _EmptyAnnouncementsCard();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F38) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: isDark ? Border.all(color: const Color(0xFF2E305C)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2E2452) : const Color(0xFFF3E5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.campaign_rounded,
              color: isDark ? const Color(0xFFB59AFF) : const Color(0xFF7B1FA2),
              size: 32.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Sin anuncios disponibles',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1D1B4B),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Te notificaremos cuando las universidades o tu orientador publiquen nuevas convocatorias o becas.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
