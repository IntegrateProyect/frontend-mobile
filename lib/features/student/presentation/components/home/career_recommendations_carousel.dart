import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../common/student_ui_colors.dart';
import '../../providers/student_home_provider.dart';
import '../../../domain/entities/event_entity.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentHomeProvider>();
    final events = provider.events;
    final hasEvents = events.isNotEmpty;
    final int itemCount = hasEvents ? events.length : _mockCareers.length;

    return Column(
      children: [
        SizedBox(
          height: 150.h,
          child: PageView.builder(
            controller: _controller,
            itemCount: itemCount,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              if (hasEvents) {
                final event = events[index];
                return GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.events.path);
                  },
                  child: _EventSlide(event: event),
                );
              } else {
                return _CareerSlide(item: _mockCareers[index]);
              }
            },
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            itemCount,
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