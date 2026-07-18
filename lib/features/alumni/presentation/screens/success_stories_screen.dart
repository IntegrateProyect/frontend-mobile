import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';
import '../components/alumni_story_card.dart';
import '../providers/alumni_provider.dart';

class SuccessStoriesScreen extends StatefulWidget {
  const SuccessStoriesScreen({super.key});

  @override
  State<SuccessStoriesScreen> createState() => _SuccessStoriesScreenState();
}

class _SuccessStoriesScreenState extends State<SuccessStoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  static const Color primaryColor = Color(0xFF311B92);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlumniProvider>().loadAlumniData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlumniProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: provider.isLoading && provider.stories.isEmpty
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
                    child: _buildSearchBar(),
                  ),
                ),
                if (provider.stories.isEmpty && !provider.isLoading)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No hay historias disponibles aún.',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final story = provider.stories[index];
                          return AlumniStoryCard(
                            story: {
                              'name': story.alumniName,
                              'major': story.career,
                              'year': story.graduationYear.toString(),
                              'title': 'Historia de éxito',
                              'story': story.story,
                            },
                            onTap: () {},
                          );
                        },
                        childCount: provider.stories.length,
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.writeStory.path),
        backgroundColor: primaryColor,
        label: Text('Compartir mi Historia', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.white)),
        icon: const Icon(Icons.auto_awesome_outlined, color: Colors.white),
        elevation: 4,
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 24.w, bottom: 16.h),
        title: Text(
          'Historias de Éxito',
          style: TextStyle(
            color: const Color(0xFF1D1B4B),
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por carrera o nombre...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
          prefixIcon: const Icon(Icons.search, color: primaryColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        ),
      ),
    );
  }
}
