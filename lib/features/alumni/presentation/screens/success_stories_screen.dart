import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:orientate/core/routes/AppRoutes.dart';
import '../components/alumni_story_card.dart';
import '../providers/alumni_home_provider.dart';
import '../components/alumni_empty_state.dart';

class SuccessStoriesScreen extends StatefulWidget {
  const SuccessStoriesScreen({super.key});

  @override
  State<SuccessStoriesScreen> createState() => _SuccessStoriesScreenState();
}

class _SuccessStoriesScreenState extends State<SuccessStoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlumniHomeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 4.h),
              child: _buildSearchBar(),
            ),
          ),
          if (provider.isLoading && provider.recentStories.isEmpty)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: _primaryColor)),
            )
          else if (provider.recentStories.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: const AlumniEmptyState(
                  title: 'Explora Historias',
                  description: 'Sé el primero en compartir tu experiencia o espera a que otros publiquen la suya.',
                  imagePath: 'assets/images/cientifico.jpg',
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 100.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final story = provider.recentStories[index];
                    return AlumniStoryCard(
                      story: {
                        'name': story.alumniName,
                        'major': story.career,
                        'year': story.graduationYear.toString(),
                        'title': 'Mi Trayectoria Profesional',
                        'story': story.story,
                      },
                      onTap: () {},
                    );
                  },
                  childCount: provider.recentStories.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.writeStory.path),
        backgroundColor: _primaryColor,
        elevation: 8,
        label: Text('Compartir mi Historia', 
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.sp, color: Colors.white, letterSpacing: 0.3)),
        icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 110.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: _accentColor, size: 20.sp),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
        title: Text(
          'Historias de Éxito',
          style: TextStyle(
            color: _accentColor,
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'Buscar por carrera o nombre...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13.sp, fontWeight: FontWeight.w500),
          prefixIcon: Icon(Icons.search_rounded, color: _primaryColor.withOpacity(0.6), size: 22.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        ),
      ),
    );
  }
}
