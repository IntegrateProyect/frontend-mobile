import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../components/alumni_text_field.dart';
import '../components/story_preview_card.dart';
import '../providers/write_story_provider.dart';

class WriteStoryScreen extends StatelessWidget {
  const WriteStoryScreen({super.key});

  static const Color primaryColor = Color(0xFF311B92);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WriteStoryProvider>();
    final profile = provider.profile;

    // Inicializar el perfil si es nulo
    if (profile == null && !provider.isLoading && provider.errorMessage == null) {
      Future.microtask(() => provider.loadProfile());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Compartir Experiencia',
          style: TextStyle(
            color: const Color(0xFF1D1B4B),
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          if (!provider.isLoading)
            TextButton(
              onPressed: () => _handlePublish(context, provider),
              child: Text(
                'Publicar',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 15.sp,
                ),
              ),
            ),
          SizedBox(width: 8.w),
        ],
      ),
      body: provider.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  StoryPreviewCard(
                    name: profile?.name ?? 'Egresado',
                    major: profile?.degree ?? 'Carrera',
                    year: profile?.graduationYear.toString() ?? 'Año',
                    title: 'Mi Historia de Éxito',
                    story: provider.storyController.text,
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Escribe tu historia',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[400],
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AlumniTextField(
                    label: 'Tu Historia',
                    hint: 'Cuéntanos tu camino al éxito...',
                    icon: Icons.history_edu_rounded,
                    controller: provider.storyController,
                    isLongText: true,
                  ),
                  if (provider.errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        provider.errorMessage!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  SizedBox(height: 40.h),
                ],
              ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          title: const Row(
            children: [
              Icon(Icons.hourglass_empty_rounded, color: primaryColor),
              SizedBox(width: 12),
              Text('Historia Enviada'),
            ],
          ),
          content: const Text(
            '¡Gracias por compartir tu experiencia! Tu historia ha sido enviada a moderación. Un administrador la revisará antes de ser publicada.',
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar dialog
                context.pop(); // Volver a la lista
              },
              child: const Text('Entendido', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
            ),
          ],
        ),
      );
    }
  }
}
