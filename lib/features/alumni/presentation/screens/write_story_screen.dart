import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../components/alumni_text_field.dart';
import '../components/story_preview_card.dart';
import '../providers/write_story_provider.dart';

class WriteStoryScreen extends StatelessWidget {
  const WriteStoryScreen({super.key});

  static const Color _primaryColor = Color(0xFF311B92);
  static const Color _accentColor = Color(0xFF1D1B4B);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WriteStoryProvider>();
    final profile = provider.profile;

    if (profile == null && !provider.isLoading && provider.errorMessage == null) {
      Future.microtask(() => provider.loadProfile());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: _accentColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Compartir Experiencia',
          style: TextStyle(
            color: _accentColor,
            fontWeight: FontWeight.w900,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          if (!provider.isLoading)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: TextButton(
                onPressed: () => _handlePublish(context, provider),
                child: Text(
                  'Publicar',
                  style: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: provider.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  _buildSectionHeader('Vista previa'),
                  SizedBox(height: 12.h),
                  StoryPreviewCard(
                    name: profile?.name ?? 'Egresado',
                    major: profile?.degree ?? 'Carrera',
                    year: profile?.graduationYear.toString() ?? 'Año',
                    title: provider.titleController.text.isEmpty ? 'Mi Camino al Éxito' : provider.titleController.text,
                    story: provider.storyController.text,
                  ),
                  SizedBox(height: 32.h),
                  _buildSectionHeader('Tu historia'),
                  SizedBox(height: 4.h),
                  Text(
                    'Inspira a otros compartiendo los retos y logros de tu trayectoria.',
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[500], fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 24.h),
                  AlumniTextField(
                    label: 'TÍTULO DE TU HISTORIA',
                    hint: 'Ej: Mi camino en la industria tech',
                    icon: Icons.auto_awesome_rounded,
                    controller: provider.titleController,
                  ),
                  SizedBox(height: 20.h),
                  AlumniTextField(
                    label: 'TU EXPERIENCIA',
                    hint: '¿Cómo fue tu paso por la universidad? ¿Qué consejos darías?',
                    icon: Icons.history_edu_rounded,
                    controller: provider.storyController,
                    isLongText: true,
                  ),
                  if (provider.errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          provider.errorMessage!,
                          style: TextStyle(color: Colors.redAccent, fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w900,
        color: Colors.grey[400],
        letterSpacing: 1.2,
      ),
    );
  }

  Future<void> _handlePublish(BuildContext context, WriteStoryProvider provider) async {
    final success = await provider.submitStory();

    if (success && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
          title: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(color: const Color(0xFFF0FDF4), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 40),
              ),
              SizedBox(height: 16.h),
              Text('¡Historia Enviada!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20.sp, color: _accentColor)),
            ],
          ),
          content: Text(
            'Tu experiencia ha sido enviada a revisión. En breve será visible para toda la comunidad.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600], height: 1.5),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  elevation: 0,
                ),
                child: const Text('Entendido', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }
  }
}
