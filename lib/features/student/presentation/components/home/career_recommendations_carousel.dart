import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../common/student_ui_colors.dart';
import '../../providers/student_home_provider.dart';
import '../../../domain/entities/event_entity.dart';
import 'package:orientate/core/routes/AppRoutes.dart';
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

  static const List<_CareerSlideData> _mockCareers = [
    _CareerSlideData(
      image: 'assets/images/recomendacion1.jpg',
      percent: '95% compatible',
      title: 'Ingeniería en Inteligencia Artificial',
      tags: '#Tech  #Futuro',
    ),
    _CareerSlideData(
      image: 'assets/images/recomendacion2.jpg',
      percent: '88% compatible',
      title: 'Diseño de Experiencia Usuario (UX)',
      tags: '#Creativo  #Digital',
    ),
    _CareerSlideData(
      image: 'assets/images/recomendacion3.jpg',
      percent: '82% compatible',
      title: 'Ingeniería en Software',
      tags: '#Código  #Innovación',
    ),
  ];

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
    final provider = context.watch<StudentHomeProvider>();
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

class _EventSlide extends StatelessWidget {
  final EventEntity event;

  const _EventSlide({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM').format(event.date);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: event.description.contains('http') || (event.description.length > 10 && event.description.startsWith('http')) 
                ? Image.network(
                    event.description, // some mockups put URL in description or location
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
                color: StudentUiColors.primary.withOpacity(0.85),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                'Evento • $dateStr',
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
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  event.location,
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
            Color(0xFF5D35F2),
            Color(0xFF24106B),
          ],
        ),
      ),
    );
  }
}

class _CareerSlide extends StatelessWidget {
  final _CareerSlideData item;

  const _CareerSlide({
    required this.item,
  });

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
            child: Image.asset(
              item.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        StudentUiColors.primary,
                        StudentUiColors.blue,
                      ],
                    ),
                  ),
                );
              },
            ),
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
                color: StudentUiColors.primary.withOpacity(0.85),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                item.percent,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12.h,
            right: 12.w,
            child: const Icon(
              Icons.favorite_border,
              color: Colors.white,
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
                  item.title,
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
                  item.tags,
                  style: TextStyle(
                    color: Colors.white,
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
}

class _CareerSlideData {
  final String image;
  final String percent;
  final String title;
  final String tags;

  const _CareerSlideData({
    required this.image,
    required this.percent,
    required this.title,
    required this.tags,
  });
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
        color: isDark ? const Color(0xFF1E1E2F) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
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
              color: isDark ? const Color(0xFF2C2C40) : const Color(0xFFF3E5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.campaign_rounded,
              color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF7B1FA2),
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