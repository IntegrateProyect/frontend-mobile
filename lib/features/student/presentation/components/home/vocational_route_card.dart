import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VocationalRouteCard extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onChatTap;
  final VoidCallback onResultsTap;

  const VocationalRouteCard({
    super.key,
    required this.onTap,
    required this.onChatTap,
    required this.onResultsTap,
  });

  static const Color _darkPurple = Color(0xFF25106F);
  static const Color _darkText = Color(0xFF17164A);
  static const Color _green = Color(0xFF11A768);
  static const Color _blue = Color(0xFF1262D2);
  static const Color _teal = Color(0xFF08A8A8);
  static const Color _muted = Color(0xFF9095A8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27.r),
        border: Border.all(
          color: const Color(0xFFECEAF5),
        ),
        boxShadow: [
          BoxShadow(
            color: _darkPurple.withOpacity(0.08),
            blurRadius: 22,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27.r),
        child: Stack(
          children: [
            _buildHeader(),
            Padding(
              padding: EdgeInsets.only(top: 132.h),
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
      height: 164.h,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF25106F),
              Color(0xFF4020A9),
              Color(0xFF6738F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _VocationalHeaderPainter(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                21.w,
                18.h,
                16.w,
                25.h,
              ),
              child: SizedBox(
                width: 230.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mi ruta vocacional',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 11.h),
                    Text(
                      'Paso actual:',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.82),
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // PASO ACTUAL CORREGIDO
                    Text(
                      'Minijuegos vocacionales',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 11.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: Text(
                        '2 de 4 etapas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        14.w,
        16.h,
        14.w,
        15.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
          bottomLeft: Radius.circular(27.r),
          bottomRight: Radius.circular(27.r),
        ),
      ),
      child: Column(
        children: [
          _buildCompletedStep(),
          SizedBox(height: 10.h),
          _buildCurrentStep(),
          SizedBox(height: 12.h),
          _buildAdditionalSteps(),
        ],
      ),
    );
  }

  Widget _buildCompletedStep() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 11.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: const Color(0xFFE8ECEF),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F8F0),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: _green,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Text(
              'Perfil inicial',
              style: TextStyle(
                color: _darkText,
                fontSize: 14.2.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 9.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F8F0),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: _green,
                  size: 13.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Completado',
                  style: TextStyle(
                    color: _green,
                    fontSize: 9.5.sp,
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

  Widget _buildCurrentStep() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 11.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FBFF),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFFBDD7FA),
              width: 1.4,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.sports_esports_rounded,
                  color: _blue,
                  size: 23.sp,
                ),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minijuegos vocacionales',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _darkText,
                        fontSize: 14.2.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Paso actual',
                      style: TextStyle(
                        color: _blue,
                        fontSize: 10.2.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 7.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 11.w,
                  vertical: 7.h,
                ),
                decoration: BoxDecoration(
                  color: _blue,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Continuar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalSteps() {
    return Row(
      children: [
        Expanded(
          child: _buildSmallStep(
            number: '3',
            title: 'Chatbot',
            status: 'Disponible',
            icon: Icons.smart_toy_outlined,
            mainColor: _teal,
            backgroundColor: const Color(0xFFE7F8F7),
            onTap: onChatTap,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildSmallStep(
            number: '4',
            title: 'Resultados',
            status: 'Bloqueado',
            icon: Icons.bar_chart_rounded,
            mainColor: _muted,
            backgroundColor: const Color(0xFFF1F2F6),
            onTap: onResultsTap,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStep({
    required String number,
    required String title,
    required String status,
    required IconData icon,
    required Color mainColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: mainColor.withOpacity(0.14),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 31.w,
                height: 31.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 10.8.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 7.w),
              Icon(
                icon,
                color: mainColor,
                size: 17.8.sp,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _darkText,
                        fontSize: 11.4.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 3.w),
              Icon(
                Icons.info_outline_rounded,
                color: mainColor,
                size: 15.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VocationalHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint backMountainPaint = Paint()
      ..color = Colors.white.withOpacity(0.055)
      ..style = PaintingStyle.fill;

    final Paint middleMountainPaint = Paint()
      ..color = Colors.white.withOpacity(0.075)
      ..style = PaintingStyle.fill;

    final Paint frontMountainPaint = Paint()
      ..color = Colors.white.withOpacity(0.10)
      ..style = PaintingStyle.fill;

    final Path backMountain = Path()
      ..moveTo(size.width * 0.48, size.height)
      ..lineTo(size.width * 0.71, size.height * 0.38)
      ..lineTo(size.width * 0.81, size.height * 0.61)
      ..lineTo(size.width * 0.91, size.height * 0.28)
      ..lineTo(size.width, size.height * 0.58)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(
      backMountain,
      backMountainPaint,
    );

    final Path middleMountain = Path()
      ..moveTo(size.width * 0.53, size.height)
      ..lineTo(size.width * 0.72, size.height * 0.54)
      ..lineTo(size.width * 0.81, size.height * 0.71)
      ..lineTo(size.width * 0.92, size.height * 0.43)
      ..lineTo(size.width, size.height * 0.64)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(
      middleMountain,
      middleMountainPaint,
    );

    final Path frontMountain = Path()
      ..moveTo(size.width * 0.49, size.height)
      ..lineTo(size.width * 0.69, size.height * 0.72)
      ..lineTo(size.width * 0.79, size.height * 0.84)
      ..lineTo(size.width * 0.91, size.height * 0.62)
      ..lineTo(size.width, size.height * 0.76)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(
      frontMountain,
      frontMountainPaint,
    );

    final Paint roadGlowPaint = Paint()
      ..color = const Color(0xFFB6AAFF).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    final Paint roadPaint = Paint()
      ..color = const Color(0xFFE5E0FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final Path road = Path()
      ..moveTo(
        size.width * 0.67,
        size.height,
      )
      ..cubicTo(
        size.width * 0.81,
        size.height * 0.80,
        size.width * 0.62,
        size.height * 0.65,
        size.width * 0.79,
        size.height * 0.52,
      )
      ..cubicTo(
        size.width * 0.93,
        size.height * 0.42,
        size.width * 0.76,
        size.height * 0.32,
        size.width * 0.88,
        size.height * 0.10,
      );

    canvas.drawPath(
      road,
      roadGlowPaint,
    );

    canvas.drawPath(
      road,
      roadPaint,
    );

    _drawFlag(
      canvas,
      position: Offset(
        size.width * 0.72,
        size.height * 0.72,
      ),
      flagColor: const Color(0xFF40D7D1),
      scale: 0.75,
    );

    _drawFlag(
      canvas,
      position: Offset(
        size.width * 0.81,
        size.height * 0.47,
      ),
      flagColor: const Color(0xFFFFC72E),
      scale: 0.82,
    );

    _drawFlag(
      canvas,
      position: Offset(
        size.width * 0.88,
        size.height * 0.12,
      ),
      flagColor: const Color(0xFFFFD438),
      scale: 0.90,
    );

    final Paint starPaint = Paint()
      ..color = Colors.white.withOpacity(0.88)
      ..strokeWidth = 1.5;

    _drawStar(
      canvas,
      Offset(
        size.width * 0.80,
        size.height * 0.23,
      ),
      starPaint,
    );

    _drawStar(
      canvas,
      Offset(
        size.width * 0.94,
        size.height * 0.25,
      ),
      starPaint,
    );

    final Paint cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.08);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          size.width * 0.75,
          size.height * 0.30,
        ),
        width: size.width * 0.12,
        height: size.height * 0.07,
      ),
      cloudPaint,
    );
  }

  void _drawFlag(
      Canvas canvas, {
        required Offset position,
        required Color flagColor,
        required double scale,
      }) {
    final Paint polePaint = Paint()
      ..color = Colors.white.withOpacity(0.90)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      position,
      Offset(
        position.dx,
        position.dy - (23 * scale),
      ),
      polePaint,
    );

    final Path flagPath = Path()
      ..moveTo(
        position.dx,
        position.dy - (23 * scale),
      )
      ..lineTo(
        position.dx + (14 * scale),
        position.dy - (19 * scale),
      )
      ..lineTo(
        position.dx,
        position.dy - (15 * scale),
      )
      ..close();

    canvas.drawPath(
      flagPath,
      Paint()..color = flagColor,
    );

    canvas.drawCircle(
      position,
      3 * scale,
      Paint()
        ..color = Colors.white.withOpacity(0.90),
    );
  }

  void _drawStar(
      Canvas canvas,
      Offset center,
      Paint paint,
      ) {
    canvas.drawLine(
      Offset(
        center.dx - 4,
        center.dy,
      ),
      Offset(
        center.dx + 4,
        center.dy,
      ),
      paint,
    );

    canvas.drawLine(
      Offset(
        center.dx,
        center.dy - 4,
      ),
      Offset(
        center.dx,
        center.dy + 4,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _VocationalHeaderPainter oldDelegate,
      ) {
    return false;
  }
}