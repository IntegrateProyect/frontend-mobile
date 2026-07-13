import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/features/student/presentation/providers/student_profile_provider.dart';

Future<void> showAvatarPickerSheet({
  required BuildContext context,
  required AuthProvider authProvider,
  required StudentProfileProvider profileProvider,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24.r),
      ),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Colors.blue,
                ),
                title: const Text('Elegir de la galería'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();

                  final success =
                  await authProvider.updateAvatarFromGallery();

                  if (success) {
                    await profileProvider.fetchProfile();
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.purple,
                ),
                title: const Text('Tomar una foto'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();

                  final success =
                  await authProvider.updateAvatarFromCamera();

                  if (success) {
                    await profileProvider.fetchProfile();
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}