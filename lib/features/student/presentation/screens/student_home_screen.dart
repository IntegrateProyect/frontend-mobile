import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';

import '../components/common/student_bottom_navigation_bar.dart';
import '../components/common/student_ui_colors.dart';
import '../components/home/career_recommendations_carousel.dart';
import '../components/home/student_appointments_section.dart';
import '../components/home/student_greeting.dart';
import '../components/home/student_home_app_bar.dart';
import '../components/home/student_recommendations_card.dart';
import '../components/home/vocational_route_card.dart';

import '../components/home/quick_access_grid.dart' as quick_access;
import '../components/home/student_account_sheet.dart' as account_sheet;

import '../providers/student_home_provider.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({
    super.key,
  });

  @override
  State<StudentHomeScreen> createState() {
    return _StudentHomeScreenState();
  }
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final GlobalKey _chatFabKey = GlobalKey();

  OverlayEntry? _chatCoachMarkEntry;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<StudentHomeProvider>().loadHomeData();
    });
  }

  @override
  void dispose() {
    _hideChatbotCoachMark();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _openVocationalRoute() {
    context.push(
      AppRoutes.vocationalRoute.path,
    );
  }

  void _openChatbot() {
    _hideChatbotCoachMark();

    context.push(
      AppRoutes.chat.path,
    );
  }

  Future<void> _showChatbotInformation() async {
    final _ChatbotInformationAction? action =
    await showModalBottomSheet<_ChatbotInformationAction>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.r),
        ),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24.w,
            4.h,
            24.w,
            28.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F8F7),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  Icons.smart_toy_rounded,
                  color: StudentUiColors.teal,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Chatbot vocacional',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: StudentUiColors.darkText,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Habla con el chatbot para resolver dudas, explorar carreras '
                    'y buscar universidades relacionadas con tus intereses.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 14.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE3DFFD),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.touch_app_rounded,
                        color: StudentUiColors.primary,
                        size: 21.sp,
                      ),
                    ),
                    SizedBox(width: 11.w),
                    Expanded(
                      child: Text(
                        'Puedes abrirlo desde el botón flotante de la esquina '
                            'inferior derecha.',
                        style: TextStyle(
                          color: StudentUiColors.darkText,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(
                      bottomSheetContext,
                      _ChatbotInformationAction.locate,
                    );
                  },
                  icon: const Icon(
                    Icons.location_searching_rounded,
                  ),
                  label: const Text(
                    'Mostrarme dónde está',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: StudentUiColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: Size.fromHeight(52.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(
                      bottomSheetContext,
                      _ChatbotInformationAction.open,
                    );
                  },
                  icon: const Icon(
                    Icons.smart_toy_outlined,
                  ),
                  label: const Text(
                    'Abrir chatbot',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: StudentUiColors.teal,
                    minimumSize: Size.fromHeight(50.h),
                    side: BorderSide(
                      color: StudentUiColors.teal.withOpacity(0.40),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null) {
      return;
    }

    if (action == _ChatbotInformationAction.open) {
      _openChatbot();
      return;
    }

    await Future<void>.delayed(
      const Duration(milliseconds: 180),
    );

    if (mounted) {
      _showChatbotCoachMark();
    }
  }

  Future<void> _showResultsInformation() async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.r),
        ),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24.w,
            4.h,
            24.w,
            28.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EEFA),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: const Color(0xFF756EB2),
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Resultados vocacionales',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: StudentUiColors.darkText,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Tus resultados se desbloquearán cuando completes todos '
                    'los minijuegos vocacionales.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 18.h),
              _buildResultInformationItem(
                number: '1',
                text: 'Completa todos los minijuegos disponibles.',
              ),
              SizedBox(height: 10.h),
              _buildResultInformationItem(
                number: '2',
                text:
                'Obtendrás tus áreas de mayor afinidad y tus carreras sugeridas.',
              ),
              SizedBox(height: 10.h),
              _buildResultInformationItem(
                number: '3',
                text:
                'Después podrás consultar universidades relacionadas.',
              ),
              SizedBox(height: 22.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(bottomSheetContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: StudentUiColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: Size.fromHeight(52.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'Entendido',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultInformationItem({
    required String number,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FB),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: const Color(0xFFE9E9F1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: const BoxDecoration(
              color: Color(0xFFEDEDF3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: const Color(0xFF868A9A),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: StudentUiColors.darkText,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChatbotCoachMark() {
    _hideChatbotCoachMark();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final BuildContext? fabContext =
          _chatFabKey.currentContext;

      if (fabContext == null) {
        return;
      }

      final RenderObject? renderObject =
      fabContext.findRenderObject();

      if (renderObject is! RenderBox ||
          !renderObject.hasSize) {
        return;
      }

      final Offset targetOffset =
      renderObject.localToGlobal(Offset.zero);

      final Rect targetRect =
      targetOffset & renderObject.size;

      final OverlayState overlay = Overlay.of(
        context,
        rootOverlay: true,
      );

      _chatCoachMarkEntry = OverlayEntry(
        builder: (overlayContext) {
          final MediaQueryData mediaQuery =
          MediaQuery.of(overlayContext);

          final Size screenSize = mediaQuery.size;

          final Rect highlightedRect =
          targetRect.inflate(10.w);

          final double bubbleWidth =
          (screenSize.width - 40.w)
              .clamp(240.0, 310.w)
              .toDouble();

          final double bubbleTop =
          (targetRect.top - 175.h)
              .clamp(
            mediaQuery.padding.top + 20.h,
            screenSize.height - 240.h,
          )
              .toDouble();

          return Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _hideChatbotCoachMark,
                    child: CustomPaint(
                      painter: _ChatbotSpotlightPainter(
                        targetRect: highlightedRect,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: highlightedRect,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4FE0D8),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4FE0D8)
                                .withOpacity(0.55),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20.w,
                  top: bubbleTop,
                  child: Container(
                    width: bubbleWidth,
                    padding: EdgeInsets.all(17.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 24,
                          offset: Offset(0, 10.h),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE7F8F7),
                                borderRadius:
                                BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.smart_toy_rounded,
                                color: StudentUiColors.teal,
                                size: 22.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                'Aquí está tu chatbot',
                                style: TextStyle(
                                  color: StudentUiColors.darkText,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Presiona el botón resaltado para comenzar '
                              'una conversación.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),
                        SizedBox(height: 13.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _hideChatbotCoachMark,
                            child: const Text(
                              'Entendido',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: highlightedRect,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _openChatbot,
                    child: const ColoredBox(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      overlay.insert(_chatCoachMarkEntry!);
    });
  }

  void _hideChatbotCoachMark() {
    _chatCoachMarkEntry?.remove();
    _chatCoachMarkEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final StudentHomeProvider provider =
    context.watch<StudentHomeProvider>();

    return Scaffold(
      backgroundColor: StudentUiColors.background,
      appBar: StudentHomeAppBar(
        onNotificationsPressed: () {
          _showMessage(
            'Notificaciones próximamente',
          );
        },
        onAccountPressed: () {
          account_sheet.showStudentAccountSheet(
            context: context,
            homeProvider: provider,
            authProvider: context.read<AuthProvider>(),
          );
        },
      ),
      body: _buildBody(provider),
      floatingActionButton: FloatingActionButton(
        key: _chatFabKey,
        backgroundColor: StudentUiColors.teal,
        elevation: 8,
        onPressed: _openChatbot,
        child: const Icon(
          Icons.smart_toy_rounded,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar:
      const StudentBottomNavigationBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildBody(
      StudentHomeProvider provider,
      ) {
    if (provider.isLoading &&
        provider.profile == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: StudentUiColors.primary,
        ),
      );
    }

    return RefreshIndicator(
      color: StudentUiColors.primary,
      onRefresh: provider.loadHomeData,
      child: ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          16.w,
          16.h,
          16.w,
          30.h,
        ),
        children: [
          StudentGreeting(
            name: provider.firstName,
            groupName: provider.currentGroupName,
            counselorName:
            provider.currentCounselorName,
          ),
          SizedBox(height: 18.h),
          VocationalRouteCard(
            onTap: _openVocationalRoute,
            onChatTap: _showChatbotInformation,
            onResultsTap: _showResultsInformation,
          ),
          SizedBox(height: 20.h),
          StudentRecommendationsCard(
            onCareersTap: () {},
            onUniversitiesTap: () {
              context.push(
                AppRoutes.universities.path,
              );
            },
          ),
          SizedBox(height: 20.h),
          StudentAppointmentsSection(
            appointments: provider.appointments,
            onRefresh: provider.loadHomeData,
          ),
          SizedBox(height: 20.h),
          const CareerRecommendationsCarousel(),
          SizedBox(height: 20.h),
          quick_access.QuickAccessGrid(
            onMessagesTap: () {
              context.push(
                AppRoutes.chatContacts.path,
              );
            },
            onCareersTap: () {
              context.push(
                AppRoutes.careers.path,
              );
            },
            onUniversitiesTap: () {
              context.push(
                AppRoutes.universities.path,
              );
            },
            onEventsTap: () {
              _showMessage(
                'Eventos próximamente',
              );
            },
          ),
        ],
      ),
    );
  }
}

enum _ChatbotInformationAction {
  locate,
  open,
}

class _ChatbotSpotlightPainter extends CustomPainter {
  final Rect targetRect;

  const _ChatbotSpotlightPainter({
    required this.targetRect,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    canvas.saveLayer(
      Offset.zero & size,
      Paint(),
    );

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = Colors.black.withOpacity(0.58),
    );

    canvas.drawOval(
      targetRect,
      Paint()
        ..blendMode = BlendMode.clear,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(
      covariant _ChatbotSpotlightPainter oldDelegate,
      ) {
    return oldDelegate.targetRect != targetRect;
  }
}