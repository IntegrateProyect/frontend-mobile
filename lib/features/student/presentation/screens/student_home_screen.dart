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
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
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
    context.push(AppRoutes.vocationalRoute.path);
  }

  void _openChatbot() {
    _hideChatbotCoachMark();
    context.push(AppRoutes.chat.path);
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 28.h),
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
                child: Icon(Icons.smart_toy_rounded,
                    color: StudentUiColors.teal, size: 40.sp),
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
              SizedBox(height: 22.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(
                      bottomSheetContext, _ChatbotInformationAction.locate),
                  icon: const Icon(Icons.location_searching_rounded),
                  label: const Text('Mostrarme dónde está'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: StudentUiColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: Size.fromHeight(52.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r)),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(
                    bottomSheetContext, _ChatbotInformationAction.open),
                icon: const Icon(Icons.smart_toy_outlined),
                label: const Text('Abrir chatbot'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: StudentUiColors.teal,
                  minimumSize: Size.fromHeight(50.h),
                  side: BorderSide(color: StudentUiColors.teal.withOpacity(0.4)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r)),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null) return;

    if (action == _ChatbotInformationAction.open) {
      _openChatbot();
    } else {
      await Future.delayed(const Duration(milliseconds: 200));
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 28.h),
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
                child: Icon(Icons.bar_chart_rounded,
                    color: const Color(0xFF756EB2), size: 40.sp),
              ),
              SizedBox(height: 18.h),
              Text(
                'Resultados vocacionales',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: StudentUiColors.darkText,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 10.h),
              Text(
                'Tus resultados se desbloquearán cuando completes todos los minijuegos vocacionales.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, height: 1.4),
              ),
              SizedBox(height: 22.h),
              _buildResultInfoItem(
                number: '1',
                text: 'Completa todos los minijuegos disponibles.',
              ),
              SizedBox(height: 10.h),
              _buildResultInfoItem(
                number: '2',
                text: 'Obtendrás tus áreas de afinidad y carreras sugeridas.',
              ),
              SizedBox(height: 22.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: StudentUiColors.primary,
                    minimumSize: Size.fromHeight(52.h)),
                child: const Text('Entendido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultInfoItem({required String number, required String text}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
          color: const Color(0xFFF8F8FB), borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12.r,
            backgroundColor: const Color(0xFFEDEDF3),
            child: Text(number, style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
          ),
          SizedBox(width: 12.w),
          Expanded(child: Text(text, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  void _showChatbotCoachMark() {
    _hideChatbotCoachMark();
    final renderBox = _chatFabKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final rect = offset & renderBox.size;

    _chatCoachMarkEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black54,
        child: Stack(
          children: [
            Positioned.fill(child: GestureDetector(onTap: _hideChatbotCoachMark)),
            Positioned(
              right: 20.w,
              bottom: 110.h,
              child: Container(
                width: 260.w,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('¡Aquí está!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    SizedBox(height: 8.h),
                    const Text(
                        'Usa este botón para hablar con el chatbot en cualquier momento.',
                        textAlign: TextAlign.center),
                    TextButton(
                        onPressed: _hideChatbotCoachMark,
                        child: const Text('Entendido')),
                  ],
                ),
              ),
            ),
            Positioned.fromRect(
              rect: rect.inflate(8),
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4))),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_chatCoachMarkEntry!);
  }

  void _hideChatbotCoachMark() {
    _chatCoachMarkEntry?.remove();
    _chatCoachMarkEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentHomeProvider>();

    return Scaffold(
      backgroundColor: StudentUiColors.background,
      appBar: StudentHomeAppBar(
        onNotificationsPressed: () => _showMessage('Notificaciones próximamente'),
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
        child: const Icon(Icons.smart_toy_rounded, color: Colors.white),
      ),
      bottomNavigationBar: const StudentBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildBody(StudentHomeProvider provider) {
    if (provider.isLoading && provider.profile == null) {
      return const Center(
          child: CircularProgressIndicator(color: StudentUiColors.primary));
    }

    return RefreshIndicator(
      color: StudentUiColors.primary,
      onRefresh: provider.loadHomeData,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),
        children: [
          StudentGreeting(
            name: provider.firstName,
            groupName: provider.hasGroup ? provider.currentGroupName : null,
            counselorName: provider.currentCounselorName,
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
            onUniversitiesTap: () => context.push(AppRoutes.universities.path),
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
            onMessagesTap: () => context.push(AppRoutes.chatContacts.path),
            onCareersTap: () => context.push(AppRoutes.careers.path),
            onUniversitiesTap: () => context.push(AppRoutes.universities.path),
            onEventsTap: () => _showMessage('Eventos próximamente'),
          ),
        ],
      ),
    );
  }
}

enum _ChatbotInformationAction { locate, open }
