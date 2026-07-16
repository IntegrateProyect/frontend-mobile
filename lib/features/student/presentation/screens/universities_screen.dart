import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:orientate/core/routes/AppRoutes.dart';

import '../../../university/presentation/providers/universities_provider.dart';
import '../components/common/student_ui_colors.dart';
import '../components/universities/university_card.dart';
import '../providers/universities_provider.dart';

class UniversitiesScreen
    extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() {
    return _UniversitiesScreenState();
  }
}

class _UniversitiesScreenState
    extends State<UniversitiesScreen> {
  final TextEditingController
  _searchController =
  TextEditingController();

  final ScrollController
  _scrollController =
  ScrollController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(
      _handleScroll,
    );

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context
          .read<UniversitiesProvider>()
          .fetchUniversities();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();

    _searchController.dispose();

    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();

    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position =
        _scrollController.position;

    final isNearBottom =
        position.pixels >=
            position.maxScrollExtent - 250;

    if (!isNearBottom) {
      return;
    }

    context
        .read<UniversitiesProvider>()
        .loadMore();
  }

  void _onSearchChanged(String value) {
    setState(() {});

    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
          () {
        if (!mounted) {
          return;
        }

        context
            .read<UniversitiesProvider>()
            .searchUniversities(value);
      },
    );
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
    final provider =
    context.watch<UniversitiesProvider>();

    return Scaffold(
      backgroundColor:
      StudentUiColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Regresar',
          onPressed: _goBack,
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
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
      body: Column(
        children: [
          _buildHeader(provider),
          Expanded(
            child: _buildBody(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      UniversitiesProvider provider,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18.w,
        18.h,
        18.w,
        14.h,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'Encuentra una universidad',
            style: TextStyle(
              color:
              StudentUiColors.darkText,
              fontSize: 21.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Consulta las instituciones del catálogo nacional RENOES.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 15.h),
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            textInputAction:
            TextInputAction.search,
            decoration: InputDecoration(
              hintText:
              'Buscar universidad...',
              prefixIcon:
              const Icon(Icons.search),
              suffixIcon:
              _searchController.text.isEmpty
                  ? null
                  : IconButton(
                onPressed: () {
                  _searchController
                      .clear();

                  setState(() {});

                  provider
                      .searchUniversities(
                    '',
                  );
                },
                icon: const Icon(
                  Icons.close,
                ),
              ),
              filled: true,
              fillColor:
              const Color(0xFFF8F9FE),
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  18.r,
                ),
                borderSide: BorderSide.none,
              ),
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  18.r,
                ),
                borderSide: BorderSide.none,
              ),
              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  18.r,
                ),
                borderSide:
                const BorderSide(
                  color:
                  StudentUiColors.primary,
                  width: 1.5,
                ),
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
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody(
      UniversitiesProvider provider,
      ) {
    if (provider.isLoading &&
        provider.universities.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: StudentUiColors.primary,
        ),
      );
    }

    if (provider.errorMessage != null &&
        provider.universities.isEmpty) {
      return _ErrorState(
        message: provider.errorMessage!,
        onRetry:
        provider.refreshUniversities,
      );
    }

    if (provider.universities.isEmpty) {
      return RefreshIndicator(
        color: StudentUiColors.primary,
        onRefresh:
        provider.refreshUniversities,
        child: ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 130.h),
            Icon(
              Icons
                  .account_balance_outlined,
              size: 72.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'No se encontraron universidades',
                style: TextStyle(
                  color:
                  StudentUiColors.darkText,
                  fontSize: 15.sp,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: StudentUiColors.primary,
      onRefresh:
      provider.refreshUniversities,
      child: ListView.builder(
        controller: _scrollController,
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          18.w,
          18.h,
          18.w,
          30.h,
        ),
        itemCount:
        provider.universities.length +
            (provider.isLoadingMore
                ? 1
                : 0),
        itemBuilder: (context, index) {
          if (index >=
              provider.universities.length) {
            return Padding(
              padding:
              EdgeInsets.symmetric(
                vertical: 18.h,
              ),
              child: const Center(
                child:
                CircularProgressIndicator(
                  color:
                  StudentUiColors.primary,
                ),
              ),
            );
          }

          final university =
          provider.universities[index];

          return UniversityCard(
            university: university,
            onTap: university.isRegistered
                ? () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(
                  content: Text(
                    'Perfil de ${university.name} próximamente',
                  ),
                  behavior:
                  SnackBarBehavior
                      .floating,
                ),
              );
            }
                : null,
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28.w),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 68.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No fue posible cargar las universidades',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                StudentUiColors.darkText,
                fontSize: 17.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh,
              ),
              label:
              const Text('Reintentar'),
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                StudentUiColors.primary,
                foregroundColor:
                Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}