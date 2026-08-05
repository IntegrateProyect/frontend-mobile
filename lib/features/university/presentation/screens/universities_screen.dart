import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';

import '../providers/universities_provider.dart';
import '../../../student/presentation/components/common/student_ui_colors.dart';
import '../components/university_card.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UniversitiesProvider>().fetchUniversities();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController..removeListener(_handleScroll)..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final isNearBottom = position.pixels >= position.maxScrollExtent - 250;
    if (!isNearBottom) return;
    context.read<UniversitiesProvider>().loadMore();
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<UniversitiesProvider>().searchUniversities(value);
    });
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.home.path);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UniversitiesProvider>();

    return Scaffold(
      backgroundColor: StudentUiColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Regresar',
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: Text(
          'Expo Universidades',
          style: TextStyle(
            color: StudentUiColors.darkText,
            fontWeight: FontWeight.w900,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              _buildHeader(provider, constraints.maxWidth),
              Expanded(
                child: _buildBody(provider, constraints),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(UniversitiesProvider provider, double maxWidth) {
    // Definimos un padding horizontal dinámico para pantallas muy anchas
    double horizontalPadding = 18.w;
    if (maxWidth > 1000) {
      horizontalPadding = (maxWidth - 1000) / 2 + 18.w;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(horizontalPadding, 18.h, horizontalPadding, 14.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Encuentra una universidad',
            style: TextStyle(
              color: StudentUiColors.darkText,
              fontSize: 21.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Consulta las instituciones del catálogo nacional RENOES.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
          ),
          SizedBox(height: 15.h),
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Buscar universidad...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                        provider.searchUniversities('');
                      },
                      icon: const Icon(Icons.close),
                    ),
              filled: true,
              fillColor: const Color(0xFFF8F9FE),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r),
                borderSide:
                    const BorderSide(color: StudentUiColors.primary, width: 1.5),
              ),
            ),
          ),
          if (provider.total > 0) ...[
            SizedBox(height: 11.h),
            Text(
              '${provider.total} universidades encontradas',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody(UniversitiesProvider provider, BoxConstraints constraints) {
    if (provider.isLoading && provider.universities.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: StudentUiColors.primary));
    }

    if (provider.errorMessage != null && provider.universities.isEmpty) {
      return _ErrorState(
        message: provider.errorMessage!,
        onRetry: provider.refreshUniversities,
      );
    }

    if (provider.universities.isEmpty) {
      return RefreshIndicator(
        color: StudentUiColors.primary,
        onRefresh: provider.refreshUniversities,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 130.h),
            Icon(Icons.account_balance_outlined,
                size: 72.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'No se encontraron universidades',
                style: TextStyle(
                    color: StudentUiColors.darkText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      );
    }

    // Lógica de Breakpoints
    int crossAxisCount = 1;
    double childAspectRatio = 3.2; // Proporción para lista en móvil
    double horizontalPadding = 18.w;

    if (constraints.maxWidth >= 1000) {
      crossAxisCount = 3;
      childAspectRatio = 1.3;
      horizontalPadding = (constraints.maxWidth - 1000) / 2 + 18.w;
    } else if (constraints.maxWidth >= 600) {
      crossAxisCount = 2;
      childAspectRatio = 1.4;
      horizontalPadding = 24.w;
    }

    return RefreshIndicator(
      color: StudentUiColors.primary,
      onRefresh: provider.refreshUniversities,
      child: GridView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
            horizontalPadding, 18.h, horizontalPadding, 30.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: provider.universities.length + (provider.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= provider.universities.length) {
            return const Center(
                child: CircularProgressIndicator(color: StudentUiColors.primary));
          }
          final university = provider.universities[index];
          return UniversityCard(
            university: university,
            onTap: () {
              context.push(AppRoutes.universityDetail.path, extra: university);
            },
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_outlined, size: 68.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              'No fue posible cargar las universidades',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: StudentUiColors.darkText,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 10.h),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 12.sp)),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: StudentUiColors.primary,
                  foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
